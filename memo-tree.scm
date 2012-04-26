(use util.trie)

;; export

(define (make-memo-tree) (cons (make-trie) (list 'head)))

(define (memo-tree-add! tree path value)
  (let* ((queue (memo-tree-get-queue tree))
         (tail (cdr queue))
         (entry (cons (list queue path value) tail)))
    ;; each element should be like this -> ((prev path value . ()) . next)
    (unless (null? tail)
            (set-car! (car tail) entry))
    (set-cdr! queue entry) ; insert path & value pair into head of the list
    ;; #?=queue
    (trie-put! (memo-tree-get-trie tree) path entry)))

(define (memo-tree-ref tree path)
  (let* ((entry (trie-get (memo-tree-get-trie tree) path))
         (queue (memo-tree-get-queue tree))
         (next (cdr entry))
         (prev (caar entry)))
    (unless (eq? (cdr queue) entry)
            (set-cdr! entry (cdr queue))
            (set-cdr! prev next)
            (unless (null? next) (set-car! (car next) prev))

            (let ((orig-1st (cdr queue)))
              (set-cdr! queue entry)
              (set-car! (car entry) queue)
              (set-car! (car orig-1st) entry)))

    ;; #?=queue
    (caddar entry)))

;; internal

(define (memo-tree-get-trie tree)
  (car tree))

(define (memo-tree-get-queue tree)
  (cdr tree))

;; utility

(define (memo-tree-ref-or-add! tree path thunk)
  (guard (e (else (let ((val (thunk)))
                    (memo-tree-add! tree path val)
                    val)))
         (memo-tree-ref tree path)))

;; test

(define hoge-data
  (let ((n 0))
    (lambda ()
      (print #`"side effect! ,n")
      (set! n (+ n 1))
      'hoge)))

(define (test)
  (let ((t (make-memo-tree)))
    (memo-tree-add! t '(a b c) "abc")
    (memo-tree-add! t '(d) "d")
    (memo-tree-add! t '(e f) "df")
    (memo-tree-add! t '(g) "g")

    (print (memo-tree-ref t '(d)))
    (print (memo-tree-ref t '(a b c)))
    (print (guard (e (else 'ok))
                  (print (memo-tree-ref t '(a b d)))))

    (print (memo-tree-ref-or-add! t '(h 0 g e) hoge-data))
    (print (memo-tree-ref-or-add! t '(h 0 g e) hoge-data))
    ))

(define (main args)
  (test))
