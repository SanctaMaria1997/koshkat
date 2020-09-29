# Koshkat
Free, cross-platform, 64-bit BASIC compiler with multimedia-focused API

Koshkat is a free (as in freedom), general-purpose 64-bit compiler and multimedia library for MacOS and Linux, focusing on 2D game programming with 3D hardware acceleration. The core language and API are based on Blitz BASIC (from Blitz Research Ltd (with whom I am in no way affiliated)). The compiler is largely complete apart from bug fixes; the API is incomplete, but is already capable of making real 2D games (like the demo games, Skyghost (an asteroid shooter) and DonJuan (a dungeon crawler)). See below for more details about what functions exactly are implemented.

DIFFERENCES FROM BLITZ BASIC

- Koshkat supports 64-bit x86 hosts and targets.
- Koshkat is cross-platform. (IMPORTANT: the Windows version has bit-rotted and is not currently maintained).
- Koshkat supports Unicode in all its string functions, including the rendering of Unicode characters with .ttf fonts..
- Koshkat supports inline assembly code.

GENERAL LANGUAGE FEATURES

- Four native 64-bit data types (int, float (technically, "double"), pointer, and UTF-8 string).
- All the operators you would expect from a modern language (Arithmetic operators: +, -, \*, /, Mod, ^ ("to-the-power-of"); Bitwise operators: And, Or, Xor, ~ (bitwise complement); Logical operator: Not; Comparision operators: >, <, =, >=, <=, <>; Assignment operator: =; Type conversion operators: Int(), Float(), Str(); Unary negate/abs: -, +; Bit-shifting operators: Shl, Shr, Sar; Precedence override operator: (); Function call operator: f(); New operator; Type-field-access operator: \; Linked list manipulation operators: First, Last, Before, After).
- Built-in constants True, False, Pi and Null.
- Support for hexadecimal and binary constants.
- Arrays of any data type and any practical dimensionality, and the ability to re-dimension arrays.
- The freedom to define custom types with the "Type" keyword (including support for arrays of types, and types within types).
- Implicit, "behind-the-scenes" linked list support with "For... Each" loops to iterate over objects of a particular type.
- Smart "New/Delete" operators for use with types.
- Operators for sorting or otherwise rearranging linked lists.
- Full support for subroutines, including C-style functions with optional arguments.
- All the traditional looping constructs you would expect ("For... To... Step... Next","Repeat... Until/Forever","While... Wend").
- Conditional branching with "If... Then... Else If... Else" and "Select... Case... Default".
- Branching with "Goto", "Gosub" and "On... Goto/Gosub" ("On... Goto/Gosub" statement uses jump tables for constant-time O(1) branching).
- Support for global, local and constant "variables".

INSTALL FROM SOURCE (MACOS)

You will need the Glasgow Haskell Compiler (GHC), the Monad Transformer Library (obtainable via Cabal), and XCode, including the command line tools. To create graphical programs, you will also need SDL2, including SDL_gfx which you may need to compile from source.

`make -f macOSMakefile release`

`chmod +x ./ktool-install-macos.sh`

`sudo make -f macOSMakefile install`

INSTALL FROM SOURCE (LINUX)

To compile and install the language on an Ubuntu host:

`sudo apt-get install ghc libghc-mtl-dev libglib2.0-dev libgtk-3-dev libsdl2-dev libsdl2-image-2.0-0 libsdl2-image-dev libsdl2-ttf-2.0-0 libsdl2-ttf-dev libsdl2-mixer-2.0-0 libsdl2-mixer-dev libsdl2_gfx libsdl2_gfx-dev pkg-config`

`make -f LinuxMakefile release`

`chmod +x ./ktool-install-linux.sh`

`sudo make -f LinuxMakefile install`

USING THE COMPILER

(Assuming a Linux host) Issue the command:

`koshkat source.bb`

A few more options are available; type:

`koshkat --help`

for details.

You can make this choice implicit and persistent by editing the file ~/.koshkat.conf

DEBUGGING

Koshkat doesn't yet have its own debugger, but DWARF debugging information is supported, so you can debug your programs using the system debugger (gdb on Linux, lldb on macOS).

LIST OF BLITZ BASIC KEYWORDS AND OPERATORS IMPLEMENTED

\*Keywords marked with an asterisk are new and were not part of the original Blitz BASIC.
(Essentially all keywords/operators are implemented except the debugging command "Stop", and the undocumented commands/operators "Object", "Handle" and "`[]`")

After, And, Before, Case, Const, Data, Default, Delete, Dim, Each, Else, Else If, End, End If, Exit, False, Field, First, Float, For, Forever, Function, Global, Gosub, Goto, If,, Insert, Int, Last, Local, Mod, New, Next, Not, Null, Or, Pi, Read, Repeat, Restore, Return, Sar, Select, Shl, Shr, Step, Str, Then, To, True, Type, Until, Wend, While, Xor, Include, On\*, + (unary) , - (unary), ~, ^, \*, /, +, -, >, < , >=, <=, <>, \

LIST OF BLITZ BASIC FUNCTIONS IMPLEMENTED (OR AT LEAST PARTIALLY IMPLEMENTED)

\*Functions marked with an asterisk are new and were not part of the original Blitz BASIC; they generally deal with graphics hardware acceleration and Unicode.

CountGfxModes, GfxModeWidth, GfxModeHeight, GfxModeDepth, Graphics, GraphicsWidth, GraphicsHeight, SetBuffer, BackBuffer, Cls, ClsColor, Color, Flip, Origin, Line, SetScale\*, SetOrientation\*, GetScaleX\*, GetScaleY\*, SetAlpha\*, GetAlpha\*, LoadImage, MaskImage, HandleImage, ImageXHandle, ImageYHandle, ImageWidth, ImageHeight, MidHandle, AutoMidHandle, DrawImage, DrawImageRect, Oval, ImagesCollide, Rect, LoadFont, SetFont, Text, StringWidth, StringHeight, LoadSound, PlaySound, LoopSound, StopChannel, ChannelPlaying, KeyDown, KeyHit, SetPrecision\*, Abs, Sin, Cos, ATan2, ATan, Tan, Sgn, Exp, Log, Sqr, SeedRnd, Rnd, Rand, CreateTimer, WaitTimer, LSet, RSet, Len, Mid, Left, Right, Uni\*, Asc, Chr, Upper, Lower, Print, Write, Input, DebugLog, Millisecs, CreateBank, FreeBank, BankSize, ResizeBank, CopyBank, PokeByte, PokeShort, PokeInt, PokeLong\*, PeekByte, PeekShort, PeekInt, PeekLong\*
