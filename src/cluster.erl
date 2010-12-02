-module (cluster).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").
-include("records.hrl").

main() -> #template { file="./site/templates/bare.html" }.

title() -> "Clustering Demo".

body() ->
	Counter = case wf:session(counter) of	
		undefined -> 0;
		N -> N
	end,
	wf:session(counter,Counter + 1),
	[
		"Node: ",wf:to_list(node()),
		#br{},
		wf:to_list(Counter),#br{}
	].

event(_) -> ok.
