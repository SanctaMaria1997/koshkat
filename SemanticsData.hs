{--

Copyright (c) 2014-2020, The Koshkat Contributors (see file: CONTRIBUTORS)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--}

{-# LANGUAGE CPP #-}

module SemanticsData where

import ParserData
import Data.Word
import DWARF

import qualified Data.Map as Map
import qualified Data.Sequence as Seq

data Parameter =
     Parameter
     {
       parameterName :: String,
       parameterType :: VariableType,
       parameterIndex :: Int,
       parameterDefaultValue :: Statement
     }
     deriving (Show, Eq)

data Symbol =
     Variable
     {
       variableName :: String,
       variableType :: VariableType,
       variableLineNumber :: Int,
       variableIsGlobal :: Bool
     } |
     LocalAutomaticVariable
     {
       localAutomaticVariableName :: String,
       localAutomaticVariableType :: VariableType,
       localAutomaticVariableLineNumber :: Int,
       localAutomaticVariableIsArgument :: Bool,
       localAutomaticVariableIndex :: Int,
       localAutomaticVariableAddress :: Int
     } |
     Const
     {
       constName :: String,
       constType :: VariableType,
       constLineNumber :: Int,
       constValue :: ConstValue
     } |
     Array
     {
       arrayName :: String,
       arrayID :: Int,
       arrayType :: VariableType,
       arrayLineNumber :: Int,
       arrayNumDimensions :: Int
     } |
     Label
     {
       labelName :: String,
       labelLineNumber :: Int
     } |
     Function
     {
       functionName :: String,
       functionRawName :: String,
       functionType :: VariableType,
       functionLineNumber :: Int,
       functionOrigin :: FunctionOrigin,
       functionParameters :: [Parameter],
       functionMaxNumArguments :: Int,
       functionMinNumArguments :: Int,
       functionNumRegisterArguments :: Int,
       functionNumStackArguments :: Int,
       functionNumLocals :: Int,
       functionUsed :: Bool,
       functionSymbols :: SymbolTable
     } |
     Type
     {
       typeName :: String,
       typeID :: Int,
       typeLineNumber :: Int,
       typeSize :: Int,
       typeSymbols :: SymbolTable
     } |
     Field
     {
       fieldName :: String,
       fieldType :: VariableType,
       fieldLineNumber :: Int,
       fieldOffset :: Int
     } |
     NO_NAMESPACE
     deriving (Show, Eq)

data ConstValue =
  ConstValue
  {
    constValueExpression :: Statement
  }
  deriving (Show,Eq)

data FunctionOrigin =
     FUNCTION_ORIGIN_STANDARD |
     FUNCTION_ORIGIN_SYSTEM |
     FUNCTION_ORIGIN_USER
     deriving (Show,Eq)

type SymbolTable = Map.Map String Symbol
type StringTable = Map.Map String Int
type IntConstantTable = Map.Map Int Int
type FloatConstantTable = Map.Map Double Int

data DebugAnnotation =
  DebugAnnotation
  {
    debugAnnotationID :: Int,
    debugAnnotationFileName :: [Char],
    debugAnnotationLineNumber :: Int
  }
  deriving (Show,Eq)

data DebugInfo =
  DebugInfo
  {
    debugInfoStrings :: Map.Map [Char] Int,
    debugInfoStringOffset :: Int,
    debugInfoDIEs :: Map.Map [Char] DWARFDIE,
    debugInfoDIEOffset :: Int,
    debugInfoAnnotations :: Seq.Seq DebugAnnotation,
    debugInfoAnnotationID :: Int,
    debugInfoLineBase :: Int,
    debugInfoLineRange :: Int,
    debugInfoLineNumberProgram :: Seq.Seq DWARFLNInstruction,
    debugInfoFiles :: Map.Map [Char] Int,
    debugInfoApple :: AppleDebugInfo,
    debugInfoHorrorShow :: HorrorShow
  }
  deriving(Show)

data AppleHashData =
  AppleNameHashData
  {
    appleNameString :: Int,
    appleNameNumDIEs :: Int,
    appleNameDIEOffsets :: [Int]
  } |
  AppleTypeHashData
  {
    appleTypeString :: Int,
    appleTypeNumDIEs :: Int,
    appleTypeDIEOffsets :: [Int],
    appleTypeDIETag :: Int,
    appleTypeFlags :: Int
  }
  deriving(Show)

data AppleDebugInfo =
  AppleDebugInfo
  {
    appleHashes :: Map.Map Int AppleHashData
  }
  deriving(Show)

data HorrorShow =
  HorrorShow
  {
    horrorShowCurrentBucketName :: [Char],
    horrorShowBuckets :: Map.Map [Char] (Seq.Seq [Char])
  }
  deriving (Show)
rawAbbreviations =
  [DWARFAbbreviation
     "__ABBREV_COMPILE_UNIT"
     (dwarfTag "DW_TAG_compile_unit")
     dwarfHasChildren
     [DWARFAttributeSpec (dwarfName "DW_AT_producer") (dwarfForm "DW_FORM_strp"),
      DWARFAttributeSpec (dwarfName "DW_AT_language") (dwarfForm "DW_FORM_data2"),
      DWARFAttributeSpec (dwarfName "DW_AT_name") (dwarfForm "DW_FORM_strp"),
      DWARFAttributeSpec (dwarfName "DW_AT_stmt_list") (dwarfForm "DW_FORM_sec_offset"),
      DWARFAttributeSpec (dwarfName "DW_AT_comp_dir") (dwarfForm "DW_FORM_strp"),
      DWARFAttributeSpec (dwarfName "DW_AT_low_pc") (dwarfForm "DW_FORM_addr"),
      DWARFAttributeSpec (dwarfName "DW_AT_high_pc") (dwarfForm "DW_FORM_data4")],
      
   DWARFAbbreviation
     "__ABBREV_FUNCTION"
     (dwarfTag "DW_TAG_subprogram")
     dwarfHasChildren
     [DWARFAttributeSpec (dwarfName "DW_AT_low_pc") (dwarfForm "DW_FORM_addr"),
      DWARFAttributeSpec (dwarfName "DW_AT_high_pc") (dwarfForm "DW_FORM_data4"),
      DWARFAttributeSpec (dwarfName "DW_AT_frame_base") (dwarfForm "DW_FORM_exprloc"),
      DWARFAttributeSpec (dwarfName "DW_AT_name") (dwarfForm "DW_FORM_strp"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_file") (dwarfForm "DW_FORM_data2"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_line") (dwarfForm "DW_FORM_data4"),
      DWARFAttributeSpec (dwarfName "DW_AT_type") (dwarfForm "DW_FORM_ref4"),
      DWARFAttributeSpec (dwarfName "DW_AT_external") (dwarfForm "DW_FORM_flag_present")
      
      ],

      
   DWARFAbbreviation
     "__ABBREV_MAIN_FUNCTION"
     (dwarfTag "DW_TAG_subprogram")
     dwarfNoChildren
     [DWARFAttributeSpec (dwarfName "DW_AT_low_pc") (dwarfForm "DW_FORM_addr"),
      DWARFAttributeSpec (dwarfName "DW_AT_high_pc") (dwarfForm "DW_FORM_data4"),
      DWARFAttributeSpec (dwarfName "DW_AT_frame_base") (dwarfForm "DW_FORM_exprloc"),
      DWARFAttributeSpec (dwarfName "DW_AT_name") (dwarfForm "DW_FORM_strp"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_file") (dwarfForm "DW_FORM_data2"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_line") (dwarfForm "DW_FORM_data4"),
      DWARFAttributeSpec (dwarfName "DW_AT_prototyped") (dwarfForm "DW_FORM_flag_present"),
      DWARFAttributeSpec (dwarfName "DW_AT_type") (dwarfForm "DW_FORM_ref4"),
      DWARFAttributeSpec (dwarfName "DW_AT_external") (dwarfForm "DW_FORM_flag_present")],

   DWARFAbbreviation
     "__ABBREV_PARAMETER"
     (dwarfTag "DW_TAG_formal_parameter")
     dwarfNoChildren
     [DWARFAttributeSpec (dwarfName "DW_AT_name") (dwarfForm "DW_FORM_strp"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_file") (dwarfForm "DW_FORM_data2"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_line") (dwarfForm "DW_FORM_data4"),
      DWARFAttributeSpec (dwarfName "DW_AT_type") (dwarfForm "DW_FORM_ref4"),
      DWARFAttributeSpec (dwarfName "DW_AT_location") (dwarfForm "DW_FORM_exprloc")],

   DWARFAbbreviation
     "__ABBREV_LOCAL_AUTOMATIC"
     (dwarfTag "DW_TAG_variable")
     dwarfNoChildren
     [DWARFAttributeSpec (dwarfName "DW_AT_name") (dwarfForm "DW_FORM_strp"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_file") (dwarfForm "DW_FORM_data2"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_line") (dwarfForm "DW_FORM_data4"),
      DWARFAttributeSpec (dwarfName "DW_AT_type") (dwarfForm "DW_FORM_ref4"),
      DWARFAttributeSpec (dwarfName "DW_AT_location") (dwarfForm "DW_FORM_exprloc")],
   
   DWARFAbbreviation
     "__ABBREV_BASE_TYPE"
     (dwarfTag "DW_TAG_base_type")
     dwarfNoChildren
     [DWARFAttributeSpec (dwarfName "DW_AT_byte_size") (dwarfForm "DW_FORM_data1"),
      DWARFAttributeSpec (dwarfName "DW_AT_encoding") (dwarfForm "DW_FORM_data1"),
      DWARFAttributeSpec (dwarfName "DW_AT_name") (dwarfForm "DW_FORM_strp")],

   DWARFAbbreviation
     "__ABBREV_POINTER_TYPE"
     (dwarfTag "DW_TAG_pointer_type")
     dwarfNoChildren
     [DWARFAttributeSpec (dwarfName "DW_AT_byte_size") (dwarfForm "DW_FORM_data1"),
      DWARFAttributeSpec (dwarfName "DW_AT_type") (dwarfForm "DW_FORM_ref4")],
   
   DWARFAbbreviation
     "__ABBREV_ARRAY_TYPE"
     (dwarfTag "DW_TAG_array_type")
     dwarfNoChildren
     [DWARFAttributeSpec (dwarfName "DW_AT_type") (dwarfForm "DW_FORM_ref4"),
      DWARFAttributeSpec (dwarfName "DW_AT_sibling") (dwarfForm "DW_FORM_ref4")],   
   
   DWARFAbbreviation  
     "__ABBREV_SUBRANGE_TYPE"
     (dwarfTag "DW_TAG_subrange_type")
     dwarfNoChildren
     [DWARFAttributeSpec (dwarfName "DW_AT_type") (dwarfForm "DW_FORM_ref4"),
      DWARFAttributeSpec (dwarfName "DW_AT_upper_bound") (dwarfForm "DW_FORM_data8")],   
   
   DWARFAbbreviation  
     "__ABBREV_CUSTOM_TYPE"
     (dwarfTag "DW_TAG_structure_type")
     dwarfHasChildren
     [DWARFAttributeSpec (dwarfName "DW_AT_name") (dwarfForm "DW_FORM_strp"),
      DWARFAttributeSpec (dwarfName "DW_AT_byte_size") (dwarfForm "DW_FORM_data4"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_file") (dwarfForm "DW_FORM_data2"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_line") (dwarfForm "DW_FORM_data4")],
   
   DWARFAbbreviation
     "__ABBREV_MEMBER"
     (dwarfTag "DW_TAG_member")
     dwarfNoChildren
     [DWARFAttributeSpec (dwarfName "DW_AT_name") (dwarfForm "DW_FORM_strp"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_file") (dwarfForm "DW_FORM_data2"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_line") (dwarfForm "DW_FORM_data4"),
      DWARFAttributeSpec (dwarfName "DW_AT_type") (dwarfForm "DW_FORM_ref4"),
      DWARFAttributeSpec (dwarfName "DW_AT_data_member_location") (dwarfForm "DW_FORM_data4")],
   
   DWARFAbbreviation   
     "__ABBREV_VARIABLE"
     (dwarfTag "DW_TAG_variable")
     dwarfNoChildren
     [DWARFAttributeSpec (dwarfName "DW_AT_name") (dwarfForm "DW_FORM_strp"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_file") (dwarfForm "DW_FORM_data2"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_line") (dwarfForm "DW_FORM_data4"),
      DWARFAttributeSpec (dwarfName "DW_AT_type") (dwarfForm "DW_FORM_ref4"),
      DWARFAttributeSpec (dwarfName "DW_AT_location") (dwarfForm "DW_FORM_exprloc")],

   DWARFAbbreviation   
     "__ABBREV_ARRAY"
     (dwarfTag "DW_TAG_variable")
     dwarfNoChildren
     [DWARFAttributeSpec (dwarfName "DW_AT_name") (dwarfForm "DW_FORM_strp"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_file") (dwarfForm "DW_FORM_data2"),
      DWARFAttributeSpec (dwarfName "DW_AT_decl_line") (dwarfForm "DW_FORM_data4"),
      DWARFAttributeSpec (dwarfName "DW_AT_type") (dwarfForm "DW_FORM_ref4"),
      DWARFAttributeSpec (dwarfName "DW_AT_location") (dwarfForm "DW_FORM_exprloc")],
      
   DWARFAbbreviation
     "NONE"
     0
     dwarfNoChildren
     []]
       
indexedAbbreviations =
  map (\t -> (fst t) (snd t))
      (zip rawAbbreviations [1,2..])

idlewildLangAbbreviations =
  Map.fromList (map (\t -> (abbreviationKey t,t)) indexedAbbreviations)

osFunctionPrefix :: String
#if MAC_OS==1
osFunctionPrefix = "_"
#else
osFunctionPrefix = ""
#endif

bbFunctionPrefix :: String
#if MAC_OS==1
bbFunctionPrefix = "_bb_"
#else
bbFunctionPrefix = "bb_"
#endif



