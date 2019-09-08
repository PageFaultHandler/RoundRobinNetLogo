breed [cpus cpu]
breed [schedulers scheduler]
breed [queues queue]
breed [slots slot]
breed [cores core]
breed [processes process]
breed[my-labels my-label]

processes-own[
  time
  state
  working-ticks
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
   context-swicth-ticks
]





to setup
  clear-all

  ask patches [set pcolor white]
  set mylist []


  create-cpus 1
  set the-cpu one-of cpus
  set max-number-of-cores 4
  set number-of-cores 0
  set  max-number-of-processes 11
  set number-of-processes 0
  set current-process 14
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
  generate-slot
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
  move-to-cpu
  remove-from-cpu
 tick
end



to generate-processes
;10169 
    if ticks > 0 and  ticks mod 13 = 0 and number-of-processes < max-number-of-processes
  [

      create-processes 1[
        set color  green
        set shape  "square" 
        set size 2
        set xcor 0
        set ycor 0
        set id current-process
        set working-ticks random 10
      ]
  
      ;set whonumber  [who] of  process current-process  --> it'doesn't work.. same error below
      ask process current-process [set whonumber  who ] ; --> current-proces is a variable that start to 0.. yeah i've tried also to put 0 instead.. doesn't work
      set mylist lput whonumber mylist

      set number-of-processes  number-of-processes + 1
      set current-process  current-process + 1 ;verificare se quando muore un processo l'assegnazione sia sempre sequenziale oppure debba fare -1 in caso di die ... TO UPDATE: se creo nuovi core o nuove turtle che non siano processi
      move-to-queue
  ]

end


to generate-slot
     let prev-x-coord -16.5
     let cont 0
  loop[
    if cont = 10 [stop]
     create-slots 1[
      set shape "slot"
      set size 4
      set xcor prev-x-coord + 3
      set ycor 10
      set color 7
      set heading 180
      set slot-taken false
    ]
    set prev-x-coord prev-x-coord + 3
    set cont cont + 1
  ]

end

to move-to-cpu 
  
  if any? cores with [core-taken = false] and number-of-processes > 0 [
      let target-distance 10
          while [target-distance > 0.00005][
               ask processes with[ who  = first  mylist] [
                  face unused-core
                  forward 0.0001
             ]
             set target-distance  [distance process first mylist] of unused-core
          ]
         ask unused-core [set core-taken  true]
          move-to unused-core
          set mylist remove first mylist mylist
          ask the-queue[set number-of-slots number-of-slots - 1]

  ]  
end


to move-to-queue
  if [number-of-slots] of the-queue < [max-number-of-slots] of the-queue and [core-taken] of unused-core = true [
          ask the-queue [ set number-of-slots number-of-slots + 1]
          ; per ogni elemento della lista eccetto l'ultimo.. spostali allo slot succesivo
     
      
           foreach mylist [ 
             [x]->  
              if x != current-process - 1 [
                  ask process x [set xcor  xcor - 3]
             ]
           ]
    
      
          let target-distance 10
          while [target-distance > 0.00005][
              ask process last mylist [
                  facexy 13.5 10
                  forward 0.0001
              ]
              set target-distance  [distance process last mylist] of one-of slots with[xcor =  13.5 and ycor = 10]
          ]
         ask slots with[xcor = 13.5] [set slot-taken  true]
         ask process last mylist [move-to one-of slots with[ xcor =  13.5 and ycor = 10]]
          ; now i need to move the process to the destination
      ]
  
  
  if [number-of-slots] of the-queue < [max-number-of-slots] of the-queue and [core-taken] of unused-core = false[
       move-to-cpu
  ]
  
  
end


to remove-from-cpu
  show " sono qui.. ticks = "
  show ticks

  if  context-swicth-ticks - ticks <= 0[
    show "sono qua"
    ask processes with [ xcor = [xcor] of unused-core][
      ifelse working-ticks - context-swicth-ticks <= 0[
          set color red  
          die
          set number-of-processes number-of-processes - 1
      ]
      [
        set color yellow
        set working-ticks working-ticks - context-swicth-ticks
        ask unused-core [ set core-taken false]
        set mylist lput [id] of one-of processes with [ xcor = [xcor] of unused-core] mylist
        move-to-queue
      ]
    ]
  ]

end

; to be defined ;
to spawn

end
