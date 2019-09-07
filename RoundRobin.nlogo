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
  id ;??????????? magari ci metto il loro whonumbher
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
  the-queue
  unused-core
  used-core
  max-number-of-cores
  number-of-cores
  max-number-of-processes
  number-of-processes
  last_created
  current-process
  current-slot
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
  set current-process 4

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
  
  create-queues 1
  set the-queue one-of queues
  ask the-queue[
   set max-number-of-slots  10
   set number-of-slots  0
   set shape  "queue"
   set size  33
   set xcor 0
    set ycor 9
    set color  grey
    set heading 180
  ]
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

  generate-processes
  
  
  ;TO DO :  MOVE THE SPAWNED PROCESS TO THE (turtle)QUEUE IF POSSIBLE
  
  
  
  
  
  
  
  
  
  
  
  

; da modificare... prima l'elemento deve essere messo nella coda..
   if any? cores with [core-taken = false] and number-of-processes > 0 [
    ask processes with[ who  = first  mylist]  [
        face unused-core
        forward 0.0001
        let target-distance  [distance process first mylist] of unused-core
         if target-distance < 0.00005 [
          ask unused-core [set core-taken  true]
          move-to unused-core
        ]
      ]
    ]  ; this action in the future will be done by the first project in the turtle queue
    
  

 tick
end



to generate-processes
  
    if ticks > 0 and  ticks mod 10 = 0 and number-of-processes < max-number-of-processes
  [

      create-processes 1[
        set color green
        set shape "square"
        set size 2
        set xcor 0
        set ycor 0
        set id current-process
      ]
      ;set whonumber  [who] of  process current-process  --> it'doesn't work.. same error below
      ask process current-process [set whonumber  who ] ; --> current-proces is a variable that start to 0.. yeah i've tried also to put 0 instead.. doesn't work
      set mylist lput whonumber mylist

      set number-of-processes  number-of-processes + 1
      set current-process  current-process + 1 ;verificare se quando muore un processo l'assegnazione sia sempre sequenziale oppure debba fare -1 in caso di die ... TO UPDATE: se creo nuovi core o nuove turtle che non siano processi
      if [number-of-slots] of the-queue < [max-number-of-slots] of the-queue [
          generate-slot
          set current-process  current-process + 1 ; mi serve monitorare il numero degli id
          set current-slot  current-process  ; l'id della nuova turtle sarà quella dell'ultimo processo genrato + 1... però incrementavo già prima
          ask the-queue [ set number-of-slots number-of-slots + 1]
      
          ; now i need to move the process to the destination
      ]
  ]
  
end


to generate-slot
  
  
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
