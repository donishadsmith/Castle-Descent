#Function to create castle and castle dataframe containing information about castle
castle_create <- function(){
  castle_dataframe <- data.frame("x" = NA, "y" = NA, "z" = NA, "object" = NA,
                                 "hp" = NA,'win_money' = NA)
  # Area of the castle floor will equal castle_width* castle_length
  # x,y are odd numbers for aesthetic reasons; those reasons involve the distance of the objects from each other
  castle_length <- sample(seq(9,13, 2),1)
  #Length of 3rd/z-dimension; 3D array
  max_floors <- sample(3:6, 1)
  
  castle <- array("",dim = c(castle_length,castle_length,max_floors))
  
  #Isolating spaces for objects; objects will be evenly spaced
  object_spaces <- seq(2,(castle_length-1), 2)
  #Area space in the array with one is where all objects will be allowed to spawn
  castle[object_spaces,object_spaces,] <- 1
  
  #Merchant not included in dataframe
  for(floor in 1:max_floors){
    castle[,,floor][sample(which(castle[,,floor] == "1"),1)] <- "\U1F9DD"
  }
  #One is the top of the castle; this is where the player spawns
  castle[,,1][sample(which(castle[,,1] == ""),1)] <- "\U1F93A"
  #Get player coordinate
  player_coord <- which(castle == "\U1F93A", arr.ind = T)[1:2]
  #Create matrix of free spaces
  movable_spaces <- which(castle[,,1] == "", arr.ind = T)
  
  #Spawn zombie at farthest location from Chebyshev distance player 
  max_coord <- c()
  for(row in 1:nrow(movable_spaces)){
    max_coord <- c(max_coord,max(abs(player_coord - movable_spaces[row,])))
  }
  coord <- movable_spaces[which(max_coord == max(max_coord))[1],]
  castle[,,1][coord[1],coord[2]] <- "\U1F9DF"
  
  #Spawn stairs ; DS = Down staircase
  for(floor in 1:(max_floors-1)){
    castle[,,floor][sample(which(castle[,,floor] == "1"),1)] <- "DS"
    castle[,,floor + 1][which(castle[,,floor] == "DS")] <- "AS"
  }
  
  castle_dataframe[nrow(castle_dataframe):nrow(which(castle == "DS", arr.ind = T)),] <- NA
  castle_dataframe[1:(castle_dataframe_rows <- nrow(castle_dataframe)),1:5] <- data.frame(which(castle=="DS", arr.ind = T), 
                                                                                          rep("DS",nrow(which(castle=="DS", arr.ind = T))),
                                                                                          rep(1,nrow(which(castle=="DS", arr.ind = T)))
  )
  
  #AS stands for above staircase; variable is used as a filler space to keep the cell corresponding to the the above "DS" object occupied
  castle_dataframe[(castle_dataframe_rows + 1):(castle_dataframe_rows + nrow(which(castle == "AS", arr.ind = T))),] <- NA
  castle_dataframe[(castle_dataframe_rows + 1):(castle_dataframe_rows <- nrow(castle_dataframe)),1:5] <- data.frame(which(castle=="AS", arr.ind = T), 
                                                                                                                    rep("AS",nrow(which(castle=="AS", arr.ind = T))),
                                                                                                                    rep(1,nrow(which(castle=="AS", arr.ind = T)))
  )
  
  #Adding new rows and coordinates to dataframe
  #Bottom of the castle is where the exit spawns
  castle[,,max_floors][sample(which(castle[,,max_floors] == "1"),1)] <- "\U2395"
  
  #Coordinates of the exit added to dataframe
  castle_dataframe[(castle_dataframe_rows + 1):(castle_dataframe_rows + nrow(which(castle=="\U2395", arr.ind = T))),] <- NA
  castle_dataframe[(castle_dataframe_rows + 1):(castle_dataframe_rows <- nrow(castle_dataframe)),c(1:5)] <- data.frame(which(castle=="\U2395", arr.ind = T), "\U2395", 1)
  
  
  
  
  #Adding same number of fairies and genies to each floor
  #This allows each floor to have the same proportion of fairies, monsters, and genies
  #simply adding fairies and genies without respect to each floor may result in an imbalance.
  #the majority of fairies and genies may be randomly placed at the top floors, bottom floors, or specfic floors.
  
  
  for(floor in 1:max_floors){
    castle[,,floor][sample(which(castle[,,floor] == "1"),round(castle_length/3,0))] <- "\U1F9DA"
    castle[,,floor][sample(which(castle[,,floor] == "1"),round(castle_length/5,0))] <- "\U1F9DE"
  }
  
  #Add monsters - Ogres and vampires
  for(floor in 1:max_floors){
    for(space in which(castle[,,floor] == "1")){
      castle[,,floor][space] <- sample(c("\U1F479","\U1F9DB"),1)
    }
  }
  
  #Adding information to dataframe
  castle_dataframe[(castle_dataframe_rows + 1):(castle_dataframe_rows + nrow(which(castle == "\U1F479", arr.ind = T))),] <- NA
  castle_dataframe[(castle_dataframe_rows + 1):(castle_dataframe_rows <- nrow(castle_dataframe)),1:4] <- data.frame(which(castle == "\U1F479", arr.ind = T), rep("\U1F479", nrow(which(castle =="\U1F479", arr.ind = T))))
  
  castle_dataframe[(castle_dataframe_rows + 1):(castle_dataframe_rows + nrow(which(castle == "\U1F9DB", arr.ind = T))),] <- NA
  castle_dataframe[(castle_dataframe_rows + 1):(castle_dataframe_rows <- nrow(castle_dataframe)),1:4] <- data.frame(which(castle == "\U1F9DB", arr.ind = T), rep("\U1F9DB", nrow(which(castle =="\U1F9DB", arr.ind = T))))
  
  #Adding hp for each each monster to dataframe
  #Initial hp ranges from 5:10
  base_hp_vector <- 5:10
  for(floor in 1:max_floors){
    length <- nrow(castle_dataframe[castle_dataframe$z == floor & castle_dataframe$object %in% c("\U1F479","\U1F9DB"),])
    castle_dataframe[castle_dataframe$z == floor & castle_dataframe$object %in% c("\U1F479","\U1F9DB"),"hp"] <- sample(base_hp_vector,length, replace = T)
    #Monsters on each floor will receive a plus 10 hp boost
    base_hp_vector <- base_hp_vector + 10
  }
  #Win money is 1/2 times the original hp
  castle_dataframe[castle_dataframe$object %in% c("\U1F479","\U1F9DB"),"win_money"] <- castle_dataframe[castle_dataframe$object %in% c("\U1F479","\U1F9DB"),"hp"]*0.5
  
  
  #Adding fairy,genie coordinate information to the dataframe
  castle_dataframe[(castle_dataframe_rows + nrow(which(castle == "\U1F9DA", arr.ind = T))),] <- NA
  castle_dataframe[(castle_dataframe_rows + 1):(castle_dataframe_rows <- nrow(castle_dataframe)),1:5] <- data.frame(which(castle == "\U1F9DA", arr.ind = T), rep("\U1F9DA", nrow(which(castle =="\U1F9DA", arr.ind = T))),
                                                                                                                    rep(1,nrow(which(castle=="\U1F9DA", arr.ind = T)))
  )
  
  castle_dataframe[(castle_dataframe_rows  + nrow(which(castle == "\U1F9DE", arr.ind = T))),] <- NA
  castle_dataframe[(castle_dataframe_rows + 1):(castle_dataframe_rows <- nrow(castle_dataframe)),1:5] <- data.frame(which(castle == "\U1F9DE", arr.ind = T), rep("\U1F9DE", nrow(which(castle =="\U1F9DE", arr.ind = T))),
                                                                                                                    rep(1,nrow(which(castle=="\U1F9DE", arr.ind = T)))
  )
  
  
  #Spawning doors at coordinates that are objects
  for(coordinate in 1:nrow(castle_dataframe)){
    x <- unlist(castle_dataframe[coordinate,1:3])
    castle[x[1],x[2],x[3]] <- "\U1F6AA"
  }
  
  #Return information
  castle_and_dataframe <- list("castle" = castle,"dataframe" = castle_dataframe,"castle_length" = castle_length)
  return(castle_and_dataframe)
}