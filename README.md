# Haskell_Interpreter
Cune Andrei 321CB


a) ClassState
Ne vom folosi de map ul din haskell,pastrand ca si chei numele functiilor/variabilelor si apoi tipul instructiunii.
Pentru un classstate gol vom initializa un map gol , pentru inserare folosim functia de insert predefinita , si totul intors ca un classstate.Pentru preluarea valorilor , vom fitra doar datele ce au ca InstrTyoe var/func in functie de caz, si preluam numele mapand fst peste toate elementele din lista.(Map.toList)

b)Parser
Clasa va fi implementata la nivel de ClasState + Nume + Parinte, programul va avea o lista de clase (ClassLayer-e) + clasa Global.
Pentru initEmptyProgram construim un program cu lista vida si clasa Global goala.

getVars:ne folosi de getvalues implementat anterior, returnam variabilele din clasa global.

getFuncs:Vom aplica getValues pentru fiecare clasa din lista de clase in parte si concatenam astfel incat sa avem toate functiile in aceeasi lista.

getClasses:vom returna numele fiecarei clase cu un map , la care adaugam si numele clasei global

searchClass:Folosim functia pentru functia getClass , va returna o lista cu clasele ce au acelasi nume,folosinfd filter.

getClass: avand in vedere functia anterioara , vom intoarce primul element.

getParentClass: tratam cazul petntru clasa global,iar altfel apelam parent pentru clasa respectiva , obtinuta cu getClass.

getfuncsForClass: se trateaza cazul pentru Global,se apeleaza getValues pentru functii , tratam cazul in care clasa nu exista , iar apoi cazul general , folosind getClass , luand ClassStateul cu classMap.

Instruction: va fi o linie de cod citita.

Parse: va separa dupa linii tot inputul programului , si mapam cu instruction astfel incat sa intoarca o lista de instructiuni

getString: va intoarce stringul corespunzator instructiunii

existingClass:verificam daca numele clasei se afla in program , ne folosim de functia getClasses.

checkArguments(se foloseste doar pentru lista de parametri ai unei functii):Va intoarce o lista de true/false daca parametrul este/nu este valid.

validArguments:Va intoaarce true daca toate elementele din lista de mai sus sunt true si respectiv false daca gasim un parametru a carui clasa e inexistenta.

replaceDelims: va fi folosita pentru a inlocui cu spatiu orice delimitator,se foloseste impreuna cu words si e folosita pentru a separa dupa spatii stringul actual

interpret:vom folosi un interpret ce foloseste stringuri in loc de Instruction

interpretStr: tratam pe rand toate cazurile:  (instrList este lista cu cuvintele citite)
-(class a) dimensiunea e 2 si se incepe cu "class", si ne asiguram ca clasa sa nu existe deja, se creeaza un nou program in care noul classLayer cu numele citit se este introdus in lista de clase a vechiului program , clasa global ramane aceeasi.

-(class a extends class b) dimensiunea este 4 si tratam cazurile in care exista sau nu clasa parinte , ne asiguram ca nu a fost creata anterior si returnam noul program , introducand noua clasa cu parintele corespunzator( global sau cel care extinde)

- crearea de noi varabile  -> daca clasa nu exista , se returneza acelasi program, si in celalalt caz , se creeaza un program cu aceeasi lista de clase , si adaugam in classstate ul noului global , numele si tipul variabilei,sub forma de lista , concatenate la lista vida.

-daca nu avem niciunul din aceste cazuri atunci vom avea declaratie de functei , listofArgs este luat lasand jos primele 3 elemente din lista intructiunii.Verificam daca lista de argumente este valida si ca clasele sunt valide.Daca avem de a face cu clasa Global procedam asemantor cu cazul crearii variabilelor , in care cream un program cu aceeasi clasa si inseram in global functia cu lista de argumente + tipul returnat = numele functiei.
Daca nu avem de a face cu Global atunci vom folosi map ca sa inlocuim clasa cu numele respectiv cu o noua clasa in al carui classState introducem aceleasi cuvinte : nume+tip returnat+lista de argumente, clasa globala ramane neschimbata .

c)infer
getVar: va returna o lista de variabile care au acelasi nume ,se foloseste pentru a verifica daca lista returnata este vida,adica daca exista variabila resprctiva.

getSameFunc:returneaza o lista cu functiile care au acelasi nume insa pot avea parametri diferiti sau tip returnat diferit.

infer: 
-pentru cazul variabila: daca functia intoarsa de getVar nu este nula atunci intoarcem tipul variabilei ,altfel Nothing.
-pentru cazul functiei -> verificam daca exista numele variabilei si numele functiei , in caz negativ sinteza de tip va esua (Nothing) .Vom cauta in lista cu toate functiile din program (intoarsa de getFuncs).Pentru functiile care au acelasi nume vom verifica recursiv tot cu infer , daca tipurile urmatoarelor expresii corespund cu tipul parametrilor functiilor. Functia pentru care se verifica aceasta consitie fa fi functia final , al carei tip il vom returna ( head final)!!1 .Practic se cauta in toate functiile programului dupa nume si dupa parametri potriviti.Se vor filtra dintre functiile cu acelasi nume doar functiile ce au parametri buni -> va fi doar una vaida -> final.


