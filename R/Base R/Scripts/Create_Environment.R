#Create local environment
castle_descent <- new.env(parent = globalenv())
#List files in folder
castle_descent_files <- c("Castle_Create.R", "Events.R", "Classes.R",
           "Inventory.R", "Menu_Cursor.R","Merchant.R", "Display.R","Item_Descriptions.R"
           ,"Main_Loop.R")
#source files to local environment
for(castle_descent_file in castle_descent_files){
  source(castle_descent_file, local = castle_descent)
}
#Save environment
saveRDS(castle_descent,file = "Castle_Descent_Base_R.rds")
#Remove variables from global environment
rm(castle_descent_file,castle_descent_files,castle_descent)