/*
 * helloXC.xc
 *
 *  Created on: 29 Sep 2017
 *      Author: sc16913
 */

#include <platform.h>
#include <stdio.h>

void hello(int tileNo);

int main(void) {
    par {
        on tile[0] : hello(0);
        on tile[1] : hello(1);
    }
    return 0;
}

void hello (int tileNo){
    printf("Hello from tile #%d.\n", tileNo);
}
