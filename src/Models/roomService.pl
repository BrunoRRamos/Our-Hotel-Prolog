:- module(roomService, [
  create_room_service_table/0,
  get_all_room_services/1]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).
:- use_module("./reservation.pl").
:- use_module("./service.pl").

create_room_service_table:-
    get_db_connection(Conn),
    sqlite_query(Conn, "CREATE TABLE IF NOT EXISTS room_service (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reservation_id INTEGER NOT NULL,
        service_id INTEGER NOT NULL,
        FOREIGN KEY (reservation_id) REFERENCES reservation(id),
        FOREIGN KEY (service_id) REFERENCES service(id))";
        _).


insert_service(ReservationId, ServiceId) :-
get_db_connection(Conn),
format(atom(SQL), "INSERT INTO room_service(reservation_id, service_id)
                      VALUES(~w, ~w)",
                      [ReservationId, ServiceId]),
sqlite_query(Conn, SQL, _),
  sqlite_query(Conn, "SELECT last_insert_rowid()", row(Id)).

get_all_room_services(RoomServices) :-
    get_db_connection(_),
    findall(
      roomService(Id, ReservationId, ServiceId),
      (
      roomService(Id, ReservationId, ServiceId)
      ),
      RoomServices
  ).

  get_one_room_serice(RoomService, Id):-
    get_db_connection(_),
    roomService(Id, ReservationId, ServiceId),
    RoomService = roomService(Id, ReservationId, ServiceId).

    get_service_by_type(Type, FilteredRoomServices) :-
      findall(RoomService,
              (   roomService(Id, ReservationId, ServiceId),
                  service(ServiceId, Type, _, _),
                  RoomService = roomService(Id, ReservationId, ServiceId)
              ),
              FilteredRoomServices).
  
