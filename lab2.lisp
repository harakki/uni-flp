; Лабораторная работа 2. Рекурсия.
; ВАРИАНТ 4

; В теле функции использование операторов SET, LET и SETQ не допускается! Все функции должны быть рекурсивными,
; функционалы не использовать.

; Задание 4  - Определите функцию, добавляющую заданное параметром X число к каждому числовому элементу списка.
;              Например, x=3, L=(a -1 6 v 3) => (a 2 9 v 6).

(defun exec_4(x l)
    (cond
        ((null l) l)
        ((numberp (car l)) (cons (+ x (car l)) (exec_4 x (cdr l)) ))
        (t (cons(car l)(exec_4 x (cdr l)) ))
    ))
(trace exec_4)
(print (exec_4 3 '(a -1 6 v 3) ))


; Задание 14 - Определите функцию, преобразующую список в множество (для повторяющихся элементов должно
;              оставаться последнее вхождение в список).
;              Например, (a b a a c c) => (b a c).

(defun exec_14 (lst)
    (cond
        ((null lst) nil)
        ((member (car lst) (cdr lst)) (exec_14 (cdr lst)))
        (t (cons (car lst)(exec_14 (cdr lst))))
    ))

(trace exec_14)
(print (exec_14 '(a b a a c c) ))

; Задание 24 - Определите функцию, переставляющую элементы списка таким образом, чтобы одинаковые элементы
;              оказались рядом. Сортировку не использовать!
;              Например, (1 5 2 1 4 3 1 2 4 5 4) => (1 1 1 5 5 2 2 4 4 4 3).

(defun exec_24 (lst)
    (cond
        ((null lst) nil)
        (t(append (find-similar (car lst) lst)(exec_24 (remove-all (car lst) lst))))
    ))

(defun find-similar (elem lst)
    (cond
        ((null lst) nil)
        ((eq elem (car lst)) (cons elem (find-similar elem (cdr lst))))
        (t (find-similar elem (cdr lst)))
    ))

(defun remove-all (elem lst)
    (cond
        ((null lst) nil)
        ((eq elem (car lst)) (remove-all elem (cdr lst)))
        (t (cons (car lst) (remove-all elem (cdr lst))))
    ))

(trace exec_24)
(print (exec_24 '(1 5 2 1 4 3 1 2 4 5 4) ))
