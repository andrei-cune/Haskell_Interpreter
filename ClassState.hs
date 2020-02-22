module ClassState
where

import Data.Map (Map)
import qualified Data.Map as Map
-- Utilizat pentru a obține informații despre Variabile sau Funcții
data InstrType = Var | Func  deriving (Show, Eq)

-- TODO - Trebuie definit ClassState
data ClassState = ClassState (Map [String] InstrType) deriving Show

initEmptyClass :: ClassState
initEmptyClass = ClassState Map.empty 

insertIntoClass :: ClassState -> InstrType -> [String] -> ClassState
insertIntoClass (ClassState cs) it name = ClassState (Map.insert name it cs) 

getValues :: ClassState -> InstrType -> [[String]]
getValues (ClassState cs) it = map fst ( filter (\(x,y) -> if it == y then True else False) (Map.toList(cs)))
