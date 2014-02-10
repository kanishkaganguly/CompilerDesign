%{
	#include <stdio.h>
	extern int lineno;
%}

%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%start translation_unit
%%

primary_expression
	: IDENTIFIER  { printf("\t %d: primary_expression : IDENTIFIER\n", lineno); }
	| CONSTANT  { printf("\t %d: primary_expression : CONSTANT\n", lineno); } 		
	| STRING_LITERAL { printf("\t%d: primary_expression : STRING_LITERAL\n", lineno); }
	| '(' expression ')' { printf("\t%d: primary_expression : expression\n", lineno); }
	;

postfix_expression
	: primary_expression { printf("\t%d: postfix_expression  : primary_expression\n", lineno); }
	| postfix_expression '[' expression ']' { printf("\t %d: postfix_expression  : [expression]\n",lineno); }
	| postfix_expression '(' ')' { printf("\t %d: postfix_expression  : ( )\n", lineno); }
	| postfix_expression '(' argument_expression_list ')' { printf("\t %d: postfix_expression  : (argument_expression_list)\n",lineno); }
	| postfix_expression '.' IDENTIFIER { printf("\t %d: postfix_expression  : .IDENTIFIER \n",lineno); }
	| postfix_expression PTR_OP IDENTIFIER { printf("\t %d: postfix_expression  : PTR_OP IDENTIFIER\n",lineno); }
	| postfix_expression INC_OP { printf("\t %d: postfix_expression  : INC_OP\n",lineno); }
	| postfix_expression DEC_OP { printf("\t %d: postfix_expression  : DEC_OP\n",lineno); }
	;

argument_expression_list
	: assignment_expression { printf("\t %d: argument_expression_list  : assignment_expression\n",lineno); }
	| argument_expression_list ',' assignment_expression { printf("\t %d: argument_expression_list  : assignment_expression\n",lineno); }
	;

unary_expression 
	: postfix_expression { printf("\t %d: unary_expression : postfix_expression\n",lineno); }
	| INC_OP unary_expression { printf("\t %d: unary_expression  : INC_OP unary_expression\n",lineno); }
	| DEC_OP unary_expression { printf("\t %d: unary_expression  : DEC_OP unary_expression\n",lineno); }
	| unary_operator cast_expression { printf("\t %d: unary_expression  : unary_operator cast_expression\n",lineno); }
	| SIZEOF unary_expression { printf("\t %d: unary_expression  : SIZEOF unary_expression\n",lineno); }
	| SIZEOF '(' type_name ')' { printf("\t %d: unary_expression  : SIZEOF\n",lineno); }
	;

unary_operator
	: '&' { printf("\t %d: unary_operator : &\n",lineno); }
	| '*' { printf("\t %d: unary_operator : *\n",lineno); }
	| '+' { printf("\t %d: unary_operator : +\n",lineno); }
	| '-' { printf("\t %d: unary_operator : -\n",lineno); }
	| '~' { printf("\t %d: unary_operator : ~\n",lineno); }
	| '!' { printf("\t %d: unary_operator : !\n",lineno); }
	;

cast_expression
	: unary_expression { printf("\t %d: cast_expression : unary_expression\n",lineno); }
	| '(' type_name ')' cast_expression { printf("\t %d: cast_expression : (type_name) cast_expression\n",lineno); }
	;

multiplicative_expression
	: cast_expression { printf("\t %d: multiplicative_expression : cast_expression\n",lineno); }
	| multiplicative_expression '*' cast_expression { printf("\t %d: multiplicative_expression : multiplicative_expression MULT cast_expression\n",lineno); }
	| multiplicative_expression '/' cast_expression { printf("\t %d: multiplicative_expression : multiplicative_expression DIV cast_expression\n",lineno); }
	| multiplicative_expression '%' cast_expression { printf("\t %d: multiplicative_expression : multiplicative_expression MOD cast_expression\n",lineno); }
	;

additive_expression
	: multiplicative_expression { printf("\t %d: additive_expression : multiplicative_expression\n",lineno); }
	| additive_expression '+' multiplicative_expression { printf("\t %d: multiplicative_expression : additive_expression PLUS multiplicative_expression\n",lineno); }
	| additive_expression '-' multiplicative_expression { printf("\t %d: multiplicative_expression : additive_expression MINUS multiplicative_expression\n",lineno); }
	;

