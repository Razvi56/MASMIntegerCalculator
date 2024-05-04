.386
 .model flat, stdcall
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;includem biblioteci, si declaram ce functii vrem sa importam
  includelib msvcrt.lib
extern exit: proc
 extern scanf: proc
 extern printf: proc
 extern fopen: proc
 extern fclose: proc
  extern fprintf: proc
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ; PROGRAMUL PRIMESTE VALORI DE TIP INT CA INPUT DAR AFISAZA REZULTATELE CA DOUBLE
 
 ;declaram simbolul start ca public - de acolo incepe executia
 public start
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 ;sectiunile programului, date, respectiv cod
 ; struct node--> structura 1
 ;typedef struct node
;{
;    struct node*left;
;    struct node*right;
;    int id;
;    double val;
;}nodeT;
  nodeT struct; nod de arbore, are copiii left si right. Vom construi arborele prefix al expresiei
  id dd ?
  val dd ?
 left dd ?
 right dd ?
 ;a operatiilor pe int  
 nodeT ends
 ; struct node--> structura 1
 
 .data;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA 
  size_node EQU 16; 4*sizeof(int_32) 
  formatul_a_ce_primesc db 200 dup(0);formatul pe care lucreaza build_prefix_tree
  tablou_valori dd 100 dup(0);valorile operanzilor, de tip int
  buffer db 250 dup(0);stocam input-ul din stdin
  root nodeT 100 dup(<>);tabloul de noduri din arborele prefix 
  format_scanf db "%s",0
  format_printf db "%.5f",10,0
  n dd ?;lungimea sirului primit
  begin_1 dd ?
  end_1 dd ?
  rezultat_anterior dq ?
 
 ;aici declaram date

 .code;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<   CODE CODE CODE CODE CODE CODE CODE CODE CODE CODE CODE CODE CODE CODE CODE CODE CODE CODE CODE CODE CODE CODE 
 
 ;functii de care am nevoie: ->> fiecare functie va avea un macro asociat care o apeleaza (daca se cunoaste numarul de parametri)
 
 ;SABLON----------------------------------------<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 ;F_nr_functie----------------------------------------------------------------------------------
 ;int operator(char c)
;{
;    if(c=='+'||c=='-'||c=='*'||c=='/')
;        return 1;
;    else
;        return 0;
;}
;----------------------------------------------------------------------------------comentarii ^
																							; |
 comment @
 functie proc ;TESTATA/NETESTATA
 push EBP
 mov EBP,ESP
 
 mov ESP,EBP
 pop EBP
 ret
 functie endp
 ;----------------------------------------------------------------------------------
 functie_m macro ;parametrii
 LOCAL etichete_locale
 push EBX
 push ECX
 push EDX
 
 push parametri
 call functie 
 add ESP,nr_biti_parametri
 
 pop EDX
 pop ECX
 pop EBX
 endm
 @
 ;F_nr_functie----------------------------------------------------------------------------------
 ;SABLON----------------------------------------<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 
 ;F1----------------------------------------------------------------------------------------
 ;int operator(char c)
;{
;    if(c=='+'||c=='-'||c=='*'||c=='/')
;        return 1;
;    else
;        return 0;
;}
;-----------------------------------------------
  operator_m macro c1; c1 dd ?
  push c1
  call operator
  add ESP,4
  endm
;-----------------------------------------------
 operator proc ;(char c) TESTATA ->> functie operator(char c)
 push EBP
 mov EBP,ESP
 ;c=[EBP+8]
 mov EAX,[EBP+8];EAX=c
 cmp EAX,'+'
 je actiune2
 cmp EAX,'-'
 je actiune2
 cmp EAX,'*'
 je actiune2
 cmp EAX,'/'
 je actiune2
 
 actiune1:
 xor EAX,EAX;altfel returneaza 0
 jmp final
 actiune2:
  mov EAX,1;daca c e operator returneaza 1
 final:
 mov ESP,EBP
 pop EBP
 ret
 operator endp
