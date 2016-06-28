helloWorld = (test) ->
  console.log "Hello world, but with functions!" if test
  console.log "And now, the other one!" if !test

shortcuts = (characters...) ->
  console.log "Introducing #{character}" for character in characters

helloWorld(true)
helloWorld(false)
shortcuts('Soshin','Cosimo','Carrick','Skye','Leilara','Hadari')
