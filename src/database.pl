:- module(database, [get_db_connection/1]).

:- use_module(library(prosqlite)).

:- dynamic db_connection/1.

get_db_connection(Conn) :-
    db_connection(Conn), !.  % If connection already exists, use it
get_db_connection(Conn) :-
    sqlite_connect(hotel, Conn, [as_predicates(true), arity(both), exists(false)]),
    assertz(db_connection(Conn)).  % Store the connection for reuse