;F1--------------------------------------------------------------------------------------


 ;F2---------------------------------------------------------------------------------- newNode(int key)
;nodeT*newNode(int key)
;{
;    nodeT*p=(nodeT*)malloc(sizeof(nodeT));
;    p->left=p->right=NULL;
;    p->id=key;
;    return p;
;}
;----------------------------------------------------------------------------------comentarii ^

 newNode_m macro key ;parametrii
 LOCAL etichete_locale
 push EBX
 push ECX
 push EDX
 
 push key
 call newNode 
 add ESP,4
 
 pop EDX
 pop ECX
 pop EBX
 endm	
 ;----------------------------------------------------------------------------------	; |
 newNode proc ;TESTATA/NETESTATA
 push EBP
 mov EBP,ESP
 ;[EBP+8]=key (dd)
 mov EAX,[EBP+8];in EAX avem key
 mov EBX,ESI
 mov [EBX],EAX;mov [ESI].id,EAX;id-ul structurii este key
 xor EAX,EAX
 mov [EBX+8],EAX;mov [ESI].left,0
 mov [EBX+12],EAX;mov [ESI].right,0
 mov EAX,ESI;in EAX returnez adresa elementului "alocat" in array-ul root, la adresa [root] se afla radacina arboorelui prefix a expresiei
 add ESI,size_node;adun size_node la ESI pentru a mai putea aloca un element si data viitoare
 mov ESP,EBP
 pop EBP
 ret
 newNode endp
 
 
 
 ;F2----------------------------------------------------------------------------------

 ;F3----------------------------------------------------------------------------------
 ;int operator(char c)
;{
;    if(c=='+'||c=='-'||c=='*'||c=='/')
;        return 1;
;    else
;        return 0;
;}
;----------------------------------------------------------------------------------comentarii ^
																							; |
 
 check_prefix_build_m macro first,last,caracter1,caracter2,index;parametrii
 LOCAL etichete_locale
 push EBX
 push ECX
 push EDX
 
 push index
 push caracter2
 push caracter1
 push last
 push first
 call check_prefix_build 
 add ESP,20
 
 pop EDX
 pop ECX
 pop EBX
 endm
 ;------------------------------------------------------
 
 check_prefix_build proc ;(first,last,caracter1,caracter2,index);TESTATA/NETESTATA
 ;returneaza 1 daca toate sunt diferite
 push EBP
 mov EBP,ESP
 ;[EBP+8]=first (int*)-dd
 ;[EBP+12]=last (int*)-dd
 ;[EBP+16]=caracter1 (char)-dd
 ;[EBP+20]=caracter2 (char)-dd
 ;[EBP+24]=index (int)-dd
 
 ;cu EAX comparam 
 mov EBX,[EBP+12];EBX=last
 sub EBX,[EBP+24];EBX=last-index
 cmp EBX,[EBP+8]
 je actiune2; last-index == first => returnam 0
 
 xor EAX,EAX
 mov AL,byte ptr[EBX];EAX=*(last-index)
 cmp EAX,[EBP+16]
 je actiune2
 cmp EAX,[EBP+20]
 je actiune2
 
 actiune1:
 mov EAX,1
 jmp final
 actiune2:
 xor EAX,EAX
 final:
 
 mov ESP,EBP
 pop EBP
 ret
 check_prefix_build endp
 ;----------------------------------------------------------------------------------

 
 ;F3----------------------------------------------------------------------------------


;F4----------------------------------------------------------------------------------
;nodeT* build_prefix_tree(int*first,int*last,double* tablou_valori)
;----------------------------------------------------------------------------------comentarii ^
																							; |
