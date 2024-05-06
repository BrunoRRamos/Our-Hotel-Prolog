:-module(admin_menu, [admin_menu/1]).

:- use_module("../util/util.pl").
:- use_module("./roomMenu.pl").
:- use_module("./reviewMenu.pl").
:- use_module("../ClientMenus/chatMenu.pl").
:- use_module("./serviceMenu.pl").

option("1", _):-
  tty_clear,
  write("Users menu here").

option("2", User):-
  tty_clear,
  write("Rooms menu here\n"),
  room_menu(User).

option("3", _):-
  tty_clear,
  write("Services menu here"),
  service_menu(User).

option("4", User):-
  chatMenu(User).

option("5", User):-
  tty_clear,
  review_menu(User).

option("6", _):-
  tty_clear,
  exit().

admin_menu(User) :-
  tty_clear,
  write('Available commands:\n'),
  write('1. Users\n'),
  write('2. Rooms\n'),
  write('3. Services\n'),
  write('4. Chat\n'),
  write('5. Hotel Review\n'),
  write('6. exit - Quit the program\n'),
  write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
  option(Option, User),
  admin_menu(User)
  .