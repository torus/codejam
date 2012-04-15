(use srfi-11)

(define (guess-max-score total)
  (let-values (((q r) (quotient&remainder total 3)))
    (case r
      ((0)
       (values q (+ q 1)))
      ((1)
       (values (+ q 1) (+ q 1)))
      ((2)
       (values (+ q 1) (+ q 2))))))

(define (guess-min-score total)
  (let-values (((q r) (quotient&remainder total 3)))
    (case r
      ((0)
       (values q (- q 1)))
      ((1)
       (values q (- q 1)))
      ((2)
       (values q q)))))

(define (choose-better a b)
  (if (and a b)
      (max a b)
      (or a b)))

(define (num-high-scorer total-list len num-surprise p)
  (define (iter total-list len num-surprise partial)
    ;; total-list must be sorted high to low
    (if (null? total-list)
        (if (= num-surprise 0) partial #f)
        (if (or (> num-surprise len)
                (< num-surprise 0))
            #f
            (let ((total (car total-list)))
              (let-values (((min-score min-score-surp) (guess-min-score total))
                           ((max-score max-score-surp) (guess-max-score total)))
                (if (and (or (= (remainder total 3) 1)
                             (>= max-score p))
                         (< num-surprise len))
                    #;(iter (cdr total-list) (- len 1) num-surprise
                    (+ (if (>= max-score p) 1 0) partial))
                    (choose-better
                     (iter (cdr total-list) (- len 1) num-surprise
                           (+ (if (>= max-score p) 1 0) partial))
                     (and
                      (not (or (< min-score-surp 0) (> max-score-surp 10)))
                      (> num-surprise 0)
                      (iter (cdr total-list) (- len 1) (- num-surprise 1)
                            (+ (if (>= max-score-surp p) 1 0) partial))))
                    (or
                     (and
                      (not (or (< min-score-surp 0) (> max-score-surp 10)))
                      (> num-surprise 0)
                      (iter (cdr total-list) (- len 1) (- num-surprise 1)
                            (+ (if (>= max-score-surp p) 1 0) partial)))
                     (iter (cdr total-list) (- len 1) num-surprise
                           (+ (if (>= max-score p) 1 0) partial)))
                    )
                )))))
  (iter total-list len num-surprise 0))

(define (main args)
  (let ((T (read)))
    (let loop ((num-cases T))
      (if (> num-cases 0)
          (let* ((N (read))
                 (S (read))
                 (p (read)))
            (let ((answer (num-high-scorer
                           (reverse
                            (sort
                             (let loop2 ((p ()) (num N))
                               (if (= num 0)
                                   p
                                   (loop2 (cons (read) p) (- num 1))))))
                           N S p)))
              (print #`"Case #,(+ 1 (- T num-cases)): ,answer"))
            (loop (- num-cases 1)))
          'done))))
