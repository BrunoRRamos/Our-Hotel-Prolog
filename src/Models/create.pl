:- module(models_create, [create_tables/0]).

:- use_module("./user.pl").
:- use_module("./service.pl").
:- use_module("./roomService.pl").
:- use_module("./room.pl").
:- use_module("./reservation.pl").
:- use_module("./message.pl").

create_tables:-
  create_user_table,
  create_reservation_table,
  create_room_table,
  create_service_table,
  create_message_table,
  create_room_service_table.
