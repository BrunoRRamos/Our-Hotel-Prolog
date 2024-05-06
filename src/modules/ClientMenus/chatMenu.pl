:- module(chatMenu, [chatMenu/1]).

:- use_module("../../Models/message.pl").
:- use_module("../../Models/user.pl").
:- use_module("./clientMenu.pl").
:- use_module("../util/util.pl").
:- use_module("../../database.pl").

:- use_module(library(prosqlite)).

chatMenu(User):-
    tty_clear,
    write("\nAvailable commands:\n"),
    write("1.  View inbox \n"),
    write("2.  View sent messages\n"),
    write("3.  Write a new message\n"),
    write("4.  Go back\n"),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option, User);
    chatMenu(User).

option("1", User):- 
    tty_clear,
    User = user(Email, _, _, _, _, _, _),
    get_messages_by_recipient(Email),
    press_to_continue.

option("2", User):- 
    tty_clear,
    User = user(Email, _, _, _, _, _, _),
    get_messages_by_sender(Email),
    press_to_continue.

option("3", User):- 
    tty_clear,
    User = user(Email, _, _, _, _, _, _),
    write('Enter the recipient Email: '), read_string(user_input, '\n', '\r', _, RecipientEmail),

    (get_one_user(_, RecipientEmail) ->
    write('Enter the message: '), read_string(user_input, '\n', '\r', _, Message),

    get_time(TimeStamp),
    format_time(atom(SentDate), '%F %T', TimeStamp),

    insert(Email, RecipientEmail, Message, SentDate),
    write("Message Sent!\n\n"),
    press_to_continue;

    write("User not found!\n\n"),
    press_to_continue).

option("4",_):- true.

option(_):-true.
