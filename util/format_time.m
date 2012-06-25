function td=format_time(seconds)

hours=floor(seconds/3600);
min=floor(rem(seconds,3600)/60);
secs=round(rem(rem(seconds,3600),60));
td='';
if(hours>0)
   td=[num2str(hours) 'hours:'];
  
end

if(min>0)
   td=[td num2str(min) 'min:'];
  
end
td=[td num2str(secs) 'sec'];

end
