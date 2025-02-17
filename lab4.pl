% Лабораторная работа 4. Факты и правила.

% Задание 1 - Описать следующее дерево отношений с помощью предиката "родитель":
%       ┌──────┐  ┌──────┐
%       │ Джон │  │ Мэри │      [asciiflow.com]
%       └─────┬┘  └┬────┬┘
%            ┌┴────┴┐  ┌┴─────┐
%            │ Боб  │  │ Энн  │
%            └┬──┬─┬┘  └──────┘
%        ┌────┘  │ └────┐
%  ┌─────┴┐  ┌───┴──┐  ┌┴─────┐
%  │ Лиз  │  │ Паул │  │ Сэм  │
%  └──────┘  └──┬───┘  └──────┘
%            ┌──┴───┐
%            │ Пат  │
%            └──────┘

родитель('Джон', 'Боб').
родитель('Мэри', 'Боб').
родитель('Мэри', 'Энн').

родитель('Боб', 'Лиз').
родитель('Боб', 'Паул').
родитель('Боб', 'Сэм').

родитель('Паул', 'Пат').

% Задание 2 - Введите отношения "мужчина", "женщина" в форме фактов.

мужчина('Джон').
мужчина('Боб').
мужчина('Паул').
мужчина('Сэм').

женщина('Мэри').
женщина('Энн').
женщина('Лиз').
женщина('Пат').

% Задание 3 - С помощью правил определите отношения "отец", "мать", "брат", "сестра", "внук",
%             "тетя", "иметь двух детей", "продолжатель рода" (мужчина, у которого есть сын).

отец(X,Y) :- мужчина(X), родитель(X,Y).
мать(X,Y) :- женщина(X), родитель(X,Y).
брат(X,Y) :- мужчина(X), родитель(Z,X), родитель(Z,Y), X\=Y.
сестра(X,Y) :- женщина(X), родитель(Z,X), родитель(Z,Y), X\=Y.
внук(X,Y) :- мужчина(X), родитель(Z,X), родитель(Y,Z).
тетя(X,Y) :- женщина(X), родитель(A,X), родитель(A,Z), X\=Z, родитель(Z,Y).
иметь_двух_детей(X) :- родитель(X,Y), родитель(X,Z), Y\=Z, Y@>Z, \+ (родитель(X,E), E\=Y, E\=Z).
продолжитель_рода(X) :- мужчина(X), родитель(Y,X), мужчина(Y).

% Задание 4 - Задайте вопросы и получите ответы в Пролог-системе:
%             а) Кто отец Сэма?
%             б) Есть ли мать у Боба? (ответ должен быть true)
%             в) Кто сестра Сэма?
%             г) Есть ли сестра у Лиз?
%             д) Кто брат Боба?
%             е) Кто внуки Мэри?
%             ж) Чей внук Паул?
%             з) Кто тетя Сэма?
%             и) Есть ли племянники у Энн?
%             к) У кого ровно двое детей? (Пролог-система должна находить только Мэри, и,
%                причем, только один раз).
%             л) Боб - продолжатель рода?

?- отец(A, 'Сэм').
?- мать(_, 'Боб').
?- сестра(B, 'Сэм').
?- сестра(_, 'Лиз').
?- брат(C, 'Боб').
?- внук(D, 'Мэри').
?- внук('Паул', E).
?- тетя(F, 'Сэм').
?- тетя('Энн', _).
?- иметь_двух_детей(G).
?- продолжитель_рода('Боб').
