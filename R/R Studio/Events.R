#Script for fairy, genie, monster, and moving to the next floor events

#Function for fairy event
fairy_event <- function(castle_data,player){
  #Add space between previously printed screen and new screen
  new_line(50)
  castle_data$castle[player$movement_coordinate] <- player$encountered_object
  display_array(castle_data = castle_data,player = player,game_sequence = "non-battle")
  cat("You encountered a fairy!")
  new_line(2)
  #Player mana and hp capped at 100
  if(player$hp == 100 & player$mana == 100){
    cat("Your HP and mana are already full. Come back later.")
    #Add pause to allow player to read information
    Sys.sleep(1.5)
  }
  else{
    if(player$hp == 100 & player$mana < 100){
      cat("Your mana was fully restored!.")
      player$mana <- player$mana + (100 - player$mana)
    }
    else if(player$hp < 100 & player$mana == 100){
      cat("Your HP was fully restored!")
      player$hp <- player$hp + (100 - player$hp)
    }
    else{
      cat("Your HP and mana were fully restored!")
      player$mana <- player$mana + (100 - player$mana)
      player$hp <- player$hp + (100 - player$hp)
    }
    
    castle_data$dataframe[player$castle_dataframe_row,"hp"] <- 0
    #Add pause to allow player to read information
    Sys.sleep(1.5)
  }
  #Adding back door 
  castle_data$castle[player$movement_coordinate] <- "\U1F6AA"
  if(castle_data$dataframe[player$castle_dataframe_row,"hp"] == 0){
    #Adding zero to dataframe so that fairy event is deactivated
    castle_data$dataframe[player$castle_dataframe_row,"hp"] <- 0
    new_line(50)
    display_array(castle_data = castle_data,player = player,game_sequence = "non-battle")
    cat("The fairy disappeared...")
    #Add pause to allow player to read information
    Sys.sleep(1.5)
  }
  #Return information
  fairy_event_output <- c(castle_data,player)
  return(fairy_event_output)
  }
#Function for genie event
genie_event <- function(castle_data,player){
  new_line(50)
  castle_data$castle[player$movement_coordinate] <- player$encountered_object
  display_array(castle_data = castle_data,player = player,game_sequence = "non-battle")
  cat("You encountered a genie!")
  player_choice <- ""
  player_action <- ""
  while(!player_action == "s"){
    new_line(50)
    display_array(castle_data = castle_data,player = player,game_sequence = "non-battle")
    cat("___________________________________________________")
    new_line(1)
    cat(player$menus[["genie"]])
    new_line(1)
    cat("___________________________________________________")
    new_line(2)
    player_action <- read_console_player_menu_action(game_sequence = "genie")
    #Move cursor
    if(player_action %in% c("a","d")){
      player <- cursor$move_cursor(player,player_action,game_sequence = "genie")
    }
    #Logic for selection
    else{
      player_choice <- player$menus[["genie"]][cursor$position + 1]
    }
  }
  
  if(player_choice == "Increase Attack"){
    new_line(50)
    display_array(castle_data = castle_data,player = player,game_sequence = "non-battle")
    attack_increase <- sample(1:5,1)
    cat(sprintf("Your Attack range and Enchanced Attack range increased by %s points.",attack_increase))
    player$attack_range <- player$attack_range + attack_increase
    player$enhanced_attack_range <- player$enhanced_attack_range + attack_increase
    new_line(2)
    cat(sprintf("New Attack range: %s:%s",min(player$attack_range),max(player$attack_range)))
    new_line(2)
    cat(sprintf("New Enchanced Attack range: %s:%s",min(player$enhanced_attack_range),max(player$enhanced_attack_range)))
  }
  else if(player_choice == "Reduce Mana Cost"){
    new_line(50)
    display_array(castle_data = castle_data,player = player,game_sequence = "non-battle")
    decrease_mana_cost <- sample(1:5,1)
    if(player$mana_cost - decrease_mana_cost < 1){
      decrease_mana_cost <- player$mana_cost  - 1
      player$mana_cost <- 1
      player$menu[["genie"]] <- player$menu[["genie"]][1:2]
    }
    else{
      player$mana_cost <- player$mana_cost - decrease_mana_cost
    }
    player$menus[["battle"]][4] <- sprintf("Enchanced Attack(%s mana)", player$mana_cost)
    cat(sprintf("Your Enhanced Attack now costs %s mana",player$mana_cost))
  }
  else{
    cat("Come back later.")
  }
  #Adding pause so player can read info
  Sys.sleep(2)
  #Adding back door and a zero in dataframe
  castle_data$castle[player$movement_coordinate] <- "\U1F6AA"
  if(!player_action == "exit"){
    new_line(50)
    display_array(castle_data = castle_data,player = player,game_sequence = "non-battle")
    cat("The genie disappeared...")
    castle_data$dataframe[player$castle_dataframe_row,"hp"] <- 0
    Sys.sleep(1.5)
  }
  #Erase cursor and add back to slot 1
  player$menus[["genie"]][which(player$menus[["genie"]] == "\U2771")] <- ""
  #Reset cursor position
  cursor$position <- 1
  player$menus[["genie"]][cursor$position] <- "\U2771"
  inventory_output <- c(castle_data,player)
  #Return information
  genie_event_output <- c(castle_data,player)
  return(genie_event_output)
  }
