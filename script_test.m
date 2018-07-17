labels = {'dict_nine.mat','dict_zero.mat'};


final_table_0 = zeros(12,12);
final_table_25 = zeros(12,12);
final_table_50 = zeros(12,12);
final_table_75 = zeros(12,12);
final_table_100 = zeros(12,12);

for i=1:1
    for j=2:2
        File1 = labels{i};
        File2 = labels{j};  
        
        disp(File1);
        disp('vs');
        disp(File2);
        disp('  ');
     
        test = analytics_dynPerc_compare_seq(File1, File2);
        
        final_table_0(i,j) = test(1);    
        final_table_25(i,j) = test(2);
        final_table_75(i,j) = test(4);          
        final_table_100(i,j) = test(5);
        
        
    end
end

