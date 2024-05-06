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

listMessages([]):-
  write("List Ended\n").

printMessage(MessageActual):-
  write("--------------------------------------------------\n"),
  MessageActual = message(Id, SenderEmail, RecipientEmail, Message, SentDate),
  write("Sender email: "), write(SenderEmail), write("\n"),
  write("Recipient email: "), write(RecipientEmail), write("\n"),
  write("Message: "), write(Message), write("\n"),

  parse_time(SentDate, TimeStamp),
  stamp_date_time(TimeStamp, DateTime, 'UTC'),
  format_time(string(FormattedDate), "%d-%m-%Y %H:%M", DateTime),
  write("Sent: "), write(FormattedDate), write("\n"),

  write("--------------------------------------------------\n").

get_messages_by_sender(Sender):-
  get_db_connection(_),
  findall(
    message(Id, Sender, RecipientEmail, Message, SentDate),
    message(Id, Sender, RecipientEmail, Message, SentDate), 
  Messages),
  (Messages = [] -> write("No messages here!\n\n"); 
  forall(member(Message, Messages), printMessage(Message))).

get_messages_by_recipient(Recipient):-
  get_db_connection(_),
  findall(
    message(Id, Sender, Recipient, Message, SentDate),
    message(Id, Sender, Recipient, Message, SentDate), 
  Messages),
  (Messages = [] -> write("No messages here!\n\n"); 
  forall(member(Message, Messages), printMessage(Message))).

insert(SenderEmail, RecipientEmail, Message, SentDate):-
  get_db_connection(Conn),
  format(atom(SQL), "INSERT INTO message(sender_email, recipient_email, message, sentDate)
                     VALUES('~w', '~w', '~w', '~w')",
                     [SenderEmail, RecipientEmail, Message, SentDate]),
  sqlite_query(Conn,SQL, Row).