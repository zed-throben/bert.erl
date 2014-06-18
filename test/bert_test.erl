-module(bert_test).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

%% encode

encode_list_nesting_test() ->
  Bert = term_to_binary([foo, {bert, true}]),
  Bert = bert:encode([foo, true]).

encode_tuple_nesting_test() ->
  Bert = term_to_binary({foo, {bert, true}}),
  Bert = bert:encode({foo, true}).

encode_empty_list_test() ->
  Bert = term_to_binary({bert, nil}),
  Bert = bert:encode([]).

encode_dict_test() ->
  Bert = term_to_binary({bert, dict, dict:to_list(dict:from_list([{foo, bar}]))}),
  Bert = bert:encode(dict:from_list([{foo, bar}])).

encode_bool_test() ->
  Bert = term_to_binary({bert, false}),
  Bert = bert:encode({bert, false}).

%% decode

decode_list_nesting_test() ->
  Bert = term_to_binary([foo, {bert, true}]),
  Term = [foo, true],
  Term = bert:decode(Bert).

decode_tuple_nesting_test() ->
  Bert = term_to_binary({foo, {bert, true}}),
  Term = {foo, true},
  Term = bert:decode(Bert).

decode_empty_list_test() ->
  Bert = term_to_binary({bert, nil}),
  Term = [],
  Term = bert:decode(Bert).

decode_dict_test() ->
  Bert = term_to_binary({bert, dict, [{foo, bar}]}),
  Term = dict:from_list([{foo, bar}]),
  Term = bert:decode(Bert).

decode_bool_test() ->
  Bert = term_to_binary({bert, false}),
  Term = false,
  Term = bert:decode(Bert).

base64_test() ->
    A = [foo, {bar, baz}],
    ?assertEqual(A, decode64(encode64(A))).

-endif.
