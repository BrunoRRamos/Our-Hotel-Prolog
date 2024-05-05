:- module(chatMenu, [chatMenu/0]).
:- use_module("../../Models/message.pl").
:- use_module("./clientMenu.pl").

option("1"):- 
    write('Enter your Email: '), read_string(user_input, '\n', '\r', _, RecipientEmail),
    get_messages_by_recipient(RecipientEmail),
    chatMenu().

option("2"):- 
    write('Enter your Email: '), read_string(user_input, '\n', '\r', _, SenderEmail),
    get_messages_by_sender(SenderEmail),
    chatMenu().

option("3"):- 
    write('Enter your Email: '), read_string(user_input, '\n', '\r', _, SenderEmail),
    write('Enter the recipient Email: '), read_string(user_input, '\n', '\r', _, RecipientEmail),
    write('Enter the message: '), read_string(user_input, '\n', '\r', _, Message),
    write('Enter today date: '), read_string(user_input, '\n', '\r', _, SentDate),
    insert(SenderEmail, RecipientEmail, Message, SentDate),
    write("Message Sent !"),
    chatMenu().

option("4"):- 
    client_menu().

chatMenu():-
    write("\nAvailable commands:\n"),
    write("1.  View recived messages\n"),
    write("2.  View sent messages\n"),
    write("3.  Whrite a new message\n"),
    write("4.  Go back\n"),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option).