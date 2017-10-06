/*
 * Parallel-Ants.xc
 *
 *  Created on: 29 Sep 2017
 *      Author: sc16913
 */

#include <platform.h>
#include <stdio.h>
#include <stdbool.h>

void queen (unsigned int x, unsigned int y, chanend cWorker1toQueen, chanend cWorker2toQueen){
    unsigned int foodFromWorker1 = 0;
    unsigned int foodFromWorker2 = 0;
    unsigned int overall = 0;

    for (int i=0; i < 5; i++) {

        printf("Food is %i\n", overall);

        cWorker1toQueen :> foodFromWorker1;
        printf("Worker 1 sent data %i to Queen\n", foodFromWorker1);
        cWorker2toQueen :> foodFromWorker2;
        printf("Worker 2 sent data %i to Queen\n", foodFromWorker2);

        if (foodFromWorker1 > foodFromWorker2){
            cWorker2toQueen <: 0;
            cWorker1toQueen <: 1;
            overall += foodFromWorker1;
        }
        else {
            cWorker2toQueen <: 1;
            cWorker1toQueen <: 0;
            overall += foodFromWorker2;
        }
    }

    printf("Overall food gathered: %i\n", overall);
}

void ant (const unsigned char map[3][4], unsigned int id, unsigned int x, unsigned int y, chanend cQueen){
    unsigned int foodCount = 0;
    unsigned int order = 0;
    unsigned int ownFood = 0;

    for (int i=0; i<5; i++) {
        foodCount = map[x][y];
        cQueen <: foodCount;

        cQueen :> order;

        if (order == 0) {
            for (int i = 0; i < 2; i++){
                   if (map[x][(y+1)%4] > map[(x+1)%3][y])
                       y = (y+1)%4;
                   else
                       x = (x+1)%3;
               }
        }
        else {
            ownFood += map[x][y];
            printf("Own food for ant %i is %i\n", id, ownFood);
        }
    }

}

int main(){

    const unsigned char map[3][4] = {
                                   {10, 0, 1, 7},
                                   {2, 10, 0, 3},
                                   {6, 8, 7, 6}
                                   };
    chan cWorker1toQueen;
    chan cWorker2toQueen;

    par {
        ant(map, 1, 0, 1, cWorker1toQueen);
        ant(map, 2, 1, 0, cWorker2toQueen);
        queen(1,1, cWorker1toQueen, cWorker2toQueen);
    }

    return 0;
}


