
# makefile for MPI_exercises/Intro

# You can change these.

F90    = gfortran
CFLAGS = -O1

# You shouldn't change these unless you really know what you're doing.

MY_NUMBER_F90 = my_number.f90
MY_NUMBER_O   = my_number.o
MY_NUMBER_EXE = my_number

LIBS          =

EXECUTABLE    = ${MY_NUMBER_EXE}
EXECUTABLES   = ${EXECUTABLE}

default:	${EXECUTABLES}

clean:		
	rm -f ${EXECUTABLES} *.[oadD] *.[mM][oO][dD]

${MY_NUMBER_EXE}:	${MY_NUMBER_O}
		${F90} ${CFLAGS} -o ${MY_NUMBER_EXE} ${MY_NUMBER_O} ${LIBS}

${MY_NUMBER_O}:		${MY_NUMBER_F90}
		${F90} ${CFLAGS} -c ${MY_NUMBER_F90}

