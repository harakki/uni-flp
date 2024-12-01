% РГЗ
% ВАРИАНТ 2

% Задание 1 - Удалите из списка все повторные вхождения элементов (должны остаться первые
%             вхождения повторяющихся элементов).
%             Например, [1,2,1,4,1,2,3]-> [1,2,4,3].

remove_duplicates(List, Result) :-
    remove_duplicates_accumulator(List, [], ReversedResult),
    reverse(ReversedResult, Result).

% Если список пуст, то результат - аккумулятор.
remove_duplicates_accumulator([], Accumulator, Accumulator).

% Если элемент есть в аккумуляторе, то пропускаем его
remove_duplicates_accumulator([H|T], Accumulator, Result) :-
    member(H, Accumulator),
    remove_duplicates_accumulator(T, Accumulator, Result).

% Если элемента нет в аккумуляторе, то добавляем его
remove_duplicates_accumulator([H|T], Accumulator, Result) :-
    \+ member(H, Accumulator),
    remove_duplicates_accumulator(T, [H|Accumulator], Result).

% Задание 2 - Запишите в новый файл все строки исходного файла, содержащие в качестве
%             фрагмента заданную строку, которая вводится с клавиатуры.

filter_lines(SourceFile, SearchStr, OutputFile) :-
    open(SourceFile, read, InStream),
    open(OutputFile, write, OutStream),
    process_lines(InStream, SearchStr, OutStream),
    close(InStream),
    close(OutStream).

process_lines(InStream, SearchStr, OutStream) :-
    read_line_to_string(InStream, Line),
    % Пока не EOF, то ...
    (   Line \= end_of_file
    % Если подстрока есть в строке, то записываем строку в файл
    ->  (   sub_string(Line, _, _, _, SearchStr)
        ->  write(OutStream, Line), nl(OutStream)
        % Иначе - пропускаем
        ;   true
       ),
       process_lines(InStream, SearchStr, OutStream)
    ;   true).  % EIF -> Exit

% Задание 3 - Напишите программу для работы с базой данных по заданию. Начальная база данных
%             должна храниться в файле базы данных. В программе должно присутствовать меню из
%             5 пунктов, реализующих следующие возможности:
%               − просмотр содержимого базы данных;
%               − добавления записи (за один вход в этот пункт должна быть возможность
%                 добавления нескольких записей);
%               − удаления записи (за один вход в этот пункт должна быть возможность удаления
%                 нескольких записей);
%               − выполнения запроса к базе данных по заданию;
%               − выход из программы с сохранением содержимого базы данных в файл базы
%                 данных
% 
%             Создайте базу данных городского транспорта: название транспорта, номер
%             маршрута, список остановок. Определите, на каких маршрутах можно
%             добраться от одной остановки до другой без пересадок. Названия остановок
%             вводятся с клавиатуры.

% Определение динамической базы данных
:- dynamic transport/3.

setup_menu :-
    writeln('1 - Просмотр базы данных'),
    writeln('2 - Добавить запись'),
    writeln('3 - Удалить запись'),
    writeln('4 - Найти маршрут между остановками'),
    writeln('5 - Сохранить и выйти'),
    writeln('Выберите пункт: '),
    write(''), read(Choice),
    handle_choice(Choice).

% Обработчик действий
handle_choice(1) :- view_database, setup_menu.
handle_choice(2) :- add_records, setup_menu.
handle_choice(3) :- delete_records, setup_menu.
handle_choice(4) :- find_route, setup_menu.
handle_choice(5) :- save_and_exit.
handle_choice(_) :- writeln('Ошибка! Такого пункта нет.'), setup_menu.

% 1 - Просмотр базы данных
view_database :-
    writeln('Содержимое базы данных:'),
    forall(transport(Type, Route, Stops), 
        (write('Транспорт: '), writeln(Type),
         write('Маршрут  : '), writeln(Route),
         write('Остановки: '), writeln(Stops))),
    writeln('').

% 2 - Добавление записей
add_records :-
    writeln('Добавление записей.'),
    writeln('Для остановки добавления данных введите "n"'),
    repeat,
    writeln('Введите название транспорта: '),
    write(''), read(Type),
    (Type == n -> ! ; true),
    writeln('Введите номер маршрута: '),
    write(''), read(Route),
    (Route == n -> ! ; true),
    writeln('Введите список остановок вида [stop1, stop2, etc]: '),
    write(''), read(Stops),
    (Stops == n -> ! ; true),
    assertz(transport(Type, Route, Stops)),
    writeln('Запись добавлена.'), fail.

% 3 - Удаление записей
delete_records :-
    writeln('Удаление записей.'),
    writeln('Для остановки удаления данных введите "n"'),
    repeat,
    writeln('Введите название транспорта для удаления: '),
    write(''), read(Type),
    (Type == n -> ! ; true),
    writeln('Введите номер маршрута для удаления: '), 
    write(''), read(Route),
    (Route == n -> ! ; true),
    retractall(transport(Type, Route, _)),
    writeln('Запись удалена.'), fail.

% 4 - Поиск маршрута между остановками
find_route :-
    writeln('Поиск маршрута между остановками.'),
    writeln('Введите начальную остановку: '),
    write(''), read(Start),
    writeln('Введите конечную остановку: '),
    write(''), read(End),
    writeln('Возможные маршруты:'),
    forall(transport(Type, Route, Stops),
        (member(Start, Stops), member(End, Stops) ->
            (write('Транспорт: '), writeln(Type),
             write('Маршрут  : '), writeln(Route),
             write('Остановки: '), writeln(Stops)) ; true)),
    writeln('').

% 5 - Сохранение и выход
save_and_exit :-
    writeln('Путь к файлу для сохранения: '),
    write(''), read(FileNameRaw),
    % Обработка случая с путем бех кавычек
    (atom(FileNameRaw) -> atom_string(FileNameRaw, FileName) ;
     compound(FileNameRaw) -> term_string(FileNameRaw, FileName) ;
     FileName = FileNameRaw),
    open(FileName, write, Stream),
    forall(transport(Type, Route, Stops),
        (write(Stream, transport(Type, Route, Stops)), write(Stream, '.'), nl(Stream))),
    close(Stream),
    writeln('База данных записана.'),
    halt.

% Стартовая загрузка базы данных
load_database(FileName) :-
    open(FileName, read, Stream),
    repeat,
    read(Stream, Term),
    ( Term == end_of_file -> close(Stream), ! ; assertz(Term), fail).

% Старт программы
start :-
    writeln('Введите путь базы данных ("n" для создания новой): '),
    write(''), read(FileName),
    ( FileName \= n -> 
        (exists_file(FileName) -> load_database(FileName) ; writeln('Файл не найден, работа продолжится в новой базе данных.'))
        ; writeln('Создание новой базы данных.')),
    setup_menu.

