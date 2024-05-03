:- module(login_menu, [loginLoop/0]).
:- use_module("../../Models/user.pl").
:- use_module("../AdminMenus/adminMenu.pl").
:- use_module("../ClientMenus/clientMenu.pl").

verifyPassword(user(_, _, _, Pass, _, _, _), Password):-
    atom_string(Pass, Exit), Exit == Password.

sendToMenu(user(_,_,_,_,_,_,Role)):-
    atom_string(Role, Exit),
    Exit == "CLIENT" -> 
    write("CLIENT MENU\n"),
    client_menu(User);
    write("ADMIN MENU\n"),
    admin_menu(User).

login(User, Email, Pass):- 
    get_one(User, Email),
    \+ verifyPassword(User, Pass) -> write("Incorrect password\n");
    get_one(User, Email),
    write("Login Successful\n"),
    sendToMenu(User).

register(Email, FirstName, LastName, Password, Role):-
    get_one(_, Email) -> write("User already exists");
    insert(Email, FirstName, LastName, Password, true, "", Role, Result),
    write(Result),
    write("Register Successful").

action("1"):-
    write('Enter your email: '), read_string(user_input, '\n', '\r', _, Email),
    write('Enter your password: '), read_string(user_input, '\n', '\r', _, Pass),
    login(_, Email, Pass).
    % FUNÇÃO DE MENU DE CLIENT

action("2"):- 
    write('Enter your email: '), read_string(user_input, '\n', '\r', _, Email),
    write('Enter your first name: '), read_string(user_input, '\n', '\r', _, FName),
    write('Enter your last name: '), read_string(user_input, '\n', '\r', _, LName),
    write('Enter your password: '), read_string(user_input, '\n', '\r', _, Pass),
    register(Email, FName, LName, Pass, "CLIENT"), !.
    % FUNÇÃO DE MENU DE CLIENT

action("3"):- 
    write("╔══════════════════════════════════════════════════════════════════════════════╗\n"),
    write("║                    THANK YOU FOR VISITING, COME BACK SOON                    ║\n"),
    write("║══════════════════════════════════════════════════════════════════════════════║\n"),
    write("║                                    TEAM:                                     ║\n"),
    write("║══════════════════════════════════════════════════════════════════════════════║\n"),
    write("║                               Bruno Rodrigues                                ║\n"),
    write("║                              José Gabriel Melo                               ║\n"),
    write("║                             Pedro Henrique Costa                             ║\n"),
    write("║                              Pedro Silva Filho                               ║\n"),
    write("║                                Suelen Felix                                  ║\n"),
    write("╚══════════════════════════════════════════════════════════════════════════════╝\n"),
    halt.

loginLoop():-
    write("\nAvailable commands:\n"),
    write("1.  Login\n"),
    write("2.  Register\n"),
    write("3.  exit - Quit the program\n"),
    write('Enter the option: '), read_string(user_input, '\n', '\r', _, Option),
    action(Option).