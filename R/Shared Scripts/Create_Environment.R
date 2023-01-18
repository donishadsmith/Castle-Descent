#Run this script to play the game
castle_descent <- new.env(parent = globalenv())
#source files to local environment
for(shared_file in dir()){
  if(!shared_file %in% c("Create_Environment.R","castle_descent.rds")){
    source(shared_file, local = castle_descent)
  }
}
#Save environment
saveRDS(castle_descent, file = "castle_descent.rds")

