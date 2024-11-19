% Лабораторная работа 5. Рекурсия, списки.

% Задание 1 - Написать предикат, который печатает все нечётные числа из диапазона в порядке
%             убывания. Границы диапазона вводятся с клавиатуры в процессе работы предиката.

print_odd_reverse(Low, High) :-
    Low =< High,
    (High mod 2 =:= 1 -> writeln(High); true),
    Next is High - 1,
    print_odd_reverse(Low, Next).

% Задание 2 - Написать предикат, который находит числа Фибоначчи по их номерам, которые в
%             цикле вводятся с клавиатуры. Запрос номера и нахождение соответствующего числа
%             Фибоначчи должно осуществляться до тех пор, пока не будет введено отрицательное
%             число.
%             Циклический ввод организовать с помощью предиката repeat.
%             Числа Фибоначчи определяются по следующим формулам:
%             F(0)=1, F(1)=1, F(i)=F(i-2)+F(i-1) (i=2,3,4,...).

fibonacci(0, 1) :- !.
fibonacci(1, 1) :- !.
fibonacci(N, Result) :-  
    N > 1,
    N1 is N - 1,
    N2 is N - 2,
    fibonacci(N1, F1),
    fibonacci(N2, F2),
    Result is F1 + F2.

fibonacci_loop :-
    repeat,
    write('Введите номер числа Фибоначчи (отрицательное - для выхода): '),
    read(N),
    (N < 0 -> ! ;
    fibonacci(N, Result),
    write(Result), nl,
    fail).

% Задание 3 - Написать предикат, который разбивает числовой список по двум числам, вводимым с
%             клавиатуры на три списка: меньше меньшего введенного числа, от меньшего
%             введенного числа до большего введенного числа, больше большего введенного числа.
%             Список и два числа вводятся с клавиатуры в процессе работы предиката.
%             Например: [3,7,1,-3,5,8,0,9,2],8,3 => [1,-3,0,2],[3,7,5,8],[9].

split_list(_, _, [], [], [], []).

split_list(Low, High, [H|T], Less, Between, Greater) :-
    H < Low ->
        Less = [H|LessTail],
        split_list(Low, High, T, LessTail, Between, Greater)
    ;
    H =< High ->
        Between = [H|BetweenTail],
        split_list(Low, High, T, Less, BetweenTail, Greater)
    ;
    Greater = [H|GreaterTail],
    split_list(Low, High, T, Less, Between, GreaterTail).

% split_list(3, 8, [3,7,1,-3,5,8,0,9,2], Less, Between, Greater).

% Задание 4 - Написать предикат, который формирует список из наиболее часто встречающихся
%             элементов списка. Список вводится с клавиатуры в процессе работы предиката.
%             Встроенные предикаты поиска максимума и сортировки не использовать!
%             Например: [0,3,5,7,1,5,3,0,3,3,5,7,0,5,0] => [0,3,5].

swap([X, Y | T], [Y, X | T]) :- 
    X > Y.
swap([H | T], [H | T1]) :- 
    swap(T, T1).

bubble_sort(List, Sorted) :- 
    swap(List, List1), !, 
    bubble_sort(List1, Sorted).

bubble_sort(Sorted, Sorted).

count(_, [], 0).

count(X, [X|T], N) :- 
    count(X, T, N1), 
    N is N1 + 1.

count(X, [_|T], N) :- 
    count(X, T, N).

remove_duplicates([], []).

remove_duplicates([H|T], [H|T1]) :-  
    \+ member(H, T), 
    remove_duplicates(T, T1).

remove_duplicates([H|T], T1) :-  
    member(H, T), 
    remove_duplicates(T, T1).

build_frequencies([], _, []).

build_frequencies([H|T], List, [Count-H|FreqTail]) :-
    count(H, List, Count), 
    build_frequencies(T, List, FreqTail).

find_max_frequencies([], MaxFreq, MaxFreq).

find_max_frequencies([Count-_|T], MaxSoFar, MaxFreq) :-
    Count > MaxSoFar ->  
        find_max_frequencies(T, Count, MaxFreq) 
    ;
        find_max_frequencies(T, MaxSoFar, MaxFreq).

most_frequent(List, MostFrequentSorted) :-
    remove_duplicates(List, UniqueList),  
    build_frequencies(UniqueList, List, FreqList),  
    find_max_frequencies(FreqList, 0, MaxFreq),  
    findall(Elem, (member(Count-Elem, FreqList), Count =:= MaxFreq), MostFrequent),
    bubble_sort(MostFrequent, MostFrequentSorted),
    !.
