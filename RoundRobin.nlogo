breed [cpus cpu]
breed [queues queue]
breed [slots slot]
breed [cores core]
breed [graveyards graveyard]
breed [processes process]
breed[my-labels my-label]


processes-own[
  state
  working-ticks
  id 
]


slots-own
[
  slot-taken
]

cores-own
[
  core-taken
]


;should be usefull
queues-own
[
  number-of-slots
  max-number-of-slots
  queue-taken
]

globals[
  the-cpu
  the-queue
  the-graveyard
  the-core
  max-number-of-cores
  number-of-cores
  max-number-of-processes
  number-of-processes
  current-process
  current-slot
  mylist
  context-switch-ticks
]





to setup
  clear-all

  ask patches [set pcolor white]
  set mylist []


  create-cpus 1
  create-graveyards 1
  set the-graveyard one-of graveyards
  set the-cpu one-of cpus
  set max-number-of-cores 4
  set number-of-cores 0
  set  max-number-of-processes 11
  set number-of-processes 0
  set current-process 16
  set context-switch-ticks n-ticks
  ask the-cpu
  [

    set shape  "square 2"
    set xcor 10
    set ycor -10
    set size 15
    set color 4
  ]
  ask the-graveyard[
    set shape "graveyard"
    set size 10
    set color grey
    set heading 360
    set xcor -14
    set ycor -14
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
   create-my-labels 1[
     set xcor ([xcor] of the-queue) - 12
    set ycor ([ycor] of the-queue) + 5
    set label "QUEUE"
    set label-color white
    set size 0
  ]
  generate-slot
  reset-ticks
end





to go
  ;generate-processes
  move-to-cpu
  remove-from-cpu
 tick
end

to add-core

  if max-number-of-cores != number-of-cores
  [set number-of-cores number-of-cores + 1
      create-cores 1
      set the-core one-of cores
      ask the-core [
      if number-of-cores = 1  [set xcor ([xcor] of the-cpu - 2) set ycor ([ycor] of the-cpu + 2) set color 7]
      set shape "square"
      set size  4
      set core-taken false
    ]
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

to generate-processes

  if number-of-processes < max-number-of-processes
  [

      create-processes 1[
        set color  green
      set shape  one-of ["square" "triangle" "circle"  "star"  "arrow" "box"]
        set size 2
        set xcor 0
        set ycor 0
        set id current-process
        set working-ticks random 200
        set state "wait"
      ]

      
      set mylist lput current-process mylist

      set number-of-processes  number-of-processes + 1
      set current-process  current-process + 1 ;verificare se quando muore un processo l'assegnazione sia sempre sequenziale oppure debba fare -1 in caso di die ... TO UPDATE: se creo nuovi core o nuove turtle che non siano processi
      move-to-queue
  ]

end




to move-to-cpu

  if any? cores with [core-taken = false] and number-of-processes > 0 [

      ;execute the dequeue routine 
      let target-distance 10
          while [target-distance > 0.00005][
               ask processes with[ who  = first  mylist] [
                  face the-core
                  forward 0.0001
             ]
             set target-distance  [distance process first mylist] of the-core
          ]
         ask the-core [set core-taken  true]
          move-to the-core
          ask processes with[ who  = first  mylist] [set state  "running"]
          set mylist remove first mylist mylist
          ask the-queue[set number-of-slots number-of-slots - 1]

  ]
end


to move-to-queue
  if [number-of-slots] of the-queue < [max-number-of-slots] of the-queue [
          ask the-queue [ set number-of-slots number-of-slots + 1]
          

           ;shift all processes on the left by one slot (it simulates the creation of a new "cell" in our queue)
           foreach mylist [
             [x]->
              if [state] of  process x = "ready" [ask process x [ set xcor xcor - 3]]
            ]
          

          ;execute the enqueue routine
          let target-distance 10
          while [target-distance > 0.00005][
              ask process last mylist [
                  facexy 13.5 10
                  forward 0.0001
              ]
              set target-distance  [distance process last mylist] of one-of slots with[xcor =  13.5 and ycor = 10]
          ]
         ask slots with[xcor = 13.5] [set slot-taken  true]
         ask process last mylist [move-to one-of slots with[ xcor =  13.5 and ycor = 10]  set state "ready"]
      ]
end


to remove-from-cpu

  if ticks  > 0 and ticks mod  context-switch-ticks  = 0[
    ask processes with [ state = "running"][
      ifelse number-of-processes = 1[      ;if there is only one process there is no reason to doing a context-switch.. little process the whole cpu is your
        while[number-of-processes = 1][check-status]
      ]
      [check-status]
    ]
  ]

end


to check-status
  
        ifelse working-ticks - context-switch-ticks <= 0[          ;the process have finished his job... 
          set color red
          set number-of-processes number-of-processes - 1
          set state  "death"
        
        ]
        [
          set color yellow
          set working-ticks working-ticks - context-switch-ticks     ;even thought the process had the cpu for a while it didn't finish his job
          
          
           if number-of-processes != 1 [
               set mylist lput [id] of one-of processes with [state = "running"] mylist
               set state "wait"
               move-to-queue
           ]
        ]
      
    
    ask the-core [ set core-taken false]  
      
    ask processes with[state = "death"][   ;if a process end his job it will be be destroyed by sending him to the graveyard
      let distance-of-death 10
      while[distance-of-death > 0.00005][
        set distance-of-death [distance one-of processes with[state = "death"]] of the-graveyard
        face the-graveyard 
        forward 0.0001  ]
      move-to the-graveyard
      die
    ]
  
end
