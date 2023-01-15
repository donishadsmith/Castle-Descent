#cursor class
import numpy as np
class inventory_cursor_class:
    def __init__(self,position,cursor_movement_dict):
        self.position = position
        self.cursor_movement_dict = cursor_movement_dict
        
    def move_cursor(self,player,player_action):
        self.position += self.cursor_movement_dict[player_action]
        player.observable_inventory[1,:] = ''
        #player.observable_inventory[list(zip(*np.where(player.observable_inventory == u'\u25B2')))[0]] = ''
        #First dimension will never change
        if self.position[1] in [-1,3]:
            if self.position[1] == -1:
                self.position[1] = 2
            else:
                self.position[1] = 0
        player.observable_inventory[tuple(self.position)] = u'\u25B2'
        return player
        
cursor = inventory_cursor_class(position = np.array((1,0)),
                                cursor_movement_dict = {'a': np.array((0,-1)),
                                                        'd': np.array((0,1))})
