;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                  BOLT ADT                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-bolt-adt position rebel? power)
  (let ((active? #t))
  
    (define (evaporate!)
      (set! active? #f))

    (define (bolt-move! direction)
      ((position 'move) direction))
     
       
  (define (dispatch-bolt-adt msg)
    (cond ((eq? msg 'position) position)
          ((eq? msg 'active?) active?)
          ((eq? msg 'rebel?) rebel?)
          ((eq? msg 'power) power)
          ((eq? msg 'evaporate!) (evaporate!))
          ((eq? msg 'up!) (bolt-move! up))
          ((eq? msg 'down!) (bolt-move! down))))
  dispatch-bolt-adt))


  
  