shift_expression
	: additive_expression { printf("\t %d: shift_expression : additive_expression\n",lineno); }
	| shift_expression LEFT_OP additive_expression { printf("\t %d: shift_expression : shift_expression LEFT_OP additive_expression\n",lineno); }
	| shift_expression RIGHT_OP additive_expression { printf("\t %d: shift_expression : shift_expression RIGHT_OP additive_expression\n",lineno); }
	;

relational_expression
	: shift_expression { printf("\t %d: relational_expression : shift_expression\n",lineno); }
	| relational_expression '<' shift_expression { printf("\t %d: relational_expression : relational_expression < shift_expression\n",lineno); }
	| relational_expression '>' shift_expression { printf("\t %d: relational_expression : relational_expression > shift_expression\n",lineno); }
	| relational_expression LE_OP shift_expression { printf("\t %d: relational_expression : relational_expression LE_OP shift_expression\n",lineno); }
	| relational_expression GE_OP shift_expression { printf("\t %d: relational_expression : relational_expression GE_OP shift_expression\n",lineno); }
	;

equality_expression
	: relational_expression { printf("\t %d: equality_expression : relational_expression\n",lineno); }
	| equality_expression EQ_OP relational_expression { printf("\t %d: equality_expression : equality_expression EQ_OP relational_expression\n",lineno); }
	| equality_expression NE_OP relational_expression { printf("\t %d: equality_expression : equality_expression NE_OP relational_expression\n",lineno); }
	;

and_expression
	: equality_expression { printf("\t %d: and_expression : equality_expression\n",lineno); }
	| and_expression '&' equality_expression { printf("\t %d: and_expression : and_expression & equality_expression\n",lineno); }
	;

exclusive_or_expression 
	: and_expression { printf("\t %d: exclusive_or_expression : and_expression\n",lineno); }
	| exclusive_or_expression '^' and_expression { printf("\t %d: exclusive_or_expression : exclusive_or_expression ^ and_expression\n",lineno); }
	;

inclusive_or_expression
	: exclusive_or_expression { printf("\t %d: inclusive_or_expression : exclusive_or_expression\n",lineno); }
	| inclusive_or_expression '|' exclusive_or_expression { printf("\t %d: inclusive_or_expression : inclusive_or_expression | and_expression\n",lineno); }
	;

logical_and_expression
	: inclusive_or_expression { printf("\t %d: logical_and_expression : inclusive_or_expression\n",lineno); }
	| logical_and_expression AND_OP inclusive_or_expression { printf("\t %d: logical_and_expression : logical_and_expression AND_OP inclusive_or_expression\n",lineno); }
	;

logical_or_expression
	: logical_and_expression { printf("\t %d: logical_or_expression : logical_and_expression\n",lineno); }
	| logical_or_expression OR_OP logical_and_expression { printf("\t %d: logical_or_expression : logical_or_expression OR_OP logical_and_expression\n",lineno); }
	;

conditional_expression
	: logical_or_expression { printf("\t %d: conditional_expression : logical_or_expression\n",lineno); }
	| logical_or_expression '?' expression ':' conditional_expression { printf("\t %d: conditional_expression : logical_or_expression ? expression : conditional_expression\n",lineno); }
	;

assignment_expression 
	: conditional_expression { printf("\t %d: assignment_expression : conditional_expression\n",lineno); }
	| unary_expression assignment_operator assignment_expression { printf("\t %d: assignment_expression : unary_expression assignment_expression assignment_expression\n",lineno); }
	;

assignment_operator
	: '=' { printf("\t %d: assignment_operator : =\n",lineno); }
	| MUL_ASSIGN { printf("\t %d: assignment_operator : MUL_ASSIGN\n",lineno); }
	| DIV_ASSIGN { printf("\t %d: assignment_operator : DIV_ASSIGN\n",lineno); }
	| MOD_ASSIGN { printf("\t %d: assignment_operator : MOD_ASSIGN\n",lineno); }
	| ADD_ASSIGN { printf("\t %d: assignment_operator : ADD_ASSIGN\n",lineno); }
	| SUB_ASSIGN { printf("\t %d: assignment_operator : SUB_ASSIGN\n",lineno); }
	| LEFT_ASSIGN { printf("\t %d: assignment_operator : LEFT_ASSIGN\n",lineno); }
	| RIGHT_ASSIGN { printf("\t %d: assignment_operator : RIGHT_ASSIGN\n",lineno); }
	| AND_ASSIGN { printf("\t %d: assignment_operator : AND_ASSIGN\n",lineno); }
	| XOR_ASSIGN { printf("\t %d: assignment_operator : XOR_ASSIGN\n",lineno); }
	| OR_ASSIGN { printf("\t %d: assignment_operator : OR_ASSIGN\n",lineno); }
	;

