(define (problem hanoi-6)
  (:domain hanoi-domain)
  (:objects p1 p2 p3 d1 d2 d3 d4 d5 d6 d7 d8 d9 d10)
  (:init (smaller d1 p1) (smaller d2 p1) (smaller d3 p1) (smaller d4 p1) (smaller d5 p1) (smaller d6 p1) (smaller d7 p1) (smaller d8 p1) (smaller d9 p1) (smaller d10 p1)
		(smaller d1 p2) (smaller d2 p2) (smaller d3 p2) (smaller d4 p2) (smaller d5 p2) (smaller d6 p2) (smaller d7 p2) (smaller d8 p2) (smaller d9 p2) (smaller d10 p2)
		(smaller d1 p3) (smaller d2 p3) (smaller d3 p3) (smaller d4 p3) (smaller d5 p3) (smaller d6 p3) (smaller d7 p3) (smaller d8 p3) (smaller d9 p3) (smaller d10 p3)
		(smaller d1 d2) (smaller d1 d3) (smaller d1 d4) (smaller d1 d5) (smaller d1 d6) (smaller d1 d7) (smaller d1 d8) (smaller d1 d9) (smaller d1 d10)
						(smaller d2 d3) (smaller d2 d4) (smaller d2 d5) (smaller d2 d6) (smaller d2 d7) (smaller d2 d8) (smaller d2 d9) (smaller d2 d10)
										(smaller d3 d4) (smaller d3 d5) (smaller d3 d6) (smaller d3 d7) (smaller d3 d8) (smaller d3 d9) (smaller d3 d10)
														(smaller d4 d5) (smaller d4 d6) (smaller d4 d7) (smaller d4 d8) (smaller d4 d9) (smaller d4 d10)
																		(smaller d5 d6) (smaller d5 d7) (smaller d5 d8) (smaller d5 d9) (smaller d5 d10)
																					    (smaller d6 d7) (smaller d6 d8) (smaller d6 d9) (smaller d6 d10)
																										(smaller d7 d8) (smaller d7 d9) (smaller d7 d10)
																														(smaller d8 d9) (smaller d8 d10)
																																		(smaller d9 d10)
		(clear p1) (clear p2) (clear d1) 											    
		(disk d1) (disk d2) (disk d3) (disk d4) (disk d5) (disk d6) (disk d7) (disk d8) (disk d9) (disk d10)
		(on d1 d2) (on d2 d3) (on d3 d4) (on d4 d5) (on d5 d6) (on d6 d7) (on d7 d8) (on d8 d9) (on d9 d10) (on d10 p3)
	)
  (:goal (and (on d1 d2) (on d2 d3) (on d3 d4) (on d4 d5) (on d5 d6) (on d6 d7) (on d7 d8) (on d8 d9) (on d9 d10) (on d10 p1)))
  )
