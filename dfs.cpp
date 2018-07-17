#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <string>

using namespace std;

//Helper for DFS
//curr_node contains node number and time,
vector<vector<int> > DFSHelper(double graph[15][1201], double times[15][1201], int i, int j, double min_time){
	//cout<<"Recursively called DFS on "<<i<<" "<<j<<endl;

	if(i == 8 && j == 26){
		//cout<<"MAIN CASE";
	}

	//Get node number
	int node_num = graph[i][j];
	//cout<<"Got node number"<<node_num;

	int index_corr = node_num - 784;


	//Time at which this node was fired
	double time_fired = times[i][j];
	//cout<<"Time fired"<<time_fired;

	//Base case
	//If this node was fired before mintime, don't do anything
	if(time_fired < min_time - 0.01){
		//cout<<"Terminating";
		return vector<vector<int> >();
	}

	//Otherwise let's look at all nodes which fired this guy
	vector<vector<int> >ans;


	//Recursive case

	//Find which nodes caused this node to fire at its time
	for(int k = j; k >= 0; k--){
		//Found some node which caused THIS node to fire
		//For all cols in which this node could have fired
		if(times[0][k] == time_fired && graph[index_corr][k] != 0){

			//Get this guy's paths
			//cout<<"Getting sub nodes of a sub node";
			int new_node = graph[index_corr][k];
			int new_node_time_fired = times[index_corr][k];

			//Call DFS on node which caused ith node to fire!
			vector<vector<int> > local_answer = DFSHelper(graph, times, index_corr, k, min_time);
			//cout<<"Number of sub paths of this node "<<local_answer.size()<<endl;

			//For all of these paths push_back the current node which was fired
			for (int vec_index = 0; vec_index < local_answer.size(); vec_index++){
				local_answer.at(vec_index).push_back(node_num);

				//Add this path to final_ans!
				ans.push_back(local_answer.at(vec_index));
			}


		}
	}

	if(ans.size() == 0){
		ans.push_back(vector<int>(1, node_num));
	}

	return ans;
}

//Main dfs function
vector<vector<int> > doDFS(double graph[][1201], double times[][1201]){

	//Total number of rows
	int rows = 15;
	//Total number of columns
	int cols = 1201;

	//min_time
	double min_time = graph[0][0];

	//Initialzing final vector
	vector<vector<int> > final_ans;


	cout<<"Starting DFS Process"<<endl;


	//Iterating over columns
	for(int j = cols-1; j > 0; j--){

		//Iterating over OUTPUT NODE rows in that column
		for(int i = 6; i < rows; i++){

			//If non-zero
			if(graph[i][j] != 0){

				cout<<"("<<i<<", "<<j<<")"<<" Non-zero"<<endl;

				//Call DFS on node which caused ith node to fire!
				vector<vector<int> > local_answer = DFSHelper(graph, times, i, j, min_time);
				cout<<"Number of sub paths is"<<local_answer.size()<<endl;


				//For all of these paths push_back the current node which was fired
				for (int vec_index = 0; vec_index < local_answer.size(); vec_index++){
					//Started here
					local_answer.at(vec_index).push_back(i+784);
					//Add this path to final_ans!
					final_ans.push_back(local_answer.at(vec_index));
				}

				cout<<"Paths found and added."<<endl;


			}

		}
	}

	return final_ans;
}

	int main(int argc, char *argv[]){

		//inFile
		ifstream inFile;

		//Total number of rows and columns
		int rows = 15;
		int cols = 1201;

		//Initializing
		double graph[15][1201];
		double times[15][1201];

		for(int i = 0; i < rows; i++){
			for(int j = 0; j < cols; j++){
				graph[i][j] = 0;
				times[i][j] = 0;
			}
		}

		double nextNum;
		inFile.open("everything.txt");


		while(!inFile.eof()){
			//Get row
			inFile >> nextNum;
			int row = (int)nextNum;
			if(row > 15){break;}

			//Get col
			inFile >> nextNum;
			int col = (int)nextNum;

			cout<<"Populating row "<<row<<" column "<<col<<endl;

			//Get mot
			inFile  >> nextNum;
			graph[row-1][col-1] = nextNum;

			//Get time
			inFile >> nextNum;
			times[row-1][col-1] = nextNum;
		}



		inFile.close();
		cout<<"Done loading data."<<endl;
		cout<<"MIN TIME"<<graph[0][0];


		vector<vector<int> > DONE = doDFS(graph, times);
		cout<<"Total Number of paths found"<<DONE.size();

		cout<<"Exporting patterns"<<endl;

		ofstream outFile;
		outFile.open("paths.txt");
		for(int i = 0; i < DONE.size(); i++){
			//reverse(DONE.at(i).begin(), DONE.at(i).end());

			for(int j =0; j < DONE.at(i).size(); j++){
				outFile << DONE.at(i).at(j) << " ";
			}

			outFile << '\n';
		}
		outFile.close();

	}
