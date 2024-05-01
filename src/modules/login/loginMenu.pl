:- module(login_menu, [loginLoop/0]).
:- use_module("../../Models/user.pl").

login(Email, Password, Users):- 
    number(user(Email, _, _, Password, true, _, _), Users),
    write("Login Successful").

register(Email, FirstName, LastName, Password, Role):-
    insert(Email, FirstName, LastName, Password, true, false, Role),
    write("Register Successful").

action("1"):- 
    write("\nInsert your Email: "),
    read(EmailInput),
    write("\nInsert your Password: "),
    read(PasswordInput),
    login(EmailInput, PasswordInput, get_all()).
    % FUNÇÃO DE MENU DE CLIENT

action("2"):- 
    write("\nInsert your First Name: "),
    read(FirstNameInput),
    write("\nInsert your Last Name: "),
    read(LastNameInput),
    write("\nInsert your E-mail: "),
    read(EmailInput),
    write("\nInsert your Password: "),
    read(PasswordInput),
    register(Email, FirstNameInput, LastNameInput, PasswordInput, "CLIENT").
    % FUNÇÃO DE MENU DE CLIENT

action("3"):- write("Implementar exit").%exit


loginLoop():-
    write("\nAvailable commands:\n"),
    write("1.  Login\n"),
    write("2.  Register\n"),
    write("3.  exit - Quit the program\n"),
    write("\nEnter a command: \n"),
    read(Option),
    action(Option).