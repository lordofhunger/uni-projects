;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                ABSTRACTIONS                                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; SCREENS
(define game-name "HYPERSPACE INVADERS")

(define (imager x)
  (string-append "images/" x))
(define (sounder x)
  (string-append "sounds/" x))

(define pause-screensaver (imager "pausescreen2.png"))
(define losing-screen     (imager "lost.png"))
(define start-screensaver (imager "startscherm.png"))


;; COLOURS
(define background-colour          "black")
(define score-and-phrase-colour     "yellow")
(define highscore-colour            "hotpink")
(define score-pause-colour          "red")
(define lives-colour                "white")
(define level-and-difficulty-colour "orchid")
(define pause-colour                "snow")


;; PHRASES
(define pause-phrase-1 "P = PAUSE")
(define pause-phrase-2 "Press <P> to unpause")
(define (silly-phrase)
  (let ((lucky-number (random 0 31))
        (phrases (vector
                  "Try Plegeus' Formidable Space Invaders!" "Dodge II, V, VII, IX and X!"
                  "Also dodge enemy bolts!"
                  "Lorem ipsum dolor sit amet!"
                  "www.youtube.com/watch?v=dQw4w9WgXcQ&ab"
                  "Please don't sue me Disney!"
                  "Don't put pineapple on pizza!"
                  "Do or do not, there is no try!"
                  "May the Force be with you!"
                  "I don't like sand!"
                  "I find your lack of faith disturbing!"
                  "Let go of what you fear to lose"
                  "Fear is the path to the darkside"
                  "Fear leads to anger ..."
                  "Anger leads to hate ..."
                  "All your decisions have lead you here"
                  "That's no moon"
                  "There is no such thing as luck"
                  "Help me Obi-Wan Kenobi, you're my only hope"
                  "You are my favourite player!"
                  "When in doubt, spam up!"
                  "You are harder to hit when you move!"
                  "Try shooting, that's a good trick!"
                  "Try to find the mystery easter-egg!"
                  "We have updated our privacy policy"
                  "Hurry up! We're waiting for you!"
                  "Failure will not be accepted!"
                  "Strike back!"
                  "There's no surrender! There's no retreat!"
                  "And now it begins"
                  "コナミコマンド"
                  "Hate leads to suffering ..."
                  "abstractions.rkt:66:0: error: 'silly-phrase' undefined")))
    (vector-ref phrases lucky-number)))


;; CELL-INFORMATION
(define cell        1)
(define half-cell   (/ cell 2))
(define double-cell (* cell 2))
(define title-cell  (* cell 8))
(define xwing-cell  9)

;; PIXEL-INFORMATION
(define tile-width-px  50)
(define tile-height-px 50)

;; SCREEN-INFORMATION
(define game-width  12)
(define game-height 12)

(define left-border   0)
(define right-border  (- game-width cell))
(define top-border    3)
(define bottom-border 12)

(define bolt-top 0)

(define leftmost 0)
(define upmost   0)

(define window-width  (* tile-width-px game-width))
(define window-height (* tile-height-px game-height))

(define score-x      (- game-width double-cell))
(define infocolumn-y 0)

(define xwing-lane (* game-height 0.75))
(define xwing-spot (/ game-width 2))

(define pause-x       55)
(define pause-y       300)
(define pausescreen-y 275)

(define silphrase-x 265)
(define silphrase-y 135)


(define diflev-x 17)
(define diflev-y 17)

(define leftish-x 5)
(define uppish-y  5)

(define lives-x 20)
(define lives-y 13)

(define highscore-x   60)

(define screenpause-y 25)

;; TIMERS AND 'SPEEDS'

(define second              1000)
(define decisecond          100)
(define powerup-time        5)
(define double-powerup-time (* 2 powerup-time))
(define short-powerup-time  (/ powerup-time 10))
(define song-second         130)

(define bolt-speed      (* 3 decisecond))
(define game-speed      (* 5 decisecond))
(define powerup-speed   (* 5 decisecond))
(define shoot-speed     (* 15 decisecond))
(define fast-shot-speed (* 5 decisecond))


(define powerup-shoot-speed (* second powerup-time))
(define triple-speed        (* second powerup-time))
(define stealth-speed       (* second double-powerup-time))
(define shield-speed        (* second double-powerup-time))
(define boom-speed          (* second short-powerup-time))
(define song-speed          (* second song-second))

