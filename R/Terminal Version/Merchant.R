#Merchant Class

merchant_class = setRefClass("merchant", fields = list(item_costs = "list",
                             shop_inventory = "matrix",
                             selection_menu = "matrix",
                             max_buy = "numeric"),
                             methods = list(
                               
                               menu = function(castle_data,player,game_sequence){
                                 #Get functions
                                 new_line <- get("new_line", envir = castle_descent_env)
                                 cursor <- get("cursor", envir = castle_descent_env)
                                 item_descriptions <- get("item_descriptions", envir = castle_descent_env)
                                 player_action <- ""
                                 object = shop_inventory[2]
                                 while(!player_action =="e"){
                                   #Display Shop
                                   new_line(50)
                                   cat("\U1F9DD")
                                   new_line(2)
                                   cat("Merchant")
                                   new_line(1)
                                   cat("___________________________________________")
                                   new_line(2)
                                   cat(shop_inventory)
                                   new_line(1)
                                   cat("___________________________________________")
                                   new_line(2)
                                   #Item descriptions
                                   item_descriptions(object = object, cost = "yes")
                                   #Show number in inventory
                                   new_line(1)
                                   cat("___________________________________________")
                                   new_line(2)
                                   #Show number in inventory and money
                                   cat(sprintf("%s : %s %s Number in inventory: %s",money_unicode <- "\U1F4B0",player$money,"|",player$hidden_item_inventory[[object]]))
                                   new_line(2)
                                   while(!(player_action %in% c("a","d","s","e"))){
                                     cat("a(left), d(right), s(select), e(exit): ")
                                     player_action = tolower(keypress(block = T))
                                   }
                                   if(player_action %in% c("a","d")){
                                     shop_inventory <<- cursor$move_cursor(shop_inventory,player_action,game_sequence = game_sequence)
                                     #Get object
                                     object <- shop_inventory[cursor$position + 1]
                                     #Clear current player_action
                                     player_action <- ""
                                   }
                                   if(player_action == "s"){
                                     if(player$money > item_costs[[object]]){
                                       player <- add_item(player, object)
                                       player_action <- ""
                                     }
                                     else{
                                       player_action <- ""
                                     }
                                     
                                   }
                                   #Reset mouse position
                                   if(player_action == "e"){
                                     shop_inventory[which(shop_inventory == "\U2771")] <<- ""
                                     shop_inventory[1] <<- "\U2771"
                                   }
                                 }
                                 #Erase cursor and add back to slot 1
                                 player$observable_item_inventory[which(player$observable_item_inventory == "\U2771")] <- ""
                                 #Reset cursor position
                                 cursor$position <- 1
                                 player$observable_item_inventory[cursor$position] <- "\U2771"
                                 merchant_output <- c(castle_data,player)
                                 },
                               add_item = function(player, object){
                                 #Get functions
                                 new_line <- get("new_line", envir = castle_descent_env)
                                 cursor <- get("cursor", envir = castle_descent_env)
                                 item_descriptions <- get("item_descriptions", envir = castle_descent_env)
                                 #max amount player is allowed to buy
                                 player_action <- ""
                                 max_buy <<- round(player$money/item_costs[[object]],0) 
                                 if(max_buy*item_costs[[object]] > player$money){
                                   max_buy <<- round(player$money/item_costs[[object]],0) - 1
                                 }
                          
                                 while(!player_action %in% c("e","s")){
                                   #temporary_money = player$money
                                   #Display Shop
                                   new_line(50)
                                   cat("\U1F9DD")
                                   new_line(2)
                                   cat("Merchant")
                                   new_line(1)
                                   cat("___________________________________________")
                                   new_line(2)
                                   cat(shop_inventory)
                                   new_line(1)
                                   cat("___________________________________________")
                                   new_line(2)
                                   #Item descriptions
                                   item_descriptions(object = object, cost = "yes")
                                   new_line(2)
                                   cat(selection_menu)
                                   #Show number in inventory
                                   new_line(1)
                                   cat("___________________________________________")
                                   new_line(2)
                                   #Show number in inventory and money
                                   #Code for temporary money reduces/adds the amount of money as players add/subtract item to cart
                                   #Doing this may confuse player into believing that they already bought item.
                                   #cat(sprintf("%s : %s %s Number in inventory: %s",money_unicode <- "\U1F4B0", temporary_money <- temporary_money - (as.numeric(selection_menu[3])*item_costs[[object]])
                                               #, "|",player$hidden_item_inventory[[object]]))
                                   
                                   cat(sprintf("%s : %s %s Number in inventory: %s",money_unicode <- "\U1F4B0", player$money
                                               , "|",player$hidden_item_inventory[[object]]))
                                   new_line(2)
                                   #Actions based on player choice
                                   #Player input
                                   while(!(player_action %in% c("a","d","s","e"))){
                                     cat("a(left), d(right), s(select), e(exit): ")
                                     player_action = tolower(keypress(block = T))
                                   }
                                   #Add item to selection_menu and wrap
                                   if(player_action %in% c("a","d")){
                                     cat("")
                                     if(player_action == "a"){
                                       if(selection_menu[3] == "1"){
                                         selection_menu[3] <<- as.character(max_buy)
                                     
                                       }
                                       else{
                                         selection_menu[3] <<- as.character(as.numeric(selection_menu[3]) - 1)
                                    
                                       }
                                     }
                                     else if(player_action == "d"){
                                         if(selection_menu[3] == as.character(max_buy)){
                                           print(max_buy)
                                          selection_menu[3] <<- "1"
                                     
                                         }
                                       else{
                                            selection_menu[3] <<- as.character(as.numeric(selection_menu[3]) + 1)
                                           }
                                     }
                                     player_action <- ""
                                   }
                                   #Add object to inventory
                                   else if(player_action == "s"){
                                     player$hidden_item_inventory[[object]] <- player$hidden_item_inventory[[object]] + as.numeric(selection_menu[3])
                                     #If it is not in inventory, loop through available spaces to add it too
                                     if(length(which(player$observable_item_inventory[seq(2,8,2)] == object)) == 0){
                                       free_space <- which(player$observable_item_inventory[seq(2,8,2)] == "")
                                       player$observable_item_inventory[seq(2,8,2)][free_space[1]] <- object
                                     }
                                     #Subtract player money
                                     #player$money <- temporary_money
                                     player$money <- player$money - (as.numeric(selection_menu[3])*item_costs[[object]])
                                     #Put selection menu back to 1
                                     selection_menu[3] <<- "1"
                                   }
                                   
                                   
                                   
                                   }
                                 add_item_output <- c(player,player_action)
                                 return(player)
                                 }
                               ))

shop_inventory <- matrix("", ncol = 8)
shop_inventory[c(2,4,6,8)] <- c("\U1F52E","\U1F371", "\U0001f50e", "\U1F9EA")
shop_inventory[1] <- "\U2771"

selection_menu <- matrix(c("Buy: ","\U2770","1","\U2771"), ncol = 4)


merchant <- merchant_class(item_costs = list("\U1F52E" = 50,"\U1F371" = 10,"\U0001f50e" = 250,"\U1F9EA" = 40),
                          shop_inventory = shop_inventory,
                          selection_menu = selection_menu
                          )



