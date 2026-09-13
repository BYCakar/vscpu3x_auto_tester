#include "generated/mastermind_secret.h"


int plus = 0;
int minus = 0;

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

void wait_tx(){
  
  int *terminal = (int *) 8448; // start address of uart terminal

  int rd_terminal;
  rd_terminal = *(terminal + 5);
  rd_terminal = rd_terminal & 1;
  while(rd_terminal == 1){
    rd_terminal = *(terminal + 5);
    rd_terminal = rd_terminal & 1;
  }

}

void wait_for_tx_drain(void)
{
    int delay = 10000;
    int *terminal = (int *) 8448;

    /* First wait until the final byte has entered the hardware TX FIFO. */
    while (*(terminal + 4) != 0) {
    }

    /*
     * CodeMaker exposes TX-full but not TX-empty.  Keep the core running
     * long enough to drain a worst-case 16-byte FIFO at 115200 baud before
     * main returns and the tester observes the core's done signal.
     */
    while (delay > 0) {
        delay--;
    }
}

void print_found(){
  
  int *terminal = (int *) 8448; // start address of uart terminal

  wait_tx();
  *(terminal + 3) = 102; // f
  *(terminal + 4) = 1;
  wait_tx();
  *(terminal + 3) = 111; // o
  *(terminal + 4) = 1;
  wait_tx();
  *(terminal + 3) = 117; // u
  *(terminal + 4) = 1;
  wait_tx();
  *(terminal + 3) = 110; // n
  *(terminal + 4) = 1;
  wait_tx();
  *(terminal + 3) = 100; // d
  *(terminal + 4) = 1;
  
}

void print_code(int x){

  int *terminal = (int *) 8448; // start address of uart terminal

  wait_tx();
  *(terminal + 3) = (x >> 12) + 48;
  *(terminal + 4) = 1; // write 1-byte
  wait_tx();
  *(terminal + 3) = ((x >> 8) & 15) + 48;
  *(terminal + 4) = 1;
  wait_tx();
  *(terminal + 3) = ((x >> 4) & 15) + 48;
  *(terminal + 4) = 1;
  wait_tx();
  *(terminal + 3) = ((x) & 15) + 48;
  *(terminal + 4) = 1;
 
}

void print_new_line(){
  
  int *terminal = (int *) 8448; // start address of uart terminal
  
  wait_tx();
  *(terminal + 3) = 13; // CR character
  *(terminal + 4) = 1;
  wait_tx();
  *(terminal + 3) = 10; // LF character
  *(terminal + 4) = 1;
}

void print_space(int count){
  
  int *terminal = (int *) 8448; // start address of uart terminal
  
  wait_tx();
  *(terminal + 3) = 32; // Space character
  *(terminal + 4) = 1;
}

void print_plus(int count){
  
  int *terminal = (int *) 8448; // start address of uart terminal
  
  wait_tx();
  *(terminal + 3) = 43; // + character
  *(terminal + 4) = 1;
  wait_tx();
  *(terminal + 3) = (48+plus); // plus
  *(terminal + 4) = 1;
}

void print_minus(int count){
  
  int *terminal = (int *) 8448; // start address of uart terminal
  
  wait_tx();
  *(terminal + 3) = 45; // - character
  *(terminal + 4) = 1;
  wait_tx();
  *(terminal + 3) = (48+minus); // minus
  *(terminal + 4) = 1;
}

int main(){
  int sc = MASTERMIND_SECRET_BCD; // generated secret code
  int sc_found = 0;

  int guess = 0;
  int guess_r = 0;

  int *shm = (int *) 8192; // start address of shared memory
  
  int *led = (int *) 8464; // start address of leds

  int *terminal = (int *) 8448; // start address of uart terminal

  int rd_terminal = 0;

  *(shm+11) = 1; // notify CT

  *(led) = 1; // test statement

  
  wait_tx();
  *(terminal + 3) = 115; // s
  *(terminal + 4) = 1;
  wait_tx();
  *(terminal + 3) = 99; // c
  *(terminal + 4) = 1;
  wait_tx();
  *(terminal + 3) = 58; // :
  *(terminal + 4) = 1;
  
  print_code(sc);
  print_new_line();
  
  while(sc_found == 0){
    
    *(led) = 2;
    // to-do: wait for start signal coming from terminal
    while(*(shm + 11) != 2){
      // wait until CT replies
    }
    guess = *(shm + 10); // get the guess from CT
    score(guess, sc);
    
    print_plus(plus);
    print_space(1);
    print_minus(minus);
    print_space(1);
    print_code(guess);
    print_new_line();
    
    if(plus == 4){
      sc_found = 1;
    }
    *(shm + 10) = (plus << 20) | (minus << 16) | guess;
    *(shm + 11) = 1;
  }

  *(led) = 5;
  print_found();
  print_new_line();

  wait_for_tx_drain();
   
  return 0;
    
}
