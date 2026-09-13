int g_plus = 0; // plus score of guess
int g_minus = 0; // minus score of guess
int AG_count = 1; // number of agents

int BCD_compare_digit(int S,int S2,int d,int d2) {
	// compares digit, if digits are equal, returns 1
	// else returns 0
	
	S = S >> (d-1) * 4;
	S = S & 15;
	
	S2 = S2 >> (d2-1) * 4;
	S2 = S2 & 15;
	
	return (S2 == S) && (S2 != 15);
}

void score(int guess, int answer) {
	// compares guess and answer and finds plus and minus
	int i;
	int j;

	int result;
	
	for(i = 1; i <= 4; i++) {
	
		result = BCD_compare_digit(guess, answer, i, i);
		
		guess	= guess		| ((15*result) << ((i-1)*4));
		answer	= answer	| ((15*result) << ((i-1)*4));
		
		g_plus = g_plus + result;
	}
	

	for(i = 1; i <= 4; i++) {
		for(j = 1; j <= 4; j++) {
			
			if (i != j) {
				
				result = BCD_compare_digit(guess, answer, i, j);

				if(result) {
					
					guess	= guess		| (15 << ((i-1)*4));
					answer	= answer	| (15 << ((j-1)*4));
				
					g_minus++;

					break;
				}
			}
		}

	}
}


