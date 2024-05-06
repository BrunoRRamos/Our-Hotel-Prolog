:- module(util_stay_review, [generate_stay_review/3]).

:- use_module("../../Models/user.pl").
:- use_module("../../Models/reservation.pl").
:- use_module(library(dcg/basics)).
:- use_module(library(system)).

generate_stay_review(Conn, Reservation, User) :-
    writeln('Please provide your rating (from 1 to 5): '),
    read_line_to_codes(user_input, RatingInputCodes),
    string_codes(RatingInput, RatingInputCodes),
    number_string(Rating, RatingInput),
    writeln('Please provide your comments: '),
    read_line_to_string(user_input, Comments),
    get_time(CurrentTime),
    stamp_date_time(CurrentTime, DateTime, 'UTC'),
    date_time_value(year, DateTime, Year),
    date_time_value(month, DateTime, Month),
    date_time_value(day, DateTime, Day),
    date_time_value(hour, DateTime, Hour),
    date_time_value(minute, DateTime, Minute),
    date_time_value(second, DateTime, Second),
    user_email(User, Email),
    insert_review(Conn, Reservation.id, Rating, Comments, Year, Month, Day, Hour, Minute, Second, User.email).