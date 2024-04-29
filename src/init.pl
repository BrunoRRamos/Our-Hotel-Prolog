:- module(init, [install/0]).

install :-
  pack_install([prosqlite], [insecure(true), interactive(false)]).
