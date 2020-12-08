LIBS = 
LIB_DIR =  
FLAGS = -g -Wall -D_GNU_SOURCE

.PHONY: clean all

all: fast slow mult tmult

fast: fast.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

slow: slow.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

mult: mult.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

tmult: tmult.c arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ fast slow mult tmult
