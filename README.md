# Castle-Descent
Repository for a R/Python text-based adventure game that I created.

The objective is to descend to the bottom of a randomly generated castle (represented as a 3D Array) while avoiding a zombie. The doors may contain a genie, which increases your attack range, a fairy that heals you, a monster, or the staircase/exit to the next level. Defeating 60% of the monsters on each level will reveal the stairs/exit. 

The zombie will always be spawned on the grid that is the maximum Chebyshev distance from the player for each new floor.
Additionally, the zombie uses pathfinding, essentially the A* algorigthm with modifications, to minimize the distance to the player predicted position or current position depending on its distacne from the player. Predicted position is calculated using player's velocity and acceleration. The velocity calculation is displacement/(player's reaction time + game update time). This is done to create more interesting movement. The zombie can move in 8 directions while the player is restricted to 4 movements (north, west, east, south). You play mainly using the wasd keys. The array wraps arounf only for the player so that you can spawn on the opposite side of the array if you go out of bounds. You can also use the doors to hide from the zombie if they are empty. If you encounter a fairy or genie or defeat a monster, then you can use can freely move through those empty doors, which is something that the zombie cannot do. 

<img width="354" alt="Screenshot 2022-12-30 at 9 51 10 PM" src="https://user-images.githubusercontent.com/112973674/210123653-0453060b-4986-4e50-9c35-4356fb41516a.png">
<img width="356" alt="Screenshot 2022-12-30 at 9 49 47 PM" src="https://user-images.githubusercontent.com/112973674/210123650-a886a76a-521c-46bc-bfdc-ad5e0c4d4cc8.png">
<img width="358" alt="Screenshot 2022-12-30 at 9 46 11 PM" src="https://user-images.githubusercontent.com/112973674/210123651-7c976a53-a25f-48bb-a64a-b1ae338de265.png">
<img width="363" alt="Screenshot 2022-12-30 at 9 47 46 PM" src="https://user-images.githubusercontent.com/112973674/210123652-c1020690-b7ea-4c31-b400-7dcac0211afb.png">
<img width="359" alt="Screenshot 2022-12-30 at 9 44 43 PM" src="https://user-images.githubusercontent.com/112973674/210123649-25cc557b-6634-4d24-acd3-8b67676b441f.png">
