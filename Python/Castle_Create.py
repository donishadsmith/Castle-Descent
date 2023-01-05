import random, numpy as np
def castle_create():
    #x,y of castle
    castle_area = random.sample([num for num in range(9,15, 2)],1)[0]
    #z of castle
    castle_z_length = random.sample([num for num in range(3,7)],1)[0]
    #dtype = 'U1' so that numpy array can store unicode
    castle = np.array(np.zeros(shape = [castle_z_length, castle_area, castle_area]), dtype = 'U1')
    #From an array containing zeroes to an array of block unicode
    castle[:] = ''
    #Designating specfic areas for monster, genie, fairy, stairs, etc objects
    object_spawn_locations = [num for num in range(1,castle_area - 1,2)]
    for num in object_spawn_locations:
        castle[:,num,object_spawn_locations] = '1'
    #Spawn player by randomly sampling x,y coordinate from list
    free_space = random.sample(list(zip(*np.where(castle[0] == ''))),1)[0]
    castle[0][free_space] = '\U0001F93A' 
    #Spawn zombie at max euclidean distance
    #Get available coordinates
    player_coord = list(zip(*np.where(castle[0] == '\U0001F93A')))[0]
    available_coordinates =  list(zip(*np.where(castle[0] == '')))   
    max_chebyshev_distance = [max(abs(np.array(num) - np.array(player_coord))) for num in available_coordinates]
    castle[0][available_coordinates[max_chebyshev_distance.index(max(max_chebyshev_distance))]] =  u'\U0001F9DF'
    #Spawn objects
    #Spawn stairs and exit
    object_info = []
    for floor in range(0,(castle_z_length-1)):
        spawnable_coord = random.sample(list(zip(*np.where(castle[floor] == '1'))),1)[0]
        castle[floor][spawnable_coord] = 'D'
        castle[floor+1][spawnable_coord] = 'A'
        object_info.append([floor,spawnable_coord[0],spawnable_coord[1],'D',1])
        object_info.append([floor+1,spawnable_coord[0],spawnable_coord[1],'A',1])
        if floor == castle_z_length-2:
            spawnable_coord = random.sample(list(zip(*np.where(castle[floor+1] == '1'))),1)[0]
            castle[floor+1][spawnable_coord] = u'\u2395'
            object_info.append([floor+1,spawnable_coord[0],spawnable_coord[1],u'\u2395',1])

    
    #Spawn fairies and genies
    #Proportion og each floor that will contain fairies and genies
    proportion = int(round(len(castle[:][castle[:] == '1'])*0.05))
    for floor in range(0,castle_z_length):
        #Spawn fairies  
        fairy_coordinates = random.sample(list(zip(*np.where(castle[floor] == '1'))),proportion)
        for fairy_coordinate in fairy_coordinates:
            castle[floor][fairy_coordinate] = '\U0001f9da'
            object_info.append([floor,fairy_coordinate[0],fairy_coordinate[1],'\U0001f9da',1])
        #Spawn genies
        genie_coordinates = random.sample(list(zip(*np.where(castle[floor] == '1'))),proportion)
        for genie_coordinate in genie_coordinates:
            castle[floor][genie_coordinate] = u'\U0001F9DE'
            object_info.append([floor,genie_coordinate[0],genie_coordinate[1],u'\U0001F9DE',1])
        #Spawn Crystal Ball
        crystal_ball_coordinate = random.sample(list(zip(*np.where(castle[floor] == '1'))),1)[0]
        castle[floor][crystal_ball_coordinate] = u'\U0001F52E'
        object_info.append([floor,crystal_ball_coordinate[0],crystal_ball_coordinate[1],u'\U0001F52E',1])
    
    #Spawn monsters   
    base_hp_vector = [num for num in range(5,11)]
    iteration = 0   
    for floor in range(0,castle_z_length):
        castle[floor][castle[floor] == '1'] = u'\U0001f479'
        monster_coordinates = list(zip(*np.where(castle[floor] == u'\U0001f479')))
        if iteration > 0:
            base_hp_vector = [num + 5 for num in base_hp_vector]
        for monster_coordinate in monster_coordinates:
            hp = random.sample(base_hp_vector,1)[0]
            object_info.append([floor,monster_coordinate[0],monster_coordinate[1],u'\U0001f479',hp])
        iteration += 1

    #Put information in dictionary
    #Coordinates will be the keys and the unicode and and number will be the values
    #Values in a list to ensure that these values can be changes when they need to be
    castle_info = {}
    for obj in object_info:
        castle_info[(obj[0], obj[1], obj[2])] = [obj[3],obj[4]]       

    #Spawn doors
    for key in castle_info:
        castle[key] = u'\U0001f6aa'

        
    return castle,castle_info
