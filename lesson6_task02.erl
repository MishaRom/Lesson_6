-module(lesson6_task02).
-compile(export_all).

%% Common Test callbacks

init_per_suite(Config) ->
    %% Ініціалізація перед запуском тестів
    application:start(homework6),
    Config.

end_per_suite(_Config) ->
    %% Завершення після всіх тестів
    application:stop(homework6).

init_per_testcase(_TestCase, Config) ->
    Config.

end_per_testcase(_TestCase, _Config) ->
    ok.

all() ->
    %% Список тест-кейсів
    [create_table_test, insert_test, lookup_test, expiration_test].

%% Тест на створення таблиці
create_table_test(Config) ->
    TableName = test_table,
    ok = homework6:create(TableName),
    ?assertMatch(true, ets:info(TableName) /= undefined),
    Config.

%% Тест на вставку даних
insert_test(Config) ->
    TableName = test_table,
    Key = test_key,
    Value = test_value,
    ok = homework6:insert(TableName, Key, Value),
    ?assertEqual([{Key, Value, infinity}], ets:lookup(TableName, Key)),
    Config.

%% Тест на пошук даних
lookup_test(Config) ->
    TableName = test_table,
    Key = test_key,
    Value = test_value,
    Result = homework6:lookup(TableName, Key),
    ?assertEqual(Value, Result),
    Config.

%% Тест на перевірку обмеження часу
expiration_test(Config) ->
    TableName = test_table,
    Key = expiring_key,
    Value = expiring_value,
    TTL = 1, %% 1 секунда
    ok = homework6:insert(TableName, Key, Value, TTL),
    timer:sleep(2000), %% Чекаємо 2 секунди
    Result = homework6:lookup(TableName, Key),
    ?assertEqual(undefined, Result),
    Config.