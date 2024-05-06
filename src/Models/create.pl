:- module(models_create, [create_tables/0]).
:- use_module("../database.pl").
:- use_module(library(prosqlite)).

:- use_module("./user.pl").
:- use_module("./service.pl").
:- use_module("./roomService.pl").
:- use_module("./room.pl").
:- use_module("./reservation.pl").
:- use_module("./message.pl").

create_default_adm:-
  get_db_connection(Conn),
  sqlite_query(Conn, "INSERT INTO user(email, first_name, last_name, password, is_active, block_reason, role)
                      VALUES('adm@gmail.com', 'adm', 'adm', '123', true, '', 'ADMIN')",
    _).

create_tables:-
  create_user_table,
  create_reservation_table,
  create_room_table,
  create_service_table,
  create_message_table,
  create_default_adm,
  create_room_service_table.