
# makefile for SIPE_exercises/Intro

# You can change these.

# NOT SUPPORTED BY INTEL COMPILERS: -mno-hle -mno-prefetchw -mno-adcx -mno-abm
# NOT SUPPORTED BY GNU COMPILERS: 

CC     = gcc
CFLAGS_ALL = -O
CFLAGS_INTEL = ${CFLAGS_ALL} -axCOMMON-AVX512,CORE-AVX2 -xavx2
CFLAGS_AMD = ${CFLAGS_ALL}
CFLAGS = ${CFLAGS_ALL} 
#CC     = gcc
#CFLAGS = -mmovbe -mmmx -msse -msse2 -msse3 -mssse3 -msse4.1 -msse4.2 /
#-mpopcnt -mcx16 -mavx -mpclmul -mfsgsbase -mf16c -mavx2 -mbmi -mbmi2 /
#-mrdseed -maes -mclflushopt -mxsavec -mxsaves /
#-mavx512f -mclwb -mavx512vl -mavx512bw -mavx512dq -mavx512cd /
#-mno-sahf -mno-fxsr -mno-xsave -mno-rdrnd -mno-lzcnt -mno-hle -mno-sgx /
#-mno-mwaitx -mno-sha -mno-clzero -mno-sse4a -mno-abm /
#-mno-rdpid -mno-wbnoinvd -mno-pku -mno-vpclmulqdq -mno-vaes /
#-mno-avx512ifma -mno-avx512bf16 -mno-avx512vbmi -mno-avx512vbmi2 /
#-mno-avx512vnni -mno-avx512bitalg -mno-avx512vpopcntdq -mno-gfni

#CFLAGS = -mmovbe -mmmx -msse -msse2 -msse3 -mssse3 -msse4.1 -msse4.2 /
#-mpopcnt -mcx16 -mavx -mpclmul -mfsgsbase -mf16c -mavx2 -mbmi -mbmi2 /
#-mno-sahf -mno-fxsr -mno-xsave -mno-rdrnd -mno-lzcnt -mno-hle /
#-mno-rdseed -mno-aes -mno-clflushopt -mno-xsavec -mno-xsaves -mno-sgx /
#-mno-avx512f -mno-clwb -mno-avx512vl -mno-avx512bw -mno-avx512dq -mno-avx512cd /
#-mno-mwaitx -mno-sha -mno-clzero -mno-sse4a -mno-abm /
#-mno-rdpid -mno-wbnoinvd -mno-pku -mno-vpclmulqdq -mno-vaes /
#-mno-avx512ifma -mno-avx512bf16 -mno-avx512vbmi -mno-avx512vbmi2 /
#-mno-avx512vnni -mno-avx512bitalg -mno-avx512vpopcntdq -mno-gfni

# You shouldn't change these unless you really know what you're doing.

MY_NUMBER_C   = my_number.c
MY_NUMBER_O   = my_number.o
MY_NUMBER_EXE = my_number

LIBS          =

EXECUTABLE    = ${MY_NUMBER_EXE}
EXECUTABLES   = ${EXECUTABLE}

default:	${EXECUTABLES}

clean:		
	rm -f ${EXECUTABLES} *.[oadD] *.[mM][oO][dD]

${MY_NUMBER_EXE}:	${MY_NUMBER_O}
		${CC} ${CFLAGS} -o ${MY_NUMBER_EXE} ${MY_NUMBER_O} ${LIBS}

${MY_NUMBER_O}:		${MY_NUMBER_C}
		${CC} ${CFLAGS} -c ${MY_NUMBER_C}

