:-module(room_menu, [room_menu/1]).

:- use_module("./adminMenu").
:- use_module("../../Models/room.pl", [
   get_all_rooms/1,
   insert_room/4,
   delete_room/1,
   get_one_room/2,
   update_room/4,
   list_rooms/1,
   print_room/1]).
:- use_module("../util/util.pl").

option("1"):-
  tty_clear,
  write("Add room to hotel\n"),
  write("Enter daily rate: "), input(DailyRate, room_menu(User)),
  write("Enter occupancy: "), input(Occupancy, room_menu(User)),
  insert_room(DailyRate, "AVAILABLE", Occupancy, Room),
  write(Room),
  write("\nRoom Created Successfully\n").

option("2"):-
  tty_clear,
  write("Edit room"),
  get_all_rooms(Rooms),
  list_rooms(Rooms),
  write("\n"), 
  parse_input("Enter the number of the room to edit: ", Input, atom_number, RoomId),
  Input \= "q",
  (
    get_one_room(Room, RoomId) ->
    write("Room found\n"),
    print_room(Room),
    write("\n"),

    parse_optional_input("Enter daily rate: (Press enter to skip) ", DailyRateInput, atom_number, DailyRate),
    parse_optional_input("Enter occupancy: (Press enter to skip) ", OccupancyInput, atom_number, Occupancy),

    parse_input("Block room? (y/n) ", _, parse_room_status, Status),

    update_room(RoomId, DailyRate, Status, Occupancy),
    write("Room updated successfully\n")
  ;
    write("Room not found\n")
  ).

option("3"):-
  tty_clear,
  write("Delete room\n"),
  get_all_rooms(Rooms),
  list_rooms(Rooms),
  write("\n"), 
  write("Enter room id: "), input(Id, room_menu(User)),
  delete_room(Id),
  write("Room deleted successfully\n").

option("4"):-
  tty_clear,
  write("List rooms"),
  get_all_rooms(Rooms),
  list_rooms(Rooms),
  write("\n"),
  press_to_continue.

option("5"):-
  tty_clear,
  write("exit - back to admin menu\n"),
  admin_menu(User).

room_menu(User):-
  tty_clear,
  write('Available commands:\n'),
  write('1. Add room to hotel\n'),
  write('2. Edit room\n'),
  write('3. Delete room\n'),
  write('4. List rooms\n'),
  write('5. exit - back to admin menu\n'),
  write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
  option(Option),
  room_menu(User).