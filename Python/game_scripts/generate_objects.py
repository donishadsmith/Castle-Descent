import numpy as np

def generate_objects(player_class, zombie_class, merchant_class, castle, castle_info, player_controller, zombie_movement):
    #Add values to player and zombie attributes
    player = player_class(hp = 100,
                          mana = 100,
                          money = 0,
                          hidden_item_inventory = dict({
                              u'\U0001F52E': 0,
                              u'\U0001F371': 0,
                              u'\U0001F50E': 0,
                              u'\U0001F9EA': 0,
                          }),
                          mana_cost = 20,
                          observable_item_inventory = np.array(np.zeros(shape = 8),dtype = 'U1'),
                          menus = {'battle': np.array(np.zeros(shape = 8),dtype = 'object'),
                                    'genie' : np.array(np.zeros(shape = 4),dtype = 'object')},
                          zombie_halt = 0,
                          attack_range = [num for num in range(5,11)],
                          enhanced_attack_range = [num for num in range(20,25)],
                          floor = 0, 
                          controller = player_controller,
                          current_coordinate = list(zip(*np.where(castle == '\U0001F93A')))[0],
                          total_floors = len(castle),
                          #For velocity and acceleration, there is code in Classes.py
                          #to get the correct dimension
                          max_velocity = 0,
                          previous_velocity = 0,
                          previous_game_update_time = 0,
                          acceleration = 0,
                          total_monsters =  [floor[0] for floor in [(key[0],object[0]) for key,object in castle_info.items() if object[0] in [u'\U0001f479',u'\U0001F9DB',u'\U0001F409']]])
    #Add cursor to observable inventory and menus
    player.observable_item_inventory[:] = ''
    player.observable_item_inventory[0] = u'\u2771' 
    for menu in player.menus.keys():
        player.menus[menu][:] = ''
        player.menus[menu][0] = u'\u2771' 
    #Add words to player menus
    player.menus['battle'][list(range(1,len(player.menus['battle']),2))] = ['Attack', f'Enchanced Attack({player.mana_cost} mana)', 'Inventory', 'Run']
    player.menus['genie'][list(range(1,len(player.menus['genie']),2))] = ['Increase Attack', 'Reduce Mana Cost']
    #Calculate the number of monsters needed to be defeated
    player.monster_threshold = int(len([floor for floor in player.total_monsters if floor == player.floor])*0.60)
    #Get zombie coordinate
    zombie = zombie_class(current_coordinate = list(zip(*np.where(castle == u'\U0001F9DF')))[0],
                        controller = zombie_movement)
    #Calculate initial distance between zombie and player
    zombie.distance_to_player = zombie.chebyshev_distance(zombie.current_coordinate, player.current_coordinate)
    #Create merchant
    merchant = merchant_class(item_costs={
                              u'\U0001F52E': 50,
                              u'\U0001F371': 10,
                              u'\U0001F50E': 500,
                              u'\U0001F9EA': 40,
                          },
                          shop_inventory=np.array(np.zeros(shape = 8), dtype = 'object'),
                          selection_menu=np.array(np.zeros(shape = 4), dtype = 'object'))
    merchant.shop_inventory[:] = ''
    merchant.shop_inventory[list(range(1,8,2))] = [u'\U0001F52E',u'\U0001F371',
    u'\U0001F50E',u'\U0001F9EA']
    merchant.shop_inventory[0] = u'\u2771'
    merchant.selection_menu[:] = ['Buy: ',u'\u2770',1,u'\u2771']
    return player, zombie, merchant
