-module(update).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() -> #template{file="site/templates/bare.html"}.


title() -> "Update Demo".

body() ->
	#panel{id=wrapper,body=[
		"Click below<br />",
		#button{text="Click Me!",postback=update}
	]}.

event(update) ->
	wf:update(wrapper,[
		"You clicked it<br />", 
		#link{
			url="http://erlang.org",
			text="Here's Erlang"
		}
	]).
