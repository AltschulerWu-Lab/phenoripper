function img=Read_and_Scale_Image(filenames,marker_scales,xres_full,yres_full,channels_per_file,xres_cropped,yres_cropped)
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

img=zeros(xres_cropped,yres_cropped,number_of_channels);
%Decide if we want to split image
dont_split_image=((xres_full==xres_cropped)&&(yres_full==yres_cropped));
if(dont_split_image)
    
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
else
    x1=ceil((xres_full-xres_cropped)/2);
    y1=ceil((yres_full-yres_cropped)/2);
    x2=x1+xres_cropped-1;
    y2=y1+yres_cropped-1;
    
    if(channels_per_file>1)
        temp=double(imread(filenames{1}));
        for channel=1:number_of_channels
            img=temp(x1:x2,y1:y2,:);
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
            temp=imread(filenames{channel_counter});
            temp=temp(x1:x2,y1:y2);
            img(:,:,channel_counter)=100*min(max((double(temp)-marker_scales(channel_counter,1))/...
                (marker_scales(channel_counter,2)-marker_scales(channel_counter,1)),0),1);
        end
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
