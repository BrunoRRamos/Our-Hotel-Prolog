:- module(login_actions, [login/0, register/1]).
:- use_module(models_user).

login(Email, Password, Users):- 
    number(user(Email, _, _, Password, true, _, _), Users),
    write("Login Successful").

register(Email, FirstName, LastName, Password, Role):-
    insert(Email, FirstName, LastName, Password, true, false, Role),
    write("Register Successful").