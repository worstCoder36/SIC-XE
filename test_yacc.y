%{
	#include<stdio.h>
	extern int yylex();
	extern FILE *yyin;
	extern FILE *yyout;
	extern int yylineno;
	extern int lineNum;
	FILE *datafile;
%}

%token LB STR NUM WS NL OP END SLB RW RB BE CL
%%	
STMT:  X  	
S : STR WS NUM
 |
 ;
B : LB WS OP WS LB
 | LB WS OP WS NUM
 | OP WS LB
 | OP WS NUM
 | LB WS OP WS SLB
 | OP WS SLB
 | END WS LB
 | END
 | END WS SLB
 | SLB WS OP WS SLB
 | SLB WS OP WS LB
 | SLB WS OP WS NUM
 | SLB WS OP
 | OP
 | SLB BE
 | RW
 | RB
 | BE
 | SLB RW
 | SLB RB
 | LB RB
 | LB RW
 | LB CL
 | CL
 | SLB CL
 | WS LB WS OP WS LB
 | WS LB WS OP WS NUM
 | WS OP WS LB
 | WS OP WS NUM
 | WS LB WS OP WS SLB
 | WS OP WS SLB
 | WS END WS LB
 | WS END
 | WS END WS SLB
 | WS RW
 | WS RB
 | WS BE
 | WS LB CL
 | WS CL
 | WS SLB CL
 | WS SLB RW
 | WS SLB RB
 | WS LB RB
 | WS LB RW
 | WS SLB WS OP WS SLB
 | WS SLB WS OP WS LB
 | WS SLB WS OP WS NUM
 | WS SLB WS OP
 | WS OP
 | WS SLB BE
 | 
 ;
X: S NL X
 | B NL X
 | 
;
%%


int main(){
FILE *myfile = fopen("in.txt","r");
FILE *outfile = fopen("out.txt","w");
datafile = fopen("data.h","w");
yyin = myfile;
yyout = outfile;
yyparse();
}
int yyerror(){
printf("error.%d\n%d\n",yylineno,lineNum);
}