expression
	: assignment_expression { printf("\t %d: expression : assignment_expression\n",lineno); }
	| expression ',' assignment_expression { printf("\t %d: expression : expression , assignment_expression\n",lineno); }
	;

constant_expression
	: conditional_expression { printf("\t %d: constant_expression : conditional_expression\n",lineno); }
	;

declaration
	: declaration_specifiers ';' { printf("\t %d: declaration : declaration_specifiers;\n",lineno); }
	| declaration_specifiers init_declarator_list ';' { printf("\t %d: declaration : declaration_specifiers init_declarator_list ;\n",lineno); }
	;

declaration_specifiers
	: storage_class_specifier { printf("\t %d: declaration_specifiers : storage_class_specifier\n",lineno); }
	| storage_class_specifier declaration_specifiers { printf("\t %d: declaration_specifiers : storage_class_specifier declaration_specifiers\n",lineno); }
	| type_specifier { printf("\t %d: declaration_specifiers : type_specifier\n",lineno); }
	| type_specifier declaration_specifiers { printf("\t %d: declaration_specifiers : type_specifier declaration_specifier\n",lineno); }
	| type_qualifier { printf("\t %d: declaration_specifiers : type_qualifier\n",lineno); }
	| type_qualifier declaration_specifiers { printf("\t %d: declaration_specifiers : type_qualifier declaration_specifiers\n",lineno); }
	;

init_declarator_list 
	: init_declarator { printf("\t %d: init_declarator_list : init_declarator\n",lineno); }
	| init_declarator_list ',' init_declarator { printf("\t %d: init_declarator_list : init_declarator_list , init_declarator\n",lineno); }
	;

init_declarator
	: declarator { printf("\t %d: init_declarator : declarator\n",lineno); }
	| declarator '=' initializer { printf("\t %d: init_declarator_list : declarator = initializer\n",lineno); }
	;

storage_class_specifier 
	: TYPEDEF { printf("\t %d: storage_class_specifier : TYPEDEF\n",lineno); }
	| EXTERN { printf("\t %d: storage_class_specifier : EXTERN\n",lineno); }
	| STATIC { printf("\t %d: storage_class_specifier : STATIC\n",lineno); }
	| AUTO { printf("\t %d: storage_class_specifier : AUTO\n",lineno); }
	| REGISTER { printf("\t %d: storage_class_specifier : REGISTER\n",lineno); }
	;

type_specifier
	: VOID { printf("\t %d: type_specifier : VOID\n",lineno); }
	| CHAR { printf("\t %d: type_specifier : CHAR\n",lineno); }
	| SHORT { printf("\t %d: type_specifier : SHORT\n",lineno); }
	| INT { printf("\t %d: type_specifier : INT\n",lineno); }
	| LONG { printf("\t %d: type_specifier : LONG\n",lineno); }
	| FLOAT { printf("\t %d: type_specifier : FLOAT\n",lineno); }
	| DOUBLE { printf("\t %d: type_specifier : DOUBLE\n",lineno); }
	| SIGNED { printf("\t %d: type_specifier : SIGNED\n",lineno); }
	| UNSIGNED { printf("\t %d: type_specifier : UNSIGNED\n",lineno); }
	| struct_or_union_specifier { printf("\t %d: type_specifier : struct_or_union_specifier\n",lineno); }
	| enum_specifier { printf("\t %d: type_specifier : enum_specifier\n",lineno); }
	| TYPE_NAME { printf("\t %d: type_specifier : TYPE_NAME\n",lineno); }
	;

struct_or_union_specifier
	: struct_or_union IDENTIFIER '{' struct_declaration_list '}' { printf("\t %d: struct_or_union_specifier : struct_or_union IDENTIFIER {struct_declaration_list}\n",lineno); }
	| struct_or_union '{' struct_declaration_list '}' { printf("\t %d: struct_or_union_specifier : struct_or_union {struct_declaration_list}\n",lineno); }
	| struct_or_union IDENTIFIER { printf("\t %d: struct_or_union_specifier : struct_or_union IDENTIFIER\n",lineno); }
	;

