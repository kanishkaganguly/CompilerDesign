DIG			[0-9]
LETTERS		[a-zA-Z_]
HEX			[a-fA-F0-9]
EXP			[Ee][+-]?{DIG}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
#include <stdio.h>
int lineno = 1;
%}

%%
"/*"			comment();
"auto"			return(AUTO);
"break"			return(BREAK);
"case"			return(CASE);
"char"			return(CHAR);
"const"			return(CONST);
"continue"		return(CONTINUE);
"default"		return(DEFAULT);
"do"			return(DO);
"double"		return(DOUBLE);
"else"			return(ELSE);
"enum"			return(ENUM);
"extern"		return(EXTERN);
"float"			return(FLOAT);
"for"			return(FOR);
"goto"			return(GOTO);
"if"			return(IF);
"int"			return(INT);
"long"			return(LONG);
"register"		return(REGISTER);
"return"		return(RETURN);
"short"			return(SHORT);
"signed"		return(SIGNED);
"sizeof"		return(SIZEOF);
"static"		return(STATIC);
"struct"		return(STRUCT);
"switch"		return(SWITCH);
"typedef"		return(TYPEDEF);
"union"			return(UNION);
"unsigned"		return(UNSIGNED);
"void"			return(VOID);
"volatile"		return(VOLATILE);
"while"			return(WHILE);

{LETTERS}({LETTERS}|{DIG})*		return(check_type());

0[xX]{HEX}+{IS}?		return(CONSTANT);
0{DIG}+{IS}?			return(CONSTANT);
{DIG}+{IS}?			return(CONSTANT); 
LETTERS?'(\\.|[^\\'])+' 	return(CONSTANT);

{DIG}+{EXP}{FS}?			return(CONSTANT);
{DIG}*"."{DIG}+({EXP})?{FS}?	return(CONSTANT);
{DIG}+"."{DIG}*({EXP})?{FS}?	return(CONSTANT);

LETTERS?\"(\\.|[^\\"])*\"	return(STRING_LITERAL);

"..."			return(ELLIPSIS);
">>="			return(RIGHT_ASSIGN);
"<<="			return(LEFT_ASSIGN);
"+="			return(ADD_ASSIGN);
"-="			return(SUB_ASSIGN);
"*="			return(MUL_ASSIGN);
"/="			return(DIV_ASSIGN);
"%="			return(MOD_ASSIGN);
"&="			return(AND_ASSIGN);
"^="			return(XOR_ASSIGN);
"|="			return(OR_ASSIGN);
">>"			return(RIGHT_OP);
"<<"			return(LEFT_OP);
"++"			return(INC_OP);
"--"			return(DEC_OP);
"->"			return(PTR_OP);
"&&"			return(AND_OP);
"||"			return(OR_OP);
"<="			return(LE_OP);
">="			return(GE_OP);
"=="			return(EQ_OP);
"!="			return(NE_OP);
 \;			    return(';');
"{"				return('{');
"}"				return('}');
","				return(',');
":"				return(':');
"="				return('=');
"("				return('(');
")"				return(')');
("[")			return('[');
("]")			return(']');
"."				return('.');
"&"				return('&');
"!"				return('!');
"~"				return('~');
"-"				return('-');
"+"				return('+');
"*"				return('*');
"/"				return('/');
"%"				return('%');
"<"				return('<');
">"				return('>');
"^"				return('^');
"|"				return('|');
"?"				return('?');
[\n]			return lineno++;
[\t\v\f]		{ }
.			    { /* ignore bad characters */ }

%%

yywrap()
{
	return(1);
}


comment()
{
	char c, c1;

loop:
	while ((c = input()) != '*' && c != 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

	if (c != 0)
		putchar(c1);
}


int column = 0;

int check_type()
{
	return(IDENTIFIER);
}