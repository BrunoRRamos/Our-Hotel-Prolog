:- use_module("models/create").

:-pack_install([prosqlite], [insecure(true), interactive(false)]), create_tables, halt.
