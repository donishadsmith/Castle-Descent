#Script for player and zombie classes
#Zombie class contains the necessary attributes to keep track of zombie coordinates
#and methods to allow zombie to move
zombie_class = setRefClass('zombie_info', fields = list(movement_dict = 'list',
                                                        current_coordinate = 'matrix',
                                                        distance_to_player= 'numeric',
                                                        floor = 'numeric'),
                           methods = list(
                             chebyshev_distance = function(a,b){
                               distance = max(abs(a - b))
                               return(distance)
                             },
                             manhattan_distance = function(a,b){
                               distance = sum(abs(a - b))
                               return(distance)
                             },
                             pathfinding = function(castle_data,player){
                              #Using the current coordinate, get list of for possible
                                 movement_vector = c()
                                 for(movement in movement_dict){
                                   possible_coordinate = current_coordinate + movement
                                   #If coordinate is not out of bounds and is empty or contains the player, it is a possible coordinate to move to
                                   if(!(length(which(possible_coordinate[1:2] %in% c(0,castle_data$castle_length + 1) > 0)))){
                                     if(castle_data$castle[possible_coordinate] == ' '| castle_data$castle[possible_coordinate] == '\U1F93A'){
                                       movement_vector = c(movement_vector, list(possible_coordinate))
                                     }
                                   }
                                 }
                                 #See if player coordinate is in the movement_vector
                                 logic_vector = c()
                                 for(possible_coordinate in movement_vector){
                                   logic_vector = c(logic_vector, possible_coordinate == player$current_coordinate)
                                 }
                                 #If player coordinate isn't in movement vector
                                 if(!(T %in% logic_vector[1] & T %in% logic_vector[2] & T %in% logic_vector[3])){
                                   #Manhattan distance so that if zombie is out of a certain range, it minimizes distance to player
                                   distance = manhattan_distance(current_coordinate,player$current_coordinate)
                                   if(distance > 4){
                                     distance_to_player_position = c()
                                     for(possible_coordinate in movement_vector){
                                       distance_to_player_position = c(distance_to_player_position,chebyshev_distance(possible_coordinate,player$current_coordinate))
                                     }
                                     current_coordinate <<-  movement_vector[[which(distance_to_player_position == min(distance_to_player_position ))[1]]]
                                   }
                                   #If it is within a certain range it starts to predict
                                   else{
                                     dynamic_t = chebyshev_distance(current_coordinate,player$current_coordinate)/player$max_velocity
                                     predicted_player_x = round(player$current_coordinate[1] + (player$current_velocity*dynamic_t),0)
                                     predicted_player_y = round(player$current_coordinate[2] + (player$current_velocity*dynamic_t),0)
                                     predicted_player_position = c(predicted_player_x,predicted_player_y,player$floor)
                                     
                                     distance_to_predicted_player_position = c()
                                     for(possible_coordinate in movement_vector){
                                       distance_to_predicted_player_position = c(distance_to_predicted_player_position,chebyshev_distance(possible_coordinate,predicted_player_position))
                                     }
                                     current_coordinate <<-  movement_vector[[which(distance_to_predicted_player_position == min(distance_to_predicted_player_position))[1]]]
                                     
                                   }
                                  
                                 }
                                 #If player coordinate is in movement vector, zombie moves to the coordinate
                                 else{
                                   current_coordinate <<- player$current_coordinate
                                 }
                                 #Erase zombie from old location and add to new location
                                 castle_data$castle[which(castle_data$castle=='\U1F9DF', arr.ind = T)] = ' '
                                 castle_data$castle[current_coordinate] = '\U1F9DF'
                                 #Calculate new distance from zombie to player
                                 distance_to_player <<- chebyshev_distance(current_coordinate,player$current_coordinate)
                                 if(distance_to_player == 0){
                                   cat(rep("\n", 50))
                                   print(castle_data$castle[,,player$floor], quote = F)
                                   print('You were eaten by the zombie' , quote = F)
                                 }
                                 #Return information
                                 pathfinder_output = c(castle_data,player)
                                 return(pathfinder_output)
                               
                             },
                             #Allow zombie to move ot new floor with player
                             move_to_new_floor_event = function(castle_data,player){
                               #Find the coordinate that allows the zombie to be at the greatest Chebyshev distance from the
                               #player
                               movable_spaces = which(castle_data$castle[,,player$floor]==' ', arr.ind = T)
                               max_distance = c()
                               for(row in 1:nrow(movable_spaces)){
                                 max_distance = c(max_distance,chebyshev_distance(movable_spaces[row,],player$current_coordinate[1:2]))
                               }
                               coord = movable_spaces[which(max_distance== max(max_distance))[1],]
                               #Erase old zombie location
                               castle_data$castle[which(castle_data$castle=='\U1F9DF', arr.ind = T)] = ' '
                               #Add new zombie location and update initial coordinate,current coordinate, and distance
                               castle_data$castle[,,player$floor][coord[1],coord[2]] = '\U1F9DF'
                               current_coordinate <<- which(castle_data$castle=='\U1F9DF', arr.ind = T)
                               distance_to_player <<- chebyshev_distance(current_coordinate,player$current_coordinate)
                               #Reset 
                               move_to_new_floor_event_output = c(castle_data,player)
                               return(move_to_new_floor_event_output)
                             }))

#Player class keeps importint information about player such as health and current posisiton
player_class =  setRefClass('player_info', fields = list(hp ='numeric', current_coordinate='matrix',
                                                         movement_dict = 'list',
                                                         encountered_object='character',
                                                         movement_coordinate = 'matrix',
                                                         attack_range='numeric', 
                                                         attack_power = 'numeric',
                                                         floor = 'numeric',
                                                         castle_dataframe_row = 'numeric',
                                                         #Adding incentive to kill monsters. If player kills a certain number of monsters.
                                                         #Stairs/exit is revealed
                                                         monster_threshold = 'numeric',
                                                         total_floors = 'numeric',
                                                         max_velocity = 'numeric',
                                                         before_game_update_time = 'numeric',
                                                         after_game_update_time = 'numeric',
                                                         current_velocity = 'numeric'
                                                         ),
                            methods = list(
                              calculate_player_velocity = function(){
                                #Change in grid position always equals 1
                                current_velocity <<- 1/(after_game_update_time - before_game_update_time)
                                if (current_velocity > max_velocity) {
                                  max_velocity <<- current_velocity
                                }
                              },
                              move_to_new_floor_event = function(castle_data){
                                cat(rep("\n", 50))
                                print('You found the stairs!', quote = F)
                                print(paste('You can now advance to floor', floor + 1,'!'), quote = F)
                                print(paste('Floor', floor, 'of',total_floors), quote = F)
                                print(castle_data$castle[,,floor], quote = F)
                                #Add 1 to player's current z-position
                                floor <<- floor + 1
                                #Reset the monster threshold
                                monster_threshold <<- round(length(which(castle_data$dataframe['z'] == floor & castle_data$dataframe['object']=='\U1F479'))*0.60,0)
                                current_coordinate[3] <<- floor
                                castle_data$castle[current_coordinate] = '\U1F93A'
                                Sys.sleep(1)
                                #Return information
                                return(castle_data)
                              }
                              
                            ))



