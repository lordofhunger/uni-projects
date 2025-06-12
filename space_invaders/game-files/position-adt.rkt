;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                              POSITION ADT                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; maak-adt-positie :: number, number -> position
(define (make-position-adt x y)

  ; (define (y? other-y)
  ;   (= y other-y))

  (define (rough-compare? other-position)
    (and (or (= x (other-position 'x))
             (= (+ x half-cell) (other-position 'x))
             (= (- x half-cell) (other-position 'x))
             (and (> x (- (other-position 'x) cell))
                  (< x (+ (other-position 'x) cell))))
         (or (= y (other-position 'y))
             (= (+ y half-cell) (other-position 'y))
             (= (- y half-cell) (other-position 'y))
             (and (> y (- (other-position 'y) half-cell))
                  (< y (+ (other-position 'y) half-cell))))))

  (define (powerup-compare? other-position)
    (and (= x (other-position 'x))
         (= (- y cell) (other-position 'y))))

  ;; move :: symbol -> position-adt
  (define (move! direction)
    (cond ((eq? direction up)(set! y (- y cell)))
          ((eq? direction down) (set! y (+ y cell)))   
          ((eq? direction left) 
           (if (> x left-border)
               (set! x (- x half-cell))))
          ((eq? direction right) 
           (if (< x right-border)
               (set! x (+ x half-cell))))
          ((eq? direction upleft)    (if (not (= right-border x))
                                         (begin (set! x (+ x half-cell))
                                                (set! y (- y cell)))))
          ((eq? direction upright)   (if (not (= left-border x))
                                         (begin (set! x (- x half-cell))
                                                (set! y (- y cell)))))
          ((eq? direction downleft)  (if (not (= left-border x))
                                         (begin (set! x (- x half-cell))
                                                (set! y (+ y cell)))))
          ((eq? direction downright) (if (not (= right-border x))
                                         (begin (set! x (+ x half-cell))
                                                (set! y (+ y cell)))))))

  (define (new direction)
    (cond ((eq? direction up)(make-position-adt x (- y cell)))
          ((eq? direction down) (make-position-adt x (+ y cell)))
          ((eq? direction upleft)    (if (not (= right-border x))
                                         (make-position-adt (+ x half-cell) (- y cell))
                                         (make-position-adt x (- y cell))))
          ((eq? direction upright)   (if (not (= left-border x))
                                         (make-position-adt (- x half-cell) (- y cell))
                                         (make-position-adt x (- y cell))))))
          

  ;; dispatch-position-adt :: symbol -> any
  (define (dispatch-position-adt msg)
    (cond ((eq? msg 'x) x)
          ((eq? msg 'y) y)
          ((eq? msg 'move) move!)
          ((eq? msg 'new) new)
          ((eq? msg 'rough-compare?) rough-compare?)
          ((eq? msg 'powerup-compare?) powerup-compare?)))
  dispatch-position-adt)

