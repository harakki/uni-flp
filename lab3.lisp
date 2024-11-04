; Лабораторная работа 3. Предикаты и функционалы.
; ВАРИАНТ 4

; В теле функции использование операторов SET, LET и SETQ не допускается! Все функции должны быть рекурсивными,
; функционалы не использовать.

; Задание 2  - Определите предикат, проверяющий, является ли одно множество подмножеством другого.

(defun subset (set1 set2)
  (cond
    ((null set1) t) 
    ((member (car set1) set2) (subset (cdr set1) set2))  
    (t nil))) 


(print (subset '(1 2 3) '(1 2 3 4 5)))  
(print (subset '(1 2 6) '(1 2 3 4 5)))  

; Задание 7  - Определите функцию, возвращающую симметрическую разность двух множеств, т.е. множество из
;              элементов, не входящих в оба множества.

(defun symmetric-difference (set1 set2)
  (cond
    ((null set1) set2) ;; Если set1 пустое, возвращаем set2
    ((null set2) set1) ;; Если set2 пустое, возвращаем set1
    ((member (car set1) set2)
     (symmetric-difference (cdr set1) (remove (car set1) set2))) ;; Убираем общий элемент
    (t (cons (car set1) (symmetric-difference (cdr set1) set2))))) ;; Добавляем элемент, если его нет в обоих множествах

(print (symmetric-difference '(1 2 3) '(2 3 4)))
(print (symmetric-difference '(1 2 3) '(4 5 6)))

; Задание 12 - Определите функционал, аналогичный предикату MAPLIST для одноуровнего списка.
;              (Используйте применяющий функционал FUNCALL).

(defun maplist-flat (func lst)
  (cond
    ((null lst) nil) ;; Если список пуст, возвращаем nil
    (t (cons (funcall func lst) (maplist-flat func (cdr lst))))))

(print (my-maplist #'reverse '(1 2 3 4)))  
(print (my-maplist #'length '(1 2 3 4)))  