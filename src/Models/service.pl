:- module(models_service, [create_service_table/0]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).

% Definição dos tipos de serviço
service_type(cleaning).
service_type(meal).

% Criação da tabela de serviço
create_service_table:-
    get_db_connection(Conn),
    sqlite_query(Conn, "CREATE TABLE IF NOT EXISTS service (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      price REAL NOT NULL,
      type TEXT CHECK(type IN ('CLEANING', 'MEAL')) NOT NULL,
      description TEXT NOT NULL);",
      _).
  
insert_service(Price, Type, Description) :-
    get_db_connection(Conn),
    format(atom(SQL), "INSERT INTO service(price, type, description)
                        VALUES(~w, '~w', '~w')",
                        [Price, Type, Description]),
    sqlite_query(Conn, SQL, _),
    sqlite_query(Conn, "SELECT last_insert_rowid()", row(Id)).
        
update_service(Id, Price, Type, Description) :-
    get_db_connection(Conn),
    findall(
        SQLFragment,
        (
        (nonvar(Id), format(atom(SQLFragment), "id= ~w", [Id]));
        (nonvar(Price), format(atom(SQLFragment), "price = '~w'", [Price]));
        (nonvar(Type), format(atom(SQLFragment), "type = '~w'", [Type]));
        (nonvar(Description), format(atom(SQLFragment), "description = '~w'", [Description]))
        ),
        SQLFragments
    ),
    atomic_list_concat(SQLFragments, ', ', SQLSetClause),
    format(atom(SQL), "UPDATE service SET ~w WHERE id = ~w", [SQLSetClause, Id]),
    sqlite_query(Conn, SQL, _).
        
delete_service(Id) :-
    get_db_connection(Conn),
    format(atom(SQL), "DELETE FROM service WHERE id = ~w", [Id]),
    sqlite_query(Conn, SQL, _).

get_all_services(Services):-
  get_db_connection(_),
  findall(
    service(Id, Price, Type, Description),
    service(Id, Price, Type, Description),
    Services
  ).

% deve ser adicionado em roomService
    get_all_services(Services):-
      get_db_connection(_),
      findall(
        service(Id, Price, Type, Description, ReservationId),
        service(Id, Price, Type, Description, ReservationId),
        Services
      ).

  get_service(ServiceId, Service):-
    get_db_connection(_),
    service(ServiceId, Price, Type, Description),
    Service = service(ServiceId, Price, Type, Description).
  

/*adicionado em roomService
get_services_by_reservation(ReservationId, Services):-
  get_all_services(S),

  findall(
    Service, 
    (member(Service, S), service(_, _, _, _, ReservationId) = Service), 
    Services
    ).
