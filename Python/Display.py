def new_line(num):
    for _ in range(num):
        print('\n')
        
def viewer(arr): 
    print('\n'.join([''.join(['{:^{}}'.format(cell, 5) for cell in row]) for row in arr]))    

         
    
