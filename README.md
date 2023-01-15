# Castle-Descent
Repository for a R/Python Unicode text-based/rouguelike game that I created. This project is ongoing and new features will be added in the future when I have time. 

Note: Both versions are playable, I am working on refining and debugging code. I'm also working on a better way to display the python array. The R folder contains three seperate versions of the same game. The differences pertain to how the player's input is handled. The "Base R" can be used with base terminal/console R, no additional packages are needed. The "Terminal Version" needs the keypress package, which prevents the player from having to press enter after each input. The "R Studio" version uses R Studio's Application Programming Interface (API) to get the player's input without having to press enter. To run the Base and terminal versions of the R version, go to the folder and type 'Rscript Game.R' in the Terminal, if you have R installed. I also tried to match the R and Python code as best as I can, mostly to make it easier to change things in both languages if I need to since the structure is the same.


The objective is to descend to the bottom of a randomly generated castle (represented as a 3D Array) while avoiding a zombie. The doors may contain a genie, which increases your attack range, a fairy that heals you, a monster, or the staircase/exit to the next level. Defeating 60% of the monsters on each level will reveal the stairs/exit. 

The zombie will always be spawned on the grid that is the maximum Chebyshev distance from the player for each new floor.
Additionally, the zombie uses pathfinding, to minimize the distance to the player predicted position or current position depending on its distance from the player (using Chebyshev distance). Predicted position is calculated using player's velocity and acceleration. The velocity calculation is displacement/(player's reaction time + game update time). This is done to create more interesting movement. The zombie can move in 8 directions while the player is restricted to 4 movements (north, west, east, south). You play mainly using the wasd keys. The array wraps around only for the player so that you can spawn on the opposite side of the array if you go out of bounds. You can also use the doors to hide from the zombie if they are empty. If you encounter a fairy or genie or defeat a monster, then you can use can freely move through those empty doors, which is something that the zombie cannot do. 

<img width="354" alt="Screenshot 2023-01-07 at 2 27 05 AM" src="https://user-images.githubusercontent.com/112973674/211139376-80874eee-27ee-4718-bfcd-2cfda453f45c.png">
<img width="357" alt="Screenshot 2023-01-07 at 2 26 32 AM" src="https://user-images.githubusercontent.com/112973674/211139377-45876a06-c237-4ae5-8119-0daa9c43b5af.png">
<img width="350" alt="Screenshot 2023-01-07 at 2 26 44 AM" src="https://user-images.githubusercontent.com/112973674/211139378-9517cdfc-df45-49d0-a6fa-6bc7a3299f2e.png">
<img width="351" alt="Screenshot 2023-01-07 at 2 26 58 AM" src="https://user-images.githubusercontent.com/112973674/211139380-6a1ddf93-900a-4187-a92a-c366800cb405.png">
<img width="502" alt="Screenshot 2023-01-07 at 2 26 14 AM" src="https://user-images.githubusercontent.com/112973674/211139381-cae3ab08-dd66-400b-8168-cfb29f344ca3.png">

Added new feature - inventory for 3 new items. Currently working on adding this feature to the python version. The inventory matrix wraps around just like the castle array. So going out of bounds will spawn the cursor on the opposite side. 

<img width="371" alt="Screenshot 2023-01-07 at 2 17 53 AM" src="https://user-images.githubusercontent.com/112973674/211139057-e7da69cc-8c44-4892-9c70-02f4f1d4644c.png">
<img width="369" alt="Screenshot 2023-01-07 at 1 10 40 AM" src="https://user-images.githubusercontent.com/112973674/211138746-600aa86b-453a-4f88-b6bb-eb9545b4ab20.png">
<img width="373" alt="Screenshot 2023-01-07 at 1 10 47 AM" src="https://user-images.githubusercontent.com/112973674/211138749-410b3427-d931-4dbf-9126-0183fa0ec3bd.png">



