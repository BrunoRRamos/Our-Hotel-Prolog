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
:- use_module("../util/util.pl", [input/2, optionalInput/3]).

option("1"):-
  write("Add room to hotel\n"),
  write("Enter daily rate: "), input(DailyRate, room_menu(User)),
  write("Enter occupancy: "), input(Occupancy, room_menu(User)),
  insert_room(DailyRate, "AVAILABLE", Occupancy, Room),
  write(Room),
  write("\nRoom Created Successfully\n").

option("2"):-
  write("Edit room"),
  get_all_rooms(Rooms),
  list_rooms(Rooms),
  write("\n"), 
  write("Enter room id: "), input(Id, room_menu(User)),
  get_one_room(Room, Id),
  room(Id, DailyRate, Status, Occupancy),
  write("Selected room: \n"), print_room(Room), write("\n"),
  write("Enter daily rate: "), optionalInput(InputDailyRate, DailyRate, room_menu(User)),
  write("Enter occupancy: "), optionalInput(InputOccupancy, Occupancy, room_menu(User)),
  write("Enter status:(A,B) "), optionalInput(InputStatus, Status, room_menu(User)),
  (InputStatus = "A" -> InputStatus = "AVAILABLE"; InputStatus = "BLOCKED"),
  update_room(Id, InputDailyRate, InputStatus, InputOccupancy),
  write("Room updated successfully\n").

option("3"):-
  write("Delete room\n"),
  get_all_rooms(Rooms),
  list_rooms(Rooms),
  write("\n"), 
  write("Enter room id: "), input(Id, room_menu(User)),
  delete_room(Id),
  write("Room deleted successfully\n").

option("4"):-
  write("List rooms"),
  get_all_rooms(Rooms),
  list_rooms(Rooms),
  write("\n").

option("5"):-
  write("exit - back to admin menu\n"),
  admin_menu(User).

room_menu(User):-
  write('Available commands:\n'),
  write('1. Add room to hotel\n'),
  write('2. Edit room\n'),
  write('3. Delete room\n'),
  write('4. List rooms\n'),
  write('5. exit - back to admin menu\n'),
  write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
  option(Option),
  room_menu(User).