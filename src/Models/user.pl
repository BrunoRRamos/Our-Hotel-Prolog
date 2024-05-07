:- module(models_user, [create_user_table/0, get_all/1, insert/8, get_one_user/2, set_block_user/3]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).

to_boolean(1, true).
to_boolean(0, true).

create_user_table:-
  get_db_connection(Conn),
  sqlite_query(Conn, "CREATE TABLE IF NOT EXISTS user( 
    email TEXT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    password TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT 1,
    block_reason TEXT,
    role TEXT CHECK(role IN ('ADMIN', 'CLIENT')) NOT NULL);",
    _).

% Users é variavel resposta
get_all(Users) :-
  get_db_connection(_),
  findall(
      user(Email, FName, LName, Pass, IsActive, BlockR, Role),
      (
          user(Email, FName, LName, Pass, IsActiveInt, BlockR, Role),
          to_boolean(IsActiveInt, IsActive)
      ),
      Users
  ).

% User é variavel resposta
get_one_user(User, Email):-
  get_db_connection(_),
  user(Email, FName, LName, Pass, IsActiveInt, BlockR, Role),
  to_boolean(IsActiveInt, IsActive),
  User = user(Email, FName, LName, Pass, IsActive, BlockR, Role).

% Row é variavel resposta
insert(Email, FName, LName, Pass, Active, BlockR, Role, Row):-
  get_db_connection(Conn),
  format(atom(SQL), "INSERT INTO user(email, first_name, last_name, password, is_active, block_reason, role)
                     VALUES('~w', '~w', '~w', '~w', ~w, '~w', '~w')",
                     [Email, FName, LName, Pass, Active, BlockR, Role]),
  sqlite_query(Conn,SQL, Row).

set_block_user(Email, Reason, IsActive) :-
  get_db_connection(Conn),
  findall(
      SQLFragment,
      (
      (nonvar(Email), format(atom(SQLFragment), "email= '~w'", [Email]));
      (nonvar(Reason), format(atom(SQLFragment), "block_reason = '~w'", [Reason]));
      (nonvar(IsActive), format(atom(SQLFragment), "is_active = ~w", [IsActive]))
      ),
      SQLFragments
  ),
  atomic_list_concat(SQLFragments, ', ', SQLSetClause),
  format(atom(SQL), "UPDATE user SET ~w WHERE email = '~w'", [SQLSetClause, Email]),
  sqlite_query(Conn, SQL, _).
