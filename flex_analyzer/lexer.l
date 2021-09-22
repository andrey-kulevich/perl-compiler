%option noyywrap
%option never-interactive
%option yylineno

%{
	#include <stdio.h>
    #include <string.h>

    void remove_char_from_str(const char * str, char * dest, char deleted_char);
    int binstr_to_dec(const char * str);
    void print_token(const char * token, const char * token_type, int line);
%}

WHITESPACE      [ \t\r]
NEXTLINE        [\n]
DIGIT [0-9]
HEX_DIGIT [0-9A-Fa-f]
OCT_DIGIT [0-7]
BIN_DIGIT [01]
EXPONENT [eE][+-]?[1-9]{DIGIT}*(_{DIGIT}+)*
NUMBER_ALPHA_UNDERSCOPE [a-zA-Z0-9_]*

%x ML_COMMENT
%x STRING 
%x SYMBOL

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

__DATA__    { print_token(yytext, "SELFLOADER_START_KEYWORD", yylineno); }
__END__     { print_token(yytext, "SELFLOADER_END_KEYWORD", yylineno); }
__FILE__    { print_token(yytext, "CURRENT_FILENAME_KEYWORD", yylineno); }
__LINE__    { print_token(yytext, "CURRENT_LINE_KEYWORD", yylineno); }
__PACKAGE__ { print_token(yytext, "CURRENT_PACKAGE_KEYWORD", yylineno); }
and         { print_token(yytext, "AND_KEYWORD", yylineno); }
cmp         { print_token(yytext, "COMPARISON_KEYWORD", yylineno); }
continue    { print_token(yytext, "CONTINUE_KEYWORD", yylineno); }
CORE        { print_token(yytext, "CORE_KEYWORD", yylineno); }
do          { print_token(yytext, "DO_KEYWORD", yylineno); }
else        { print_token(yytext, "ELSE_KEYWORD", yylineno); }
elsif       { print_token(yytext, "ELSIF_KEYWORD", yylineno); }
eq          { print_token(yytext, "EQ_KEYWORD", yylineno); }
exp         { print_token(yytext, "EXP_KEYWORD", yylineno); }
for         { print_token(yytext, "FOR_KEYWORD", yylineno); }
foreach     { print_token(yytext, "FOREACH_KEYWORD", yylineno); }
given       { print_token(yytext, "GIVEN_KEYWORD", yylineno); }
ge          { print_token(yytext, "GE_KEYWORD", yylineno); }
gt          { print_token(yytext, "GT_KEYWORD", yylineno); }
if          { print_token(yytext, "IF_KEYWORD", yylineno); }
last        { print_token(yytext, "LAST_KEYWORD", yylineno); }
le          { print_token(yytext, "LE_KEYWORD", yylineno); }
lock        { print_token(yytext, "LOCK_KEYWORD", yylineno); }
It          { print_token(yytext, "IT_KEYWORD", yylineno); }
my          { print_token(yytext, "MY_KEYWORD", yylineno); }
m           { print_token(yytext, "M_KEYWORD", yylineno); }
ne          { print_token(yytext, "NE_KEYWORD", yylineno); }
next        { print_token(yytext, "NEXT_KEYWORD", yylineno); }
no          { print_token(yytext, "NO_KEYWORD", yylineno); }
or          { print_token(yytext, "OR_KEYWORD", yylineno); }
package     { print_token(yytext, "PACKAGE_KEYWORD", yylineno); }
q           { print_token(yytext, "Q_KEYWORD", yylineno); }
qq          { print_token(yytext, "QQ_KEYWORD", yylineno); }
qr          { print_token(yytext, "QR_KEYWORD", yylineno); }
qw          { print_token(yytext, "QW_KEYWORD", yylineno); }
qx          { print_token(yytext, "QX_KEYWORD", yylineno); }
s           { print_token(yytext, "S_KEYWORD", yylineno); }
sub         { print_token(yytext, "SUB_KEYWORD", yylineno); }
tr          { print_token(yytext, "TR_KEYWORD", yylineno); }
unless      { print_token(yytext, "UNLESS_KEYWORD", yylineno); }
until       { print_token(yytext, "UNTIL_KEYWORD", yylineno); }
while       { print_token(yytext, "WHILE_KEYWORD", yylineno); }
when        { print_token(yytext, "WHEN_KEYWORD", yylineno); }
xor         { print_token(yytext, "XOR_KEYWORD", yylineno); }
y           { print_token(yytext, "Y_KEYWORD", yylineno); }

