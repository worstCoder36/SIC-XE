%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<math.h>
    #include"data_structures.h"
    #include"data.h"
    int contF,endF,fd,opVal,i,opInfo,temp,startTRec,colCount=0,t1,t2,modIndex,colNotFull,reswF,resbF,byteF,wordF;
    char *loc;
    int modArr[10];
    char arr[15],listArr[30];
    char recArr[100];
    char tempRec[100];
%}

%%
"START" {
            fprintf(yyout,"H^%s^",Name);
            fprintf(yyout,"%06X^",startAddr);
            fprintf(yyout,"%06X^\n",progSize);
            LOCCTR = startAddr;
            colCount=0;
        }
"END"   {
                                if(colNotFull==1){
                                    fprintf(yyout,"%X^%s",colCount,recArr);
                                    colNotFull=0;
                                }
                                 for(i=0;i<modIndex;i++)                           
                                    fprintf(yyout,"\nM^%06X^05^",modArr[i]+1);            
                                    endF = 1;
        }
"X\'"[a-zA-Z0-9]+"\'"|"C\'"[a-zA-Z0-9]+"\'" {
                                            contF=0;
                                            if(strcmp(yytext,"X\'F1\'")==0){
                                                    LOCCTR += 1;
                                                    byteF = 0;
                                                }
                                                else{
                                                    LOCCTR += (yyleng-3);
                                                    byteF=0;
                                                }}
[a-zA-Z0-9\#\,\+]+   {
                    if(endF==1){
                             for(i=0;i<labelCount;i++){
                                        if(strcmp(yytext,tab[i].label)==0){
                                                temp = tab[i].val;
                                                break;
                                            }
                                        }
                            fprintf(yyout,"\nE^%06X^",temp);
                            endF=0;
                    
                    }
                else if((opVal=sOpTab(yytext))!=-1 && (opInfo = searchOpTab(yytext))>0){
                    t1 = opVal;
                    
                    t2 = opInfo;
                    if(strcmp(yytext,"RSUB")==0){
                        LOCCTR += opInfo;
                        temp = t1;
                        sprintf(tempRec,"%X0000^",temp|0x03);
                        strcat(recArr,tempRec);
                        contF=0;
                    }
                    else if(strcmp(yytext,"RESW")==0){
                    
                    contF = 1;
                        reswF = 1;                      
                    }
                    else if(strcmp(yytext,"RESB")==0){
                    
                    contF = 1;
                        resbF = 1;
                    }
                    else if(strcmp(yytext,"BYTE")==0){
                    
                    contF = 1;
                        byteF = 1;
                    }
                    else if(strcmp(yytext,"WORD")==0){
                    
                    contF = 1;
                        wordF = 1;
                    }
                    else{
                    
                    contF = 1;
                    LOCCTR += opInfo;
                    printf("%X\n",LOCCTR);
                    }
                    if(colCount>=59){
                        fprintf(yyout,"%X^%s",colCount,recArr); 
                        colCount = 0;
                        startTRec = LOCCTR;
                        colNotFull = 0;
                            strcpy(recArr,""); 
                    }
                    else{colNotFull = 1;}
                    if(colCount==0)
                        fprintf(yyout,"\nT^%06X^",startTRec);
                }
                else{
                    if(reswF==1){
                        LOCCTR += 3*(atoi(yytext));
                        reswF=0;
                        contF=0;                      
                    }
                    else if(resbF==1){
                        LOCCTR += atoi(yytext);
                        resbF=0;
                        contF=0;
                    }
                    
                    else if(wordF==1){
                        LOCCTR += 1;
                        wordF = 0;
                        contF=0;
                    }
                    else if(t2==0);
                    else if(yytext[0] == '#'){
                        temp = t1;
                        contF=0;
                        sprintf(tempRec,"%X0%03X^",temp|0x01,atoi(++yytext));
                        strcat(recArr,tempRec);
                        colCount +=6;
                    }
                   else if(t2==1){
                        
                        temp = t1;
                        contF=0;
                         sprintf(tempRec,"%-2X^",temp);
                         strcat(recArr,tempRec);
                        colCount += 2;
                    }
                   else if(t2 == 2 && yyleng==3){
                        temp = t1;
                        contF=0;
                        colCount += 4;
                        sprintf(tempRec,"%-2X%X%X^",temp,searchRegTab(yytext[0]),searchRegTab(yytext[2]));
                        strcat(recArr,tempRec);
                    }
                   else if(t2==2 && yyleng==1){
                        temp = t1;
                        contF=0;
                        colCount += 4;
                        sprintf(tempRec,"%-2X%02X^",temp,searchRegTab(yytext[0]));
                        strcat(recArr,tempRec);
                   }
                   else if(t2==3){
                        for(i=0;i<labelCount;i++){
                                if((strcmp(yytext,tab[i].label))==0 && contF==1){
                                 temp = t1;
                                  contF=0;
                                 break;
                                }
                            }
                            if((tab[i].val-LOCCTR)>0)
                            sprintf(tempRec,"%X2%03X^",temp|0x03,(tab[i].val-LOCCTR));
                            else
                            sprintf(tempRec,"%X2%03X^",temp|0x03,abs(tab[i].val-LOCCTR));
                            strcat(recArr,tempRec);
                        colCount += 6;
                    }
                   else if(t2==4){
                         for(i=0;i<labelCount;i++){
                            if((strcmp(yytext,tab[i].label))==0 && contF==1){
                             temp = t1;
                              contF=0;
                             break;
                            }
                        }
                        
                        sprintf(tempRec,"%-2X1%05X^",temp|0x03,tab[i].val);
                        strcat(recArr,tempRec);
                        modArr[modIndex++] = startTRec+(colCount/2);
                        colCount += 8;
                    }
                    
                    
               
             }
             }
\n  {contF=0;}
[ ]+    ;   
%%

main(){

yyout = fopen("obj.txt","w");
yyin = fopen("out.txt","r");
rd = fopen("in.txt","r");
wd = fopen("list.txt","w");
yylex();

}

int yywrap(){return 1;}
