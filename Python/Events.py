import random, copy, time
from Display import *

#Functions for various events
def fairy_event(castle, player, castle_info):
    new_line(20)
    print('You encountered a fairy!\nYour health increases by 10 HP.')
    print(f'Floor {player.floor + 1} of {len(castle)}')
    castle[player.movement_coordinate] = player.encountered_object
    #Changing dictionary number to zero to prevent this event from activating again
    castle_info[player.movement_coordinate][1] = 0
    viewer(castle[player.floor])
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
    viewer(castle[player.floor])
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
    viewer(castle[player.floor])
    print(f'Floor {player.floor + 1} of {len(castle)}\nYou encountered a monster!\nYour HP: {player.hp}')
    monster_hp = copy.deepcopy(castle_info[player.movement_coordinate][1])
    print(f'Monster HP: {monster_hp}')
    
    player_action = ''
    #Monster event loops until player or monster dies or player chooses to flee
    while not any([player_action in ['r','run'],player.hp == 0,monster_hp == 0]):
        new_line(20)
        print(f'Floor {player.floor + 1} of {len(castle)}')
        viewer(castle[player.floor])
        while not player_action in ['a','r']:
            player_action = input('Attack (a) or run (r): ').lower()
        if player_action  == 'a':
           #Seperate function for combat so that this function is not too long
           player, monster_hp = monster_combat_event(player = player , monster_hp = monster_hp)
                
        #Display new monster and player hp
        new_line(1)
        print(f'Your HP: {player.hp}')        
        print(f'Monster HP: {monster_hp}')       
                
            
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
    
    return player, monster_hp
                    
def upstairs_event(castle,player):
    new_line(20)
    print(f'You already came from upstairs\nFloor {player.floor + 1} of {len(castle)}')
    viewer(castle[player.floor])
    
    
def inventory_event(castle, player, castle_info, player_action):
    #Event determined by player action, if player action is 'i'
    #player wants to look in inventor
    # if player_action in wasd, player found the door/coordinate coresponding to crystal ball
    if not player_action == 'i':
        #Event when a crystal ball is found
        new_line(20)
        print('You found a crystal ball! The crystal ball is in your inventory.' )
        print(f'Floor {player.floor + 1} of {len(castle)}')
        castle[player.movement_coordinate] = player.encountered_object
        castle_info[player.movement_coordinate][1] = 0
        viewer(castle[player.floor])
        player.inventory[u'\U0001F52E'] += 1
        print(player.inventory)
        castle[player.movement_coordinate] = u'\U0001f6aa'
        
    else:
        #Event when player looks in inventory - depends on whether or not player has a crystal ball in their inventory
        print(player.inventory)
        if player.inventory[u'\U0001F52E'] == 0:    
            print('You have nothing in your inventory')
        
        else:
            crystal_ball_stock = player.inventory[u'\U0001F52E']
            if  crystal_ball_stock == 1:
                prompt = 'ball'
            else:
                prompt = 'balls'
                 
            print(f'You have {crystal_ball_stock} crystal {prompt} in your inventory.')
            new_line(1)
            player_action = ''
            while not player_action in ['s','l']:
                player_action = input('Temporarily halt zombie movement(s) or leave your inventory (l): ').lower()
            #If player uses the ball, the zombie stocks moving for a randomly sampled number of steps
            if player_action  == 's':
                player.zombie_halt  = random.sample([num for num in range (10,21)],1)[0]
                player.inventory[u'\U0001F52E'] -= 1
            
    time.sleep(2)      
    return castle, player, castle_info