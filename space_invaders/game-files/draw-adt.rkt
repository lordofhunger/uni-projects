;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                   DRAW ADT                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; make-draw-adt :: number, number -> 
(define (make-draw-adt px-horizontal px-vertical)
  (let* ((window (make-window px-horizontal px-vertical game-name))
         (background (window 'make-layer))
         (boom-time timer-start)
         (explosions '())
         (stealth? #f)
         (start-screen? #f)
         (paused? #t))


    ((window 'set-background!) background-colour)
    ((background 'add-drawable) (make-tile px-horizontal px-vertical space-file))

    (define tie-layer (window 'make-layer))
    (define fleet-tiles '())

    (define (add-tie! tie-adt)
      (let ((tie-tile (make-tile tile-width-px tile-height-px (tie-file (tie-adt 'lives)))))
        (set! fleet-tiles (cons (cons tie-adt tie-tile) fleet-tiles))
        ((tie-layer 'add-drawable) tie-tile)
        tie-tile))
    
    (define (pick-tie tie-adt)
      (let ((result (assoc tie-adt fleet-tiles)))
        (if result
            (cdr result)
            (add-tie! tie-adt))))

    (define xwing-layer (window 'make-layer))
    (define xwing-tile (make-tile tile-width-px tile-height-px xwing-file))
    (define shielded-xwing-tile (make-tile tile-width-px tile-height-px shielded-xwing-file))
    ((xwing-layer 'add-drawable) xwing-tile)
    
    (define (re-add-xwing)
      ((xwing-layer 'add-drawable) xwing-tile))

    (define (un/draw-object obj draw/undraw tile/type)
      (cond ((eq? draw/undraw 'draw) (draw-object! obj tile/type))
            ((eq? draw/undraw 'undraw) (undraw-object obj tile/type))))
    
    (define (draw-object! obj tile)
      (let* ((obj-x ((obj 'position) 'x))
             (obj-y ((obj 'position) 'y))
             (screen-x (* tile-width-px obj-x))
             (screen-y (* tile-height-px obj-y)))
        ((tile 'set-x!) screen-x)
        ((tile 'set-y!) screen-y)))
            

    (define (undraw-object object type)
      (cond ((eq? type 'tie)((tie-layer 'remove-drawable)(undraw-help object fleet-tiles)))
            ((eq? type 'bolt)((bolt-layer 'remove-drawable)(undraw-help object bolts-tiles)))
            ((eq? type 'xwing)((xwing-layer 'remove-drawable) xwing-tile))
            ((eq? type 'powerup)((powerup-layer 'remove-drawable)(undraw-help object powerup-tiles)))))

    (define (draw-xwing! xwing-adt)
      (if xwing-adt
          (un/draw-object xwing-adt 'draw xwing-tile)))

    (define (draw-tie! tie-adt)
      (let ((tile (pick-tie tie-adt)))
        (if (tie-adt 'position)
            (un/draw-object tie-adt 'draw tile))))

    (define bolt-layer (window 'make-layer))
    (define bolts-tiles '())

    (define (draw-shield! xwing-adt)
      (if  xwing-adt
           (begin ((bolt-layer 'add-drawable) shielded-xwing-tile)
                  (un/draw-object xwing-adt 'draw shielded-xwing-tile))))

    (define (undraw-shield!)
      ((shielded-xwing-tile 'set-x!) leftmost)
      ((shielded-xwing-tile 'set-y!) upmost)
      ((bolt-layer 'remove-drawable) shielded-xwing-tile))
    
    (define (add-bolt! bolt-adt)
      (let ((new-bolt-tile (if (bolt-adt 'rebel?)
                               (make-tile tile-width-px tile-height-px xwing-bolt-file)
                               (if stealth?
                                   (make-tile tile-width-px tile-height-px stealthbolt-file)
                                   (make-tile tile-width-px tile-height-px tie-bolt-file)))))
        (set! bolts-tiles (cons (cons bolt-adt new-bolt-tile) bolts-tiles))
        ((bolt-layer 'add-drawable) new-bolt-tile)
        new-bolt-tile))

    (define (pick-bolt bolt-adt)
      (let ((result (assoc bolt-adt bolts-tiles)))
        (if result
            (cdr result)
            (add-bolt! bolt-adt))))
      
    (define (draw-bolt! bolt-adt)
      (let ((tile (pick-bolt bolt-adt)))
        (if (bolt-adt 'position)
            (un/draw-object bolt-adt 'draw tile))))

    (define powerup-layer (window 'make-layer))
    (define powerup-tiles '())

    (define (add-powerup! powerup-adt)
      (let ((new-powerup-tile (make-tile tile-width-px tile-height-px (powerup-file (powerup-adt 'kind)))))
        (set! powerup-tiles (cons (cons powerup-adt new-powerup-tile) powerup-tiles))
        ((powerup-layer 'add-drawable) new-powerup-tile)
        new-powerup-tile))

    (define (pick-powerup powerup-adt)
      (let ((result (assoc powerup-adt powerup-tiles)))
        (if result
            (cdr result)
            (add-powerup! powerup-adt))))
      
    (define (draw-powerup! powerup-adt)
      (let ((tile (pick-powerup powerup-adt)))
        (if (powerup-adt 'position)
            (un/draw-object powerup-adt 'draw tile))))

    (define (draw-info-column! score-adt level-adt)
      (let ((current (number->string (score-adt 'current-score)))
            (high (number->string (score-adt 'highscore)))
            (lives (number->string ((level-adt 'xwing) 'lives)))
            (difficulty (number->string (level-adt 'difficulty)))
            (level (number->string (level-adt 'level))))
        (score-tile 'clear)
        (un/draw-object score-adt 'draw score-tile)
        ((score-tile 'draw-text) current regtext leftish-x uppish-y score-and-phrase-colour)
        ((score-tile 'draw-text) high regtext highscore-x uppish-y highscore-colour)
        ((score-tile 'draw-text) pause-phrase-1 regtext leftish-x screenpause-y score-pause-colour)
        ((life-tile 'set-x!) (* tile-width-px right-border))
        ((life-tile 'set-y!) (* tile-height-px (+ xwing-lane cell)))
        ((difficulty-tile 'set-x!) (* tile-width-px left-border))
        ((difficulty-tile 'set-y!) infocolumn-y) 
        ((level-tile 'set-x!)(* tile-width-px (+ left-border cell)))
        ((level-tile 'set-y!) infocolumn-y)
        ((title-tile 'set-x!) (* tile-width-px (+ left-border double-cell)))
        ((title-tile 'set-y!) infocolumn-y)
        (life-tile 'clear)
        ((life-tile 'draw-text) lives regtext2 lives-x lives-y lives-colour)
        (difficulty-tile 'clear)
        ((difficulty-tile 'draw-text) difficulty regtext2 diflev-x diflev-y level-and-difficulty-colour)
        (level-tile 'clear)
        ((level-tile 'draw-text) level regtext2 diflev-x diflev-y level-and-difficulty-colour)))

    (define (draw-game! deltatime game-adt)
      (set! boom-time (+ boom-time deltatime))
      (explosion-undrawer)
      (draw-level! (game-adt 'level)))

    (define (draw-level! level-adt)
      (let ((dummy 1))
        (draw-xwing! (level-adt 'xwing))
        (draw-fleet! (level-adt 'fleet))
        (draw-bolts! (level-adt 'bolts))
        (draw-powerups! (level-adt 'powerups))
        (draw-info-column! (level-adt 'score) level-adt)
        ((tie-layer 'remove-drawable) lost-screen)
        (if (level-adt 'defeat?)
            (begin (defeat! level-adt)
                   (undraw-screen-objects)))
        (if (level-adt 'shield-power?)
            (draw-shield! (level-adt 'xwing))
            (undraw-shield!))
        (if (level-adt 'stealth?)
            (set! stealth? #t)
            (set! stealth? #f))
        (if (level-adt 'p?)
            (begin (level-adt 'p!)
                   (pause-screen)))
        (for-each (lambda (tie/number)
                    (if (not (equal? dummy tie/number))
                        (begin (explosion-drawer tie/number)
                               (undraw-object tie/number 'tie))))
                  (map (lambda (tie)
                         (if (not ((car tie) 'alive?))
                             (car tie)
                             dummy))  fleet-tiles))
        (for-each (lambda (bolt/number)
                    (if (not (number? bolt/number))
                        (undraw-object bolt/number 'bolt)))
                  (map (lambda (bolt)
                         (if (not ((car bolt) 'active?))
                             (car bolt)
                             dummy)) bolts-tiles))
      
        (if (not ((level-adt 'xwing) 'alive?))
            (undraw-object (level-adt 'xwing) 'xwing))
        (for-each (lambda (powerup/number)
                    (if (not (number? powerup/number))
                        (undraw-object powerup/number 'powerup)))
                  (map (lambda (powerup)
                         (if (not ((car powerup) 'active?))
                             (car powerup)
                             dummy)) powerup-tiles))
        (set! fleet-tiles (cleanse-the-assoclist fleet-tiles 'ties))
        (set! powerup-tiles (cleanse-the-assoclist powerup-tiles 'powerups))
        (set! bolts-tiles (cleanse-the-assoclist bolts-tiles 'bolts))))
    
    (define (cleanse-the-assoclist fleet kind)
      (define (iter left result)
        (cond ((null? left) (reverse result))
              (((caar left) (if (eq? kind 'ties)
                                'alive?
                                'active?)) (iter (cdr left) (cons (car left) result)))
              (else (iter (cdr left) result))))
      (iter fleet '()))

    (lambda (tie)
      (if (not (tie 'alive?))
          tie
          useless))

    (define (useless . args)
      useless)

    (define (draw-fleet! fleet-adt)
      ((fleet-adt 'for-each-tie) draw-tie!))

    (define (draw-bolts! bolts-adt)
      ((bolts-adt 'for-each-bolt) draw-bolt! 'xwing)
      ((bolts-adt 'for-each-bolt) draw-bolt! 'ties))

    (define (draw-powerups! powerups-adt)
      ((powerups-adt 'for-each-powerup) draw-powerup!))

    (define (set-gameloop-function! fun)
      ((window 'set-update-callback!) fun))

    (define (set-key-function! fun)
      ((window 'set-key-callback!) fun))

    (define (undraw-fleet tie)
      ((tie-layer 'remove-drawable) (cdr tie)))

    (define (undraw-help object list)
      (cond ((null? list))
            ((eq? (caar list) object) (cdar list))
            (else (undraw-help object (cdr list)))))
    
    (define (undraw-bolt bolt)
      ((bolt-layer 'remove-drawable) (cdr bolt)))

    (define (undraw-powerup powerup)
      ((powerup-layer 'remove-drawable) (cdr powerup)))

    (define (bolt-undrawer)
      (map undraw-bolt bolts-tiles))

    (define (fleet-undrawer)
      (map undraw-fleet fleet-tiles))

    (define (powerup-undrawer)
      (map undraw-powerup powerup-tiles))

    (define (undraw-screen-objects)
      (bolt-undrawer)
      (fleet-undrawer)
      (powerup-undrawer)
      ((pause-layer 'remove-drawable) start-tile)
      ((pause-layer 'remove-drawable) pause-tile))

    (define score-layer (window 'make-layer))
    
    (define score-tile (make-tile (* double-cell tile-width-px) tile-height-px score-file))
    
    (define life-tile (make-tile tile-width-px tile-height-px life-file))
    
    (define difficulty-tile (make-tile tile-width-px tile-height-px difficulty-file))
    
    (define level-tile (make-tile tile-width-px tile-height-px level-file))
    
    (define title-tile (make-tile (* title-cell tile-width-px) tile-height-px title-file))
    
    ((score-layer 'add-drawable) score-tile)
    
    ((score-layer 'add-drawable) life-tile)
    
    ((score-layer 'add-drawable) difficulty-tile)
    
    ((score-layer 'add-drawable) level-tile)
    
    ((score-layer 'add-drawable) title-tile)

    (define pause-layer (window 'make-layer))
    
    (define pause-tile (make-tile px-horizontal px-vertical pause-screensaver))
    
    (define start-tile (make-tile px-horizontal px-vertical start-screensaver))

    (define (start-screen)
      ((pause-layer 'add-drawable) start-tile)
      (set! paused? #t)
      (set! start-screen? #t)
      (start-tile 'clear)
      ((start-tile 'draw-text) (silly-phrase) regtext silphrase-x silphrase-y score-and-phrase-colour)
      ((start-tile 'draw-text) pause-phrase-2 pausetext pause-x pause-y pause-colour))
    
    (define (pause-screen)
      (cond ((not paused?)
             ((pause-layer 'add-drawable) pause-tile)
             ((pause-tile 'draw-text) (silly-phrase) regtext silphrase-x silphrase-y score-and-phrase-colour)
             ((pause-tile 'draw-text) pause-phrase-2 pausetext pause-x pausescreen-y pause-colour)
             (set! paused? #t))
            (paused?
             (if start-screen?
                 ((pause-layer 'remove-drawable) start-tile))
             (pause-tile 'clear)
             ((pause-layer 'remove-drawable) pause-tile)
             (set! paused? #f))))
    
    (define explosion (make-tile tile-width-px tile-height-px explosion-file))
    
    (define (explosion-drawer tie)
      (let ((tieplosion (make-tile tile-width-px tile-height-px tieplosion-file)))
        (set! explosions (cons (cons tieplosion boom-speed) explosions))
        ((tie-layer 'add-drawable) tieplosion)
        (un/draw-object tie 'draw tieplosion)))
    
    (define (explosion-undrawer)
      (define (iter checked rest)
        (cond ((null? rest) (set! explosions checked)
                            )
              ((> boom-time (cdar rest)) ((tie-layer 'remove-drawable) (caar rest))
                                         (iter checked (cdr rest)))
              (else (set-cdr! (car rest) (- (cdar rest) boom-time))
                    (iter (cons (car rest) checked) (cdr rest)))))
      (iter '() explosions)
      (set! boom-time timer-start))

    (define lost-screen (make-tile window-width window-height losing-screen))
    
    (define (defeat! level-adt)
      (map undraw-fleet fleet-tiles)
      ((tie-layer 'add-drawable) explosion)
      (set! explosions (cons (cons explosion boom-speed) explosions))
      ((explosion 'set-y!) (* xwing-lane tile-height-px))
      ((explosion 'set-x!) (* (((level-adt 'xwing) 'position) 'x) tile-width-px))  
      ((level-adt 'xwing) 'execute-order-66)                                       
      (((level-adt 'fleet) 'for-each-tie) (lambda (tie) (tie 'operation-cinder))) 
      ((xwing-layer 'remove-drawable) xwing-tile)
      (bolt-undrawer)
      ((level-adt 'bolts) 'delete-bolts!)                                        
      ((tie-layer 'add-drawable) lost-screen))

    (define (dispatch-draw-adt msg)
      (cond ((eq? msg 'set-key-function!) set-key-function!)
            ((eq? msg 'set-gameloop-function!) set-gameloop-function!)
            ((eq? msg 'draw-game!) draw-game!)
            ((eq? msg 'undraw-screen-objects) (undraw-screen-objects))
            ((eq? msg 'start-screen) (start-screen))
            ((eq? msg 're-add-xwing) (re-add-xwing))))
    dispatch-draw-adt))
      







 
