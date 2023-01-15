#For checking width of unicode characters
import wcwidth
def new_line(num):
    for _ in range(num):
        print('\n')
        
def display_array(arr): 
    print('\n'.join(['  '.join(['{:^{}}'.format(cell,wcwidth.wcwidth(u'\U0001f6aa')) if cell == '' else cell for cell in row]) for row in arr]))      
    #print('\n'.join(['  '.join(['{:^{}}'.format(cell,wcwidth.wcwidth(u'\U0001f6aa')) if cell in ['','\U0001F93A',u'\U0001F9DF'] else cell for cell in row]) for row in arr]))      

         
    
