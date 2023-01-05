def new_line(num):
    for _ in range(num):
        print('\n')
        
def viewer(arr): 
    print('\n'.join([''.join(['{:^{}}'.format(cell, 5) for cell in row]) for row in arr]))    
   # if not np.where(arr == '\U0001F93A')[0] == '':
        #player_y = np.where(arr == '\U0001F93A')[1][0]
        #new_col = np.array(['' for _ in range(arr.shape[1])]).T
        #new_arr =  np.insert(arr, player_y - 1, new_col, axis=1)
        #print('\n'.join([''.join(['{:^{}}'.format(cell, 5) for cell in row]) for row in new_arr]))
    
    #else:
         
    
