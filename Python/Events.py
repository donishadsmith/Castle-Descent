import random, copy, time, msvcrt
from Display import *
from Inventory import *
from Menu_Cursor import cursor
#Functions for various events
def fairy_event(castle, player, castle_info):
    castle[player.movement_coordinate] = player.encountered_object
    display_array(castle = castle, game_sequence = 'non-battle', player = player)
    print('You encountered a fairy!')
    new_line(1)
    if all([player.hp == 100, player.mana == 100]):
        print('Your HP and mana are already full. Come back later.')
        time.sleep(1.5)
    else:
        if player.hp == 100 & player.mana < 100:
            print('Your mana was fully restored!')
            player.mana = 100
        elif player.hp < 100 & player.mana == 100:
            print('Your HP was fully restored!')
            player.hp = 100
        else:
            player.mana = 100
            player.hp = 100
        #Changing dictionary number to zero to prevent this event from activating again
        castle_info[player.movement_coordinate][1] = 0
    time.sleep(1)
    #Adding back door
    castle[player.movement_coordinate] = u'\U0001f6aa'
    return castle, player, castle_info
    
def genie_event(castle, player, castle_info):
    castle[player.movement_coordinate] = player.encountered_object
    display_array(castle = castle, game_sequence = 'non-battle', player = player)
    print('You encountered a genie!')
    player_choice = ''
    player_action = ''
    cursor.position = 0
    if "Reduce Mana Cost" in player.menus['genie']:
        while not player_action == 's':
            cursor.position = np.where(player.menus['battle'] == u'\u2771' )[0][0]
            display_array(castle = castle, game_sequence = 'non-battle', player = player)
            new_line(1)   
            print('___________________________________________')
            new_line(1)
            print(''.join(['{}'.format(cell + ' ') for cell in player.menus['genie']])) 
            new_line(1)
            print('___________________________________________')
            new_line(1)
            while not player_action in ['a','d','s']:
                print('a(left), d(right), s(select): ')
                player_action = msvcrt.getch().decode('utf-8').lower()
            if player_action in ['a','d']:
                player = cursor.move_cursor(object = player, player_action = player_action, game_sequence = 'genie')
                player_action = ''
            else:
                player_choice = player.menus['genie'][cursor.position + 1]
    else:
        player_choice = 'Increase Attack'
    display_array(castle = castle, game_sequence = 'non-battle', player = player)
    if player_choice == 'Increase Attack':
        attack_increase = random.sample([num for num in range(1,6)],1)[0]
        print(f'Your Attack range and Enhanced Attack range increased by {attack_increase} points.')
        new_line(1)
        player.attack_range = list(map(lambda a: a + attack_increase, player.attack_range))
        player.enhanced_attack_range = list(map(lambda a: a + attack_increase, player.enhanced_attack_range))
        print(f'New Attack range: {min(player.attack_range)}:{max(player.attack_range)}')
        new_line(1)
        print(f'New Enhanced Attack range: {min(player.enhanced_attack_range)}:{max(player.enhanced_attack_range)}')
    elif player_choice == "Reduce Mana Cost":
        decrease_mana_cost = random.sample([num for num in range(1,6)],1)[0]
        player.mana_cost -= decrease_mana_cost
        if player.mana_cost < 1:
            player.mana_cost = 1
            player.menus['genie'] = player.menus['genie'][0:2]
        player.menus['battle'][3] = f'Enhanced Attack({player.mana_cost} mana)'
        print(f'Your Enhanced Attack now costs {player.mana_cost} mana.')
    
    #Changing dictionary number to zero to prevent this event from activating again
    castle_info[player.movement_coordinate][1] = 0
    time.sleep(1)
    #Adding back door
    castle[player.movement_coordinate] = u'\U0001f6aa'
    player.menus['genie'][cursor.position] = ''
    player.menus['genie'][0] = u'\u2771' 
    time.sleep(1)
    return castle, player, castle_info

