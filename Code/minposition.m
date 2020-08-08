function [ minimum,index ] = minposition( array )
   % Function: Calculate the minimum value and its position in matrix
  
      A      = size(array);             
      ndim   = length(A);           
      [minimum,I] = min(array(:));        
      remaining = 1;                          
      index = [];                             
      while remaining~=ndim+1                 
         r       = rem(I,A(remaining));
         int     = fix(I/A(remaining)); 
         if r == 0                          
             new_index   = A(remaining);
         else                               
             int         = int+1;
             new_index   = r;                    
         end
         I     = int;                       
         index = [index new_index];                 
         remaining = remaining + 1;
      end
  end