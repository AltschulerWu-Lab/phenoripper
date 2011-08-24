function cmap=DisplayColor2Cmap(display_colors)
    cmap=zeros(length(display_colors),3);
    for i=1:length(display_colors)
       switch display_colors{i}
        case {'b','B','Blue'},    cmap(i,:)= [0 0.51 0.84];%[0.2148    0.4922    0.7188];
        case {'g','G','Green'},   cmap(i,:)= [0.21 0.71 0.09];%[0.3008    0.6836    0.2891];
        case {'r','R','Red'},     cmap(i,:)=[1 0.2 0];%[0.8906    0.1016    0.1094];
        case {'k','K','Gray'},    cmap(i,:)=[0.5 0.5 0.5];
        case {'o','O','Orange'},  cmap(i,:)=[1 0.4 0];
        case {'y','Y','Yellow'},  cmap(i,:)=[1 1 0];
        case {'c','C','Cyan'},    cmap(i,:)=[0 1 1];
        case {'m','M','Magenta'}, cmap(i,:)=[1 0 1];
        case {'','-' ,'None'},    cmap(i,:)=[0 0 0];
       end
    end
    

end