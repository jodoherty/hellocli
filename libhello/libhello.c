//
//  libhello.c
//  libhello
//
//  Created by James O'Doherty on 3/14/23.
//

#include <stdio.h>
#include <stdlib.h>
#include "libhello.h"

HelloHandler *current_handler = NULL;

void hello(const char *str) {
    if (str == NULL) return;

    char *s = NULL;
    if (current_handler != NULL) {
        current_handler->convert(current_handler->context, str, &s);
    }
    if (s != NULL) {
        printf("%s\n", s);
        free(s);
    }
}

void clear_handler(void) {
    if (current_handler == NULL) return;
    current_handler->close(current_handler, current_handler->context);
    current_handler = NULL;
}

void register_handler(HelloHandler *handler) {
    clear_handler();
    current_handler = handler;
}
