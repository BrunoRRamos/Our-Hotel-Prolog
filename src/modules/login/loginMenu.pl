:- module(login_menu, [loginLoop/0]).
:- use_module("../../Models/user.pl").
:- use_module("../util/util.pl").
:- use_module("../ClientMenus/clientMenu.pl").
:- use_module("../AdminMenus/adminMenu.pl").

verifyPassword(user(_, _, _, Pass, _, _, _), Password):-
    atom_string(Pass, Exit), Exit == Password.

sendToMenu(User):-
    User = user(_,_,_,_,_,_,Role),
    atom_string(Role, Exit),
    Exit == "CLIENT" -> 
    write("\nCLIENT MENU\n"),
    client_menu(User);
    write("\nADMIN MENU\n"),
    admin_menu(User).

login(User, Email, Pass):- 
    get_one_user(User, Email) -> (
    \+ verifyPassword(User, Pass) -> write("\nIncorrect password\n"), press_to_continue;
    get_one_user(User, Email),
    write("\nLogin Successful\n"),
    press_to_continue,
    sendToMenu(User)); write("\nUser not exists\n"), press_to_continue.

register(Email, FirstName, LastName, Password, Role):-
    get_one_user(_, Email) -> write("\nUser already exists\n");
    insert(Email, FirstName, LastName, Password, true, "", Role, Result),
    write(Result),
    write("\nRegister Successful\n"),
    get_one_user(User, Email),
    press_to_continue,
    sendToMenu(User).

option("1"):-
    tty_clear,
    write('Enter your email: '), read_string(user_input, '\n', '\r', _, Email),
    write('Enter your password: '), read_string(user_input, '\n', '\r', _, Pass),
    login(_, Email, Pass).

option("2"):- 
    tty_clear,
    write('Enter your email: '), read_string(user_input, '\n', '\r', _, Email),
    write('Enter your first name: '), read_string(user_input, '\n', '\r', _, FName),
    write('Enter your last name: '), read_string(user_input, '\n', '\r', _, LName),
    write('Enter your password: '), read_string(user_input, '\n', '\r', _, Pass),
    register(Email, FName, LName, Pass, "CLIENT").

option("3"):- 
    tty_clear,
    exit().

option(_):-true.

loginLoop():-
    tty_clear,
    write("\nAvailable commands:\n"),
    write("1.  Login\n"),
    write("2.  Register\n"),
    write("3.  Exit\n"),
    write('Enter a command: '), read_string(user_input, '\n', '\r', _, Option),
    option(Option),
    loginLoop.