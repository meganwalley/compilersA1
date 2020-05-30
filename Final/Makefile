CC=g++
CCFLAGS=-g -W -Wall

FLEX=flex
FLEX_OPTS=-Pcpp

BISON=bison
BISON_OPTS=-t -pcpp

OBJS=Absyn.o Lexer.o Parser.o Printer.o

.PHONY : clean distclean

all : Testcpp

clean :
	rm -f *.o Testcpp cpp.aux cpp.log cpp.pdf cpp.dvi cpp.ps cpp

distclean : clean
	rm -f Absyn.C Absyn.H Test.C Parser.C Parser.H Lexer.C Skeleton.C Skeleton.H Printer.C Printer.H Makefile cpp.l cpp.y cpp.tex

Testcpp : ${OBJS} Test.o
	@echo "Linking Testcpp..."
	${CC} ${CCFLAGS} ${OBJS} Test.o -o Testcpp

Absyn.o : Absyn.C Absyn.H
	${CC} ${CCFLAGS} -c Absyn.C

Lexer.C : cpp.l
	${FLEX} -oLexer.C cpp.l

Parser.C : cpp.y
	${BISON} cpp.y -o Parser.C

Lexer.o : Lexer.C Parser.H
	${CC} ${CCFLAGS} -c Lexer.C

Parser.o : Parser.C Absyn.H
	${CC} ${CCFLAGS} -c Parser.C

Printer.o : Printer.C Printer.H Absyn.H
	${CC} ${CCFLAGS} -c Printer.C

Skeleton.o : Skeleton.C Skeleton.H Absyn.H
	${CC} ${CCFLAGS} -Wno-unused-parameter -c Skeleton.C

Test.o : Test.C Parser.H Printer.H Absyn.H
	${CC} ${CCFLAGS} -c Test.C
