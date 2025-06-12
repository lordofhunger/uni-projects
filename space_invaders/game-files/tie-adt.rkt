;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                   TIE ADT                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; make-tie-adt :: position-adt, number, boolean, number -> tie-adt
(define (make-tie-adt position lives shooter?)
  (let ((explosion #f)
        (life-adt (make-life-adt lives)))


    (define (move! direction)
      ((position 'move) direction))
   
    ;; dispatch-tie-adt :: symbol -> (/ -> /) U (/ -> /) U (/ -> /) U (/ -> /) U number U (/ -> /) U boolean U position-adt U (/ -> pair) U (position-adt -> /) U (/ -> /) U (/ -> /)
    (define (dispatch-tie-adt msg)
      (cond ((eq? msg 'left!)(move! left))
            ((eq? msg 'right!)(move! right))
            ((eq? msg 'downleft!)(move! downleft))
            ((eq? msg 'downright!)(move! downright))
            ((eq? msg 'shooter?) shooter?)
            ((eq? msg 'lives) lives)
            ((eq? msg 'life-less!)(life-adt 'life-less!))
            ((eq? msg 'lives-less!)(life-adt 'lives-less!))
            ((eq? msg 'life-more!)(life-adt 'life-more!))
            ((eq? msg 'alive?)(life-adt 'alive?))
            ((eq? msg 'position) position)
            ((eq? msg 'leftborder?)(position 'leftborder?))
            ((eq? msg 'rightborder?)(position 'rightborder?))
            ((eq? msg 'operation-cinder)(set! position #f))))
    dispatch-tie-adt))

