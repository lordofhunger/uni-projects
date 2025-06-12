;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                     GAME                                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(#%require "graphics-adt/Graphics-4.rkt")
(#%require (only racket random))
(#%require (only racket void?))
(#%require 2htdp/image (only racket/gui/base play-sound))

(load "powerup-adt.rkt")
(load "powerups-adt.rkt")
(load "abstractions.rkt")
(load "level-adt.rkt")
(load "position-adt.rkt")
(load "xwing-adt.rkt")
(load "tie-adt.rkt")
(load "fleet-adt.rkt")
(load "level-adt.rkt")
(load "draw-adt.rkt")
(load "game-adt.rkt")
(load "bolt-adt.rkt")
(load "bolts-adt.rkt")
(load "scoreboard-adt.rkt")
(load "life-adt.rkt")

(define game (make-game-adt))
(game 'start)



