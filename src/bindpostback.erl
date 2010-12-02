-module(bindpostback).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

main() -> #template{file="site/templates/bare.html"}.

title() -> "Data binding with postback demo".

get_data() ->
	[{"Apples","5"},{"Bananas","4"},{"Oranges","6"}].

body() ->
	Data = get_data(),
	Map = {fruit@body,qty@body},
	#table{rows=[
		#bind{data=Data,map=Map,transform=fun format_data/2,body=[
			#tablerow{cells=[
				#tablecell{id=fruit},
				#tablecell{id=qty},
				#tablecell{body=#link{id=wishlist,text="Wishlist"}},
				#tablecell{body=#link{id=buy,text="Add to Cart"}}
			]}
		]}
	]}.

format_data({Fruit,_} = DataRow,Acc) ->
	{DataRow,Acc,[{wishlist@postback,{wishlist,Fruit}},{buy@postback,{buy,Fruit}}]}.

event({Action,Name}) ->
	wf:info({Action,Name}),
	CurList = wf:session_default(Action,[]),
	NewList = [Name | CurList],
	wf:session(Action,NewList),
	wf:wire(#alert{text=wf:f("New ~p: ~p",[Action,NewList])}).
