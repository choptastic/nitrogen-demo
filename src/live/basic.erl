-module(basic).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() -> #template{file="site/templates/bare.html"}.

title() -> "".

body() -> ok.

event(_) -> ok.
