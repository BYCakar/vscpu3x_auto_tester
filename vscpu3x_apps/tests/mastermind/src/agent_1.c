
int plus = 0;
int minus = 0;

int AG_candidate = 0; // default value of candidate

void BCD_inc() {
  int x;
  int i;
  int negativeOne = 0;
  negativeOne = ~negativeOne;
  // it does not work for 9999 in BCD
  // modified for base-8
  for(i = 1; i <= 4; i++) {
    // if 4 is nine check next 4
    x = 7 << (4*(i-1));
    
    if((AG_candidate & x) == x)
      continue;
    
    // reset
    x = negativeOne << (4*(i-1));
    AG_candidate = AG_candidate & x;
    
    // increment
    x  = 1 << (4*(i-1));
    AG_candidate = AG_candidate + x;
    
    break;
  }

}

int BCD_compare_digit(int S,int S2,int d,int d2) {
  // compares digit, if digits are equal, returns 1
  // else returns 0
  int x;
  int y;
  int m;
  int t;

  if(d > d2) {
    m = d2;
    S = S >> 4*(d-d2);
  }
  else {
    m = d;
    S2 = S2 >> 4*(d2-d);
  }
  
  // XOR
  x = (S & ~S2) | (~S & S2);
  
  x = x >> (m-1)*4;
  
  y = -1;
  y = y - 15;
  
  t = x & y;
  
  if(t == x)
    return 1;
  
  return 0;
}

void score(int guess, int answer){
  // compares guess and answer and finds plus and minus
  int i;
  int j;
  plus = 0;
  minus = 0;
  int result;
  int guess_map = 0;
  int answer_map = 0;
  int num;
  int num2;
  for(i = 1; i <= 4; i++) {
    num  = 1 << (i-1);
    if (((guess_map | answer_map) & num) == num)
      continue;
    result = BCD_compare_digit(guess, answer, i, i);
    if (result) {
      guess_map = guess_map | num;
      answer_map = guess_map;
      plus++;
      continue;
    }
  }

  for(i = 1; i <= 4; i++) {
    for(j = 1; j <= 4; j++) {
      num  = 1 << (i-1);
      num2  = 1 << (j-1);
      if (((guess_map & num) == num) || ((answer_map & num2) == num2) || (i == j))
	continue;
      result = BCD_compare_digit(guess, answer, i, j);

      if(result) {
	minus++;
	guess_map = guess_map | num;
	answer_map = answer_map | num2;

	break;

      }

    }

  }
}

int main(){

  int CT_gsp[10]; // copy of guess-score pairs

  int AG_consistent = 0; // agent ptr is inconsistent by default
  int AG_dead = 0; // agent is alive by default dead
      
  int g_plus = 0; // plus score of guess
  int g_minus = 0; // minus score of guess
  int g_score = 0;
  
  int *shm = (int *) 8192; // start address of shared memory  
  int g_index = 2; // guess index
  int i = 0; // set score table index to zero

  int AG_limit = 1911; // 777 in BCD
  AG_limit = (AG_limit << 4) | 7; // 7777 in BCD

  // wait for start signal coming from CT - g_index points to last index of guess-score table
  while(*(shm+12) != g_index){
    if (*(shm+12) == -1) return 0;
  }

  // copy first guess-score pair from shared memory
  CT_gsp[0] = *(shm);
  // copy second guess-score pair from shared memory
  CT_gsp[1] = *(shm + 1);

  while(AG_dead == 0){ // continue to look for candidates while agent is alive
    
    // perform consistency check for current agent ptr
    AG_consistent = 0; // agent ptr is inconsistent by default
    // AG_dead = 0; // agent is alive by default

    while((AG_consistent != 1) && (AG_dead != 1)) { // continue to look for a candidate while agent is inconsistent and alive
            
      while(i < g_index){

	/*
	if((CT_guess_score_pair & 15) == 15){ // if current entry in score table is invalid, finish consistency check
	  break; // is there any case that evaluates this line?
	}
	*/

	if(AG_candidate == AG_limit){ // agent consumed its subspace and is dead
	  AG_dead = 1;
	  break;
	}

	g_plus = (CT_gsp[i] >> 20); // plus score of guess[i] in score table
	g_minus = (CT_gsp[i] >> 16) & 15; // minus score of guess[i] in score table
	g_score = CT_gsp[i] & 65535; // guess[i] in score table

	// FUNCTION
	score(g_score, AG_candidate); // score agent's pointer against guess[i] in score table
	// plus = g_pm >> 4;
	// minus = g_pm & 15;

	if((plus == g_plus) && (minus == g_minus)) { // if there is a match, continue to look for other guess/score pairs in score table
	  AG_consistent = 1;
	  i = i + 1; // increment score table index
	}
	else{ // if there is a mismatch, increment agent's pointer and restart from the beginning of score table
	  AG_consistent = 0;
	  // FUNCTION
	  BCD_inc();
	  i = 0;
	}
      }
    }

    // write the result and notify CT
    *(shm + 25) = AG_candidate;
    *(shm + 20) = (AG_consistent << 1) | AG_dead;

    g_index = g_index + 1; // increment g_index

    // wait for start signal coming from CT - g_index points to index of guess-score table
    while(*(shm+12) != g_index){
      // Return if Control Tower shares secret code found info
      if (*(shm+12) == -1) return 0;
    }

    // copy (g_index)th guess-score pair from shared memory
    CT_gsp[(g_index) - 1] = *(shm + (g_index) - 1);
  }
   
  return 0;
    
}
