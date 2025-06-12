;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                   GAME ADT                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-game-adt)
  (let* ((level single-level)
        (draw-adt (make-draw-adt window-width window-height))
        (level-adt (make-level-adt game-width game-height level)))

    (draw-adt 'start-screen)
    
    (define (gameloop-procedure delta-time)
      ((level-adt 'update!) delta-time dispatch-game)
      ((draw-adt 'draw-game!) delta-time dispatch-game)
      (if (level-adt 'won?) (victory!))
      (if (level-adt 'restart?) (restart!)))

    (define (start!)
      ((draw-adt 'set-gameloop-function!) gameloop-procedure)
      ((draw-adt 'set-key-function!) (level-adt 'keyfunction)))

    (define (restart!)
      (set! level single-level)
      (set! level-adt (make-level-adt game-width game-height level))
      
      (draw-adt 'undraw-screen-objects)
      (draw-adt 'start-screen)
      (draw-adt 're-add-xwing)
      (start!))
    
    (define (victory!)
      (let ((lives ((level-adt 'xwing) 'lives))
            (pos ((level-adt 'xwing) 'position))
            (score ((level-adt 'score) 'current-score))
            (song-on? (level-adt 'song?))
            (song-timer (level-adt 'song-time)))
        (set! level (+ level single-level))
        (draw-adt 'undraw-screen-objects)
        ((level-adt 'powerups) 'delete-powerups!)
        ((level-adt 'score) 'new-high!)
        (set! level-adt (make-level-adt game-width game-height level))
        (((level-adt 'xwing) 'lives!) lives)
        (((level-adt 'xwing) 'position!) pos)
        (((level-adt 'score) 'current-score!) score)
        ((level-adt 'set-song!) song-on?)
        ((level-adt 'song-time!) song-timer)
        ((level-adt 'score) 'level-score)
        (start!)))
    
    (define (dispatch-game msg)
      (cond ((eq? msg 'start) (start!))
            ((eq? msg 'level) level-adt)
            ((eq? msg 'draw) draw-adt)
            ((eq? msg 'restart) (restart!))
            ((eq? msg 'victory) (victory!))))
    dispatch-game))