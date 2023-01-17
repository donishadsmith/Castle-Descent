#Run this script to play the game
castle_descent_files <- readLines("Castle_Descent_Files.txt")
castle_descent <- new.env(parent = globalenv())
#source files to local environment
for(castle_descent_file in castle_descent_files){
  source(castle_descent_file, local = castle_descent)
}
#Activate game
castle_descent$start_game()
