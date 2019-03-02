(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action robotMove
      :parameters (?r - robot ?fl - location ?tl - location)
      :precondition (and (connected ?fl ?tl) (no-robot ?tl) (at ?r ?fl) (not (no-robot ?fl)))
      :effect (and (at ?r ?tl) (not (at ?r ?fl)) (not (no-robot ?tl)) (no-robot ?fl))
   )

   (:action robotMoveWithPallette
      :parameters (?r - robot ?fl - location ?tl - location ?p - pallette)
      :precondition (and (connected ?fl ?tl) (at ?r ?fl) (at ?p ?fl) (no-robot ?tl) (no-pallette ?tl))
      :effect (and (has ?r ?p) (not (free ?r)) (at ?r ?tl) (not (at ?r ?fl)) (not (no-robot ?tl)) (not (no-pallette ?tl)) (at ?p ?tl) (not (at ?p ?fl)) (no-pallette ?fl) (no-robot ?fl))
   )

   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?p - pallette ?si - saleitem ?o - order)
      :precondition (and (at ?p ?l) (packing-location ?l) (packing-at ?s ?l) (contains ?p ?si) (ships ?s ?o) (orders ?o ?si) (started ?s))
      :effect (and (not (contains ?p ?si)) (includes ?s ?si))
   )

   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) (packing-location ?l) (packing-at ?s ?l) (not (available ?l)))
      :effect (and (complete ?s) (not (packing-at ?s ?l)) (available ?l) (not (started ?s)))
   )
)