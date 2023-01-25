upstairs_event <- function(castle_data,player){
  display_array(castle_data = castle_data,player = player,game_sequence = "non-battle")
  cat("You already came from upstairs.")
  new_line(2)
  upstairs_event_output <- c(castle_data,player)
  Sys.sleep(1)
  return(upstairs_event_output)
}