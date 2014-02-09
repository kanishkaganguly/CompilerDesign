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
	: logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression
	| unary_expression assignment_operator assignment_expression
	;

assignment_operator
	: '='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression
	: assignment_expression
	| expression ',' assignment_expression
	;

constant_expression
	: conditional_expression
	;

declaration
	: declaration_specifiers ';'
	| declaration_specifiers init_declarator_list ';'
	;

declaration_specifiers
	: storage_class_specifier
	| storage_class_specifier declaration_specifiers
	| type_specifier
	| type_specifier declaration_specifiers
	| type_qualifier
	| type_qualifier declaration_specifiers
	;

init_declarator_list
	: init_declarator
	| init_declarator_list ',' init_declarator
	;

init_declarator
	: declarator
	| declarator '=' initializer
	;

storage_class_specifier
	: TYPEDEF
	| EXTERN
	| STATIC
	| AUTO
	| REGISTER
	;

type_specifier
	: VOID
	| CHAR
	| SHORT
	| INT
	| LONG
	| FLOAT
	| DOUBLE
	| SIGNED
	| UNSIGNED
	| struct_or_union_specifier
	| enum_specifier
	| TYPE_NAME
	;

struct_or_union_specifier
	: struct_or_union IDENTIFIER '{' struct_declaration_list '}'
	| struct_or_union '{' struct_declaration_list '}'
	| struct_or_union IDENTIFIER
	;

struct_or_union
	: STRUCT
	| UNION
	;

struct_declaration_list
	: struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list ';'
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

struct_declarator_list
	: struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator
	: declarator
	| ':' constant_expression
	| declarator ':' constant_expression
	;

enum_specifier
	: ENUM '{' enumerator_list '}'
	| ENUM IDENTIFIER '{' enumerator_list '}'
	| ENUM IDENTIFIER
	;

enumerator_list
	: enumerator
	| enumerator_list ',' enumerator
	;

enumerator
	: IDENTIFIER
	| IDENTIFIER '=' constant_expression
	;

type_qualifier
	: CONST
	| VOLATILE
	;

declarator
	: pointer direct_declarator
	| direct_declarator
	;

direct_declarator
	: IDENTIFIER
	| '(' declarator ')'
	| direct_declarator '[' constant_expression ']'
	| direct_declarator '[' ']'
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' identifier_list ')'
	| direct_declarator '(' ')'
	;

pointer
	: '*'
	| '*' type_qualifier_list
	| '*' pointer
	| '*' type_qualifier_list pointer
	;

type_qualifier_list
	: type_qualifier
	| type_qualifier_list type_qualifier
	;


parameter_type_list
	: parameter_list
	| parameter_list ',' ELLIPSIS
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: declaration_specifiers declarator
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

type_name
	: specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator
	: pointer
	| direct_abstract_declarator
	| pointer direct_abstract_declarator
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' constant_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' constant_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
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