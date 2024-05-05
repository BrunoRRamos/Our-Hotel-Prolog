:- module(models_message, [create_message_table/0, get_messages_by_sender/2, get_messages_by_recipient/2]).

:- use_module("../database.pl").
:- use_module(library(prosqlite)).

create_message_table:-
  get_db_connection(Conn),
  sqlite_query(Conn, "CREATE TABLE IF NOT EXISTS message (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sender_email TEXT NOT NULL,
    recipient_email TEXT NOT NULL,
    message TEXT NOT NULL,
    sentDate TEXT NOT NULL,
    FOREIGN KEY (sender_email) REFERENCES user(email),
    FOREIGN KEY (recipient_email) REFERENCES user(email));",
    _).

get_all(Messages):-
  get_db_connection(_),
  findall(
    message(SenderEmail, RecipientEmail, Message, SentDate),
    Messages).

% comapare_email_sender(message(SenderEmail, _, _, _), SenderEmailInput):-
%   atom_string(SenderEmail, Exit) == SenderEmailInput.

% comapare_email_recipient(message(_, RecipientEmail, _, _), RecipientEmailInput):-
%   atom_string(SenderEmail, Exit) == RecipientEmailInput.

compare_email_sender(Email, message(SenderEmail, _, _, _)) :-
  Email == SenderEmail.

get_messages_by_sender(Email, Messages) :-
  get_all(AllMessages),
  include(compare_email_sender(Email), AllMessages, Messages).

get_messages_by_recipient(Email, Messages) :-
  get_all(AllMessages),
  include(comapare_email_recipient(Email), AllMessages, Messages).

% filter_email_sender(SenderEmail, MensagensInput):-

% filter_email_recipient(RecipientEmail, MensagensInput):-

get_all_from_email(Messages, Email):-
  get_all(Messages).

insert(SenderEmail, RecipientEmail, Message, SentDate):-
  get_db_connection(Conn),
  format(atom(SQL), "INSERT INTO message(sender_email, recipient_email, message, sentDate)
                     VALUES(~w, ~w, ~w, ~w)",
                     [SenderEmail, RecipientEmail, Message, SentDate]),
  sqlite_query(Conn,SQL, Row).