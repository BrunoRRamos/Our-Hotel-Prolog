:- module(util_roomService, [
    request_room_service/5
]).

:- use_module(models_service).

:- dynamic service/5.

request_room_service(Conn, ReservationId, Price, ServiceType, Description) :-
    get_time(CurrentTime),
    create_service(Conn, service(0, Price, ServiceType, Description, ReservationId)),
    writeln("Serviço de quarto requisitado com sucesso!").
