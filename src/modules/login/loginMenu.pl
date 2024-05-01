:- use_module(login_actions)

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

action(_):- write("Invalid Option").

loginLoop():-
    write("\nAvailable commands:").
    write("1.  Login").
    write("2.  Register").
    write("3.  exit - Quit the program").
    write("\nEnter a command: ").
    read(Option).
    action(Option).