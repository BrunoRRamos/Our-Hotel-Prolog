:- use_module(user)

blockClient(User, Reason, BlockedUser) :-
    (Reason = '' ->
        BlockedUser = User.put(is_active, false).put(block_reason, 'Reason not specified');
    BlockedUser = User.put(is_active, false).put(block_reason, Reason)).