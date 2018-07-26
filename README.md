# DFS ExtractPaths

Workflow 1 (extracting DFS paths for single file):
1) Place file in the working diretory
2) Run "write.m" after changing the location in the file.
3) compile the c++ file "g++ dfs.cpp"
4) run "./a.out" - "paths.txt" is the txt file containing the paths
5) Run "read_back.m" to get mat file with the paths. 

Workflow 2 (extracting DFS paths for multiple files):
1) Place all files in the folder "MotFiles"
2) run get_paths.sh
