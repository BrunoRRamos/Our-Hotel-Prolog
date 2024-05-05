:-module(admin_menu, [admin_menu/1]).

:- use_module("../util/util.pl").
:- use_module("./roomMenu.pl").
:- use_module("./reviewMenu.pl").

option("1"):-
  tty_clear,
  write("Users menu here").

option("2"):-
  tty_clear,
  write("Rooms menu here\n"),
  room_menu(User).

option("3"):-
  tty_clear,
  write("Services menu here").

option("4"):-
  tty_clear,
  write("Hotel Review menu here\n"),
  review_menu(User).

option("5"):-
  tty_clear,
  exit().

admin_menu(User) :-
  tty_clear,
  write('Available commands:\n'),
  write('1. Users\n'),
  write('2. Rooms\n'),
  write('3. Services\n'),
  write('4. Hotel Review\n'),
  write('5. exit - Quit the program\n'),
  write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
  option(Option).