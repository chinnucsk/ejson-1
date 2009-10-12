#! /usr/bin/env escript

main([]) ->
    code:add_pathz("ebin/"),
    check_good(),
    check_errors().

check_good() ->
    lists:map(fun
        ({J, E}) ->
            E = ejson:decode(J),
            J = ejson:encode(E);
        ({J, E, J2}) ->
            E = ejson:decode(J),
            J2 = ejson:encode(E)
        end,
    good()).

good() ->
    [
        {<<"0">>, 0},
        {<<"1">>, 1},
        {<<"12">>, 12},
        {<<"-3">>, -3},
        {<<"309230948234098">>, 309230948234098},
        {<<"1.0">>, 1.0},
        {<<"2.4234324">>, 2.4234324},
        {<<"-3.1416">>, -3.1416},
        {<<"1E4">>, 10000.0, <<"1.0e4">>},
        {<<"3.0E2">>, 300.0, <<"300.0">>},
        {<<"0E3">>, 0.0, <<"0.0">>},
        {<<"1.5E3">>, 1500.0, <<"1.5e3">>},
        {<<"1.5E-1">>, 0.15, <<"0.15">>},
        {<<"-0.323E+2">>, -32.3, <<"-32.3">>}
    ].

check_errors() ->
    lists:map(fun(E) ->
        ok = case ejson:decode(E) of
            {error, _} -> ok;
            Error ->
                io:format("Error: ~p~n", [E]),
                Error
        end
    end, errors()).

errors() ->
    [
        <<"02">>,
        <<"-0">>,
        <<"-01">>,
        <<"+12">>,
        <<"-">>,
        <<"1.">>,
        <<".1">>,
        <<"1.-1">>,
        <<"1E">>,
        <<"1-E2">>,
        <<"2E +3">>,
        <<"1EA">>
    ].