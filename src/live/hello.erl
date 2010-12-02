-module(hello).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() -> #template{file="site/templates/bare.html"}.

body() ->
	wf:wire(whatever,field,#validate{validators=[
		#is_required{text="Please enter something"}
	]}),
	[
	#textbox{id=field,class=textbox,text="Something"},
	#button{id=whatever,text="Click ME",postback=clicked}
	].
	



event(clicked) ->
	FieldValue = wf:q(field),
	wf:wire(#alert{text=FieldValue}).
