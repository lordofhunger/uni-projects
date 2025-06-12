;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                 POWER-UP ADT                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-powerup-adt position kind)
  (let ((active? #t))

    
  (define (dispatch-powerup-adt msg)
    (cond ((eq? msg 'position) position)
          ((eq? msg 'active?)  active?)
          ((eq? msg 'kind) kind)
          ((eq? msg 'taken!) (set! active? #f))
          ((eq? msg 'down!)  ((position 'move) down))))
  dispatch-powerup-adt))