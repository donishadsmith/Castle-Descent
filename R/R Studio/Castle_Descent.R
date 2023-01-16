#Create local environment
castle_descent_env <- new.env(parent = globalenv())
#List files in folder
castle_descent_files <- c("API.R", "Castle_Create.R", "Events.R", "Classes.R",
           "Inventory.R", "Menu_Cursor.R","Merchant.R", "Display.R","Item_Descriptions.R"
           ,"Start_Game.R")
#source files to local environment
for(castle_descent_file in castle_descent_files){
  source(castle_descent_file, local = castle_descent_env)
}
#Remove variables from global environment
rm(castle_descent_file,castle_descent_files)
#Activate game
castle_descent_env$start_game()
