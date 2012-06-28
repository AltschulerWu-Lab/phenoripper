function display_image_with_boundaries(img,axis_handle,color_scaling,colors,mask,boundary_mask)
img=double(img);
[xres,yres,nch]=size(img);
final_image=zeros(xres,yres,3);

for channel=1:nch
    img(:,:,channel)=max(min((img(:,:,channel)-color_scaling(channel,1))...
        /(color_scaling(channel,2)-color_scaling(channel,1)),1),0);
    switch colors{channel}
        case {'b','B','Blue'},    ch = 3;     wt = 1;
        case {'g','G','Green'},   ch = 2;     wt = 1;
        case {'r','R','Red'},     ch = 1;     wt = 1;
        case {'k','K','Gray'},    ch = 1:3;   wt = [1 1 1];
        case {'o','O','Orange'},  ch = 1:2;   wt = [1 .75];
        case {'y','Y','Yellow'},  ch = 1:2;   wt = [.5 .5];
        case {'c','C','Cyan'},    ch = 2:3;   wt = [1 1];
        case {'m','M','Magenta'}, ch = [1 3]; wt = [1 1];
        case {'','-' ,'None'},    ch=[];      wt=[];
    end
    for h=1:length(ch)
        if(isempty(mask))
            final_image(:,:,ch(h))=final_image(:,:,ch(h))+wt(h)*img(:,:,channel);
        else
           final_image(:,:,ch(h))=final_image(:,:,ch(h))+wt(h)*img(:,:,channel)+0.25*mask; 
        end
    end
    
end


final_image=min(max(final_image,0),1);
if(~isempty(boundary_mask))
    
    for i=1:3
    temp=final_image(:,:,i);
    temp(boundary_mask)=1;
    final_image(:,:,i)=temp;
    end
end
axes(axis_handle);
image(final_image);
%axis off;

end
