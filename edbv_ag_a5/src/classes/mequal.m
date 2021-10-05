function [n] = mequal(inputImage)

numbers= {imread('../assets/levels/0.png'),imread('../assets/levels/1.png'),imread('../assets/levels/2.png'),imread('../assets/levels/3.png'),imread('../assets/levels/4.png'),imread('../assets/levels/5.png'),imread('../assets/levels/6.png'),imread('../assets/levels/7.png'),imread('../assets/levels/8.png'),imread('../assets/levels/9.png')};

%Loop for all ten images from 0 to 9.
for n = 1 : 10
    number=numbers{n};
    %if digit is 1 Imagesize is different.
    if(size(inputImage,2)==3)
        n=1;
        return 
    end    
    
    % Determin if there is a difference between
    % InputImage and Template Digit.
    for  c = 0 : 1
        %rows
        for i = 1 : 7
            %columns
            for j = 1 : 4
                 %Checks if pixel of input and template match
                 if(inputImage(i,j) - number(i,j)~= 0)                   
                     %If Pixel doesn't match c++
                     c=c+1;                    
                end                
            end
        end
        
        % if c stays zero template is a match.
        if c==0 
            % n equals the matched digit. 
            n=n-1
            return;
        end
    end
    
end
return;
end


