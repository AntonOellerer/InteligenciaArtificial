(defparameter *planets* '(Mallory Avalon Katril Kentares Davion Proserpina Sirtis))
(defparameter *white-holes*
  '(
    (Mallory Katril 10) (Mallory Proserpina 15) 
    (Avalon Mallory 6.4) (Avalon Proserpina 8.6)
    (Katril Davion 9) (Katril Mallory 10) 
    (Kentares Avalon 3) (Kentares Katril 10) (Kentares Proserpina 7) 
    (Davion Sirtis 6) (Davion Proserpina 5) 
    (Proserpina Mallory 15) (Proserpina Davion 5) (Proserpina Sirtis 12) (Proserpina Avalon 8.6)
    (Sirtis Davion 6) (Sirtis Proserpina 12)))

(defparameter *worm-holes*
  '(
    (Mallory Katril 5) (Mallory Proserpina 11) (Mallory Avalon 9)
    (Avalon Mallory 9) (Avalon Kentares 4)
    (Katril Sirtis 10) (Katril Davion 5) (Katril Mallory 5)
    (Kentares Avalon 4) (Kentares Proserpina 12)
    (Davion Katril 5) (Davion Sirtis 8)
    (Proserpina Mallory 11) (Proserpina Sirtis 9) (Proserpina Kentares 12)
    (Sirtis Proserpina 9) (Sirtis Davion 8) (Sirtis Katril 10)))

(defparameter *sensors*
  '(
    (Mallory 12)
    (Avalon 15)
    (Katril 9)
    (Kentares 14)
    (Davion 5)
    (Proserpina 7)
    (Sirtis 0)))

(defparameter *planet-origin* 'Mallory)
(defparameter *planets-destination* '(Sirtis))
(defparameter *planets-forbidden* '(Avalon))
(defparameter *planets-mandatory* '(Katril Proserpina))
;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    Problem definition
;;
(defstruct problem
  states              	; List of states
  initial-state       	; Initial state
  f-goal-test		; reference to a function that determines whether 
  ; a state fulfills the goal 
  f-h                 	; reference to a function that evaluates to the 
  ; value of the heuristic of a state
  operators)    	; list of operators (references to functions) 
; to generate actions, which, in their turn, are 
; used to generate succesors
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    Node in the search algorithm
;;
(defstruct node 
  state        	; state label
  parent       	; parent node
  action				; action that generated the current node from its parent
  (depth 0)    	; depth in the search tree
  (g 0)        	; cost of the path from the initial state to this node
  (h 0)					; value of the heuristic
  (f 0))       	; g + h
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    Actions 
;;
(defstruct action
  name         ; Name of the operator that generated the action
  origin       ; State on which the action is applied
  final        ; State that results from the application of the action
  cost )       ; Cost of the action
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    Search strategies 
;;
(defstruct strategy
  name              ; Name of the search strategy
  node-compare-p)		; boolean comparison
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
;; f-h-galaxy 
;; Returns the approximated distance from a planet to the goal
;; state: name of the planet
;; sensors: list of (k v) pairs for h
;; devuelves: approximacion h(x) for the distance between state and destination
;;;;;;;;;;;;;;;;;;;;;;;

(defun f-h-galaxy (state sensors)
  (second (assoc state sensors)))

#|
(print (equal (f-h-galaxy 'Sirtis *sensors*) 0))
(print (equal (f-h-galaxy 'Avalon *sensors*) 15))
(print (equal (f-h-galaxy 'Earth *sensors*) nil)) ;-> NIL
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; navigate-white-hole
;; returns all possible paths through white holes from the planet "state"
;; state: nombre del planeto
;; white-holes: list of white hole paths leading from states to other planets
(defun action-name-route (name route)
  (make-action :name name
	       :origin (first route)
	       :final (second route)
	       :cost (third route)))

(defun create-action-white-hole (route)
  (action-name-route "navigate-white-hole" route))

(defun get-routes-for (state routes)
  (remove-if #'(lambda (route) (not (equal (first route) state))) routes))

(defun navigate-white-hole (state white-holes)
  (mapcar #'(lambda (route) (create-action-white-hole route)) (get-routes-for state white-holes)))

(print (navigate-white-hole 'Kentares *white-holes*))
