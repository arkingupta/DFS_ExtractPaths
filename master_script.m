%MASTER SCRIPT for sequence analysis
%Last Update: 04/17/2018

%Grabbing files in folder
list = dir;
A = {list.name};
one = {};three = {};nine = {}; zero = {};

%Sorting into different lists
disp(A);

%Change range of i to iterate only through ss files
for i=13:60
    str = A{i};
    newStr = extractAfter(str, strlength(str)-5);
    if(newStr == '1.mat')
        one{end+1} = str;
    end
    if(newStr == '3.mat')
        three{end+1} = str;
    end
    if(newStr == '9.mat')
        nine{end+1} = str;
    end
    if(newStr == '0.mat')
        zero{end+1} = str;
    end
 
end

%Initializing tables

%UPDATE THE FOLLOWING VARIABLES:
max_dict = 5;

final_table_0 = zeros(4,max_dict);
final_table_25 = zeros(4,max_dict);
final_table_50 = zeros(4,max_dict);
final_table_75 = zeros(4,max_dict);
final_table_100 = zeros(4,max_dict);
nums = {'zero', 'one', 'three', 'nine'};

%Cahnge variable to total number of files of a single label
sample_size = 10;
    
%t_label is the INDEX of the label we are calculating the accuracy for,
%also change label name where getting File

for t_label = 1:4
    
    for dict_size = 1:max_dict
        
        test_size = sample_size-dict_size;

        %generate an array of indices to set aside for dictionary
        arr_indices = [];
    
        for random_index = 1:dict_size
            temp_random = randi([1,sample_size]);
            while(ismember(temp_random, arr_indices))
                temp_random = randi([1,sample_size]);
            end
                arr_indices(end+1) = temp_random;
        end
    
        zero_dict = {};
        one_dict = {};
        three_dict = {};
        nine_dict = {};
    
        for index = 1:dict_size
            zero_dict{end+1} = zero{arr_indices(index)};
            one_dict{end+1} = one{arr_indices(index)};
            three_dict{end+1} = three{arr_indices(index)};
            nine_dict{end+1} = nine{arr_indices(index)};
        end
    
     
        %append all files with the index in this array to become dictionary
        append_all(zero_dict, dict_size, 'zero');
        append_all(one_dict, dict_size, 'one');
        append_all(three_dict, dict_size, 'three');
        append_all(nine_dict, dict_size, 'nine');
    
        
        total_correct_1 = 0;
        total_correct_2 = 0;
        total_correct_3 = 0;
        total_correct_4 = 0;
        total_correct_5 = 0;

        test_indices = [];
        %compare all other files with the dictionary zero
        for test_number = 1:test_size
        
            %Pick a random file
            temp_random_two = randi([1,sample_size]);
        
            while(ismember(temp_random_two, arr_indices) || ismember(temp_random_two, test_indices))
                temp_random_two = randi([1,sample_size]);
            end
        
            %Append file name 
            test_indices(end+1) = temp_random_two;
            
            %Get file
            Files = {};
            Files{1} = zero{temp_random_two};
            Files{2} = one{temp_random_two};
            Files{3} = three{temp_random_two};
            Files{4} = nine{temp_random_two};
            File = Files{t_label};
            
            %Run against all dictionaries
            atest_vals = {};
            atest_vals{1} = analytics_dynPerc_compare_seq(File, 'dict_zero.mat');
            atest_vals{2} = analytics_dynPerc_compare_seq(File, 'dict_one.mat');
            atest_vals{3} = analytics_dynPerc_compare_seq(File, 'dict_three.mat');
            atest_vals{4} = analytics_dynPerc_compare_seq(File, 'dict_nine.mat');
            
            
            test_vals = {};
            for k = 1:4
                if(k ~= t_label)
                    
                    test_vals{end+1} = atest_vals{k};
                end
            end
            
             %Updating 0% match 
             max_val = max(test_vals{1}(1),test_vals{2}(1));
             max_val = max(max_val,test_vals{3}(1));

             if (atest_vals{t_label}(1) > max_val)
                total_correct_1 =  total_correct_1 + 1;
             end
             
             %Updating 25% match
             max_val = max(test_vals{1}(2),test_vals{2}(2));
             max_val = max(max_val,test_vals{3}(2));

             if (atest_vals{t_label}(1) > max_val)
                total_correct_2 =  total_correct_2 + 1;
             end
             
             %Updating 50% match
             max_val = max(test_vals{1}(3),test_vals{2}(3));
             max_val = max(max_val,test_vals{3}(3));

             if (atest_vals{t_label}(1) > max_val)
                total_correct_3 =  total_correct_3 + 1;
             end
             
             %Updating 75% match
             max_val = max(test_vals{1}(4),test_vals{2}(4));
             max_val = max(max_val,test_vals{3}(4));


             if (atest_vals{t_label}(1) > max_val)
                total_correct_4 =  total_correct_4 + 1;
             end
             
             %Updating 100% match
             max_val = max(test_vals{1}(5),test_vals{2}(5));
             max_val = max(max_val,test_vals{3}(5));

             if (atest_vals{t_label}(1) > max_val)
                total_correct_5 =  total_correct_5 + 1;
             end
            
        end
        
        
        final_table_0(t_label, dict_size) = total_correct_1/test_size;
        final_table_25(t_label, dict_size) = total_correct_2/test_size;
        final_table_50(t_label, dict_size) = total_correct_3/test_size;
        final_table_75(t_label, dict_size) = total_correct_4/test_size;
        final_table_100(t_label, dict_size) = total_correct_5/test_size;
           
    end
      
end