;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                  X-WING ADT                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; make-xwing-adt :: position-adt -> xwing-adt
(define (make-xwing-adt position)
  (let ((life-adt (make-life-adt xwing-lives)))

    (define (move direction)
      ((position 'move) direction))

  ;; dispatch-xwing-adt :: symbol -> any
  (define (dispatch-xwing-adt msg)
    (cond ((eq? msg 'position)  position)
          ((eq? msg 'position!) (lambda (new-position)(set! position new-position)))
          ((eq? msg 'right-xwing!) (move right))
          ((eq? msg 'left-xwing!)  (move left))
          ((eq? msg 'alive?) (life-adt 'alive?)) 
          ((eq? msg 'lives)  (life-adt 'lives))   
          ((eq? msg 'lives!) (life-adt 'lives!))
          ((eq? msg 'life-more!) (life-adt 'life-more!))
          ((eq? msg 'life-less!) (life-adt 'life-less!))
          ((eq? msg 'lives-less!)     (life-adt 'lives-less!))
          ((eq? msg 'execute-order-66)(life-adt 'kill!))
          ((eq? msg 'shield)   (life-adt 'shield))
          ((eq? msg 'powerup9) ((life-adt 'lives!) reg-lives))
          ((eq? msg 'unshield) (life-adt 'unshield))))
  dispatch-xwing-adt))
