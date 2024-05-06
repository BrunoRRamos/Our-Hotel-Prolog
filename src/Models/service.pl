:- module(models_service, [create_service_table/0, get_all_services/1, get_services_by_reservation/2]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).

create_service_table:-
  get_db_connection(Conn),
  sqlite_query(Conn, "CREATE TABLE IF NOT EXISTS service (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    price REAL NOT NULL,
    type TEXT CHECK(type IN ('CLEANING', 'MEAL')) NOT NULL,
    description TEXT NOT NULL,
    reservation_id INTEGER NOT NULL,
    FOREIGN KEY (reservation_id) REFERENCES reservation(id));",
    _).

get_all_services(Services):-
  get_db_connection(_),
  findall(
    service(Id, Price, Type, Description, ReservationId),
    service(Id, Price, Type, Description, ReservationId),
    Services
  ).

get_services_by_reservation(ReservationId, Services):-
  get_all_services(S),

  findall(
    Service, 
    (member(Service, S), service(_, _, _, _, ReservationId) = Service), 
    Services
    ).