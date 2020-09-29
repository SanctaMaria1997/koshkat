#!/bin/bash

KOSHKAT_HOME=$(echo $1 | tr -d '"')
KOSHKAT_LIBS=$(echo $2 | tr -d '"')
KOSHKAT_DOCS=$(echo $3 | tr -d '"')
APPEND_TO_PATH1="export PATH=\$PATH:/usr/local/bin/ # this line was generated automatically by the koshkat install script"
APPEND_TO_PATH2="export PATH=\$PATH:/usr/local/lib/ # this line was generated automatically by the koshkat install script"

if [ ! -d $KOSHKAT_HOME ]; then
  mkdir $KOSHKAT_HOME
fi

cp koshkat "${KOSHKAT_HOME}/koshkat-macos"

if [ ! -f "/usr/local/bin/koshkat" ]; then
  ln -s "${KOSHKAT_HOME}/koshkat-macos" /usr/local/bin/koshkat
fi

cp libkoshka.core.dylib $KOSHKAT_LIBS
cp libkoshka.mm.dylib $KOSHKAT_LIBS
cp nasm_koshkat_macos $KOSHKAT_HOME
cp kls $KOSHKAT_HOME
cp kdi.asm $KOSHKAT_HOME
cp tree.h $KOSHKAT_HOME
cp libkoshka_core.h $KOSHKAT_HOME

if ! grep -Fxq "$APPEND_TO_PATH1" ~/.bash_profile; then
  echo -e "$APPEND_TO_PATH1" >> ~/.bash_profile
fi

if ! grep -Fxq "$APPEND_TO_PATH2" ~/.bash_profile; then
  echo -e "$APPEND_TO_PATH2" >> ~/.bash_profile
fi