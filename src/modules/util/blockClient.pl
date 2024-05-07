:- module(blockClient, [ block_client/2]).

:- use_module("../../Models/user.pl").

block_client(Email, Reason) :-
    set_block_user(Email, Reason, false),
    writeln('Customer account successfully blocked.').
