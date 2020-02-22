module Parser
where

--import Util
import Data.Maybe
import InferenceDataType
import ClassState

-- Definire Program

data ClassLayer = ClassLayer { name::String
                              ,parent::String
                              ,classMap::ClassState
                              } deriving Show

data Program = Program { classList::[ClassLayer]
                        ,global::ClassLayer
                        } deriving Show

initEmptyProgram :: Program
initEmptyProgram = Program [] (ClassLayer "Global" "Global" initEmptyClass)
--ret o lista cu variabilele
getVars :: Program -> [[String]]
getVars p = getValues ( classMap (global p)) Var

--ret o lista cu toate functiile din program
getFuncs :: Program -> [[String]]
getFuncs p = concat (map (\x->getValues (classMap x) Func) (classList p)) 

--toate classele din program
getClasses :: Program -> [String]
getClasses p = (name (global p)):(map name (classList p))

--va intoarce o lista cu clasele ce au numele respectiv , se foloseste in getClass
searchClass:: String->Program->[ClassLayer]
searchClass clsname p = filter (\x->if (name x) == clsname then True else False) (classList p)

--cauta o clasa in program si o returnreaza 
getClass::String -> Program -> ClassLayer
getClass clsname p = head (searchClass clsname p)

--intoarce parintele unei clase
getParentClass :: String -> Program -> String
getParentClass name p 
    |name == "Global" = "Global"
    |otherwise = parent (getClass name p)

--functiile pentru o clasa data
getFuncsForClass :: String -> Program -> [[String]]
getFuncsForClass name p 
    |name == "Global" = getValues ( classMap (global p)) Func
    |existingClass name p == False = []
    |otherwise = getValues ( classMap (getClass name p)) Func


--o instructiune = o linie de cod citita
data Instruction = Instruction String deriving (Show,Eq)

--se imparte programul in linii de instructiuni
parse :: String -> [Instruction]
parse s = map Instruction (lines s)

--intoarce un string dintr-o instructiune
getString:: Instruction -> String
getString (Instruction i) = i

--se verifica daca numele unei clase se afla in program
existingClass :: String -> Program -> Bool  
existingClass cls p = elem cls (getClasses  p)
 
--intoarce o lista de bool in functie de existenta clasei lor ,pt toti parametri -> folosita in validArguments
checkArguments:: [String] -> Program ->[Bool]
checkArguments l p = map (\x -> existingClass x p) l 

--daca in lista mentionata anterior avem un parametru a carui clasa nu exista atunci lista de parametri e invalida
validArguments:: [String]->Program->Bool
validArguments l p = if (elem False (checkArguments l p)) then False else True

--se inlocuiesc delimitatorii instructiunii cu spatiu
replaceDelims::String -> String
replaceDelims [] = []
replaceDelims (x:xs) = if x==':' || x==',' || x=='(' || x==')' || x=='=' then (' ':(replaceDelims xs)) else (x:(replaceDelims xs))


interpret :: Instruction -> Program -> Program
interpret instr p = interpretStr (getString instr) p

--explicata in detaliu in readme
interpretStr :: String -> Program -> Program
interpretStr instr p
        |instr == "" = p
        |length instrList == 2 && head instrList == "class" && (existingClass (head instrList) p) == False =
                                                    Program ((ClassLayer (instrList!!1) "Global" initEmptyClass):(classList p)) (global p)

        |length instrList == 4 && head instrList == "class" && ( (existingClass (instrList!!3) p) == False)  &&  (existingClass (instrList!!1) p) == False=
                                                    Program ((ClassLayer (instrList!!1) "Global" initEmptyClass):(classList p)) (global p)

        |length instrList == 4 && head instrList == "class" && ( (existingClass (instrList!!3) p) == True) && (existingClass (instrList!!1) p) == False =
                                                    Program ((ClassLayer (instrList!!1) (instrList!!3) initEmptyClass):(classList p)) (global p)

        |head instrList == "newvar" && ( (existingClass (instrList!!2) p) == False) = p

        |head instrList == "newvar" && ( (existingClass (instrList!!2) p) == True) = 
                                                   Program (classList p) 
                                                           (ClassLayer "Global" "Global" (insertIntoClass (classMap (global p) ) Var ( (instrList!!1):(instrList!!2):[] )))

        |otherwise = if (validArguments (listOfArgs) p) == False || ( (existingClass (instrList!!0) p) == False) || ( (existingClass (instrList!!1) p) == False)
                        then p
                        else
                             if (instrList!!1) == "Global"
                                then Program (classList p) 
                                             (ClassLayer "Global" "Global" (insertIntoClass (classMap (global p) ) Func ( (instrList!!2):(instrList!!0): listOfArgs )))
                                else
                                     Program ( map (\x -> if (name x) == (instrList!!1) then 
                                             (ClassLayer (name x) (parent x) (insertIntoClass (classMap x) Func ( (instrList!!2):(instrList!!0): listOfArgs ))) else x ) (classList p)) 
                                                 (global p)

            where listOfArgs = ( drop 3 (words (replaceDelims instr)))
                  instrList = (words (replaceDelims instr))




getVar:: String->Program-> [[String]]
getVar str p = filter (\x-> (x!!0 == str)) (getVars p)

--returneaza o lista cu functiile ce au aceasi nume
getSameFunc::String->[[String]]->[[String]]
getSameFunc fname list = filter (\x-> fname == (head x)) list  

--descrisa in detaliu in readme
infer :: Expr -> Program -> Maybe String
infer (Va str) p = if length ( getVar str p ) > 0 then Just ((head (getVar str p))!!1) else Nothing

infer (FCall var_name func_name expr_list) p
        | length ( getVar var_name p ) < 0 = Nothing

        | elem (func_name) (map head (getFuncs p)) == False = Nothing

        | otherwise = if (length final) > 0 then Just ((head final)!!1) else Nothing

            where final = filter  (\x-> map Just (drop 2 (x)) == (map (\x->infer x p) expr_list) ) (getSameFunc func_name (getFuncs p))
   
    
