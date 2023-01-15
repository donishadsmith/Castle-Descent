from Castle_Create import castle_create
#Get player and zombie classes
from Classes import * 
#Get all the game events
from Events import * 
#Get functions new_line(num) to add new lines and display_array() to print the game screen
from Display import *
#Player and zombie controllers. Player can move one unit in four directions, zombie can move 1 unit in 8 directions
from Controllers import *
from Inventory import inventory


#Used to determine the intro the player recieves depending on how many times the game is repeated
iteration = 0

#While loop of actual game
def castle_descent():
    global iteration
    #Get outputs from castle_create() function
    castle,castle_info = castle_create()
    #Add values to player and zombie attributes
    player = player_class(hp = 100,
                          hidden_inventory = dict({
                              u'\U0001F52E': 0,
                              u'\U0001F371': 0,
                              u'\U0001F50E': 0 
                          }),
                          zombie_halt = 0,
                          attack_range = [num for num in range(5,11)],
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
                          total_monsters =  [floor[0] for floor in [(key[0],object[0]) for key,object in castle_info.items() if object[0] == u'\U0001f479']])
    #Create observable inventory array
    inventory_array = np.array(np.zeros(shape = [2,3]),dtype = 'U1')
    inventory_array[:] = ''
    #Add cursor
    inventory_array[1,0] = u'\u25B2'
    player.observable_inventory = inventory_array
    #Calculate the number of monsters needed to be defeated
    player.monster_threshold = int(len([floor for floor in player.total_monsters if floor == player.floor])*0.60)
    #Get zombie coordinate
    zombie = zombie_class(current_coordinate = list(zip(*np.where(castle == u'\U0001F9DF')))[0],
                        controller = zombie_movement)
    #Calculate initial distance between zombie and player
    zombie.distance_to_player = zombie.chebyshev_distance(zombie.current_coordinate, player.current_coordinate)
    
    #Introduction changes depending on whether or not this is the first iteration of the session
    if iteration == 0:
        print('Welcome to Castle Descent!')
        time.sleep(1)
        print('The objective of the game is to descend the bottom of the castle while avoiding the zombie.')
        time.sleep(1)
        print('You will be starting at the top of the castle!')
        time.sleep(1)
    
    else:
        print('New game.')   
        time.sleep(1)      
    
    #While loop of the actual game
    #The loop is program if the player is eaten by the zombie, has their health droppped to 0, or finds the exit
    while not any([player.hp == 0, zombie.distance_to_player == 0, player.encountered_object != u'\u2395' and player.floor == player.total_floors]):
        new_line(20)
        #Print game screen and corresponding prompts
        object = ''
        #Current floor player is on
        print(f'Floor {player.floor + 1} of {len(castle)}')
        #Door revealed if player defeats certain number of monsters, this adds an incentive to defeat monsters 
        #instead of running
        if player.monster_threshold == 0:
            for key, object in castle_info.items():
                if key[0] == player.floor and object[0] in ['D',u'\u2395']:
                    coord = key
                    object = object[0]
            castle[coord] = u'\u2395'
        #Displays current floor/grid
        d = [x for x in player.hidden_inventory.keys()]
        test_dict = [[key,object] for key,object in castle_info.items() if all([key[0] == player.floor,object[0] in ['D',d[0], d[1], d[2],u'\u2395']])]
        print(test_dict)
        display_array(castle[player.floor])
        
        match object:
            case 'D': 
                print('The location of the stairs has been revealed!')
            case u'\u2395': 
                print('The location of the exit has been revealed!')
            case _:
                if player.monster_threshold > 1:
                    print(f'{player.monster_threshold} monsters required to be defeated  reveal the door.')  
                else:
                    print(f'{player.monster_threshold} monster required to be defeated  reveal the door.')

                
        #Information if player finds a crystal ball and uses the crystal ball in their inventory
        #To stop the zombie for 10 - 20 steps
        if player.zombie_halt > 0:
            print('')
            if player.zombie_halt == 1:
                print(f'{player.zombie_halt} step before zombie can move.')
            else:
                print(f'{player.zombie_halt} steps before zombie can move.')
          
        #Player input
        player_action = ''
        #Get approximate time of stimulus presention. The stimulus in the prompt
        player.stimulus_time = time.time()
        while not player_action in player_controller:
            player_action = input('w (up), a (left), s (down), d (right), or check inventory (i): ').lower()
        
        #Events are determined by encountered objects
        
        #If player acesses inventory, the object is the crystal ball
        if player_action == 'i':
            player.encountered_object = player.controller['i']
        #Else, the movement coordinate is updated and the dictionary is accessed, if the movement coordinate corresponds to the door
        else:
            #Get new movement coordinate and encountered object
            player.movement(player_action,castle,castle_info)
            

        #Event for movable spaces, empty doors, and the zombie
        if player.encountered_object  in  ['', u'\U0001f6aa',u'\U0001F9DF']:
             #If the current coordinate is the player, it is erased
                #Prevents door from being erased if player is hiding behind it
            if castle[player.current_coordinate] == '\U0001F93A':
                    castle[player.current_coordinate] = ''
                    
            if player.encountered_object  in  ['', u'\U0001f6aa']:
                #Update with new player unicode if new space is empty
                if player.encountered_object  == '':
                    castle[player.movement_coordinate] = '\U0001F93A' 
                
                #Get velocity and acceleration
                #Velocity and acceleration depends on player reaction time plus the it takes for the coordinate to update
                #This creates more interesting movement since reaction time is more variable than update time for the code
                player.current_game_update_time = time.time()
                player.calculate_player_velocity()     
                player.current_coordinate = tuple(player.movement_coordinate)
                
                #Update player coordinate
                player.current_coordinate = tuple(player.movement_coordinate)
                if player.zombie_halt == 0:
                    #Zombie pathfinder finds the shortest path to the player's predicted position
                    #Results in coordinates that are out of bounds but this is what causes the interesting movement
                    #Pathfinder locates the possible coordinate that is the shortest chebyshev distance to the predicted coordinate
                    #Zombie is only allowed to move into empty spaces or spaces containing the player
                    castle, player = zombie.pathfinder(castle = castle, player = player, castle_info = castle_info)  
                else:
                    #If the zombie is halted, every iteration reduces the number of steps by 1
                    player.zombie_halt -= 1
            #Events if player encounters empty door
            elif player.encountered_object == u'\U0001F9DF':
                player.current_coordinate = tuple(player.movement_coordinate)
                zombie.distance_to_player =  0
                
        else: 
            if not any([player.floor == player.total_floors, player.encountered_object == u'\u2395']):
                #If the encountered item is not 
                #Match case to relevent event function depending on encountered items   
                match player.encountered_object:
                    case '\U0001f9da':
                        castle,player,castle_info = fairy_event(castle,player,castle_info)
                    case u'\U0001F9DE':
                        castle,player,castle_info = genie_event(castle,player,castle_info)
                    case u'\U0001f479':
                        castle,player,castle_info = monster_event(castle,player,castle_info)
                    case 'D':
                        castle = player.move_to_next_floor_event(castle)
                        castle = zombie.move_to_next_floor(castle,player)
                    case u'\u2395':
                        if player.floor < player.total_floors:
                            castle = player.move_to_next_floor_event(castle)
                            castle = zombie.move_to_next_floor(castle,player)
                    case 'A':
                        upstairs_event(castle,player)
                    case 'item':
                        player.encountered_object = castle_info[player.movement_coordinate][0]
                        castle,player,castle_info = item_event(castle,player,castle_info)
                    case 'inventory':
                        player = inventory(player, sequence = 'free movement')
                    
    new_line(20) 
    #Events if loop is broken
    print(f'Floor {player.floor + 1} of {len(castle)}')   
    
    if zombie.distance_to_player == 0:
        prompt = 'You were eaten by the zombie'
    else:
        prompt = 'You found the exit!'
        castle[player.movement_coordinate] = u'\u2395'
        
    display_array(castle[player.floor])
    print(prompt)
    
    #Retry
    player_action = ''
    while not player_action in ['y','n']:
        player_action = input('Would you like to play a new game? Yes (y) or no (n)').lower()
    if player_action in ['yes','y']:
        castle_descent()   
    else:
        print('Thank you for playing Castle Descent!')
        
castle_descent()   