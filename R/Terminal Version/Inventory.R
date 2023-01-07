inventory = function(castle_data,player){
  
  if(length(which(player$hidden_inventory > 0)) == 0){
    cat(rep("\n", 50))
    print('Inventory',quote = F)
    cat('')
    print(player$observable_inventory,quote = F)
    cat('')
    print('You have nothing in you inventory.',quote = F)
  }
  
  else{
    player_action = 'x'
    object = player$observable_inventory[1]
    while(!(player_action == 'u'| player_action == 'e')){
      cat(rep("\n", 50))
      print('Inventory',quote = F)
      cat('\n')
      print(player$observable_inventory,quote = F)
      switch(object,
             '\U1F52E' = {
               cat('\n')
               print('Crystal Ball',quote = F)
               cat("\n")
               print('Temporarily halts zombie movement.',quote = F)
               },
             '\U1F371' = {
               cat('\n')
               print('Bento Box',quote = F)
               cat("\n")
               print('Heals 20 hp.',quote = F)
             },
             '\U0001f50e' = {
               cat('\n')
               print('Magnifying Glass',quote = F)
               cat("\n")
               print('Reveals the door leading to stairs or exit.',quote = F)

             }
      )
      cat("\n")
      print(paste('Number in inventory: ',player$hidden_inventory[[object]]),quote = F)
      cat('\n')
      print('a (left), d(right), u (use), e (exit inventory): ',quote = F)
      while(!(player_action %in% c('a','d','u','e'))){
        player_action = tolower(keypress(block = T))
      }
      if(player_action %in% c('a','d')){
        player = cursor$move_cursor(player,player_action)
        object = player$observable_inventory[cursor$position - 1]
        #Clear current player_action
        player_action = 'x'
      }
    }
    
    if(player_action == 'u'){
      cat('\n')
      #Reduce number of items left
      player$hidden_inventory[[object]] = player$hidden_inventory[[object]] - 1
      cat(rep("\n", 50))
      print('Inventory',quote = F)
      cat('\n')
      print(player$observable_inventory,quote = F)
      cat('\n')
      switch(object,
             '\U1F52E' = {
               player$zombie_halt = sample(10:20,1)
               print(paste('Zombie halted for',player$zombie_halt,'steps.'), quote = F)
               player$hidden_inventory[[object]] = player$hidden_inventory[[object]] - 1
             },
             '\U1F371' = {
               print('Your HP increased by 20 points.',quote = F)
               player$hp = player$hp + 20
               print(paste('New HP:',player$hp),quote = F)
             },
             '\U0001f50e' = {
               player$monster_threshold = 0
               print('The door has been revealed.',quote = F)
             }
      )
      #Erase and add back available items,
      #Will have to update if numerous items get added in the future
      #since this code erases and re-adds whenever an item is used
      player$observable_inventory[1,1:3] = ''
      
      for(num in 1:length(player$hidden_inventory)){
        item = names(player$hidden_inventory[num])
        if(player$hidden_inventory[[item]] > 0){
          empty_space = which(player$observable_inventory[1,] == '')[1]
          player$observable_inventory[1,empty_space] = item
        }
      }
      #Erase cursor
      player$observable_inventory[2,1:3] = ''
      #Reset cursor
      cursor$position = 2
      player$observable_inventory[2,1] = '\U25B2'
    }
  }
  Sys.sleep(1)
  inventory_output = c(castle_data,player)
  return(inventory_output)
}