build_prefix_tree_m macro first, last, tablou_valori;parametrii
 LOCAL etichete_locale
 push EBX
 push ECX
 push EDX
 
 push tablou_valori
 push last
 push first
 call build_prefix_tree
 add ESP,12
 
 pop EDX
 pop ECX
 pop EBX
 endm
 ;--------------------------------------------------
																							
																							
 build_prefix_tree proc ;TESTATA/NETESTATA
 push EBP
 mov EBP,ESP
 ;[EBP+8]=first (int*)-dd
 ;[EBP+12]=last	(int*)-dd
 ;[EBP+16]=tablou_valori (int*)-dd
 ;ECX-> index
 xor ECX,ECX
 
 loop1:
	check_prefix_build_m [EBP+8],[EBP+12],'+','-',ECX
	cmp EAX,0
	je end_loop1;daca nu se mai respecta conditia,iesim 
	add ECX,1;inc ECX
	jmp loop1
 end_loop1:
 
 mov EAX,[EBP+12];EAX = last
 sub EAX,ECX;EAX=last-index
 cmp EAX,[EBP+8];comparam last-index cu first
 jne et1
 xor ECX,ECX
 loop2:
	check_prefix_build_m [EBP+8],[EBP+12],'*','/',ECX
	cmp EAX,0
	je end_loop2;daca nu se mai respecta conditia,iesim 
	add ECX,1;inc ECX
	jmp loop2
 end_loop2:
 et1:
 mov EBX,[EBP+12];EBX=last
 sub EBX,ECX;EBX=last-index
 

 push ECX
 xor ECX,ECX
 mov CL,byte ptr[EBX]
 newNode_m ECX;creem un nod nou cu cheia *(last-index)
 pop ECX
 ;in EAX avem adresa nodului creat
 mov EDX,EAX;EDX=adresa nodului creat
 cmp EBX,[EBP+8];comparam pe last-index cu first
 je actiune2
 actiune1:
 ;EBX=last-index
 ;EDX=adresa nodului creat
 sub EBX,1 ;1 neaparat!; EBX=last-index-1*sizeof(char*)
 build_prefix_tree_m [EBP+8],EBX,[EBP+16]
 ;EAX=adresa subarborelui stang
 mov [EDX+8],EAX;mov [EDX].left,EAX
  ;p->left=build_prefix_tree(first,last-index-1,tablou_valori);
  add EBX,2;EBX=last-index+1*sizeof(char*)
  build_prefix_tree_m EBX,[EBP+12],[EBP+16]
  ;EAX=adresa subarborelui drept
 mov [EDX+12],EAX;mov [EDX].right,EAX
 ; p->right=build_prefix_tree(last-index+1,last,tablou_valori);
 jmp final_actiune
 actiune2:
 ;EBX=last-index
 xor ECX,ECX
 mov CL,byte ptr[EBX];ECX=*(last-index)
 mov EBX,[EBP+16];EBX=tablou_valori
 mov EAX,dword ptr[EBX+4*ECX]
 mov [EDX+4],EAX;dword pentru ca iau un int
 ; p->val=tablou_valori[*(last-index)];
 final_actiune:
 mov EAX,EDX;EAX=adresa nodului creat-> returnare
 final_functie:
 mov ESP,EBP
 pop EBP
 ret
 build_prefix_tree endp
 ;----------------------------------------------------------------------------------

 evaluate_prefix_tree_m macro root ;parametrii
 push EBX
 push ECX
 push EDX
 
 push root
 call evaluate_prefix_tree 
 add ESP,4
 
 pop EDX
 pop ECX
 pop EBX
 endm
;----------------------------------------------------------------------------------	
 evaluate_prefix_tree proc;(nodeT*root);TESTATA/NETESTATA
 push EBP
 mov EBP,ESP
 ;[EBP+8]=current_root (nodeT*)-dd
 
 mov EDX,[EBP+8]
 mov EBX,[EDX+8]
 cmp EBX,0;cmp [root].left,0
 jne actiune2
 mov EBX,[EDX+12]
 cmp EBX,0;cmp [root].right,0
 jne actiune2
 ;if(root->left==NULL&&root->right==NULL)
 ;       return root->val;
 actiune1:
 mov EBX,dword ptr[EDX];EBX=[root].id
 cmp EBX,0;daca e rezultatul anterior,il incarcam ca float_32,altfel,ca int_32
 jne a2
 a1:
 fld dword ptr[EDX+4]
 jmp final_actiune_1
 a2:
 fild dword ptr[EDX+4];fild [root].val
 final_actiune_1:
 mov ESP,EBP
 pop EBP
 ret
 actiune2:

