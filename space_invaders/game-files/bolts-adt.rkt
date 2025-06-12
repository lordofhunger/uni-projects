;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                  BOLTS ADT                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-bolts-adt)
  (let ((xwing-bolts '())
        (tie-bolts '())
        (counter 1))
  
  (define (bolts! owner new-bolts)
    (cond ((eq? owner 'xwing)(set! xwing-bolts new-bolts))
          ((eq? owner 'ties) (set! tie-bolts new-bolts)))) ;not used but can make expanding easier

  
  (define (add-bolt! owner power level-adt)
    (cond ((eq? owner 'xwing)
           (if ((level-adt 'xwing) 'position)
               (set! xwing-bolts (cons (make-bolt-adt ((((level-adt 'xwing) 'position) 'new) up) #t power) xwing-bolts))))
          ((eq? owner 'triple-wing)
           (if ((level-adt 'xwing) 'position)
               (begin (set! xwing-bolts (cons (make-bolt-adt ((((level-adt 'xwing) 'position) 'new) up) #t power) xwing-bolts))
                      (set! xwing-bolts (cons (make-bolt-adt ((((level-adt 'xwing) 'position) 'new) upright) #t power) xwing-bolts))
                      (set! xwing-bolts (cons (make-bolt-adt ((((level-adt 'xwing) 'position) 'new) upleft) #t power) xwing-bolts)))))
          ((not (eq? (owner 'position) (if ((level-adt 'xwing) 'position)
                                           ((((level-adt 'xwing) 'position) 'new) up)
                                           (owner 'position))))
           (set! tie-bolts (cons (make-bolt-adt (((owner 'position) 'new) down) #f power) tie-bolts)))))

  (define (for-each-bolt f owner)
    (if (eq? owner 'xwing)
        (map f xwing-bolts)
        (map f tie-bolts)))

  (define (dispatch-bolts-adt msg)
    (cond ((eq? msg 'add-bolt!) add-bolt!)
          ((eq? msg 'xwing-bolt-list) xwing-bolts)
          ((eq? msg 'tie-bolt-list) tie-bolts)     
          ((eq? msg 'bolt-list!) bolts!)
          ((eq? msg 'delete-bolts!) (set! xwing-bolts '())
                                    (set! tie-bolts '()))
          ((eq? msg 'for-each-bolt) for-each-bolt)))
  dispatch-bolts-adt))
