-module(replaceeffect).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() -> #template{file="site/templates/bare.html"}.


title() -> "Update Demo".


body() ->
	#button{id=but,text="Click Me!",postback=replace}.

event(replace) ->
	wf:replace(but,
		#link{
			url="http://erlang.org",
			text="Here's Erlang",
			actions=#show{effect=puff}
		}
	).
