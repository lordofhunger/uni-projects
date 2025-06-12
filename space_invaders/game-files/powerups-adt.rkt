;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                POWER-UPS ADT                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-powerups-adt)
  
  (define powerups '())
  
  (define (powerups! new-powerups)
    (set! powerups new-powerups))
  
  (define (add-powerup! position kind)
    (set! powerups (cons (make-powerup-adt position kind) powerups)))

  (define (for-each-powerup f)
    (map f powerups))
  
  (define (dispatch-powerups-adt msg)
    (cond ((eq? msg 'add-powerup!) add-powerup!)
          ((eq? msg 'powerup-list) powerups)
          ((eq? msg 'powerup-list!) powerups!)
          ((eq? msg 'delete-powerups!) (set! powerups '()))
          ((eq? msg 'for-each-powerup) for-each-powerup)))
  dispatch-powerups-adt)

