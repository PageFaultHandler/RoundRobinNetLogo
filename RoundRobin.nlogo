breed [processes process]
breed [cpus cpu]
breed [schedulers scheduler]
breed [slots slot]
breed [queues queue]
breed [cores core]
breed[my-labels my-label]


cpus-own
[

  cpu-taken
]

slots-own
[
  slot-taken
]

cores-own
[
  core-taken
]

queues-own
[
  number-of-slots 
  max-number-of-slots 
  queue-taken
]

globals[
  the-cpu
  max-number-of-cores 
  number-of-cores 
]

to setup
  clear-all
  
  ask patches [set pcolor white]
 
  create-cpus 1
  set the-cpu one-of cpus
  set max-number-of-cores 4
  set max-number-of-cores 4
  set number-of-cores 0
  
  ask the-cpu
  [
    
    set shape  "square 2" 
    set xcor 10  
    set ycor -10 
    set size 15
    set color 4 
  ] 
  
   create-my-labels 1
  [
    set xcor ([xcor] of the-cpu) 
    set ycor ([ycor] of the-cpu) + 5
    set label "CPU"
    set label-color white
    set size 0
  ]
  
  add-core
  create-processes 1 [
    set color green
    set shape "circle"
    set size 3
  ]
  
  if core-taken = false [
    
  

end

to add-core

  if max-number-of-cores != number-of-cores
  [set number-of-cores number-of-cores + 1
      create-cores 1 [
      if number-of-cores = 1  [set xcor ([xcor] of the-cpu - 2) set ycor ([ycor] of the-cpu + 2) set color 7]
      set shape "square"
      set size  4
      set core-taken false
    ]
  ]
       
end



to schedule
  ;(
  ; // PSEUDOCODICE //
 ; set mylist []
 ; cpu start--> serve un thread per la cpu
  ;while(cpu taken)

     
     ;1)SE LA LISTA  HA MENO DI 8 ELEMENTI , GENERA UN NUOVO PROCESSO
     ;2)INSERISCI IN FONDO ALLA LIST AIL NUOVO PROCESSO
     
     
     
  
  ;ask mylist with[if(lenght < 8 ) [set lput spawn()]]
  
  
  ;  )  
  
end

; to be defined ;
to spawn
  
end
