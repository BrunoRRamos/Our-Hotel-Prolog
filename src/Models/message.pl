:- module(models_message, [get_all_messages/1, insert/4, create_message_table/0, get_messages_by_sender/1, get_messages_by_recipient/1]).

:- use_module("../database.pl").
:-use_module("./user.pl").
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

get_all_messages(Messages):-
  get_db_connection(_),
  findall(
    message(Id, SenderEmail, RecipientEmail, Message, SentDate),
    message(Id, SenderEmail, RecipientEmail, Message, SentDate),
    Messages).

% verifyEmail(Email):-
%   get_one_user(User, Email).

listMessages([]):-
  write("List Ended\n").

printMessage(MessageActual):-
  write("--------------------------------------------------\n"),
  MessageActual = message(Id, SenderEmail, RecipientEmail, Message, SentDate),
  write("Sender email: "), write(SenderEmail), write("\n"),
  write("Recipient email: "), write(RecipientEmail), write("\n"),
  write("Message: "), write(Message), write("\n"),
  write("SentDate: "), write(SentDate), write("\n"),
  write("--------------------------------------------------\n").

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

get_messages_by_sender(SenderTarget):-
  get_all_messages(AllMessages),
  listSenderMessages(AllMessages, SenderTarget).

get_messages_by_recipient(RecipientTarget):-
  get_all_messages(AllMessages),
  listRecipientMessages(AllMessages, RecipientTarget).

insert(SenderEmail, RecipientEmail, Message, SentDate):-
  get_db_connection(Conn),
  format(atom(SQL), "INSERT INTO message(sender_email, recipient_email, message, sentDate)
                     VALUES('~w', '~w', '~w', '~w')",
                     [SenderEmail, RecipientEmail, Message, SentDate]),
  sqlite_query(Conn,SQL, Row).