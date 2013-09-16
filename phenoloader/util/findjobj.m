function jh=findjobj(mh)
tries=0;
jh=findjobj1(mh);
while(isempty(jh)&tries<5)
disp('findjobj failed');
jh=findjobj1(mh);
tries=tries+1;
end
