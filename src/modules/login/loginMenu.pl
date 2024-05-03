:- module(login_menu, [loginLoop/0]).
:- use_module("../../Models/user.pl").
:- use_module("../util/util.pl").
:- use_module("../ClientMenus/clientMenu.pl").

verifyPassword(user(_, _, _, Pass, _, _, _), Password):-
    atom_string(Pass, Exit), Exit == Password.

login(User, Email, Pass):- 
    get_one(User, Email),
    verifyPassword(User, Pass) -> write(User), write("Login Successful");
    write("Incorrect password").

register(Email, FirstName, LastName, Password, Role):-
    get_one(_, Email) -> write("User already exists");
    insert(Email, FirstName, LastName, Password, true, "", Role, Result),
    write(Result),
    write("Register Successful").

action("1"):-
    write('Enter your email: '), read_string(user_input, '\n', '\r', _, Email),
    write('Enter your password: '), read_string(user_input, '\n', '\r', _, Pass),
    login(_, Email, Pass),
    clientMenu().

action("2"):- 
    write('Enter your email: '), read_string(user_input, '\n', '\r', _, Email),
    write('Enter your first name: '), read_string(user_input, '\n', '\r', _, FName),
    write('Enter your last name: '), read_string(user_input, '\n', '\r', _, LName),
    write('Enter your password: '), read_string(user_input, '\n', '\r', _, Pass),
    register(Email, FName, LName, Pass, "CLIENT"),
    clientMenu().

action("3"):- 
    exit().

loginLoop():-
    write("\nAvailable commands:\n"),
    write("1.  Login\n"),
    write("2.  Register\n"),
    write("3.  exit - Quit the program\n"),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    action(Option).