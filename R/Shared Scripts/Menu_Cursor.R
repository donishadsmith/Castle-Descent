#cursor class
menu_cursor_class <- setRefClass("Inventory Cursor",
                                 fields = list(position = "numeric",
                                               cursor_movement_dict = "list"),
                                 methods = list(
                                   move_cursor = function(object,player_action,game_sequence){
                                     #Get the matrix
                                     if(game_sequence == "inventory"){
                                       menu_type <- object$observable_item_inventory
                                     }
                                     else if(game_sequence %in% c("battle","genie")){
                                       menu_type <- object$menus[[game_sequence]]
                                     }
                                     else{
                                       menu_type <- object
                                     }
                                     #Get current position in current inventory and add to it
                                     position <<- which(menu_type == "\U2771") + cursor_movement_dict[[player_action]]
                                     #Erase previous cursor
                                     menu_type[which(menu_type == "\U2771")] <- ""
                                     limit <- length(menu_type)
                                     if(position %in% c(-1,limit + 1)){
                                       if(position == -1){
                                         position <<- limit - 1
                                       }
                                       else{
                                         position <<- 1
                                       }
                                     }
                                     #Place arrow in new position
                                     menu_type[position] <- "\U2771"
                                     #Give back updated menu to object
                                     if(game_sequence == "inventory"){
                                       object$observable_item_inventory <- menu_type
                                     }
                                     else if(game_sequence %in% c("battle","genie")){
                                       object$menus[[game_sequence]] <- menu_type
                                     }
                                     else{
                                       object <- menu_type
                                     }
                                     return(object)
                                   }
                                 )
)
cursor <- menu_cursor_class(position = 1, cursor_movement_dict = list("a" = -2,"d" = 2))