def monster_event(castle,player,castle_info):
    castle[player.movement_coordinate] = player.encountered_object
    monster_hp = copy.deepcopy(castle_info[player.movement_coordinate][1])
    display_array(castle = castle, game_sequence = 'battle', player = player, monster_hp = monster_hp)    
    print('You encountered a monster.')
    player_action = ''
    player_choice = ''
    cursor.position = 0
    #Monster event loops until player or monster dies or player chooses to flee
    while not any([player_choice == 'Run',player.hp == 0,monster_hp == 0]):
        while not player_action == 's':
                cursor.position = np.where(player.menus['battle'] == u'\u2771' )[0][0]
                display_array(castle = castle, game_sequence = 'battle', player = player, monster_hp = monster_hp)    
                print('_______________________________________________________________________')
                new_line(1)
                print(''.join(['{}'.format(cell + '  ') for cell in player.menus['battle']])) 
                new_line(1)
                print('_______________________________________________________________________')
                new_line(1)
                while not player_action in ['a','d','s']:
                    print('a(left), d(right), s(select): ')
                    player_action = msvcrt.getch().decode('utf-8').lower()
                if player_action in ['a','d']:
                    player = cursor.move_cursor(object = player, player_action = player_action, game_sequence = 'battle')
                    player_action = ''
                else:
                    player_choice = player.menus['battle'][cursor.position + 1]
                    if not player_choice in ['Attack','Run','Inventory']:
                        if player.mana < player.mana_cost:
                            display_array(castle = castle, game_sequence = 'battle', player = player)    
                            print('___________________________________________')
                            print(''.join(['{}'.format(cell + ' ') for cell in player.menus['battle']])) 
                            print('___________________________________________')
                            print('You do not have sufficient mana.')
                            player_action = ''
        if not player_choice in ['Run', 'Inventory']:
            player, monster_hp = battle_sequence(castle = castle, player = player , monster_hp = monster_hp, castle_info = castle_info, player_choice = player_choice)
        elif player_choice == 'Inventory':
            player = inventory(player = player, game_sequence = 'battle')
        player_action = ''

    castle[player.movement_coordinate] = u'\U0001f6aa'
    castle_info[player.movement_coordinate][1] = copy.deepcopy(monster_hp)
    player.menus['battle'][cursor.position] = ''
    player.menus['battle'][0] = u'\u2771' 

    return castle,player,castle_info         
            
def battle_sequence(castle, player, monster_hp, castle_info, player_choice):
    display_array(castle = castle, game_sequence = 'battle', player = player, monster_hp = monster_hp)   
    if player_choice == 'Attack':
        player_attack_power = random.sample(player.attack_range,1)[0]
    else:
        player_attack_power = random.sample(player.enhanced_attack_range,1)[0]
        player.mana -= player.mana_cost
    monster_hp -= player_attack_power
    print(f'You dealt {player_attack_power} points of damage.')
    new_line(1)
    if monster_hp > 0 :
        monster_attack_power = random.sample([num for num in range(1,6)],1)[0]
        player.hp -= monster_attack_power
        print(f'Monster dealt {monster_attack_power} points of damage.')
        if player.hp <= 0:
            new_line(1)
            player.hp = 0
            print('You died.')
        
    else:
        monster_hp = 0
        win_money = castle_info[player.movement_coordinate][2]
        player.money += win_money
        random_drop = random.choices([[item for item in player.hidden_item_inventory.keys()] + ['']][0],weights = [0.125,0.125,0.025,0.125,0.60])[0]
        if random_drop != '':
            player.hidden_item_inventory[random_drop] += 1
            if not random_drop in player.observable_item_inventory:
                 free_space = [space for space in range(1,8,2) if player.observable_item_inventory[space] == ''][0]
                 player.observable_item_inventory[free_space] = copy.deepcopy(random_drop)
            prompt = f'Money: {win_money}\n\nItem Drop: {random_drop}'
        else:
            prompt = f'Money: {win_money}'
        
        print('The monster fainted. You won!')
        new_line(1)
        print(prompt)

        if player.monster_threshold > 0:
            player.monster_threshold -= 1
        
    
    time.sleep(1.5)
    return player, monster_hp
                    
def upstairs_event(castle,player):    
    display_array(castle = castle, game_sequence = 'non-battle', player = player)
    print('You already came from upstairs.')
    time.sleep(1)

 
 
   
    
