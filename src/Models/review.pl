:- module(models_review, [create_review_table/0, insert_review/3]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).

create_review_table:-
  get_db_connection(Conn),
  sqlite_query(Conn, "CREATE TABLE IF NOT EXISTS review (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    reservation_id INTEGER NOT NULL,
    comments TEXT,
    rating INT NOT NULL,
    FOREIGN KEY (reservation_id) REFERENCES reservation(id));",
    _).

insert_review(ReservationId, Comments, Rating):-
    get_db_connection(Conn),
    format(atom(SQL), "INSERT INTO review(reservation_id, comments, rating)
                        VALUES(~w, '~w', ~w)",
                        [ReservationId, Comments, Rating]),
    sqlite_query(Conn, SQL, _),
    sqlite_query(Conn, "SELECT last_insert_rowid()", row(Id)).

