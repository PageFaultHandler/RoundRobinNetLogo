breed [cpus cpu]
breed [schedulers scheduler]
breed [slots slot]
breed [queues queue]
breed [cores core]
breed [processes process]
breed[my-labels my-label]

processes-own[
  time
  state
  working
]
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
  unused-core
  used-core
  max-number-of-cores 
  number-of-cores 
  max-number-of-processes
  number-of-processes
  last_created
  current-process
  mylist
  whonumber
]

to setup
  clear-all
  
  ask patches [set pcolor white]
  set mylist []

  
  create-cpus 1
  set the-cpu one-of cpus
  set max-number-of-cores 4
  set number-of-cores 0
  set  max-number-of-processes 10
  set number-of-processes 0
  set current-process 0
  
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
  reset-ticks
  

end

to add-core

  if max-number-of-cores != number-of-cores
  [set number-of-cores number-of-cores + 1
      create-cores 1
      set unused-core one-of cores
      ask unused-core [
      if number-of-cores = 1  [set xcor ([xcor] of the-cpu - 2) set ycor ([ycor] of the-cpu + 2) set color 7]
      set shape "square"
      set size  4
      set core-taken false
    ]
  ]
       
end



to go

    if ticks > 0 and ticks mod 9000 = 0 and number-of-processes < max-number-of-processes
  [ 
    
    create-processes 1[
      set color green
      set shape "square"
      set size 2
      set xcor 0
      set ycor 0
    ]
    set whonumber  [who] of  process current-process
    set mylist lput one-of processes with[who = whonumber] mylist
      
    set number-of-processes  number-of-processes + 1
    set current-process  current-process + 1 ;verificare se quando muore un processo l'assegnazione sia sempre sequenziale oppure debba fare -1 in caso di die
  ]
  ;move to queue
         
    if any? cores with [core-taken = false] and number-of-processes > 0 [
   ; ask cores with [xcor =  ([xcor] of one-of other processes)] [set core-taken true]
    ask processes with[ who  = [who] of process item 1 mylist]  [face  unused-core forward 1] ;direi che qui devo prendere il primo elemento della lista e farlo spostare qui,una volta che inizia a spostarsi dev
    
  ]
  
 tick
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
