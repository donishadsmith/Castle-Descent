#Create local environment
castle_descent <- new.env(parent = globalenv())
#source files to local environment
for(castle_descent_file in dir()){
  if(!castle_descent_file == ("Start_Game.R")){
    source(castle_descent_file, local = castle_descent)
  }
}
#Remove variables from global environment
rm(castle_descent_file)
castle_descent$start_game()

