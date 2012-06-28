function bd= bit_depth(max_value,standard_levels)

level=log2(max_value);

if(level>=max(standard_levels))
    bd=ceil(level);
    return;
else
    standard_levels=sort(standard_levels);
    i=1;
    while(level>standard_levels(i))
        i=i+1;
    end
    bd=standard_levels(i);
end
end
