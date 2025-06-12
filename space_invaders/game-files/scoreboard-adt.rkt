;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                               SCOREBOARD ADT                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (make-scoreboard-adt scores position)
  (let ((highscore (read (open-input-file scores)))
        (current-score score-zero))



    (define (current-score! x)
      (set! current-score x))

    
    (define (high-score)
      (if (number? highscore)
          highscore
          score-zero))

    (define (new-high?)
      (if (number? highscore)
          (> current-score highscore)
          #t))

  
    (define (up-score why)
      (cond ((eq? why 'powerup) (set! current-score (+ current-score powerup-score)))
            ((eq? why 'tie)(set! current-score (+ current-score tie-score)))
            ((eq? why 'shooter)(set! current-score (+ current-score shooter-score)))
            ((eq? why 'level)(set! current-score (+ current-score level-score)))))

    
    (define (new-high!)
      (cond ((new-high?)
             (set! highscore current-score)
             (call-with-output-file scores #:exists 'replace
               (lambda (out)
                 (write current-score out))))))

    (define (dispatch-scoreboard-adt msg)
      (cond ((eq? msg 'highscore) (high-score))
            ((eq? msg 'current-score) current-score)
            ((eq? msg 'current-score!) current-score!)
            ((eq? msg 'new-high?) (new-high?))
            ((eq? msg 'new-high!) (new-high!))
            ((eq? msg 'power-score) (up-score 'powerup))
            ((eq? msg 'tie-life-score) (up-score 'tie))
            ((eq? msg 'shooter-life-score) (up-score 'shooter))
            ((eq? msg 'level-score) (up-score 'level))
            ((eq? msg 'position) position)))
    dispatch-scoreboard-adt))