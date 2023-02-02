# Castle Descent 

This repository for a R/Python Unicode text-based/rouguelike game that I created. This project is ongoing and new features and refinements will be made in the future. 

The objective is to descend to the bottom of a randomly generated castle (represented as a 3D Array) while avoiding a zombie. To do so, you need to interact with the doors and defeat all monsters on the floor to reveal the door to the next level/exit. These doors may contain monsters, genies (which increase your attack or reduce the cost of mana for your enhanced attack, or faries (which heals you). Deafeating monsters earns you money and random item drops. Money can be used to purchase items, which may assist you through the game, from the merhcant.

## Technologies Used

[![RStudio Community: RStudio IDE](https://img.shields.io/endpoint?url=https%3A%2F%2Frstudio.github.io%2Frstudio-shields%2Fcategory%2Frstudio-ide.json)](https://community.rstudio.com/c/rstudio-ide)
[![Python 3.10](https://img.shields.io/badge/python-3.10-blue.svg)](https://www.python.org/downloads/release/python-3100/)

## Starting Game

#### Python:

```python
python3.10 start_game.py
```
#### RStudio:

Open `start_game.R` in **RStudio** and run the file. Ensure that your current working directory is set to the same directory where `start_game.R` is located.

To do this:

1) Ensure that `start_game.R` is open in the source editor (top left).
![Screenshot (6)](https://user-images.githubusercontent.com/112973674/216412613-58adf35a-0e34-4bfe-87b7-eb87fb9e7806.png)

2) Go to: *Session -> Set Working Directory -> To Source File Location* (or *To File Pane Location* if the directory containing `start_game.R` is in the File Pane (bottom right).
![Screenshot (7)](https://user-images.githubusercontent.com/112973674/216412677-5743579c-9a5b-4417-ac3e-f200f07b6428.png)

3) Highlight ```R source("game_scripts/create_environment.R")```

4) Click *Run*.