act1:
evaluate_prefix_tree_m [EDX+8];[root].left;rezultatul in ST(0)
evaluate_prefix_tree_m [EDX+12];[root].right;rezultatul in ST(0), cel de mai sus va fi in ST(1)

mov EBX,[EDX]
cmp EBX,'+';cmp [root].id,'+'
jne act2
fadd
jmp final

act2:
cmp EBX,'-';cmp [root].id,'-'
jne act3
fsub
jmp final

act3:
cmp EBX,'*';cmp [root].id,'*'
jne act4
fmul
jmp final

act4:
cmp EBX,'/';cmp [root].id,'/'
jne final
fdiv
final:
 
 mov ESP,EBP
 pop EBP
 ret
 evaluate_prefix_tree endp

 
 ;F5----------------------------------------------------------------------------------
 
;F6----------------------------------------------------------------------------------
;int lungime_sir (char* sir)
;----------------------------------------------------------------------------------comentarii ^
																							; |

 lungime_sir proc ;TESTATA/NETESTATA
 push EBP
 mov EBP,ESP
 ;[EBP+8]=offset sir
 xor ECX,ECX
 mov EAX,[EBP+8]
 loop1:
	mov BL,byte ptr[EAX] 
	cmp EBX,0
	je end_loop1
	inc ECX
	inc EAX
	jmp loop1
 end_loop1:
 mov EAX,ECX
 mov ESP,EBP
 pop EBP
 ret
 lungime_sir endp
 ;----------------------------------------------------------------------------------
 lungime_sir_m macro sir ;parametrii
 push EBX
 push ECX
 push EDX
 
 push offset sir
 call  lungime_sir
 add ESP,4
 
 pop EDX
 pop ECX
 pop EBX
 endm
 
 ;F6----------------------------------------------------------------------------------
 
