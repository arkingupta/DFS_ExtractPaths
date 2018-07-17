fid = fopen('paths.txt','r');
final = {}
tline = fgetl(fid);
while ischar(tline)
    C = str2num(tline)
    D = zeros(size(C,2)-1,2)
    

    D(:,1) = C(1:end-1)'
    D(:,2) = C(2:end)'
    
    final{end+1} = D
    tline = fgetl(fid);
end

save label_0_sample_35.mat final 

