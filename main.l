%{
/*libraries to be included and the variable to be declared*/  
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int check=0,isDate=0,isMonth=0,mindex=0,tempdate=0, tempyear=0;
char *monthslist[]={"","January", "Febuary", "March", "April", "May", "June", "July", "August","September", "October","November","December"};

%}

/* Rules Section*/

%%
  /* sentence beginning with capital letter */
[a-z] {
  if (check==0){
    fprintf(yyout,"%c",yytext[0]-32);
    check=1;
  }
};

([\.]+[a-z]) {
  fprintf(yyout,"%c%c",yytext[0],yytext[1]-32); /* 'a' - 'A' = 97 - 65 = 32 */
};

([\.]+[ ]+[a-z]) {
  fprintf(yyout,"%c %c",yytext[0],yytext[2]-32);
};

  /* all the cases that handles hyphen date cases */
([0-9][0-9])\-([0-9][0-9])\-([0-9][0-9][0-9][0-9]) {
  fprintf(yyout,"%s %c%c, %c%c%c%c",monthslist[(int)((yytext[3])-48)*10+(int)((yytext[4])-48)],yytext[0],yytext[1],yytext[6],yytext[7],yytext[8],yytext[9]);
};

([0-9])\-([0-9][0-9])\-([0-9][0-9][0-9][0-9]) {
  fprintf(yyout,"%s 0%c, %c%c%c%c",monthslist[(int)((yytext[2])-48)*10+(int)((yytext[3])-48)],yytext[0],yytext[5],yytext[6],yytext[7],yytext[8]);
};

([0-9][0-9])\-([0-9])\-([0-9][0-9][0-9][0-9]) {
  fprintf(yyout,"%s %c%c, %c%c%c%c",monthslist[(int)yytext[3]-48],yytext[0],yytext[1],yytext[5],yytext[6],yytext[7],yytext[8]);
};

([0-9])\-([0-9])\-([0-9][0-9][0-9][0-9]) {
  fprintf(yyout, "%s 0%c, %c%c%c%c",monthslist[(int)(yytext[2])-48],yytext[0],yytext[4],yytext[5],yytext[6],yytext[7]);
};

([0-9][0-9])\-([0-9][0-9])\-([0-9][0-9]) {
  if (yytext[6]>2){
    fprintf(yyout,"%s %c%c, 19%c%c",monthslist[(int)((yytext[3])-48)*10+(int)((yytext[4])-48)],yytext[0],yytext[1],yytext[6],yytext[7]);
  }
  else
    fprintf(yyout,"%s %c%c, 20%c%c",monthslist[(int)((yytext[3])-48)*10+(int)((yytext[4])-48)],yytext[0],yytext[1],yytext[6],yytext[7]);
};

([0-9])\-([0-9][0-9])\-([0-9][0-9]) {
  if (yytext[5]>2){
    fprintf(yyout,"%s 0%c, 19%c%c",monthslist[(int)((yytext[2])-48)*10+(int)((yytext[3])-48)],yytext[0],yytext[5],yytext[6]);
  }
  else
  fprintf(yyout,"%s 0%c, 20%c%c",monthslist[(int)((yytext[2])-48)*10+(int)((yytext[3])-48)],yytext[0],yytext[5],yytext[6]);
};

([0-9][0-9])\-([0-9])\-([0-9][0-9]) {
  if (yytext[5]>2){
    fprintf(yyout, "%s %c%c, 19%c%c",monthslist[(int)yytext[3]-48],yytext[0],yytext[1],yytext[5],yytext[6]);
  }
  else
    fprintf(yyout,"%s %c%c, 20%c%c",monthslist[(int)yytext[3]-48],yytext[0],yytext[1],yytext[5],yytext[6]);
};

  /* changed 2 digit tempyear to 4 digit */

([0-9])\-([0-9])\-([0-9][0-9]) {

  if (yytext[4]>2) {
    fprintf(yyout, "%s 0%c, 19%c%c",monthslist[(int)(yytext[2])-48],yytext[0],yytext[4],yytext[5]);
  }
  else
    fprintf(yyout, "%s 0%c, 20%c%c",monthslist[(int)(yytext[2])-48],yytext[0],yytext[4],yytext[5]);
};
  
("Jan"|"Feb"|"Mar"|"Apr"|"May"|"Jun"|"Jul"|"Aug"|"Sep"|"Oct"|"Nov"|"Dec") {
  for (int i=1;i<=12;i++){
    if (yytext[0]==monthslist[i][0] && yytext[1]==monthslist[i][1] && yytext[2]==monthslist[i][2]){
      mindex=i;
    }
  }
  
  fprintf(yyout,"%s ",monthslist[mindex]);
};

([0-9])("st"|"nd"|"rd"|"th") {
  tempdate=(int)((yytext[0])-48);
  
  fprintf(yyout, "0%d, ",tempdate);
};

([0-9][0-9])+("st"|"nd"|"rd"|"th")+[\.]+[ ]+([A-Z]) {
  tempdate=(int)((yytext[0])-48)*10+(int)((yytext[1])-48);
  
  fprintf(yyout,"%d, 2021",tempdate);
};

([0-9][0-9])+("st"|"nd"|"rd"|"th") {
  tempdate=(int)((yytext[0])-48)*10+(int)((yytext[1])-48);
  
  fprintf(yyout,"%d, ",tempdate);
};

([0-9][0-9]) {
  tempyear=(int)((yytext[0]-48)*10) + (int)(yytext[1]-48);
  
    if (tempyear>21)
      fprintf(yyout,"19%d",tempyear);
    else
      fprintf(yyout,"20%d",tempyear);
};

([a-zA-Z0-9\'\"]*) {
  if (check==0 && yytext[0]>='a' && yytext[0]<='z'){
    yytext[0] = yytext[0]-32;
    check=1;
  }
  else check=1;
  if (isDate==1 && isMonth==1){
    if (yytext[0]<'0' || yytext[0]>'9'){
    fprintf(yyout,"2021 ");
    }
    isDate=0;
    isMonth=0;
  }
  fprintf(yyout,"%s",yytext);
}

[\n]+   {
  fprintf(yyout, "\n\n\t");
  check=0;
}
%%


int main()
{   
	extern FILE *yyin, *yyout;
  yyin = fopen("input.txt", "r");
  yyout = fopen("output.txt", "w");
  yylex (); 

	return 0;
}
int yywrap()
{
  return 1;
}