"->"        { print_token(yytext, "DEREFERENCING_OP", yylineno); }
"++"        { print_token(yytext, "INCREMENT_OP", yylineno); }
"--"        { print_token(yytext, "DECREMENT_OP", yylineno); }
"**"        { print_token(yytext, "POW_OP", yylineno); }
"!"         { print_token(yytext, "INVERSION_OP", yylineno); }
"~"         { print_token(yytext, "BIN_INVERSION_OP", yylineno); }
"+"         { print_token(yytext, "ADD_OP", yylineno); }   
"-"         { print_token(yytext, "SUB_OP", yylineno); }
"=~"        { print_token(yytext, "BIN_BINDING_OP", yylineno); }
"!~"        { print_token(yytext, "NOT_BIN_BINDING_OP", yylineno); }
"<>"        { print_token(yytext, "READ_INPUT_OP", yylineno); }
"=="        { print_token(yytext, "EQL_OP", yylineno); }
"<="        { print_token(yytext, "LESS_OR_EQL_OP", yylineno); }
">="        { print_token(yytext, "GREATER_OR_EQL_OP", yylineno); }
"<=>"       { print_token(yytext, "COMB_COMPRASION_OP", yylineno); }
"&"         { print_token(yytext, "BIN_AND_OP", yylineno); }
"|"         { print_token(yytext, "BIN_OR_OP", yylineno); }
"^"         { print_token(yytext, "BIN_XOR_OP", yylineno); }
"&&"        { print_token(yytext, "AND_OP", yylineno); }
"||"        { print_token(yytext, "OR_OP", yylineno); }
".."        { print_token(yytext, "RANGE_OP", yylineno); }
"?:"        { print_token(yytext, "TERNAR_OP", yylineno); }
"="         { print_token(yytext, "ASSIGN_OP", yylineno); }
"+="        { print_token(yytext, "ADD_ASSIGN_OP", yylineno); }
"-="        { print_token(yytext, "SUB_ASSIGN_OP", yylineno); }
"*="        { print_token(yytext, "MUL_ASSIGN_OP", yylineno); }
"**="       { print_token(yytext, "POW_ASSIGN_OP", yylineno); }
".="        { print_token(yytext, "CONCAT_ASSIGN_OP", yylineno); }
"/="        { print_token(yytext, "DIV_ASSIGN_OP", yylineno); }
"%="        { print_token(yytext, "MOD_ASSIGN_OP", yylineno); }
"x="        { print_token(yytext, "REPEATE_ASSIGN_OP", yylineno); }
"&="        { print_token(yytext, "BIN_AND_ASSIGN_OP", yylineno); }
"|="        { print_token(yytext, "BIN_OR_ASSIGN_OP", yylineno); }
"^="        { print_token(yytext, "BIN_XOR_ASSIGN_OP", yylineno); }
"<<="       { print_token(yytext, "BIN_SHIFT_LEFT_ASSIGN_OP", yylineno); }
">>="       { print_token(yytext, "BIN_SHIFT_RIGHT_ASSIGN_OP", yylineno); }
"&&="       { print_token(yytext, "AND_ASSIGN_OP", yylineno); }
"||="       { print_token(yytext, "OR_ASSIGN_OP", yylineno); }
","         { print_token(yytext, "COMMA_OP", yylineno); }
"=>"        { print_token(yytext, "ARROW_COMMA_OP", yylineno); }
"\\"        { print_token(yytext, "VAR_REFERENCE_OP", yylineno); }
"*"         { print_token(yytext, "ARITHMETIC_MUL_OP", yylineno); }
"/"         { print_token(yytext, "ARITHMETIC_DIV_OP", yylineno); }
"%"         { print_token(yytext, "ARITHMETIC_MOD_OP", yylineno); }
"x"         { print_token(yytext, "REPEATE_OP", yylineno); }
"<<"        { print_token(yytext, "BIN_SHIFT_LEFT_OP", yylineno); }
">>"        { print_token(yytext, "BIN_SHIFT_RIGHT_OP", yylineno); }
">"         { print_token(yytext, "GREATER_OP", yylineno); }
"<"         { print_token(yytext, "LESS_OP", yylineno); }
"!="        { print_token(yytext, "NOT_EQL_OP", yylineno); }
"\'"        { print_token(yytext, "QUOTE_OP", yylineno); }
"\""        { print_token(yytext, "DOUBLE_QUOTE_OP", yylineno); }
"\`"        { print_token(yytext, "PRIME_QUOTE_OP", yylineno); }
"["         { print_token(yytext, "OPEN_SQUARE_BRACKET", yylineno); }
"]"         { print_token(yytext, "CLOSE_SQUARE_BRACKET", yylineno); }
"("         { print_token(yytext, "OPEN_ROUND_BRACKET", yylineno); }
")"         { print_token(yytext, "CLOSE_ROUND_BRACKET", yylineno); }
"{"         { print_token(yytext, "OPEN_CURLY_BRACKET", yylineno); }
"}"         { print_token(yytext, "CLOSE_CURLY_BRACKET", yylineno); }
";"         { print_token(yytext, "SEMICOLON", yylineno); }
":"         { print_token(yytext, "COLON", yylineno); }
\n          { print_token("\\n", "NEW_LINE", yylineno); }

\"          { 
                print_token("\"", "START_OF_STRING", yylineno);
                string[0] = 0; 
                BEGIN(STRING);    
            }
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
<STRING>\\{OCT_DIGIT}{1,3}      { 
                                    sscanf(yytext + 1, "%o", &num);
                                    temp1[0] = (char) num;
                                    temp1[1] = 0;
                                    strcat(string, temp1);
                                }

