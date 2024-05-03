:-module(clientMenu, [client_menu/1]).

client_menu(User) :-
  % Display menu options
  write('Available commands:\n'),
  write('1. Reservations\n'),
  write('2. Service\n'),
  write('3. exit - Quit the program\n'),
  write('Enter a command: '),
  read(Command),
  % Split command and access first element
  atom_chars(Command, CommandList),
  nth0(0, CommandList, Option),
  % Handle specific options
  (Option = '1' ->
    % reservation_menu(User) ;  % Assuming reservation_menu only needs User
  Option = '2' ->
    write('Service\n'),
    % room_service_menu ;  % Assuming room_service_menu doesn't need arguments
  Option = '3' ->
    write('Goodbye!\n'),
    halt  % Use halt instead of die for cleaner termination
  ; true ->  % Handle invalid option
    write('Invalid command\n')
  ).
