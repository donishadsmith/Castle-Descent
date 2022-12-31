# Castle-Descent
Repository for a R/Python text-based adventure game that I created.

The objective is to descent to the bottom of a randomly generated castle (represented as a 3D Array) while avoiding a zombie. 
The zombie will always be spawned on the grid that is the maximum Euclidean distance from the player for each new floor.
Additionally, the zombie uses pathfinding to minimize the distance to the player and can move in 8 directions while the player can only move in 4 directions.
For fairness, the zombie is restricted to move around 30% of the time. The objects in this game are unicode.

<img width="359" alt="Screenshot 2022-12-30 at 9 44 43 PM" src="https://user-images.githubusercontent.com/112973674/210123631-116494ff-1dac-4ffc-8392-3899828cf9a3.png">
<img width="358" alt="Screenshot 2022-12-30 at 9 46 11 PM" src="https://user-images.githubusercontent.com/112973674/210123633-e351506f-eae0-4d1c-91de-d07c9893e7cf.png">
<img width="363" alt="Screenshot 2022-12-30 at 9 47 46 PM" src="https://user-images.githubusercontent.com/112973674/210123634-2694e344-31cc-4502-867c-b9cd8f7cc681.png">
<img width="354" alt="Screenshot 2022-12-30 at 9 51 10 PM" src="https://user-images.githubusercontent.com/112973674/210123635-d910655d-e18b-4145-990d-679aebeef852.png">
<img width="356" alt="Screenshot 2022-12-30 at 9 49 47 PM" src="https://user-images.githubusercontent.com/112973674/210123636-8bad58b8-6e32-4048-960b-47ce4db33526.png">
