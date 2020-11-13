# FLAGS=-Wall -fbounds-check -g
OPT=-O3
COMP=gfortran
INP=input.dat
OBJ=obj-mod/
SRC=code/
EXE=simulation.exe

$(EXE) : $(OBJ)def_variables.o $(OBJ)read_input.o $(OBJ)various.o $(OBJ)main.o
	$(COMP) $(FLAGS) $(OPT) $(OBJ)def_variables.o $(OBJ)read_input.o $(OBJ)various.o $(OBJ)main.o  -o $(EXE)

$(OBJ)def_variables.o : $(SRC)def_variables.f90
	mkdir -p $(OBJ)
	$(COMP) $(FLAGS) $(OPT) -J $(OBJ) -c $< -o $@

$(OBJ)various.o : $(SRC)various.f90 $(OBJ)def_variables.o
	$(COMP) $(FLAGS) $(OPT) -J $(OBJ) -c $< -o $@

$(OBJ)read_input.o : $(SRC)read_input.f90 $(OBJ)def_variables.o
	$(COMP) $(FLAGS) $(OPT) -J $(OBJ) -c $< -o $@

$(OBJ)main.o : $(SRC)main.f90 $(OBJ)def_variables.o $(OBJ)read_input.o $(OBJ)various.o
	$(COMP) $(FLAGS) $(OPT) -J $(OBJ) -c $< -o $@

.PHONY: run
run:
	./$(EXE) $(INP)

.PHONY: nohup
nohup:
	nohup ./$(EXE) $(INP) &

.PHONY: clean
clean:
	rm -r $(OBJ)