;; DIRECTIONS
(define left      'left)
(define right     'right)
(define up        'up)
(define down      'down)
(define upright   'upright)
(define upleft    'upleft)
(define downright 'downright)
(define downleft  'downleft)

;; IMAGES
(define space-file (imager "space.png"))

(define explosion-file   (imager "explosion.png"))
(define tieplosion-file  (imager "tieplosion.png"))
(define blueplosion-file (imager "blueplosion.png"))

(define xwing-file          (imager "xwing.png"))
(define shielded-xwing-file (imager "deluxo-xwing.png"))

(define (tie-file lives)
  (cond ((= lives 1)  (imager "regulartie_50-50.png"))
        ((= lives 2)  (imager "autofightertie_50-50.png"))
        ((= lives 3)  (imager "vadertie_50-50.png"))
        ((= lives 4)  (imager "level2_regulartie_50-50.png"))
        ((= lives 5)  (imager "level2_autofightertie_50-50.png"))
        ((>= lives 6) (imager "level2_vadertie_50-50.png"))))

(define vadertie-file              (imager "vadertie_50-50.png"))
(define level2-vadertie-file       (imager "level2_vadertie_50-50.png"))
(define regulartie-file            (imager "regulartie_50-50.png"))
(define level2-regulartie-file     (imager "level2_regulartie_50-50.png"))
(define autofightertie-file        (imager "autofightertie_50-50.png"))
(define level2-autofightertie-file (imager "level2_autofightertie_50-50.png"))

(define xwing-bolt-file  (imager "bolts.png"))
(define tie-bolt-file    (imager "tiebolts.png"))
(define stealthbolt-file (imager "stealthbolts.png"))
(define blue-bolt-file   (imager "bluebolts.png"))

(define score-file      (imager "scoreboard.png"))
(define life-file       (imager "heart.png"))
(define difficulty-file (imager "difficulty.png"))
(define level-file      (imager "level.png"))
(define title-file      (imager "title-column.png"))

(define highscore-text-file "scores.txt")

(define (powerup-file x)
  (let ((files (vector (imager "powerup1.png")
                       (imager "powerup2.png")
                       (imager "powerup3.png")
                       (imager "powerup4.png")
                       (imager "powerup5.png")
                       (imager "powerup6.png")
                       (imager "powerup7.png")
                       (imager "powerup8.png")
                       (imager "powerup9.png"))))
    (vector-ref files  (- x 1))))

;; PATHMAKER
(define (pathmaker item type)
  (let ((file-location "game-files/")
        (sound-location "sounds/"))
    (cond ((eq? type 'file) (string-append file-location item))
          ((eq? type 'sound) (string-append sound-location item)))))

;; FILES
(define powerup-adt    (pathmaker "powerup-adt.rkt" 'file))
(define powerups-adt   (pathmaker "powerups-adt.rkt" 'file))

(define level-adt      (pathmaker "level-adt.rkt" 'file))
(define position-adt   (pathmaker "position-adt.rkt" 'file))
(define xwing-adt      (pathmaker "xwing-adt.rkt" 'file))
(define tie-adt        (pathmaker "tie-adt.rkt" 'file))
(define fleet-adt      (pathmaker "fleet-adt.rkt" 'file))
(define draw-adt       (pathmaker "draw-adt.rkt" 'file))
(define game-adt       (pathmaker "game-adt.rkt" 'file))
;(define end)
(define bolt-adt       (pathmaker "bolt-adt.rkt" 'file))
(define bolts-adt      (pathmaker "bolts-adt.rkt" 'file))
(define scoreboard-adt (pathmaker "scoreboard-adt.rkt" 'file))
(define life-adt       (pathmaker "life-adt.rkt" 'file))


;; SOUNDS AND SONGS
;;moet aangepast worden naar de filepath in eigen pc

(define powerup-sound   (pathmaker "sound1.wav" 'sound))
(define hit-sound       (pathmaker "sound2.wav" 'sound))
(define song2           (pathmaker "sound3.wav" 'sound))
(define hit-sound2      (pathmaker "sound4.wav" 'sound))
(define explosion-sound (pathmaker "sound5.wav" 'sound))
(define song1           (pathmaker "sound6.wav" 'sound))
(define game-over-sound (pathmaker "sound7.wav" 'sound))


;; NUMBERS
(define timer-start        0)
(define single-level       1)
(define first-level        1)
(define regtext            10)
(define regtext2           (* regtext 1.5))
(define pausetext          12)
(define score-zero         0)
(define difficulty-divider 5)
(define single-power       1)

(define reg-lives   1)
(define auto-lives  (* 2 reg-lives))
(define vader-lives (* 3 reg-lives))
(define xwing-lives 5)

(define powerup-score 5)
(define tie-score     10)
(define shooter-score 20)
(define level-score   100)



