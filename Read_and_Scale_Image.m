function img=Read_and_Scale_Image(filenames,marker_scales,xres,yres,channels_per_file)
    number_of_channels=max(length(filenames),channels_per_file);
    
%     if(length(filenames)>1)
%         number_of_channels=length(filenames);
%         info=imfinfo(filenames{1});
%         xres=info.Height;
%         yres=info.Width;
%         channels_per_file=1;
%     else 
%         test=imread(filenames{1,1});
%         xres=size(test,1);
%         yres=size(test,2);
%         number_of_channels=size(test,3);
%         channels_per_file=number_of_channels;
%     end
    img=zeros(xres,yres,number_of_channels);
    
    if(channels_per_file>1)
        img=double(imread(filenames{1}));
        for channel=1:number_of_channels
            img(:,:,channel)=min(max(img(:,:,channel)-marker_scales(channel,1),0)/...
                (marker_scales(channel,2)-marker_scales(channel,1)),1)*100;
            %        temp=img(:,:,channel);
            %        temp=100*(temp-marker_scales(channel,1))/(marker_scales(channel,2)-marker_scales(channel,1));
            %       % temp(temp<0)=0;
            %        %temp(temp>100)=100;
            %        temp=min(max(temp,0),100);
            %        img(:,:,channel)=temp;
        end
    else
        for channel_counter=1:number_of_channels
            img(:,:,channel_counter)=100*min(max((double(imread(filenames{channel_counter}))-marker_scales(channel_counter,1))/...
                (marker_scales(channel_counter,2)-marker_scales(channel_counter,1)),0),1);
        end
    end
    
%     for channel=1:number_of_channels
% %        img(:,:,channel)=min(max(img(:,:,channel)-marker_scales(channel,1),0)/...
% %            (marker_scales(channel,2)-marker_scales(channel,1)),1)*100; 
%        temp=img(:,:,channel);
%        temp=100*(temp-marker_scales(channel,1))/(marker_scales(channel,2)-marker_scales(channel,1));
%       % temp(temp<0)=0;
%        %temp(temp>100)=100;
%        temp=min(max(temp,0),100);
%        img(:,:,channel)=temp;    
%     end
end
