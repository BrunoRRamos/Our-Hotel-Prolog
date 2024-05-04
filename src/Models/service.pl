:- module(models_service, [create_service_table/0,
    create_service/2,
    get_service/3,
    get_all_services/2,
    print_service/1,
    calculate_total_price/3,
    service/5]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).
:- dynamic service/5.

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

create_service(Conn, Service) :-
    execute(
        Conn,
        "INSERT INTO service (reservation_id, price, type, description) VALUES (?, ?, ?, ?)",
        [Service^_reservationId, Service^_price, Service^_type, Service^_description]
    ),
    assertz(Service).

get_service(Conn, ServiceId, Service) :-
    query(Conn, "SELECT * FROM service WHERE id = ?", [ServiceId], row(ServiceId, Price, Type, Description, ReservationId)),
    Service = service(ServiceId, Price, Type, Description, ReservationId).

get_all_services(Conn, Services) :-
    findall(Service, get_service(Conn, _, Service), Services).

print_service(Service) :-
    format("Service ID: ~d~nPrice: ~2f~nType: ~w~nDescription: ~s~nReservation ID: ~d~n",
        [Service^_id, Service^_price, Service^_type, Service^_description, Service^_reservationId]).

calculate_total_price(Conn, ReservationId, TotalPrice) :-
    findall(Price, (service(_, Price, _, _, ReservationId), number(Price)), Prices),
    sum_list(Prices, TotalPrice).