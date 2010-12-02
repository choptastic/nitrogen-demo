-module(effect).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() -> #template{file="site/templates/bare.html"}.

title() -> "Effect demo".

body() ->
	wf:wire(doit,effected,#event{
		type=click,actions=#effect{effect=shake}
	}),
	[
		#panel{id=effected,body="Doing Something"},
		#button{id=doit,text="Do it"}
	].
