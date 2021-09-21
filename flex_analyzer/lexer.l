%option noyywrap
%option never-interactive
%option yylineno

%{
	#include <stdio.h>

    void remove_char_from_str(const char * str, char * dest, char deleted_char);
    int binstr_to_dec(const char * str);
    void print_token(const char * token_type, int line);
%}

DIGIT [0-9]
HEX_DIGIT [0-9A-Fa-f]
OCT_DIGIT [0-7]
BIN_DIGIT [01]
EXPONENT [eE][+-]?[1-9]{DIGIT}*(_{DIGIT}+)*
NUMBER_ALPHA_UNDERSCOPE [a-zA-Z0-9_]

%x ML_COMMENT
%x STRING

%% 

%{
    int num;
    float real_num;
    char temp1[100];
    char temp2[100];
    char comment[1000];
    char string[1000];
    int nestingCount = 0;
%}

__DATA__    { print_token("SELFLOADER_START_KEYWORD", yylineno); }
__END__     { print_token("SELFLOADER_END_KEYWORD", yylineno); }
__FILE__    { print_token("CURRENT_FILENAME_KEYWORD", yylineno); }
__LINE__    { print_token("CURRENT_LINE_KEYWORD", yylineno); }
__PACKAGE__ { print_token("CURRENT_PACKAGE_KEYWORD", yylineno); }
and         { print_token("AND_KEYWORD", yylineno); }
cmp         { print_token("COMPARISON_KEYWORD", yylineno); }
continue    { print_token("CONTINUE_KEYWORD", yylineno); }
CORE        { print_token("CORE_KEYWORD", yylineno); }
do          { print_token("DO_KEYWORD", yylineno); }
else        { print_token("ELSE_KEYWORD", yylineno); }
elsif       { print_token("ELSIF_KEYWORD", yylineno); }
eq          { print_token("EQ_KEYWORD", yylineno); }
exp         { print_token("EXP_KEYWORD", yylineno); }
for         { print_token("FOR_KEYWORD", yylineno); }
foreach     { print_token("FOREACH_KEYWORD", yylineno); }
ge          { print_token("GE_KEYWORD", yylineno); }
gt          { print_token("GT_KEYWORD", yylineno); }
if          { print_token("IF_KEYWORD", yylineno); }
le          { print_token("LE_KEYWORD", yylineno); }
lock        { print_token("LOCK_KEYWORD", yylineno); }
It          { print_token("IT_KEYWORD", yylineno); }
m           { print_token("M_KEYWORD", yylineno); }
ne          { print_token("NE_KEYWORD", yylineno); }
no          { print_token("NO_KEYWORD", yylineno); }
or          { print_token("OR_KEYWORD", yylineno); }
package     { print_token("PACKAGE_KEYWORD", yylineno); }
q           { print_token("Q_KEYWORD", yylineno); }
qq          { print_token("QQ_KEYWORD", yylineno); }
qr          { print_token("QR_KEYWORD", yylineno); }
qw          { print_token("QW_KEYWORD", yylineno); }
qx          { print_token("QX_KEYWORD", yylineno); }
s           { print_token("S_KEYWORD", yylineno); }
sub         { print_token("SUB_KEYWORD", yylineno); }
tr          { print_token("TR_KEYWORD", yylineno); }
unless      { print_token("UNLESS_KEYWORD", yylineno); }
until       { print_token("UNTIL_KEYWORD", yylineno); }
while       { print_token("WHILE_KEYWORD", yylineno); }
xor         { print_token("XOR_KEYWORD", yylineno); }
y           { print_token("Y_KEYWORD", yylineno); }

