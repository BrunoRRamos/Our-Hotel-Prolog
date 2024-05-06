:- module(models_room_service, [create_room_service_table/0,
    get_all_services/1, get_services_by_reservation/2,
    insert_room_service/2]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).
:- use_module("./service.pl", [get_service/2]).


create_room_service_table:-
  get_db_connection(Conn),
  sqlite_query(Conn, "CREATE TABLE IF NOT EXISTS room_service (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    service_id INTEGER NOT NULL,
    reservation_id INTEGER NOT NULL,
    FOREIGN KEY (reservation_id) REFERENCES reservation(id),
    FOREIGN KEY (service_id) REFERENCES service(id)
    );",
    
    _).

insert_room_service(SeriviceId, ReservationId) :-
  get_db_connection(Conn),
  format(atom(SQL), "INSERT INTO room_service(service_id, reservation_id)
                      VALUES('~w', '~w')",
                      [SeriviceId, ReservationId]),
  sqlite_query(Conn, SQL, _),
  sqlite_query(Conn, "SELECT last_insert_rowid()", row(Id)).
  

get_all_services(Services) :-
  get_db_connection(_),
  findall(
      service(ServiceId, Price, Type, Description),
      service(ServiceId, Price, Type, Description),
      Services
  ).

get_services_by_reservation(ReservationId, Services):-
  get_all_services(S),

  findall(
    Service, 
    (member(Service, S), service(_, _, _, _, ReservationId) = Service), 
    Services
    ).