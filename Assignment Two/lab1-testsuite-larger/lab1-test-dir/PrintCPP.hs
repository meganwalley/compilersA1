{-# LANGUAGE CPP #-}
#if __GLASGOW_HASKELL__ <= 708
{-# LANGUAGE OverlappingInstances #-}
#endif
{-# LANGUAGE FlexibleInstances #-}
{-# OPTIONS_GHC -fno-warn-incomplete-patterns #-}

-- | Pretty-printer for PrintCPP.
--   Generated by the BNF converter.

module PrintCPP where

import qualified AbsCPP
import Data.Char

-- | The top-level printing method.

printTree :: Print a => a -> String
printTree = render . prt 0

type Doc = [ShowS] -> [ShowS]

doc :: ShowS -> Doc
doc = (:)

render :: Doc -> String
render d = rend 0 (map ($ "") $ d []) "" where
  rend i ss = case ss of
    "["      :ts -> showChar '[' . rend i ts
    "("      :ts -> showChar '(' . rend i ts
    "{"      :ts -> showChar '{' . new (i+1) . rend (i+1) ts
    "}" : ";":ts -> new (i-1) . space "}" . showChar ';' . new (i-1) . rend (i-1) ts
    "}"      :ts -> new (i-1) . showChar '}' . new (i-1) . rend (i-1) ts
    ";"      :ts -> showChar ';' . new i . rend i ts
    t  : ts@(p:_) | closingOrPunctuation p -> showString t . rend i ts
    t        :ts -> space t . rend i ts
    _            -> id
  new i   = showChar '\n' . replicateS (2*i) (showChar ' ') . dropWhile isSpace
  space t = showString t . (\s -> if null s then "" else ' ':s)

  closingOrPunctuation :: String -> Bool
  closingOrPunctuation [c] = c `elem` closerOrPunct
  closingOrPunctuation _   = False

  closerOrPunct :: String
  closerOrPunct = ")],;"

parenth :: Doc -> Doc
parenth ss = doc (showChar '(') . ss . doc (showChar ')')

concatS :: [ShowS] -> ShowS
concatS = foldr (.) id

concatD :: [Doc] -> Doc
concatD = foldr (.) id

replicateS :: Int -> ShowS -> ShowS
replicateS n f = concatS (replicate n f)

-- | The printer class does the job.

class Print a where
  prt :: Int -> a -> Doc
  prtList :: Int -> [a] -> Doc
  prtList i = concatD . map (prt i)

instance {-# OVERLAPPABLE #-} Print a => Print [a] where
  prt = prtList

instance Print Char where
  prt _ s = doc (showChar '\'' . mkEsc '\'' s . showChar '\'')
  prtList _ s = doc (showChar '"' . concatS (map (mkEsc '"') s) . showChar '"')

mkEsc :: Char -> Char -> ShowS
mkEsc q s = case s of
  _ | s == q -> showChar '\\' . showChar s
  '\\'-> showString "\\\\"
  '\n' -> showString "\\n"
  '\t' -> showString "\\t"
  _ -> showChar s

prPrec :: Int -> Int -> Doc -> Doc
prPrec i j = if j < i then parenth else id

instance Print Integer where
  prt _ x = doc (shows x)

instance Print Double where
  prt _ x = doc (shows x)

instance Print AbsCPP.Id where
  prt _ (AbsCPP.Id i) = doc (showString i)
  prtList _ [x] = concatD [prt 0 x]
  prtList _ (x:xs) = concatD [prt 0 x, doc (showString ","), prt 0 xs]

instance Print AbsCPP.Program where
  prt i e = case e of
    AbsCPP.PDefs defs -> prPrec i 0 (concatD [prt 0 defs])

instance Print AbsCPP.Def where
  prt i e = case e of
    AbsCPP.DFun type_ id args stms -> prPrec i 0 (concatD [prt 0 type_, prt 0 id, doc (showString "("), prt 0 args, doc (showString ")"), doc (showString "{"), prt 0 stms, doc (showString "}")])
  prtList _ [] = concatD []
  prtList _ (x:xs) = concatD [prt 0 x, prt 0 xs]

instance Print [AbsCPP.Def] where
  prt = prtList

instance Print AbsCPP.Arg where
  prt i e = case e of
    AbsCPP.ADecl type_ id -> prPrec i 0 (concatD [prt 0 type_, prt 0 id])
  prtList _ [] = concatD []
  prtList _ [x] = concatD [prt 0 x]
  prtList _ (x:xs) = concatD [prt 0 x, doc (showString ","), prt 0 xs]

instance Print [AbsCPP.Arg] where
  prt = prtList

instance Print AbsCPP.Stm where
  prt i e = case e of
    AbsCPP.SExp exp -> prPrec i 0 (concatD [prt 0 exp, doc (showString ";")])
    AbsCPP.SDecls type_ ids -> prPrec i 0 (concatD [prt 0 type_, prt 0 ids, doc (showString ";")])
    AbsCPP.SInit type_ id exp -> prPrec i 0 (concatD [prt 0 type_, prt 0 id, doc (showString "="), prt 0 exp, doc (showString ";")])
    AbsCPP.SReturn exp -> prPrec i 0 (concatD [doc (showString "return"), prt 0 exp, doc (showString ";")])
    AbsCPP.SReturnVoid -> prPrec i 0 (concatD [doc (showString "return"), doc (showString ";")])
    AbsCPP.SWhile exp stm -> prPrec i 0 (concatD [doc (showString "while"), doc (showString "("), prt 0 exp, doc (showString ")"), prt 0 stm])
    AbsCPP.SBlock stms -> prPrec i 0 (concatD [doc (showString "{"), prt 0 stms, doc (showString "}")])
    AbsCPP.SIfElse exp stm1 stm2 -> prPrec i 0 (concatD [doc (showString "if"), doc (showString "("), prt 0 exp, doc (showString ")"), prt 0 stm1, doc (showString "else"), prt 0 stm2])
  prtList _ [] = concatD []
  prtList _ (x:xs) = concatD [prt 0 x, prt 0 xs]

instance Print [AbsCPP.Stm] where
  prt = prtList

instance Print AbsCPP.Exp where
  prt i e = case e of
    AbsCPP.ETrue -> prPrec i 15 (concatD [doc (showString "true")])
    AbsCPP.EFalse -> prPrec i 15 (concatD [doc (showString "false")])
    AbsCPP.EInt n -> prPrec i 15 (concatD [prt 0 n])
    AbsCPP.EDouble d -> prPrec i 15 (concatD [prt 0 d])
    AbsCPP.EString str -> prPrec i 15 (concatD [prt 0 str])
    AbsCPP.EId id -> prPrec i 15 (concatD [prt 0 id])
    AbsCPP.EApp id exps -> prPrec i 15 (concatD [prt 0 id, doc (showString "("), prt 0 exps, doc (showString ")")])
    AbsCPP.EPIncr exp -> prPrec i 14 (concatD [prt 15 exp, doc (showString "++")])
    AbsCPP.EPDecr exp -> prPrec i 14 (concatD [prt 15 exp, doc (showString "--")])
    AbsCPP.EIncr exp -> prPrec i 13 (concatD [doc (showString "++"), prt 14 exp])
    AbsCPP.EDecr exp -> prPrec i 13 (concatD [doc (showString "--"), prt 14 exp])
    AbsCPP.ETimes exp1 exp2 -> prPrec i 12 (concatD [prt 12 exp1, doc (showString "*"), prt 13 exp2])
    AbsCPP.EDiv exp1 exp2 -> prPrec i 12 (concatD [prt 12 exp1, doc (showString "/"), prt 13 exp2])
    AbsCPP.EPlus exp1 exp2 -> prPrec i 11 (concatD [prt 11 exp1, doc (showString "+"), prt 12 exp2])
    AbsCPP.EMinus exp1 exp2 -> prPrec i 11 (concatD [prt 11 exp1, doc (showString "-"), prt 12 exp2])
    AbsCPP.ELt exp1 exp2 -> prPrec i 9 (concatD [prt 9 exp1, doc (showString "<"), prt 10 exp2])
    AbsCPP.EGt exp1 exp2 -> prPrec i 9 (concatD [prt 9 exp1, doc (showString ">"), prt 10 exp2])
    AbsCPP.ELtEq exp1 exp2 -> prPrec i 9 (concatD [prt 9 exp1, doc (showString "<="), prt 10 exp2])
    AbsCPP.EGtEq exp1 exp2 -> prPrec i 9 (concatD [prt 9 exp1, doc (showString ">="), prt 10 exp2])
    AbsCPP.EEq exp1 exp2 -> prPrec i 8 (concatD [prt 8 exp1, doc (showString "=="), prt 9 exp2])
    AbsCPP.ENEq exp1 exp2 -> prPrec i 8 (concatD [prt 8 exp1, doc (showString "!="), prt 9 exp2])
    AbsCPP.EAnd exp1 exp2 -> prPrec i 4 (concatD [prt 4 exp1, doc (showString "&&"), prt 5 exp2])
    AbsCPP.EOr exp1 exp2 -> prPrec i 3 (concatD [prt 3 exp1, doc (showString "||"), prt 4 exp2])
    AbsCPP.EAss exp1 exp2 -> prPrec i 2 (concatD [prt 3 exp1, doc (showString "="), prt 2 exp2])
    AbsCPP.ETyped exp type_ -> prPrec i 15 (concatD [doc (showString "("), prt 0 exp, doc (showString ":"), prt 0 type_, doc (showString ")")])
  prtList _ [] = concatD []
  prtList _ [x] = concatD [prt 0 x]
  prtList _ (x:xs) = concatD [prt 0 x, doc (showString ","), prt 0 xs]

instance Print [AbsCPP.Exp] where
  prt = prtList

instance Print AbsCPP.Type where
  prt i e = case e of
    AbsCPP.Type_bool -> prPrec i 0 (concatD [doc (showString "bool")])
    AbsCPP.Type_int -> prPrec i 0 (concatD [doc (showString "int")])
    AbsCPP.Type_double -> prPrec i 0 (concatD [doc (showString "double")])
    AbsCPP.Type_void -> prPrec i 0 (concatD [doc (showString "void")])
    AbsCPP.Type_string -> prPrec i 0 (concatD [doc (showString "string")])

instance Print [AbsCPP.Id] where
  prt = prtList

