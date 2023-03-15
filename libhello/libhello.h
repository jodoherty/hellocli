//
//  libhello.h
//  libhello
//
//  Created by James O'Doherty on 3/14/23.
//

#include <CoreFoundation/CoreFoundation.h>

typedef struct HelloHandler {
    void *context;
    int (*convert)(struct HelloHandler *handler, const char *str, char **strout);
    void (*close)(struct HelloHandler *handler);
} HelloHandler;

void clear_handler(void);
void register_handler(HelloHandler *hello);
void hello(const char *s);