int main(){

	int CT_gsp[10]; // guess-score pairs
	
	int guess = 0; // guess
	
	int AG_dead[5]; // agent is alive by default
	int AG_consistent[5]; 
	int AG_partition[5]; // partition values of candidates
	int AG_max_partition[5]; // agents which have the most partition count

	int *shm = (int *) 8192; // start address of shared memory
	int g_index = 1; // guess index
	int i = 0; // set score table index to zero
	int agent_found; // agent found flag for maximum partition calculations
	int rr_pointer = 0; // round-robin pointer for maximum partition calculations

	// wait for start signal coming from CM
	while(*(shm+11) != 1){
	}

	*(shm+10) = 4660; // write 1234 in BCD
	*(shm+11) = 2; // notify CM
		
	// wait for start signal coming from CM
	while(*(shm+11) != 1){
	}

	CT_gsp[0] = *(shm+10); // read response of 1234 into CT_gsp[0]
	if ((CT_gsp[0] >> 20) == 4) {
	  *(shm + 12) = -1;
	  return 0;
	}

	guess = 1383;
	guess = (guess << 4);
	*(shm+10) = guess; // write 5670 in BCD
	*(shm+11) = 2; // notify CM

	// wait for start signal coming from CM
	while(*(shm+11) != 1){
	}

	CT_gsp[1] = *(shm+10); // read response of 5678 into CT_gsp[1]
	if ((CT_gsp[1] >> 20) == 4) {
	  *(shm + 12) = -1;
	  return 0;
	}

	*(shm) = CT_gsp[0]; // write the first guess-score pair into shared memory
	*(shm+1) = CT_gsp[1]; // write the second guess-score pair into shared memory

	i = 2;

	int j;
	int k;
	int l;
	// int info[5]; // keeps partition info
	int plus_0[5];
	int plus_1[4];
	int plus_2[3];
	int plus_3[1];
	int plus_4[1];
	int max_partition = 0; // initial maximum partition count
	int temp_partition;
	// int best_guess = 0; // keeps the index of agent with the current best guess (in terms of partition)
	
	while(1){

	  for(j = 0; j < AG_count; j++) {
	    *(shm+12+j) = i; // notify agents that guess-score pair/pairs is/are available
	  }
	  
	  // *(shm+12) = i; // notify agents that guess-score pair/pairs is/are available
	  
	  // wait for consistent-dead status coming from all agents
		
	  for(j = 0; j < AG_count; j++) {
	    
	    while(*(shm+20+j) == 0){
	    }
	    
	    AG_consistent[j] = *(shm + 20 + j);
	    AG_dead[j] = AG_consistent[j] & 1;
	    AG_consistent[j] = AG_consistent[j] >> 1;
	    // AG_dead[j] = *(shm+20+j) & 1;
	    
	    // clear consistent dead status of agent #j if agent is alive
	    if(AG_dead[j] == 0){
	      *(shm+20+j) = 0;
	    }
	    
	  }
		
	  // reset AG_partition
	  for(j = 0; j < AG_count; j++){
	    AG_partition[j] = 0;
	  }
		
	  // partition calculation for all agents
	  for(j = 0; j < AG_count; j++) {
	    if(AG_consistent[j] &&  (AG_dead[j] == 0)) {
	      temp_partition = 0;
	      // info[0] = 0;
	      // info[1] = 0;
	      // info[2] = 0;
	      // info[3] = 0;
	      // info[4] = 0;
	      for(k = 0; k < 5; k++){
		plus_0[k] = 0;
	      }
	      for(k = 0; k < 4; k++){
		plus_1[k] = 0;
	      }
	      for(k = 0; k < 3; k++){
		plus_2[k] = 0;
	      }
	      plus_3[0] = 0;
	      plus_4[0] = 0;
	      
	      for(k = 0; k < AG_count; k++) {
		if((AG_dead[k] == 0) && (k != j)) {
		  
		  score(*(shm+25+j), *(shm+25+k)); // score current candidate against other candidates
		  if(g_plus == 0){
		    plus_0[g_minus] = 1;
		  }
		  else if(g_plus == 1){
		    plus_1[g_minus] = 1;
		  }
		  else if(g_plus == 2){
		    plus_2[g_minus] = 1;
		  }
		  else if(g_plus == 3){
		    plus_3[0] = 1;
		  }
		  else if(g_plus == 4){
		    plus_4[0] = 1;
		  }
		  // info[g_plus] = info[g_plus] | (1 << (g_minus));
		  
		  // temp_partition = 0;
		  /*for (l = 0; l < 5; l++) {
		    
		    while(info[l]) {
		    temp_partition++;
		    info[l] = info[l] >> 1;
		    }
		    }
		  */
		}
	      }
	      
	      temp_partition = 0;
	      for(k = 0; k < 5; k++){
		temp_partition = temp_partition + plus_0[k];
	      }
	      for(k = 0; k < 4; k++){
		temp_partition = temp_partition + plus_1[k];
	      }
	      for(k = 0; k < 3; k++){
		temp_partition = temp_partition + plus_2[k];
	      }
	      temp_partition = temp_partition + plus_3[0];
	      temp_partition = temp_partition + plus_4[0];
	      
	      AG_partition[j] = temp_partition; // save agent's partition count
	      
	      /*
		if(max_partition < temp_partition) {
		max_partition = temp_partition;
		best_guess = j;
		}
	      */
	      
	    }
	  }
	  
	  // find max partitions
	  max_partition = 0;
	  for(k = 0; k < AG_count; k++){
	    if(max_partition <= AG_partition[k]){
	      max_partition = AG_partition[k];
	      AG_max_partition[k] = 1;
	    }
	  }

	  // clean wrong max partitions
	  for(k = 0; k < AG_count; k++){
	    if(AG_partition[k] < max_partition){
	      AG_max_partition[k] = 0;
	    }
	  }


	  agent_found = 0;
	  while(agent_found == 0){
	    if(AG_max_partition[rr_pointer] == 1){
	      agent_found = 1;
	    }
	    else {
	      rr_pointer = rr_pointer + 1;
	      if(rr_pointer >= AG_count){
		rr_pointer = 0;
	      }
	    }
	  } 
		    
	  // clean AG_max_partition array for next maximum partition calculation
	  for(k = 0; k < AG_count; k++){
	    AG_max_partition[k] = 0;
	  }
	  
	  guess = *(shm + 25 + rr_pointer);
	  rr_pointer = rr_pointer + 1;
	  if(rr_pointer >= AG_count){
	    rr_pointer = 0;
	  }
	  
	  *(shm+10) = guess; // write new guess
	  *(shm+11) = 2; // notify CM
	  
	  // wait for start signal coming from CM
	  while(*(shm+11) != 1){
	  }
	  
	  CT_gsp[i] = *(shm+10); // read response of new guess into CT_gsp[i]
	  *(shm+i) = CT_gsp[i]; // write the ith guess-score pair into shared memory

    // Return if secret code is found
    if ((CT_gsp[i] >> 20) == 4) {
      *(shm + 12) = -1;
      return 0;
    }

	  i = i + 1; // increment i
	  
	}

	return 0;

}