"->"        { print_token("REFERENCE_OP", yylineno); }
"++"        { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"--"        { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"**"        { print_token("ARITHMETIC_POW_OP", yylineno); }
"!"         { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"~"         { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"+"         { printf("Found ARITHMETIC_PLUS_OP\n"); }   
"-"         { printf("Found ARITHMETIC_MINUS_OP\n"); }
"=~"        { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"!~"        { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"<>"        { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"=="        { print_token("EQL_OP", yylineno); }
"<="        { print_token("LESS_OR_EQL_OP", yylineno); }
">="        { print_token("GREATER_OR_EQL_OP", yylineno); }
"<=>"       { print_token("COMB_COMPRASION_OP", yylineno); }
"&"         { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"|"         { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"^"         { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"&&"        { print_token("AND_OP", yylineno); }
"||"        { print_token("OR_OP", yylineno); }
".."        { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"?:"        { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"="         { print_token("ASSIGN_OP", yylineno); }
"+="        { print_token("ADD_ASSIGN_OP", yylineno); }
"-="        { print_token("SUB_ASSIGN_OP", yylineno); }
"*="        { print_token("MUL_ASSIGN_OP", yylineno); }
"**="       { print_token("POW_ASSIGN_OP", yylineno); }
".="        { print_token("CONCAT_ASSIGN_OP", yylineno); }
"/="        { print_token("DIV_ASSIGN_OP", yylineno); }
"%="        { print_token("MOD_ASSIGN_OP", yylineno); }
"x="        { print_token("REPEATE_ASSIGN_OP", yylineno); }
"&="        { print_token("BIN_AND_ASSIGN_OP", yylineno); }
"|="        { print_token("BIN_OR_ASSIGN_OP", yylineno); }
"^="        { print_token("BIN_XOR_ASSIGN_OP", yylineno); }
"<<="       { print_token("BIN_SHIFT_LEFT_ASSIGN_OP", yylineno); }
">>="       { print_token("BIN_SHIFT_RIGHT_ASSIGN_OP", yylineno); }
"&&="       { print_token("AND_ASSIGN_OP", yylineno); }
"||="       { print_token("OR_ASSIGN_OP", yylineno); }
","         { print_token("COMMA_OP", yylineno); }
"=>"        { print_token("ARROW_COMMA_OP", yylineno); }
"\\"         { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"*"         { print_token("ARITHMETIC_MUL_OP", yylineno); }
"/"         { print_token("ARITHMETIC_DIV_OP", yylineno); }
"%"         { print_token("ARITHMETIC_MOD_OP", yylineno); }
"x"         { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"<<"        { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
">>"        { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
">"         { print_token("GREATER_OP", yylineno); }
"<"         { print_token("LESS_OP", yylineno); }
"!="        { print_token("NOT_EQL_OP", yylineno); }
"\'"        { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"\""        { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"\`"        { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"//"        { print_token("ACCESS_ATTRIBUTE_OP", yylineno); }
"["         { print_token("OPEN_SQUARE_BRACKET", yylineno); }
"]"         { print_token("CLOSE_SQUARE_BRACKET", yylineno); }
"("         { print_token("OPEN_ROUND_BRACKET", yylineno); }
")"         { print_token("CLOSE_ROUND_BRACKET", yylineno); }
"{"         { printf("Found OPEN_CURLY_BRACKET\n"); }
"}"         {
                if(nestingCount == 0) {
                    printf("Found CLOSE_CURLY_BRACKET\n");
                } else {
                    nestingCount--;
                    BEGIN(STRING);
                    string[0] = 0;
                    printf("Found ARITHMETIC_PLUS_OP\n");
                }
            }
";"         { print_token("SEMICOLON", yylineno); }
":"         { print_token("COLON", yylineno); }

\"          { 
                string[0] = 0; 
                BEGIN(STRING);    
            }

<STRING>"#{"        { 
                        printf("Found string %s\n", string);
                        printf("Found ARITHMETIC_PLUS_OP\n");
                        nestingCount++;
                        BEGIN(INITIAL);
                    }
<STRING>[^\\\"\n#{}]+ { strcat(string, yytext); }
<STRING>[#{}]      { strcat(string, yytext); }
<STRING>\\n        { strcat(string, "\n"); }
<STRING>\\a        { strcat(string, "\a"); }
<STRING>\\b        { strcat(string, "\b"); }
<STRING>\\t        { strcat(string, "\t"); }
<STRING>\\v        { strcat(string, "\v"); }
<STRING>\\f        { strcat(string, "\f"); }
<STRING>\\r        { strcat(string, "\r"); }
<STRING>\\e        { strcat(string, "\e"); }
<STRING>\\s        { strcat(string, " "); }
<STRING>\\\\       { strcat(string, "\\"); }
<STRING>\\\"       { strcat(string, "\""); }
<STRING>\\{OCT_DIGIT}{1,3} { 
                                sscanf(yytext + 1, "%o", &num);
                                temp1[0] = (char) num;
                                temp1[1] = 0;
                                strcat(string, temp1);
                            }

<STRING>\\x{HEX_DIGIT}{1,2} { 
                                sscanf(yytext + 2, "%x", &num);
                                temp1[0] = (char) num;
                                temp1[1] = 0;
                                strcat(string, temp1);
                            }
<STRING>\\x[^0-9A-Fa-f\n"}]*       { printf("ERROR: Invalid hex escape \n"); }

<STRING>\" { 
                printf("Found string %s \n", string);
                BEGIN(INITIAL);
            }
<STRING>\n { printf("ERROR: expected\" \n");}
<STRING><<EOF>> { printf("ERROR: expected\" \n"); }

0|[1-9]{DIGIT}*(_{DIGIT}+)*          { 
                                remove_char_from_str(yytext,temp1,'_');
                                num = atoi(temp1);
                                printf("Found decimal number %d\n", num);
                             }

[1-9](_*{DIGIT}+)*_*   { printf("Found decimal number error1 %s\n", yytext); }

0[dD][1-9]{DIGIT}*(_{DIGIT}+)*        {
                                remove_char_from_str(yytext+2,temp1,'_');
                                num = atoi(temp1);
                                printf("Found decimal number %d\n", num);              
                             }

0_*[dD]_*[1-9](_*{DIGIT}+)*_* { printf("Found decimal number error2 %s\n", yytext); }

0[oO]?{OCT_DIGIT}+(_{OCT_DIGIT}+)*    {
                                        remove_char_from_str(yytext,temp1,'_');
                                        remove_char_from_str(temp1,temp2,'o');
                                        remove_char_from_str(temp2,temp1,'O');
                                        sscanf(temp1,"%o",&num);
                                        printf("Found octal number %d\n", num);
                                     }

0_*[oO]?_*{OCT_DIGIT}(_*{OCT_DIGIT}+)*_* { printf("Found oct number error %s\n", yytext); }

0[xX]{HEX_DIGIT}+(_{HEX_DIGIT}+)*    {
                                        remove_char_from_str(yytext + 2,temp1,'_');
                                        sscanf(temp1,"%x",&num);
                                        printf("Found hex number %d\n", num);
                                    }

0_*[xX]_*{HEX_DIGIT}(_*{HEX_DIGIT}+)*_* { printf("Found hex number error %s\n", yytext); }

0[bB]{BIN_DIGIT}+(_{BIN_DIGIT}+)*   {
                                        remove_char_from_str(yytext + 2,temp1,'_');
                                        num = binstr_to_dec(temp1);
                                        printf("Found binary number %d\n", num); 
                                    }

0_*[bB]_*{BIN_DIGIT}(_*{BIN_DIGIT}+)*_* { printf("Found bin number error %s\n", yytext); }



(0|[1-9](_?{DIGIT})*)(\.{DIGIT}+(_{DIGIT}+)*)?({EXPONENT})?  {
                                                                 remove_char_from_str(yytext,temp1,'_');
                                                                 real_num = atof(temp1);
                                                                 printf("Found float number %f\n", real_num); 
                                                            }

([1-9]*_*(\.|\.{3,})_*{DIGIT}+)+(_*{DIGIT}*)*     { printf("Found float number error1 %s\n", yytext); }

([1-9]+((_|\.)*{DIGIT}*)*[Ee]+((_|\.)*{DIGIT}*)*)+     { printf("Found float number error2 %s\n", yytext); }



#.*             { printf("Found single-line comment: %s\n", yytext + 1); }

^=begin                         { 
                                    // printf("Foun start ml-comment");
                                    comment[0] = 0; 
                                    BEGIN(ML_COMMENT);
                                }

<ML_COMMENT>^=end.*             {
                                    strcat(comment, yytext + 5);
                                    printf("Found multi-line comment: %s\n", comment);
                                    BEGIN(INITIAL);
                                }

<ML_COMMENT>.*                  { 
                                    strcat(comment, yytext); 
                                }

[a-z_]{NUMBER_ALPHA_UNDERSCOPE}*             {
                                                printf("Found local variable or method name %s\n", yytext);
                                             }
\@[a-z_]{NUMBER_ALPHA_UNDERSCOPE}*                      {
                                                             printf("Found instance variable %s\n", yytext);
                                                        }
\@\@[a-z_]{NUMBER_ALPHA_UNDERSCOPE}*         {
                                                 printf("Found class variable %s\n", yytext);
                                             }

[A-Z]{NUMBER_ALPHA_UNDERSCOPE}*            {
                                                printf("Found class name %s\n", yytext);
                                           }

\n      { //printf("Found new line\n"); 
        }
%% 

%{

    void print_token(const char * token_type) {
        printf("Found %s in line %d\n", token_type, yylineno);
    }

    void remove_char_from_str(const char * str, char * dest, char deleted_char) {
        int j = 0;
        
        for(int i = 0; str[i] != 0; i++) {
            if(str[i] != deleted_char) {
                dest[j++] = str[i];
            }
        }

        dest[j] = 0;
    }

    int binstr_to_dec(const char * str) {
        unsigned char *p = str;
        unsigned int   r = 0;

        while (p && *p ) {
            r <<= 1;
            r += (unsigned int)((*p++) & 0x01);
        }

        return (int) r;
    }

    void main(int argc, char **argv ){
        yyin = fopen(argv[1], "r" );

        yylex();
        return;
    }

%}