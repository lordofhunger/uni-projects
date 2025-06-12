;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                 FLEET ADT                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; navy-maker :: / -> pair
(define (navy-maker ties-per-lane tie-lanes reinforcements?)
  (define (iter lst units-left current-lane)
    (cond ((= current-lane 0) (reverse lst))
          ((= units-left 0) (iter lst ties-per-lane (- current-lane 1)))
          (else (iter (cons (make-tie-adt (make-position-adt (- right-border units-left) (- top-border (if reinforcements?
                                                                                                           5
                                                                                                           current-lane)))
                                          (if reinforcements?
                                              3
                                              current-lane)
                                           (= 1 (random 0 3)))
                            lst)
                      (- units-left 1)
                      current-lane))))
  (iter '() ties-per-lane tie-lanes))
        
;; make-fleet-adt :: boolean -> fleet-adt
(define (make-fleet-adt moving-right? difficulty)
  (let ((ties (navy-maker (random 4 10) (random difficulty (+ difficulty 3)) #f)))

    (define (pick-shooter number)  
      (define (iter counter rest)
        (if (and (> counter 1) (not (null? rest)))
            (iter (- counter 1) (cdr rest))
            (car rest)))
      (iter number (shooters (shooter-list))))

    (define (fleet-list! new-fleet)  
      (set! ties new-fleet))


    (define (shooters list)  
      (define (iter checked rest)
        (cond ((null? rest) checked)
              ((void? (car rest)) (iter checked (cdr rest)))
              (else (iter (cons (car rest) checked) (cdr rest)))))
      (iter '() list))
    
    (define (shooter-list) 
      (map (lambda (tie)
             (if (and (tie 'alive?) (tie 'shooter?))
                 tie))
           ties))

    ;; for-each-tie :: (tie-adt -> any) -> pair
    (define (for-each-tie f) 
      (map f ties))
      
    ;; dispatch-fleet :: symbol -> any
    (define (dispatch-fleet msg)
      (cond ((eq? msg 'fleet-list) ties)
            ((eq? msg 'shooter-list) (shooters (shooter-list)))
            ((eq? msg 'fleet-list!) fleet-list!)
            ((eq? msg 'delete-ties!) (set! ties '()))
            ((eq? msg 'moving-right?) moving-right?)
            ((eq? msg 'pick-shooter) pick-shooter)
            ((eq? msg 'for-each-tie) for-each-tie)
            ((eq? msg 'reinforcements!) (set! ties (append ties (navy-maker 6 1 #t))))
            ((eq? msg 'change-direction!) (set! moving-right? (not moving-right?)))))
    dispatch-fleet))