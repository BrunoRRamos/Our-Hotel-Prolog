:- module(util.blockClient, [block_client/1, block_client/2]).

:- use_module("../models_user").

block_client(Email) :-
    block_client(Email, '').

block_client(Email, '') :-
    block_client(Email, _).

block_client(Email, Reason) :-
    get_one(user(Email, _, _, _, _, _, 'ADMIN'), _),
    update_user_status(Email, false, Reason),
    writeln('Customer account successfully blocked.').

update_user_status(Email, Status, Reason) :-
    get_db_conection(Conn),
    (Reason = ''
    -> 
        format(atom(SQL), "UPDATE user SET is_active = ~w WHERE email = '~w'", [Status, Email])
    ; 
        format(atom(SQL), "UPDATE user SET is_active = ~w, block_reason = '~w' WHERE email = '~w'", [Status, Reason, Email])
    ),
    sqlite_query(Conn, SQL, _).