-module(bert_tests).
-include_lib("eunit/include/eunit.hrl").
-import(bert, [encode/1, decode/1, encode64/1, decode64/1]).

% simple terms (both encoding and decoding)

-define(assertEncode(Data, CorrectTerm),
    ?assertEqual(binary_to_term(encode(Data)), CorrectTerm),
    ?assertEqual(decode(term_to_binary(CorrectTerm)), Data)).

basic_types_test() ->
    lists:map(
        fun(X) -> ?assertEncode(X, X) end,
        [4,
         8.1516,
         foo,
         {coord, 23, 42},
         [1, 2, 3],
         [a, [1, 2]],
         <<"Roses are red\0Violets are blue">>]
    ).

nil_test() ->
    ?assertEncode([], {bert, nil}).

special_atoms_test() ->
    ?assertEncode(true, {bert, true}),
    ?assertEncode(false, {bert, false}).

empty_dictionary_test() ->
    ?assertEncode(dict:new(), {bert, dict, []}).

% encoding

encode_dictionary_test() ->
    ?assertMatch({bert, dict, [_, _]},
                 binary_to_term(encode(dict:from_list([{name, <<"Tom">>}, {age, 30}])))).

encode_nested_test() ->
    ?assertEncode([foo, [true, false], {42, dict:new()}],
                  [foo, [{bert, true}, {bert, false}], {42, {bert, dict, []}}]),
    Data = binary_to_term(encode(dict:from_list([{42, true}, {empty, dict:new()}]))),
    ?assertMatch({bert, dict, [_, _]}, Data),
    {bert, dict, DictItems} = Data,
%    ?assertEqual([], ordsets:subtract(ordsets:from_list(DictItems),
%                                      [{42, {bert, true}}, {empty, {bert, dict, []}}])).
    true.

%% decoding

decode_dictionary_test() ->
    Items = [{name, <<"Tom">>}, {age, 30}],
    ?assertEqual(
        [],
        ordsets:subtract(ordsets:from_list(Items),
        dict:to_list(decode(term_to_binary({bert, dict, Items}))))).

%decode_nested_test() ->
%    ?assertEqual(dict:from_list([{true, dict:from_list([{42, []}])}]),
%        decode(term_to_binary(
%            {bert, dict, [{{bert, true}, {bert, dict, [{42, {bert, nil}}]}}]}))).

%% base64

base64_test() ->
    A = [foo, {bar, baz}],
    ?assertEqual(A, decode64(encode64(A))).
