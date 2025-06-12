;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                  LIFE ADT                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(define (make-life-adt lives)
  (let ((lives-left lives)
        (alive? #t)
        (shield #f))

    (define (life-less!)
      (cond (shield)
           ((= lives-left 1) (set! lives-left 0)
                              (set! alive? #f))
            (else (set! lives-left (- lives-left 1)))))

    (define (lives-less! lives)
      (cond (shield)
           ((<= lives-left lives) (set! lives-left 0)
                                 (set! alive? #f))
            (else (set! lives-left (- lives-left lives)))))


    (define (lives! new-lives)
      (set! lives-left new-lives))

    (define (lives-more! x)
      (set! lives-left (+ lives-left x)))

    (define (dispatch msg)
      (cond
        ((eq? msg 'life-less!) (lives-less! 1))
        ((eq? msg 'lives-less!) lives-less!)
        ((eq? msg 'life-more!) (set! lives-left (+ lives-left 1)))
        ((eq? msg 'lives) lives-left)
        ((eq? msg 'alive?) alive?)
        ((eq? msg 'lives-more!) lives-more!)
        ((eq? msg 'lives!) lives!)
        ((eq? msg 'kill!)  (set! lives-left 0)
                           (set! alive? #f))
        ((eq? msg 'shield) (set! shield #t))
        ((eq? msg 'unshield) (set! shield #f))))
    dispatch))

    
