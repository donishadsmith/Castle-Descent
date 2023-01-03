#Fucntions for the API
#Use RStudio's API to dynamically read R's Terminal
read_console_try_again_action = function(){
  print('Want to play again? Yes (y) or No (n)?', quote = F)
  #Loop will continue until player inputs valid response
  while (rstudioapi::isAvailable()) {
    player_action <<- tolower(rstudioapi::getConsoleEditorContext()$contents)
    if( player_action %in% c('yes','y')){
      #Needed to clear console
      rstudioapi::sendToConsole("", execute = F)
      castle_descent()
    }
    else if ( player_action %in% c('no','n')){
      print("Thank you for playing Castle Descent!", quote = F)
      return(noquote(""))
    }
    #Needed so that player can escape game by pressing ctrl + c.
    #It suspends execution of R expressions every n seconds
    rstudioapi::sendToConsole("", execute = F)
    Sys.sleep(0.2)
  }
}


read_console_player_movement_action = function() {
  print('w (up), a (left), s (down), or, d (right), or check inventory(i)', quote = F)
  while (rstudioapi::isAvailable()) {
    player_action <<- tolower(rstudioapi::getConsoleEditorContext()$contents)
    
    if (player_action %in% c('w','a','s','d', 'i')) {
      rstudioapi::sendToConsole("", execute = F)
      return(noquote(""))
    }
    rstudioapi::sendToConsole("", execute = F)
    Sys.sleep(0.2)
  }
}

read_console_player_monster_action= function() {
  print('attack(a) or run(r)', quote = F)
  while (rstudioapi::isAvailable()) {
    player_action <<- tolower(rstudioapi::getConsoleEditorContext()$contents)
    
    if (player_action %in% c('attack','a','r','run', 'i')) {
      rstudioapi::sendToConsole("", execute = F)
      return(player_action)
    }
    
    rstudioapi::sendToConsole("", execute = F)
    Sys.sleep(0.2)
  }
}

read_console_player_inventory_action= function() {
  print('Temporarily halt zombie movement(s) or leave your inventory (l).', quote = F)
  while (rstudioapi::isAvailable()) {
    player_action <<- tolower(rstudioapi::getConsoleEditorContext()$contents)
    
    if (player_action %in% c('s','l')) {
      rstudioapi::sendToConsole("", execute = F)
      return(player_action)
    }
    
    rstudioapi::sendToConsole("", execute = F)
    Sys.sleep(0.2)
  }
}
