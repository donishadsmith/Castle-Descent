#Run this script to play the game
#Load environment
castle_descent <- readRDS("castle_descent.rds")
#Get files
castle_descent_files <- c("Merchant.R","Main_Loop.R","Inventory.R","Events.R")
#source files to local environment
for(castle_descent_file in castle_descent_files){
  source(castle_descent_file, local = castle_descent)
}
rm(castle_descent_file,castle_descent_files)
#Activate game
castle_descent$start_game()



