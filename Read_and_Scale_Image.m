function img=Read_and_Scale_Image(filenames,marker_scales)
    
    if(length(filenames)>1)
        number_of_channels=length(filenames);
        info=imfinfo(filenames{1});
        xres=info.Height;
        yres=info.Width;
        channels_per_file=1;
    else 
        test=imread(filenames{1,1});
        xres=size(test,1);
        yres=size(test,2);
        number_of_channels=size(test,3);
        channels_per_file=number_of_channels;
    end
    img=zeros(xres,yres,number_of_channels);
    
    if(channels_per_file>1)
        img=double(imread(filenames{1}));
    else
        for channel_counter=1:number_of_channels
            img(:,:,channel_counter)=double(imread(filenames{channel_counter}));
        end
    end
    
    for channel=1:number_of_channels
       img(:,:,channel)=min(max(img(:,:,channel)-marker_scales(channel,1),0)/...
           (marker_scales(channel,2)-marker_scales(channel,1)),1)*100; 
    end
end