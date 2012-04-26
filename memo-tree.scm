(use util.trie)

;; export

(define (make-memo-tree) (cons (make-trie) (list 'head)))

(define (memo-tree-add! tree path value)
  (trie-put! (memo-tree-get-trie tree) path value))

(define (memo-tree-ref tree path)
  (trie-get (memo-tree-get-trie tree) path))

;; internal

(define (memo-tree-get-trie tree)
  (car tree))

(define (memo-tree-get-list tree)
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

    (print (memo-tree-ref t '(d)))
    (print (memo-tree-ref t '(a b c)))
    (print (guard (e (else 'ok))
                  (print (memo-tree-ref t '(a b d)))))

    (print (memo-tree-ref-or-add! t '(h 0 g e) hoge-data))
    (print (memo-tree-ref-or-add! t '(h 0 g e) hoge-data))
    ))

(define (main args)
  (test))
