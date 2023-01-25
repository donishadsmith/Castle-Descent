#Create local environment
castle_descent <- new.env(parent = globalenv())
#source files to local environment
for(castle_descent_file in dir(recursive = T)[!dir(recursive = T) %in% c("game_scripts/create_environment.R", "start_game.R")]){
    source(castle_descent_file, local = castle_descent)
  
}
#Remove variables from global environment
rm(castle_descent_file)
castle_descent$start_game()


