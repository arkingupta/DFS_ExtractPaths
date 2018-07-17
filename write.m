load('./MotFiles/MotTstWgt_mnist_ex_35_label_0_sim_30_net_798_inDenWt_05_inDenD_001_hiDenWt_010_hiDenD_010')

%Getting submatrices
temp_mot = Mot(786:799, 20000:21200);
temp_tst = Tst(786:799 , 20000:21200);

%appending times on top
times = Tst(1,20000:21200);
temp_mot = [times; temp_mot];
temp_tst = [times; temp_tst];

temp_mot = full(temp_mot);
temp_tst = full(temp_tst);
 
[I, J] = find(temp_mot);

fileID = fopen('everything.txt','w');

for i = 1:size(I, 1)
    fprintf(fileID,'%d\n', I(i));
    fprintf(fileID, '%d\n', J(i));
    fprintf(fileID,'%d\n', temp_mot(I(i), J(i)));
    fprintf(fileID,'%f\n', temp_tst(I(i), J(i)));
end