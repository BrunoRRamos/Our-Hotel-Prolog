:- module(util_stay_review, [generate_stay_review/1]).

:- use_module("../../Models/user.pl").
:- use_module("../../Models/reservation.pl").
:- use_module("../../Models/review.pl").
:- use_module("./util.pl").



generate_stay_review(ReservationId) :-
    parse_input("Please provide your rating (from 1 to 5): ", _, atom_number, Rating),
    parse_input("Please provide your comments: ", _, atom_string, Comments),
    insert_review(ReservationId, Comments, Rating),
    write("\nReview Done!\n").