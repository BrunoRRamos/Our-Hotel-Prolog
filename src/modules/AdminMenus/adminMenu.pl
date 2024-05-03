:-module(admin_menu, [admin_menu/1]).

:- use_module("../util/util.pl").
:- use_module("./roomMenu.pl").

option("1"):-
  write("Users menu here").

option("2"):-
  write("Rooms menu here\n"),
  room_menu(User).

option("3"):-
  write("Services menu here").

option("4"):-
  write("Hotel Review menu here").

option("5"):-
  exit().

admin_menu(User) :-
  write('Available commands:\n'),
  write('1. Users\n'),
  write('2. Rooms\n'),
  write('3. Services\n'),
  write('4. Hotel Review\n'),
  write('5. exit - Quit the program\n'),
  write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
  option(Option).