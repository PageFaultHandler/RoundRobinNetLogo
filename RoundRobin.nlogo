breed [processes process]
breed [cpus cpu]



to setup
  clear-all
  create-processes 1 [ set color yellow ]
  create-cpus 1 [set color 123]
  ask patches [set pcolor white]
 
  ask cpus [ set shape  "square 2" set xcor 6  set ycor 0 set size 10 ] ;voglio metterci un parametro booleano "taken" se un processo è sopra di lei
  

  
  
   ask patches with [ pycor = 16 and pxcor <= 13 and pxcor >= -16] 
  [ set pcolor  1]
  ask patches with [ pycor =  11 and pxcor <= 13 and pxcor >= -16] 
  [ set pcolor  2]
  ask patches with [ pycor <= 16 and pycor >= 11   and pxcor = -16] 
  [ set pcolor 1]
    ask patches with [ pycor <= 16  and pycor >= 11 and pxcor = 13] 
  [ set pcolor 2]
  
  
  
  ask patches with [ pycor <= 15  and pycor >= 12 and pxcor >= -15 and pxcor <= -12] 
  [ set pcolor  6]
  ask patches with [ pycor <= 15  and pycor >= 12 and pxcor >= -11 and pxcor <= -8] 
  [ set pcolor  3]
  ask patches with [ pycor <= 15  and pycor >= 12 and pxcor >= -7 and pxcor <= -4] 
  [ set pcolor  6]
  ask patches with [ pycor <= 15  and pycor >= 12 and pxcor >= -3 and pxcor <= 0] 
  [ set pcolor  3]
  ask patches with [ pycor <= 15  and pycor >= 12 and pxcor >= 1 and pxcor <= 4] 
  [ set pcolor  6]
  ask patches with [ pycor <= 15  and pycor >= 12 and pxcor >= 5 and pxcor <= 8] 
  [ set pcolor  3]
  ask patches with [ pycor <= 15  and pycor >= 12 and pxcor >= 9 and pxcor <= 12] 
  [ set pcolor  6]
  
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
