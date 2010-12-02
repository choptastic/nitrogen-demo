-module(replace).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() -> #template{file="site/templates/bare.html"}.


title() -> "Update Demo".

body() ->
	#panel{id=wrapper,body=[
		"Click below<br />",
		#button{id=but,text="Click Me!",postback=replace}
	]}.

event(replace) ->
	wf:replace(but,[
		"You clicked it<br />", 
		#link{
			url="http://erlang.org",
			text="Here's Erlang"
		}
	]).
