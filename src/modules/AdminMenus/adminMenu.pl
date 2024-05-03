:-module(admin_menu, [admin_menu/1]).

admin_menu(User) :-
  % Display menu options
  write('Available commands:\n'),
  write('1. Users\n'),
  write('2. Rooms\n'),
  write('3. Services\n'),
  write('4. Hotel Review\n'),
  write('5. exit - Quit the program\n'),
  write('Enter a command: '),
  read(Command),

  % Split command and access first element
  atom_chars(Command, CommandList),
  nth0(0, CommandList, Option),

  % Handle specific options
  ( Option = '1' ->
    % users_menu(Conn),
    admin_menu(User) ; % Recursively call for next action
  Option = '2' ->
    write('Rooms\n'),
    % room_menu(Conn),
    admin_menu(User) ;
  Option = '3' ->
    write('Services\n'),
    admin_menu(User)  ;  % No room_menu implementation provided
  Option = '4' ->
    write('Hotel Review\n'),
    % hotel_review_menu(Conn),
    admin_menu(User);
  Option = 'exit' ->
    write('Exiting program...\n') ;
  true ->  % Handle invalid option
    write('Invalid command\n')
  ).