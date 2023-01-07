# Castle-Descent
Repository for a R/Python Unicode text-based/rouguelike game that I created. This project is ongoing and new features will be added in the future when I have time. 

Note: Both versions are playable, I am working on refining and debugging code. I'm also working on a better way to display the python array. The R folder contains three seperate versions of the same game. The differences pertain to how the player's input is handled. The "Base R" can be used with base terminal/console R, no additional packages are needed. The "Terminal Version" needs the keypress package, which prevents the player from having to press enter after each input. The "R Studio" version uses R Studio's Application Programming Interface (API) to get the player's input without having to press enter. To run the Base and terminal versions of the R version, go to the folder and type 'Rscript Game.R' in the Terminal, if you have R installed. I also tried to match the R and Python code as best as I can, mostly to make it easier to change things in both languages if I need to since the structure is the same.


The objective is to descend to the bottom of a randomly generated castle (represented as a 3D Array) while avoiding a zombie. The doors may contain a genie, which increases your attack range, a fairy that heals you, a monster, or the staircase/exit to the next level. Defeating 60% of the monsters on each level will reveal the stairs/exit. 

The zombie will always be spawned on the grid that is the maximum Chebyshev distance from the player for each new floor.
Additionally, the zombie uses pathfinding, to minimize the distance to the player predicted position or current position depending on its distance from the player (using Chebyshev distance). Predicted position is calculated using player's velocity and acceleration. The velocity calculation is displacement/(player's reaction time + game update time). This is done to create more interesting movement. The zombie can move in 8 directions while the player is restricted to 4 movements (north, west, east, south). You play mainly using the wasd keys. The array wraps around only for the player so that you can spawn on the opposite side of the array if you go out of bounds. You can also use the doors to hide from the zombie if they are empty. If you encounter a fairy or genie or defeat a monster, then you can use can freely move through those empty doors, which is something that the zombie cannot do. 

<img width="354" alt="Screenshot 2022-12-30 at 9 51 10 PM" src="https://user-images.githubusercontent.com/112973674/210123653-0453060b-4986-4e50-9c35-4356fb41516a.png">
<img width="356" alt="Screenshot 2022-12-30 at 9 49 47 PM" src="https://user-images.githubusercontent.com/112973674/210123650-a886a76a-521c-46bc-bfdc-ad5e0c4d4cc8.png">
<img width="358" alt="Screenshot 2022-12-30 at 9 46 11 PM" src="https://user-images.githubusercontent.com/112973674/210123651-7c976a53-a25f-48bb-a64a-b1ae338de265.png">
<img width="363" alt="Screenshot 2022-12-30 at 9 47 46 PM" src="https://user-images.githubusercontent.com/112973674/210123652-c1020690-b7ea-4c31-b400-7dcac0211afb.png">
<img width="359" alt="Screenshot 2022-12-30 at 9 44 43 PM" src="https://user-images.githubusercontent.com/112973674/210123649-25cc557b-6634-4d24-acd3-8b67676b441f.png">

Added new feature - inventory for 3 new items (available in the R version only for now). Currently working on adding this feature to the python version. 

<img width="369" alt="Screenshot 2023-01-07 at 1 10 40 AM" src="https://user-images.githubusercontent.com/112973674/211138746-600aa86b-453a-4f88-b6bb-eb9545b4ab20.png">
<img width="373" alt="Screenshot 2023-01-07 at 1 10 47 AM" src="https://user-images.githubusercontent.com/112973674/211138749-410b3427-d931-4dbf-9126-0183fa0ec3bd.png">
<img width="369" alt="Screenshot 2023-01-07 at 1 12 32 AM" src="https://user-images.githubusercontent.com/112973674/211138750-74f83dd0-d052-41b5-854d-c7b8076e00f4.png">


