:- module(database, [connect_to_database/1]).

:- use_module(library(prosqlite)).

connect_to_database(conn) :-
    sqlite_connect( hotel, conn, exists(false) ).