<STRING>\\x{HEX_DIGIT}{1,2}     { 
                                    sscanf(yytext + 2, "%x", &num);
                                    temp1[0] = (char) num;
                                    temp1[1] = 0;
                                    strcat(string, temp1);
                                }
<STRING>\\x[^0-9A-Fa-f\n"}]*    { printf("ERROR: Invalid hex escape \n"); }
<STRING>\"                      { 
                                    print_token("\"", "END_OF_STRING", yylineno);
                                    BEGIN(INITIAL);
                                }
<STRING>\n                      { printf("ERROR: expected\" \n"); }
<STRING><<EOF>>                 { printf("ERROR: expected\" \n"); }

0|[1-9]{DIGIT}*(_{DIGIT}+)*         { 
                                        remove_char_from_str(yytext,temp1,'_');
                                        num = atoi(temp1);
                                        print_token(temp1, "DECIMAL", yylineno);
                                    }

[1-9](_*{DIGIT}+)*_*   { print_token(yytext, "INVALID_DECIMAL", yylineno); }

0[dD][1-9]{DIGIT}*(_{DIGIT}+)*      {
                                        remove_char_from_str(yytext+2,temp1,'_');
                                        num = atoi(temp1);
                                        print_token(temp1, "DECIMAL", yylineno);       
                                    }

0_*[dD]_*[1-9](_*{DIGIT}+)*_*       { print_token(yytext, "INVALID_DECIMAL", yylineno); }

0[oO]?{OCT_DIGIT}+(_{OCT_DIGIT}+)*  {
                                        remove_char_from_str(yytext,temp1,'_');
                                        remove_char_from_str(temp1,temp2,'o');
                                        remove_char_from_str(temp2,temp1,'O');
                                        sscanf(temp1,"%o",&num);
                                        print_token(temp1, "OCTAL", yylineno);
                                    }

0_*[oO]?_*{OCT_DIGIT}(_*{OCT_DIGIT}+)*_* { print_token(yytext, "INVALID_OCTAL", yylineno); }

0[xX]{HEX_DIGIT}+(_{HEX_DIGIT}+)*   {
                                        remove_char_from_str(yytext + 2,temp1,'_');
                                        sscanf(temp1,"%x",&num);
                                        print_token(temp1, "HEX", yylineno);
                                    }

0_*[xX]_*{HEX_DIGIT}(_*{HEX_DIGIT}+)*_* { print_token(yytext, "INVALID_HEX", yylineno); }

0[bB]{BIN_DIGIT}+(_{BIN_DIGIT}+)*   {
                                        remove_char_from_str(yytext + 2,temp1,'_');
                                        num = binstr_to_dec(temp1);
                                        print_token(temp1, "BIN", yylineno); 
                                    }

0_*[bB]_*{BIN_DIGIT}(_*{BIN_DIGIT}+)*_* { print_token(yytext, "INVALID_BIN", yylineno); }


(0|[1-9](_?{DIGIT})*)(\.{DIGIT}+(_{DIGIT}+)*)?({EXPONENT})? {
                                                                remove_char_from_str(yytext,temp1,'_');
                                                                real_num = atof(temp1);
                                                                print_token(temp1, "FLOAT", yylineno); 
                                                            }

([1-9]*_*(\.|\.{3,})_*{DIGIT}+)+(_*{DIGIT}*)*           { print_token(yytext, "INVALID_FLOAT", yylineno); }

([1-9]+((_|\.)*{DIGIT}*)*[Ee]+((_|\.)*{DIGIT}*)*)+      { print_token(yytext, "INVALID_FLOAT", yylineno); }

\$[a-z_]{NUMBER_ALPHA_UNDERSCOPE}       { print_token(yytext + 1, "SCALAR_VARIABLE", yylineno); }
\@[a-z_]{NUMBER_ALPHA_UNDERSCOPE}       { print_token(yytext + 1, "ARRAY_VARIABLE", yylineno); }
\%[a-z_]{NUMBER_ALPHA_UNDERSCOPE}       { print_token(yytext + 1, "HASH_VARIABLE", yylineno); }

#.*                                     { print_token(yytext + 1, "SL_COMMENT", yylineno); }

^=a                                     { 
                                            comment[0] = 0; 
                                            BEGIN(ML_COMMENT);
                                        }

<ML_COMMENT>^=cut.*                     {
                                            strcat(comment, yytext + 5);
                                            print_token(yytext + 1, "ML_COMMENT", yylineno);
                                            BEGIN(INITIAL);
                                        }

<ML_COMMENT>.*                          { strcat(comment, yytext); }

[A-Z]{NUMBER_ALPHA_UNDERSCOPE}          { printf("Found class name %s\n", yytext); }

%% 

void print_token(const char * token, const char * token_type, int line) {
    printf("%s\t%s\t%d\n", token, token_type, line);
}

void remove_char_from_str(const char * str, char * dest, char deleted_char) {
    int j = 0;
    for(int i = 0; str[i] != 0; i++) {
        if(str[i] != deleted_char) dest[j++] = str[i];
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

void main(int argc, char **argv ) {
    yyin = fopen(argv[1], "r");
    yylex();
    return;
}
