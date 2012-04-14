(use srfi-1)
(use srfi-11)

(define (unique lis p)
  (if (null? lis)
      p
      (if (memq (car lis) p)
          (unique (cdr lis) p)
          (unique (cdr lis) (cons (car lis) p)))))

(define (recycle orig digits)
  (let ((orig-list (string->list (number->string orig))))
    (let ((shifted (append
                    (drop orig-list (- (length orig-list) digits))
                    (take orig-list (- (length orig-list) digits)))))
      (if (eq? #\0 (car shifted))
          #f
          (string->number
           (list->string shifted))))))

(define (count-digits n)
  (string-length (number->string n)))

(define (find-recycles n)
  (unique (map (lambda (i)
                 (recycle n (+ 1 i)))
               (iota (- (count-digits n) 1)))
          ()))

(define (filter-recycles A B n)
  ;; A <= n < m <= B
  (let ((recycles (find-recycles n)))
    (filter (lambda (m)
              (and m
                   (< n m)
                   (>= B m)))
            recycles)))

(define (solve-case A B)
  (fold + 0 (map (lambda (n)
                   (length (filter-recycles A B n)))
                 (iota (+ (- B A) 1) A))))

(define (main args)
  (let ((T (read)))
    (let loop ((count T))
      (if (> count 0)
          (let ((result (solve-case (read) (read))))
            (print #`"Case #,(+ 1 (- T count)): ,result")
            (loop (- count 1)))
          'done))))
