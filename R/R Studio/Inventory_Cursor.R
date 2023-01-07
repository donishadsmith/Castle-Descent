#cursor class
inventory_cursor = setRefClass('Inventory Cursor', fields = list(
                                             position = 'numeric',
                                             cursor_movement_dict = 'list'),
                               methods = list(
                                 move_cursor = function(player,player_action){
                                   position <<- position + cursor_movement_dict[[player_action]]
                                   player$observable_inventory[which(player$observable_inventory == '\U25B2')] = ''
                                   if(position %in% c(0,8)){
                                     if(position == 0){
                                       position <<- 6
                                     }
                                     else{
                                       position <<- 2
                                     }
                                   }
                                   player$observable_inventory[position] <- '\U25B2'
                                   return(player)
                                   }
                                   
                               ))

cursor = inventory_cursor(position = 2, cursor_movement_dict = list('a' = -2, 'd' = 2))
