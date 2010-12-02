%% -*- mode: nitrogen -*-
-module (element_canvas).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").
-include("records.hrl").

%% Move the following line to records.hrl:
-record(canvas, {?ELEMENT_BASE(element_canvas), attr1, attr2}).

reflect() -> record_info(fields, canvas).

render_element(_Record = #canvas{}) ->
    "<b>Hello from canvas</b>".
