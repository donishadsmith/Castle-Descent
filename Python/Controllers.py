#Controllers for player and zombie
import numpy as np
player_controller = {
    'w': np.array((0,-1,0)),
    'a': np.array((0,0,-1)),
    's': np.array((0,1,0)),
    'd': np.array((0,0,1)),
}
#Zombie can move in 8 directions
zombie_movement = dict(player_controller)
zombie_movement.update({
    'diag_up_left'   : np.array((0,-1,-1)), 
    'diag_up_right'  : np.array((0,-1,1)),                                    
    'diag_down_left' : np.array((0,1,-1)), 
    'diag_down_right': np.array((0,1,1))   
})
player_controller.update({'i': 'inventory'})