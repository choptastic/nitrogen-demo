-module(loginbar).
-compile(export_all).
-include_lib("nitrogen/include/wf.hrl").

logged_in(U) -> [
	#span{class=user,text=U},
	" | ",
	#link{postback=logout,delegate=?MODULE,text="Log Out"}
].

logged_out() -> [
	#textbox{id=login,text="Your Name"},
	#button{postback=login,delegate=?MODULE,text="Log In"}
].

login_body() ->
	case wf:user() of
		undefined -> logged_out();
		U -> logged_in(U)
	end.

loginbar() ->
	#panel{id=loginbox,body=login_body()}.

event(login) -> 
	Login = wf:q(login),
	wf:user(Login),
	wf:update(loginbox,login_body()),
	menubar:update();
event(logout) ->
	wf:logout(),
	wf:update(loginbox,login_body()),
	menubar:update().

