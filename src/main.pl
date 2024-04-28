:- use_module(init).
:- use_module(database).
:- use_module("models/create").

main:-
  install,
  create_tables.
  % halt.