struct_or_union 
	: STRUCT { printf("\t %d: struct_or_union : STRUCT\n",lineno); }
	| UNION  { printf("\t %d: struct_or_union : UNION\n",lineno); }
	;

struct_declaration_list 
	: struct_declaration { printf("\t %d: struct_declaration_list : struct_declaration\n",lineno); }
	| struct_declaration_list struct_declaration { printf("\t %d: struct_declaration_list : struct_declaration_list struct_declaration\n",lineno); }
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list ';' { printf("\t %d: struct_declaration : specifier_qualifier_list struct_declarator_list ;\n",lineno); }
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list { printf("\t %d: specifier_qualifier_list : type_specifier specifier_qualifier_list\n",lineno); }
	| type_specifier { printf("\t %d: specifier_qualifier_list : type_specifier\n",lineno); }
	| type_qualifier specifier_qualifier_list { printf("\t %d: specifier_qualifier_list : type_qualifier specifier_qualifier_list\n",lineno); }
	| type_qualifier { printf("\t %d: specifier_qualifier_list : type_qualifier\n",lineno); }
	;

struct_declarator_list
	: struct_declarator { printf("\t %d: struct_declarator_list : struct_declarator\n",lineno); }
	| struct_declarator_list ',' struct_declarator { printf("\t %d: struct_declarator_list : struct_declarator_list , struct_declarator\n",lineno); }
	;

struct_declarator
	: declarator { printf("\t %d: struct_declarator : declarator\n",lineno); }
	| ':' constant_expression { printf("\t %d: struct_declarator_list : : constant_expression\n",lineno); }
	| declarator ':' constant_expression { printf("\t %d: declarator : constant_expression\n",lineno); }
	;

enum_specifier
	: ENUM '{' enumerator_list '}' { printf("\t %d: enum_specifier : ENUM {enumerator_list}\n",lineno); }
	| ENUM IDENTIFIER '{' enumerator_list '}' { printf("\t %d: enum_specifier : ENUM IDENTIFIER {enumerator_list}\n",lineno); }
	| ENUM IDENTIFIER { printf("\t %d: enum_specifier : ENUM IDENTIFIER\n",lineno); }
	;

enumerator_list
	: enumerator { printf("\t %d: enumerator_list : enumerator\n",lineno); }
	| enumerator_list ',' enumerator { printf("\t %d: enumerator_list : enumerator_list : enumerator\n",lineno); }
	;

enumerator
	: IDENTIFIER { printf("\t %d: enumerator : IDENTIFIER\n",lineno); }
	| IDENTIFIER '=' constant_expression { printf("\t %d: enumerator : IDENTIFIER = constant_expression\n",lineno); }
	;

type_qualifier
	: CONST { printf("\t %d: type_qualifier : CONST\n",lineno); }
	| VOLATILE { printf("\t %d: type_qualifier : VOLATILE\n",lineno); }
	;

declarator
	: pointer direct_declarator { printf("\t %d: declarator : pointer direct_declarator\n",lineno); }
	| direct_declarator { printf("\t %d: declarator : direct_declarator\n",lineno); }
	;

direct_declarator
	: IDENTIFIER { printf("\t %d: direct_declarator : IDENTIFIER\n",lineno); }
	| '(' declarator ')' { printf("\t %d: direct_declarator : (declarator)\n",lineno); }
	| direct_declarator '[' constant_expression ']' { printf("\t %d: direct_declarator : direct_declarator [constant_expression]\n",lineno); }
	| direct_declarator '[' ']' { printf("\t %d: direct_declarator : direct_declarator[]\n",lineno); }
	| direct_declarator '(' parameter_type_list ')' { printf("\t %d: direct_declarator : direct_declarator (parameter_type_list)\n",lineno); }
	| direct_declarator '(' identifier_list ')' { printf("\t %d: direct_declarator : direct_declarator (identifier_list)\n",lineno); }
	| direct_declarator '(' ')'  { printf("\t %d: direct_declarator : direct_declarator ()\n",lineno); }
	;

pointer
	: '*' { printf("\t %d: pointer : *\n",lineno); }
	| '*' type_qualifier_list { printf("\t %d: pointer : * type_qualifier_list\n",lineno); }
	| '*' pointer { printf("\t %d: pointer : * pointer\n",lineno); }
	| '*' type_qualifier_list pointer { printf("\t %d: pointer : * type_qualifier pointer\n",lineno); }
	;