#Function for monster event
monster_event <- function(castle_data,player){
  new_line(50)
  #Go to dataframe and extract 
  castle_data$castle[player$movement_coordinate] <- player$encountered_object
  monster_hp <- castle_data$dataframe[player$castle_dataframe_row, "hp"]
  display_array(castle_data = castle_data,player = player,game_sequence = "battle",
                monster_hp = monster_hp)
  cat("You encountered a monster!")
  new_line(2)
  player_choice <- ""
  player_action <- ""
  #While loop so that player can engage with monster unless they decide to run, they faint, or they win
  while(!(player_choice == "Run" | monster_hp == 0 | player$hp == 0)){
    #Player input command for battle menu
    while(!player_action == "s"){
      new_line(50)
      display_array(castle_data = castle_data,player = player,game_sequence = "battle",
                    monster_hp = monster_hp)
      cat("___________________________________________________")
      new_line(1)
      cat(player$menus[["battle"]])
      new_line(1)
      cat("___________________________________________________")
      new_line(2)
      player_action <- read_console_player_menu_action(game_sequence = "battle")
      #Move cursor
      if(player_action %in% c("a","d")){
        player <- cursor$move_cursor(player,player_action,game_sequence = "battle")
      }
      #Logic for selection
      else{
        player_choice <- player$menus[["battle"]][cursor$position + 1]
        #Check mana
        if(!player_choice %in% c("Attack","Run", "Inventory")){
          if(player$mana - player$mana_cost < 0){
            new_line(50)
            display_array(castle_data = castle_data,player = player,game_sequence = "battle",
                          monster_hp = monster_hp)
            cat("___________________________________________________")
            new_line(1)
            cat(player$menus[["battle"]])
            new_line(1)
            cat("___________________________________________________")
            new_line(2)
            cat("You don't have sufficient mana.")
            #Clear player_action
            player_action = ""
            Sys.sleep(1)
          }
        }
      }
      }
   
    if(!player_choice %in% c("Run", "Inventory")){
      event_output <- battle_sequence(castle_data = castle_data,player = player,monster_hp = monster_hp,
                                      player_choice = player_choice)
      castle_data <- event_output[1:3]
      player <- event_output[[4]]
      monster_hp <- castle_data$dataframe[player$castle_dataframe_row,"hp"]
      }
    #Access inventory during battle
    else if(player_choice == "Inventory"){
      event_output <- item_inventory(castle_data = castle_data,player = player,game_sequence = "battle")
      player_action <- ""
      player <- event_output[[4]]
    }
    }
  #Add back door
  castle_data$castle[player$movement_coordinate] <- "\U1F6AA"
  #Erase cursor and add back to slot 1
  player$menus[["battle"]][which(player$menus[["battle"]] == "\U2771")] <- ""
  #Reset cursor position
  cursor$position <- 1
  player$menus[["battle"]][cursor$position] <- "\U2771"
  monster_event_output <- c(castle_data,player)
  return(monster_event_output)
  }
#Function for monster combat
battle_sequence <- function(castle_data,player,monster_hp,player_choice){
  new_line(50)
  display_array(castle_data = castle_data,player = player,game_sequence = "battle",
                monster_hp = monster_hp)
  if(player_choice == "Attack"){
    player$attack_power <- sample(player$attack_range,1)
  }
  else{
    player$attack_power <- sample(player$enhanced_attack_range,1)
    player$mana <- player$mana - player$mana_cost
  }
  cat(sprintf("You dealt %s points of damage",player$attack_power))
  new_line(2)
  #Monster hp set to zero to exit loop if attack > than monster hp
  if(monster_hp - player$attack_power <= 0){
    #Add zero to dataframe to ensure that event is not triggered
    castle_data$dataframe[player$castle_dataframe_row,"hp"] <- monster_hp <- 0
    win_money <- castle_data$dataframe[player$castle_dataframe_row,"win_money"]
    player$money = player$money + win_money
    cat(sprintf("The monster fainted. Got %s dollars",win_money))
    Sys.sleep(1.5)
    if(player$monster_threshold > 0){
      player$monster_threshold <- player$monster_threshold - 1
    }
    }
  else{
    #Update monster hp, if player decides to run, when they encounter monster again, 
    #it will reflect the new hp
    castle_data$dataframe[player$castle_dataframe_row,"hp"] <- monster_hp <-  monster_hp - player$attack_power
    monster_attack <- sample(1:5,1)
    player$hp <- player$hp - monster_attack
    cat(sprintf("Monster dealt %s points of damage",monster_attack))
    if(player$hp <= 0){
      new_line(2)
      #player health set to zero if monster attack > than player hp
      player$hp <- 0
      cat("You died.")
    }
    }
  monster_combat_event_output <- c(castle_data,player)
  return(monster_combat_event_output)
  }

upstairs_event <- function(castle_data,player){
  new_line(50)
  display_array(castle_data = castle_data,player = player,game_sequence = "non-battle")
  cat("You already came from upstairs.")
  new_line(2)
  upstairs_event_output <- c(castle_data,player)
  Sys.sleep(1)
  return(upstairs_event_output)
  }


