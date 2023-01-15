import random, copy, time, numpy as np
from Display import *
from Inventory import *
#Functions for various events
def fairy_event(castle, player, castle_info):
    new_line(20)
    print('You encountered a fairy!\nYour health increases by 10 HP.')
    print(f'Floor {player.floor + 1} of {len(castle)}')
    castle[player.movement_coordinate] = player.encountered_object
    #Changing dictionary number to zero to prevent this event from activating again
    castle_info[player.movement_coordinate][1] = 0
    display_array(castle[player.floor])
    player.hp += 10
    print(f'New HP: {player.hp}')
    time.sleep(1)
    #Adding back door
    castle[player.movement_coordinate] = u'\U0001f6aa'
    return castle, player, castle_info
    
def genie_event(castle, player, castle_info):
    new_line(20)
    print('You encountered a genie!\nYour attack range increased by 2 points.')
    castle[player.movement_coordinate] = player.encountered_object
    #Changing dictionary number to zero to prevent this event from activating again
    castle_info[player.movement_coordinate][1] = 0
    display_array(castle[player.floor])
    print(f'Floor {player.floor + 1} of {len(castle)}')
    player.attack_range = list(map(lambda a: a + 5, player.attack_range))
    print(f'New attack range: {min(player.attack_range)}:{max(player.attack_range)}')
    time.sleep(1)
    #Adding back door
    castle[player.movement_coordinate] = u'\U0001f6aa'
    return castle, player, castle_info

def monster_event(castle,player,castle_info):
    new_line(20)
    castle[player.movement_coordinate] = player.encountered_object
    display_array(castle[player.floor])
    print(f'Floor {player.floor + 1} of {len(castle)}\nYou encountered a monster!\nYour HP: {player.hp}')
    monster_hp = copy.deepcopy(castle_info[player.movement_coordinate][1])
    print(f'Monster HP: {monster_hp}')
    
    player_action = ''
    #Monster event loops until player or monster dies or player chooses to flee
    while not any([player_action == 'r',player.hp == 0,monster_hp == 0]):
        new_line(20)
        print(f'Floor {player.floor + 1} of {len(castle)}')
        display_array(castle[player.floor])
        while not player_action in ['a','r','i']:
            player_action = input('Attack (a), run (r), or check inventory(i): ').lower()
        if player_action  == 'a':
           #Seperate function for combat so that this function is not too long
           player, monster_hp = monster_combat_event(player = player , monster_hp = monster_hp)
        #Access inventory
        if player_action == 'i':
            player = inventory(player, sequence = 'battle')
            new_line(50)
            player_action = ''
               
            
    if player_action == 'r':
        print('You decided to run.')

    castle[player.movement_coordinate] = u'\U0001f6aa'
    castle_info[player.movement_coordinate][1] = copy.deepcopy(monster_hp)

    return castle,player,castle_info         
            
def monster_combat_event(player, monster_hp):
    print('You decided to attack')
    player_attack_power = random.sample(player.attack_range,1)[0]
    monster_hp -= player_attack_power
    print(f'You dealt {player_attack_power} points of damage.')
    
    if monster_hp <= 0:
        monster_hp = 0
        print('The monster fainted. You won!')
        if player.monster_threshold > 0:
            player.monster_threshold -= 1
        time.sleep(1)
        
    else:
        monster_attack_power = random.sample([num for num in range(1,6)],1)[0]
        player.hp -= monster_attack_power
        print(f'Monster dealt {monster_attack_power} points of damage.')
        if player.hp <= 0:
            player.hp = 0
            print('You died.')
    
    #Display new monster and player hp
    new_line(1)
    print(f'Your HP: {player.hp}')        
    print(f'Monster HP: {monster_hp}')  

    return player, monster_hp

def item_event(castle, player, castle_info):   
    new_line(20)
    match player.encountered_object:
            case u'\U0001F52E': 
                print('You found a crystal ball! The crystal ball is in your inventory.')
            case u'\U0001F371': 
                print('You found a bento box! The bento box is in your inventory.')
            case u'\U0001F50E':
                print('You found a magnifying glass! The magnifying glass is in your inventory.') 
    
    castle[player.movement_coordinate] = player.encountered_object
    #Changing dictionary number to zero to prevent this event from activating again
    castle_info[player.movement_coordinate][1] = 0
    print(f'Floor {player.floor + 1} of {len(castle)}') 
    display_array(castle[player.floor])
    player.hidden_inventory[player.encountered_object] += 1
    if not player.encountered_object in player.observable_inventory[0,:]:
         player.observable_inventory[0,np.where(player.observable_inventory[0,:] == '')[0][0]] = player.encountered_object
    display_array(player.observable_inventory)
    time.sleep(1)
    #Adding back door
    castle[player.movement_coordinate] = u'\U0001f6aa'
    return castle,player,castle_info
                    
def upstairs_event(castle,player):
    new_line(20)
    print(f'You already came from upstairs\nFloor {player.floor + 1} of {len(castle)}')
    display_array(castle[player.floor])
    time.sleep(1)

 
 
   
    