type_qualifier_list
	: type_qualifier { printf("\t %d: type_qualifier_list : type_qualifier\n",lineno); }
	| type_qualifier_list type_qualifier { printf("\t %d: type_qualifier_list : type_qualifier_list type_qualifier\n",lineno); }
	;


parameter_type_list
	: parameter_list { printf("\t %d: parameter_type_list : parameter_list\n",lineno); }
	| parameter_list ',' ELLIPSIS { printf("\t %d: parameter_type_list : parameter_list , ELLIPSIS\n",lineno); }
	;

parameter_list
	: parameter_declaration { printf("\t %d: parameter_list : parameter_declaration\n",lineno); }
	| parameter_list ',' parameter_declaration { printf("\t %d: parameter_list : parameter_list , parameter_declaration\n",lineno); }
	;

parameter_declaration
	: declaration_specifiers declarator { printf("\t %d: parameter_declaration : declaration_specifiers declarator\n",lineno); }
	| declaration_specifiers abstract_declarator { printf("\t %d: parameter_declaration : declaration_specifiers abstract_declarator\n",lineno); }
	| declaration_specifiers { printf("\t %d: parameter_declaration : declaration_specifiers declaration_specifiers\n",lineno); }
	;

identifier_list
	: IDENTIFIER { printf("\t %d: identifier_list : IDENTIFIER\n",lineno); }
	| identifier_list ',' IDENTIFIER { printf("\t %d: identifier_list : identifier_list , IDENTIFIER\n",lineno); }
	;

type_name
	: specifier_qualifier_list { printf("\t %d: type_name : specifier_qualifier_list\n",lineno); }
	| specifier_qualifier_list abstract_declarator { printf("\t %d: type_name : specifier_qualifier_list abstract_declarator\n",lineno); }
	;

abstract_declarator
	: pointer { printf("\t %d: abstract_declarator : pointer\n",lineno); }
	| direct_abstract_declarator { printf("\t %d: abstract_declarator : direct_abstract_declarator\n",lineno); }
	| pointer direct_abstract_declarator { printf("\t %d: abstract_declarator : pointer direct_abstract_declarator\n",lineno); }
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'  { printf("\t %d: direct_abstract_declarator : (abstract_declarator) \n",lineno); }
	| '[' ']'					   { printf("\t %d: direct_abstract_declarator : [] \n",lineno); }
	| '[' constant_expression ']'  { printf("\t %d: direct_abstract_declarator : [constant_expression] \n",lineno); }
	| direct_abstract_declarator '[' ']' { printf("\t %d: direct_abstract_declarator : direct_abstract_declarator [] \n",lineno); }
	| direct_abstract_declarator '[' constant_expression ']' { printf("\t %d: direct_abstract_declarator : direct_abstract_declarator [constant_expression] \n",lineno); }
	| '(' ')' { printf("\t %d: direct_abstract_declarator : () \n",lineno); }
	| '(' parameter_type_list ')' { printf("\t %d: direct_abstract_declarator : (parameter_type_list) \n",lineno); }
	| direct_abstract_declarator '(' ')' { printf("\t %d: direct_abstract_declarator : direct_abstract_declarator() \n",lineno); }
	| direct_abstract_declarator '(' parameter_type_list ')' { printf("\t %d: direct_abstract_declarator : direct_abstract_declarator (parameter_type_list) \n",lineno); }
	;

initializer
	: assignment_expression { printf("\t %d: initializer : assignment_expression \n",lineno); }
	| '{' initializer_list '}' { printf("\t %d: initializer : {initializer_list} \n",lineno); }
	| '{' initializer_list ',' '}' { printf("\t %d: initializer : {initializer_list,} \n",lineno); }
	;

initializer_list
	: initializer { printf("\t %d: initializer_list : initializer \n",lineno); }
	| initializer_list ',' initializer { printf("\t %d: initializer_list : initializer_list , initializer \n",lineno); }
	;

statement
	: labeled_statement { printf("\t %d: statement: labeled_statement \n",lineno); }
	| compound_statement { printf("\t %d: statement: compound_statement \n",lineno); }
	| expression_statement { printf("\t %d: statement: expression_statement \n",lineno); }
	| selection_statement { printf("\t %d: statement: selection_statement \n",lineno); }
	| iteration_statement { printf("\t %d: statement: iteration_statement \n",lineno); }
	| jump_statement { printf("\t %d: statement: jump_statement \n",lineno); }
	;

