nrows=30;
ncols=7;
block_size=30;
load filteredyeastdata;
%temp=yeastvalues
%data=rand(nrows,ncols);
data=yeastvalues(1:nrows,1:ncols);
representatives=cell(ncols,1);
for i=1:ncols
   representatives{i}=rand(block_size,block_size,3).^i; 
end
figure;
pos=CoolClustergram(data,representatives);

clustergram(data);
X = rand(nrows,2);
Y = pdist(X);
Z = linkage(Y,'average');
[H,T] = dendrogram(Z,'orientation','left');
axis on;