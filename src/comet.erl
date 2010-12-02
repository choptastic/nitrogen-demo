-module(comet).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() -> #template{file="site/templates/bare.html"}.

title() -> "Simple Comet Example".

body() ->
	wf:comet(fun()-> count(0) end),
	["Counter: ",#span{id=countspan}].

count(Counter) ->
	timer:sleep(1000),
	wf:update(countspan,"blah" ++ wf:to_list(Counter)),
	wf:flush(), % flush commands to browser
	?MODULE:count(Counter + 1).
