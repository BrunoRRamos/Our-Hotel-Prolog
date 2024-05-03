:-module(review_menu, [review_menu/1]).


option("1"):-
  write("Total clients in reservations today\n").

option("2"):-
  write("Room availability\n").

option("3"):-
  write("Average rating\n").

option("4"):-
  write("Total revenue\n").

option("5"):-
  write("Best rooms\n").

option("6"):-
  write("Last month reservations\n").

option("7"):-
  write("This month reservations\n").

review_menu(User) :-
  write('Available commands:\n'),
  write('1. Total clients in reservations today\n'),
  write('2. Room availability\n'),
  write('3. Average rating\n'),
  write('4. Total revenue\n'),
  write('5. Best rooms\n'),
  write('6. Last month reservations\n'),
  write('7. This month reservations\n'),
  write('8. Exit\n'),
  write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
  option(Option),
  review_menu(User).