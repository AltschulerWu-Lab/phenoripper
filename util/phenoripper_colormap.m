function colors=Color_Brewer(number_of_colors)

if(number_of_colors<13 && number_of_colors>2)
    load('color_data.mat');
    colors=color_brewer{number_of_colors}./256;
else
   colors=jet(number_of_colors); 
end

end