labeled_statement
	: IDENTIFIER ':' statement { printf("\t %d: labeled_statement: IDENTIFIER : statement \n",lineno); }
	| CASE constant_expression ':' statement { printf("\t %d: labeled_statement: CASE constant_expression : statement \n",lineno); }
	| DEFAULT ':' statement { printf("\t %d: labeled_statement: DEFAULT : statement \n",lineno); }
	;

compound_statement
	: '{' '}' { printf("\t %d: compound_statement : { } \n",lineno); }
	| '{' statement_list '}' { printf("\t %d: compound_statement : {statement_list} \n",lineno); }
	| '{' declaration_list '}' { printf("\t %d: compound_statement : {declaration_list} \n",lineno); }
	| '{' declaration_list statement_list '}' { printf("\t %d: compound_statement : {declaration_list statement_list} \n",lineno); }
	;

declaration_list
	: declaration { printf("\t %d: declaration_list : declaration \n",lineno); }
	| declaration_list declaration { printf("\t %d: declaration_list : declaration_list declaration \n",lineno); }
	;

statement_list
	: statement { printf("\t %d: statement_list : statement \n",lineno); }
	| statement_list statement { printf("\t %d: statement_list : statement_list statement \n",lineno); }
	;

expression_statement
	: ';'  { printf("\t %d: expression : ; \n",lineno); }
	| expression ';' { printf("\t %d: expression : expression; \n",lineno); }
	;

selection_statement
	: IF '(' expression ')' statement  { printf("\t %d: selection_statement : IF (expression) statement \n",lineno); }
	| IF '(' expression ')' statement ELSE statement  { printf("\t %d: selection_statement : IF (expression) statement ELSE statement \n",lineno); }
	| SWITCH '(' expression ')' statement  { printf("\t %d: selection_statement : SWITCH (expression) statement \n",lineno); }
	;

iteration_statement
	: WHILE '(' expression ')' statement { printf("\t %d: iteration_statement : WHILE (expression) statement \n",lineno); }
	| DO statement WHILE '(' expression ')' ';'  { printf("\t %d: iteration_statement : DO statement WHILE (expression) \n",lineno); }
	| FOR '(' expression_statement expression_statement ')' statement { printf("\t %d: iteration_statement : FOR (expression_statement expression_statement) statement\n",lineno); }
	| FOR '(' expression_statement expression_statement expression ')' statement { printf("\t %d: iteration_statement : FOR (expression_statement expression_statement expression)\n",lineno); }
	;

jump_statement
	: GOTO IDENTIFIER ';' { printf("\t %d: jump_statement : GOTO IDENTIFIER \n",lineno); }
	| CONTINUE ';' { printf("\t %d: jump_statement : CONTINUE \n",lineno); }
	| BREAK ';' { printf("\t %d: jump_statement : BREAK \n",lineno); }
	| RETURN ';' { printf("\t %d: jump_statement : RETURN \n",lineno); }
	| RETURN expression ';' { printf("\t %d: jump_statement : RETURN expression \n",lineno); }
	;

translation_unit
	: external_declaration { printf("\t %d: translation_unit : external_declaration\n",lineno); }
	| translation_unit external_declaration { printf("\t %d: translation_unit : translation_unit external_declaration\n",lineno); }
	;

external_declaration
	: function_definition { printf("\t %d: external_declaration : function_definition\n",lineno); }
	| declaration { printf("\t %d: external_declaration : declaration\n",lineno); }
	;

function_definition
	: declaration_specifiers declarator declaration_list compound_statement { printf("\t %d: function_definition : declaration_specifiers declarator declaration_list compound_statement\n",lineno); }
	| declaration_specifiers declarator compound_statement { printf("\t %d: function_definition : declaration_specifiers declarator compound_statement\n",lineno); }
	| declarator declaration_list compound_statement { printf("\t %d: function_definition : declarator declaration_list compound_statement\n",lineno); }
	| declarator compound_statement { printf("\t %d: function_definition : declarator compound_statement\n",lineno); }
	;

%%
#include "lex.yy.c"
#include <stdio.h>

int yyerror()
{
	printf("Error in line %d\n", lineno);
}

int main(int argc, char *argv[])
{
	if (argc != 2)
	{
		printf("Enter filename to be Compiled\n");
		return -1;
	}

	yyin = fopen(argv[1], "r");

	yyparse();

	return 0;
}