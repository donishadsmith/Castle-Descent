import copy, random, time, numpy as np
from Display import *
from Inventory_Cursor import cursor 
def inventory(player,sequence):
    player_action = ''
    object = player.observable_inventory[0,0]
    while not player_action == 'e':
        new_line(50)
        print('Inventory\n')
        display_array(player.observable_inventory)
        new_line(1)
        match object:
            case u'\U0001F52E': 
                print('Crystal Ball')
                new_line(1)
                print('Temporarily halts zombie movement.')
            case u'\U0001F371': 
                print('Bento Box')
                new_line(1)
                print('Heals 20 hp.')                   
            case u'\U0001F50E':
                print('Magnifying Glass')
                new_line(1)
                print('Reveals the door leading to stairs or exit.')
            case _:
                print('???')

        if not object == '':     
            new_line(1)
            print(f'Number in inventory: {player.hidden_inventory[object]}')
            new_line(1)
        while not player_action in ['a','d','u','e']:
            player_action = input('a (left), d(right), u (use), e (exit inventory): ').lower()
        if player_action in ['a', 'd']:
            player = cursor.move_cursor(player, player_action)
            object_position = copy.deepcopy(cursor.position)
            object_position -= np.array((1,0))
            object = player.observable_inventory[tuple(object_position)]
            player_action = ''
        if player_action == 'u':
            if sequence == 'free movement' or sequence == 'battle' and object == u'\U0001F371':
                player = use_item(player,object)
                player.reset_inventory()
                player_action = ''
                object_position = copy.deepcopy(cursor.position)
                object_position -= np.array((1,0))
                object = player.observable_inventory[tuple(object_position)]
            else:
                if not object == '':
                    new_line(50)
                    print('Inventory\n')
                    display_array(player.observable_inventory)
                    new_line(1)
                    print('Cannot use this item during battle.')
                    player_action = ''
                    time.sleep(1) 
    #Erase cursor
    player.observable_inventory[1,:] = ''
    #Add back cursor
    player.observable_inventory[1,0] = '\u25B2'
    cursor.position = np.array((1,0))
    return player

def use_item(player, object):
    new_line(50)
    print('Inventory\n')
    display_array(player.observable_inventory)
    new_line(1)
    player.hidden_inventory[object] -= 1
    match object:
        case u'\U0001F52E': 
            player.zombie_halt = random.sample([num for num in range(10,21)],1)[0]
            print(f'Zombie halted for {player.zombie_halt} steps')
            print('Temporarily halts zombie movement.')
        case u'\U0001F371': 
            print('Your HP increased by 20 points.')
            player.hp += 20
            print(f'New HP: {player.hp}')                  
        case u'\U0001F50E':
            player.monster_threshold = 0
            print('The door has been revealed.')
    time.sleep(1) 
    return player