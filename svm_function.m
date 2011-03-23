function val=svm_function(svm_struct,sample)

alpha=svm_struct.Alpha;
sv_indices=svm_struct.SupportVectorIndices;
sv_vecs=svm_struct.SupportVectors;
b=svm_struct.Bias;
val=b;
w=zeros(1,size(sv_vecs,2));
for i=1:length(alpha)
   w=w+  alpha(i)*sv_vecs(i,:);
   val=val+ alpha(i)*svm_struct.KernelFunction(sv_vecs(i,:),(sample+svm_struct.ScaleData.shift).*svm_struct.ScaleData.shift);
end
w=w.*svm_struct.ScaleData.scaleFactor;
b1=b+sum(w.*svm_struct.ScaleData.shift);
disp('meow');