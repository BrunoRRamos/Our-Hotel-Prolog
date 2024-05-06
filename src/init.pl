:- use_module("Models/create").

:-pack_install([prosqlite], [insecure(true), interactive(false)]), create_tables, halt.
