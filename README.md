# Castle-Descent
Repository for a R/Python text-based adventure game that I created.

The objective is to descent to the bottom of a randomly generated castle (represented as a 3D Array) while avoiding a zombie. 
The zombie will always be spawned on the grid that is the maximum Euclidean distance from the player for each new floor.
Additionally, the zombie uses pathfinding to minimize the distance to the player and can move in 8 directions while the player can only move in 4 directions.
For fairness, the zombie is restricted to move around 30% of the time.

Sample screenshots from the R (Terminal Version) of the game:
![image](https://user-images.githubusercontent.com/112973674/209449640-7447d1d5-b460-4b13-be50-c48fda0ab179.png)

![image](https://user-images.githubusercontent.com/112973674/209449648-c4790936-c6f9-4bd2-9b34-5ff2b9a3a7b4.png)

![image](https://user-images.githubusercontent.com/112973674/209449653-6c1c5df1-931b-425e-857d-3e29c170df0e.png)