;F8----------------------------------------------------------------------------------
;int operator(char c)
;{
;    if(c=='+'||c=='-'||c=='*'||c=='/')
;        return 1;
;    else
;        return 0;
;}
;----------------------------------------------------------------------------------comentarii ^
																							; |
 my_atoi_m macro m_begin, m_end ;parametrii
 push EBX
 push ECX
 push EDX
 
 push m_end; se considera ca e deja offset
 push m_begin;se considera ca e deja offset
 call my_atoi
 add ESP,8
 
 pop EDX
 pop ECX
 pop EBX
 endm
 ;----------------------------------------------------------------------------------
 my_atoi proc ;(char* begin, char* end);TESTATA/NETESTATA
 push EBP
 mov EBP,ESP
 ;[EBP+8]= begin
 ;[EBP+12]= end
 sub ESP,8;2 variabile locala
 mov EAX,10
 mov [ESP],EAX; [ESP]=10
 
 mov EAX,[EBP+12];EAX=end
 
 fld1; st(0)=1
 fldz; st(0)=0, st(1)=1 
 loop_atoi:
	xor EBX,EBX
	mov BL,byte ptr[EAX]
	sub BL,'0'
	mov [ESP+4],EBX
	
	fild dword ptr[ESP+4]; st(0)= cifra_curenta,st(1)=val_anterioara,st(2)= putere_a_lui_10
	fmul st(0),st(2)
	fadd
	fild dword ptr[ESP]
	fmulp st(2),st(0)
	cmp EAX,[EBP+8]
	je end_loop_atoi
	;incrementare
	sub EAX,1;decrementez end-ul din tabloul de char
	jmp loop_atoi
 end_loop_atoi:
 
 
 mov ESP,EBP
 pop EBP
 ret
 my_atoi endp
 
 
 
 ;F8----------------------------------------------------------------------------------
 
 start:;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  START START START START START START START START START START START START START START START START START START START START START 
 ;aici se scrie codul
	
	xor EAX,EAX
	xor EBX,EBX
	xor ECX,ECX
	xor EDX,EDX
	

	;EBX- contor_tablou_valori  
	;ECX- contor_formatul_a_ce_primesc
	;EDX- i_buff
	
	loop_until_exit:;-> a se vedea functia main() din codul comentat de la final 
		finit
		mov ESI,offset root
		push offset buffer
		push offset format_scanf
		call scanf;scanf("%s",buffer);
		; citesc input-ul si il salvez in buffer
		add ESP,8
		lungime_sir_m buffer
		mov n,EAX;int n=strlen(buffer);
		;n = lungimea sirului
		;begin=formatul_a_ce_primesc
		;end =formatul_a_ce_primesc+ ECX -1
		
		xor EDX,EDX;int i_buff=0; ->EDX
		xor ECX,ECX
		mov EBX,1
		;int contor_tablou_valori=1; ->EBX
        ;int contor_formatul_a_ce_primesc=0;-> ECX
		cmp [buffer +EDX],'e'
		je end_loop_until_exit;detectam secventa "exit"
		 
		push EBX
		push EDX
		mov EBX,offset buffer
		mov DL,byte ptr[EBX+ EDX] 
		operator_m EDX
		pop EDX
		pop EBX
		cmp EAX,1
		jne mai_departe_1
		mov [formatul_a_ce_primesc + ECX],0
		inc ECX
		mai_departe_1:
		
		loop_to_get_format:
			cmp [buffer + EDX],0
			je end_loop_to_get_format
			cmp [buffer + EDX],'='
			je end_loop_to_get_format
			;conditii de iesire
			
			push EBX
			push EDX
			mov EBX,offset buffer
			mov DL,byte ptr [EBX + EDX]
			operator_m EDX
			pop EDX
			pop EBX
			cmp EAX,0
			je ramura2
			push EBX;-----FIND THEM ALL
			mov EBX,offset buffer
			mov BL,byte ptr [EBX+EDX]
			mov byte ptr[formatul_a_ce_primesc + ECX],BL
			pop EBX
			inc ECX
			inc EDX
			jmp again
			
			ramura2:
			mov [formatul_a_ce_primesc + ECX],BL
			inc ECX
			
			mov EAX,offset buffer
			add EAX,EDX
			mov begin_1,EAX;adresa primei cifre a int
			
			push EBX;-----
			push ECX
			mov CL,'='
			mov EBX,offset buffer
			loop_get_int:
				push EDX
				mov DL,byte ptr[EBX + EDX]
				operator_m EDX
				pop EDX
				cmp EAX,0
				jne end_loop_get_int
				cmp EDX,n
				jae end_loop_get_int
				cmp byte ptr[EBX + EDX],CL
				je end_loop_get_int
				
				
				inc EDX;i_buff++
				jmp loop_get_int
			end_loop_get_int:
			pop ECX
			pop EBX;-----
			
			mov EAX,offset buffer
			add EAX,EDX
			dec EAX
			mov end_1,EAX;end_1= adresa ultimei cifre a int
			
			my_atoi_m begin_1, end_1
			
			fist dword ptr[tablou_valori + 4*EBX]
			inc EBX
			finit
			
			again:
			jmp loop_to_get_format
		end_loop_to_get_format:
		
		mov EAX,offset formatul_a_ce_primesc
		add EAX,ECX
		sub EAX,1;discutabil
		build_prefix_tree_m offset formatul_a_ce_primesc,EAX,offset tablou_valori
		evaluate_prefix_tree_m offset root
		fst dword ptr[tablou_valori];pe pozitia 0 avem intotdeauna rezultatul operatiei anterioare,pe 32 de biti
		fstp qword ptr[rezultat_anterior]
		push dword ptr [rezultat_anterior+4]
		push dword ptr [rezultat_anterior]
		push offset format_printf
		call printf
		add ESP,12
		
		jmp loop_until_exit
	end_loop_until_exit:
	
 
 ;terminarea programului
 push 0
 call exit
 end start