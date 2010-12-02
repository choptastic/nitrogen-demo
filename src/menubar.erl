-module(menubar).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

menu() ->
	Data = case wf:user() of 
		undefined -> [];
		_ -> [
			{"/update","Update"},
			{"/replace","Replace"},
			{"/replaceeffect","Replace with Effect"},
			{"/effect","Effect"},
			{"/cluster","Clustering"},
			{"/comet","Comet"},
			{"/bindpostback","Advanced Bind"},
			{"/twitter","Twitter Search"}
		]
	end,
	Map = {menulink@url,menulink@text},
	#bind{data=Data,map=Map,empty_body="Log In for Menu",body=[
		#list{class=menu,body=[
			#listitem{body=#link{id=menulink}}
		]}
	]}.

update() ->
	wf:update("div.menu",menu()).
