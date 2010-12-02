-module(twitter).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() -> #template{file="site/templates/bare.html"}.


title() -> "Twitter Example with Comet".

body() ->
	"<b>Hello</b><input type=text value=whatever>",
	LastSearchTerm = wf:session_default(twitterterm,"Erlang"),
	wf:wire(search,term,#validate{validators=[
		#is_required{text="Required"}
	]}).
	

event(pause) ->
	wf:info("Pausing"),
	Pid = wf:state(twitterpid),
	Pid ! pause,
	wf:update(controllers,resume_button());
event(resume) ->
	wf:info("Resuming"),
	Pid = wf:state(twitterpid),
	Pid ! resume,
	wf:update(controllers,pause_button());
event(search) ->
	%% Get postback info
	SearchTerm = wf:q(term),
	wf:session(twitterterm,SearchTerm),


	%% Kill the running search process 
	OldPid = wf:state(twitterpid),
	case is_pid(OldPid) of
		true -> exit(OldPid,normal);
		false -> ok
	end,

	%% Launch the Comet Process and store the Pid in the Page State
	{ok,Pid} = wf:comet(fun() -> get_twitter_posts(wf:url_encode(SearchTerm),"0") end),
	wf:state(twitterpid,Pid),

	%% put up the pause button, and empty the current results
	wf:update(controllers,pause_button()),
	wf:update(results,"").


pause_button() -> #button{id=pause,text="Pause",postback=pause}.
resume_button() -> #button{id=resume,text="Resume",postback=resume}.


%% will update the results every second as long as there are results
get_twitter_posts(SearchTerm,LastNum) ->
	receive 
		pause -> receive resume -> get_twitter_posts(SearchTerm,LastNum) end
	after 1000 ->	
		Url = "http://search.twitter.com/search.json?q=" ++ SearchTerm ++ "&since_id=" ++ wf:to_list(LastNum),
		{ok, {_Status, _Headers, Json}} = httpc:request(Url),
		{NewLastNum,StructPosts} = decode_twitter(Json),
		case StructPosts of
			[] -> ok;
			_ ->
				Posts = [format_twitter_post(Proplist) || {struct,Proplist} <- StructPosts],
				wf:insert_top(results,Posts),
				wf:flush()
		end,
		get_twitter_posts(SearchTerm,NewLastNum)
	end.

format_twitter_post(Proplist) ->
	[User,Avatar,Text,Time] = [proplists:get_value(F,Proplist) || F <- [<<"from_user">>,<<"profile_image_url">>,<<"text">>,<<"created_at">>]],
	#panel{class=twitterpost,actions=#show{effect=slide},body=[
		Text,
		#br{},
		#image{image=Avatar},
		#span{class=user,text=User},
		" posted ",
		#span{class=time,text=Time}
	]}.



decode_twitter(Json) ->
	{struct,Decoded} = mochijson2:decode(Json),
	LastNum = proplists:get_value(<<"max_id">>,Decoded),
	Results = proplists:get_value(<<"results">>,Decoded),
	{LastNum,Results}.
	
