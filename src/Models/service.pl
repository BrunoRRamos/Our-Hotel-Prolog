:- module(models_service, [create_service_table/0]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).
:- dynamic service/5.

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
        
get_service(Id, Service) :-
    get_db_connection(_),
    service(Id, Price, Type, Description),
    Service = service(Id, Price, Type, Description).
        
        
get_all_services(Services) :-
    get_db_connection(_),
    findall(
        service(Id, Price, Type, Description),
        (
        service(Id, Price, Type, Description)
        ),
        Services
    ).

printService(Index, ServiceType, ServicePrice):-
    write("--------------------------------------------------\n"),
    write(Index), write(". Service type: "), write(ServiceType), write("; Service price: "), write(ServicePrice), write("\n"),
    write("--------------------------------------------------\n").

listService([], Cont):-
    write("END").

listService([ServiceActual|Rest], Cont):-
    Cont is 1,
    ServiceActual = service(id, price, type, description),
    printService(Cont, type, price),
    listService(Rest, Cont+1).

loadService():-
    get_all_services(Services),
    listService(Services).

      
    listSenderMessages([], SenderTarget):-
    write("\n").
    
    listSenderMessages([MessageActual|Rest], SenderTarget):-
    MessageActual = message(Id, SenderEmail, RecipientEmail, Message, SentDate),
    atom_string(SenderTarget, Exit), Exit == SenderTarget -> printMessage(MessageActual);
    listSenderMessages(Rest, SenderTarget).
    
    listRecipientMessages([MessageActual|Rest], RecipientTarget):-
    MessageActual = message(Id, SenderEmail, RecipientEmail, Message, SentDate),
    atom_string(RecipientEmail, Exit), Exit == RecipientTarget -> printMessage(MessageActual);
    listRecipientMessages(Rest, RecipientTarget).
    
    get_meal_service(SenderTarget):-
    get_all_messages(AllMessages),
    listSenderMessages(AllMessages, SenderTarget).
    
    get_messages_by_recipient(RecipientTarget):-
    get_all_messages(AllMessages),
    listRecipientMessages(AllMessages, RecipientTarget).