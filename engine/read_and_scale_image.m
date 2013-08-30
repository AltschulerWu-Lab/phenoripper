function img=read_and_scale_image(filenames,marker_scales,xres_full,yres_full,channels_per_file,xres_cropped,yres_cropped,rescale_param)
%imread Read, scale and crop images from graphics files.
%    IMG=READ_AND_SCALE_IMAGE(FILENAMES,MARKER_SCALES,XRES_FULL,YRES_FULL,...
%    CHANNELS_PER_FILE,XRES_CROPPED,YRES_CROPPED) reads an image of size 
%    [XRES_FULL,YRES_FULL] from the file(s) specified by the cell array FILENAME. 
%    Presently either a single multi-channel with CHANNELS_PER_FILE channels or
%    multiple gray-scale (CHANNELS_PER_FILE=1) files are supported. The
%    output array IMG is a multichannel array cropped to  size
%    [XRES_CROPPED,YRES_CROPPED] with intensities rescaled scaled by values
%    specified by MARKER_SCALES which is an array of size [number of channels x 2]. 
%    The first column is the min value of each channel, and the second the max value.
%
% ------------------------------------------------------------------------------
% Copyright ??2012, The University of Texas Southwestern Medical Center 
% Authors:
% Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
% For latest updates, check: < http://www.PhenoRipper.org >.
%
% All rights reserved.
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, version 3 of the License.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details:
% < http://www.gnu.org/licenses/ >.
%
% ------------------------------------------------------------------------------
%%
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
    
    if(channels_per_file>1)%If MultiChannel
        img=double(imread2(filenames{1},true,rescale_param));
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
    else%If Single Channel Image File
        for channel_counter=1:number_of_channels
          %USE IMREAD FOR SINGLE CHANNEL ALWAYS
          img(:,:,channel_counter)=100*min(max((double(imread2(filenames{channel_counter},false,rescale_param{channel_counter}))-marker_scales(channel_counter,1))/...
                (marker_scales(channel_counter,2)-marker_scales(channel_counter,1)),0),1);
        end
    end
else
    x1=ceil((xres_full-xres_cropped)/2);
    y1=ceil((yres_full-yres_cropped)/2);
    x2=x1+xres_cropped-1;
    y2=y1+yres_cropped-1;
    
    if(channels_per_file>1)%If MultiChannel
      temp=double(imread2(filenames{1},true,rescale_param));
      for channel=1:number_of_channels
        %A=rescale_param{channel}{1};
        %B=rescale_param{channel}{2};
%         img=temp(x1:x2,y1:y2,:);
%         img(:,:,channel)=min(max(img(:,:,channel)-marker_scales(channel,1),0)/...
%             (marker_scales(channel,2)-marker_scales(channel,1)),1)*100;
          
        imgtemp=temp(x1:x2,y1:y2,channel);
        img(:,:,channel)=min(max(imgtemp(:,:)-marker_scales(channel,1),0)/...
            (marker_scales(channel,2)-marker_scales(channel,1)),1)*100;

          %        temp=img(:,:,channel);
          %        temp=100*(temp-marker_scales(channel,1))/(marker_scales(channel,2)-marker_scales(channel,1));
          %       % temp(temp<0)=0;
          %        %temp(temp>100)=100;
          %        temp=min(max(temp,0),100);
          %        img(:,:,channel)=temp;
      end
    else%If Single Channel Image File
        for channel_counter=1:number_of_channels        
          A=rescale_param{channel_counter}{1};
          B=rescale_param{channel_counter}{2};
          %USE IMREAD FOR SINGLE CHANNEL ALWAYS
          temp=imread2(filenames{channel_counter},false,rescale_param{number_of_channels});
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
