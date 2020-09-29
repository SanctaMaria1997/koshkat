#!/bin/bash

KOSHKAT_HOME=$(echo $1 | tr -d '"')
KOSHKAT_LIBS=$(echo $2 | tr -d '"')
KOSHKAT_DOCS=$(echo $3 | tr -d '"')
APPEND_TO_PATH1="export PATH=\$PATH:/usr/bin/ # this line was generated automatically by the koshkat install script"
APPEND_TO_PATH2="export PATH=\$PATH:/usr/lib/ # this line was generated automatically by the koshkat install script"

if [ ! -d $KOSHKAT_HOME ]; then
  mkdir $KOSHKAT_HOME
fi

if [ ! -d $KOSHKAT_DOCS ]; then
  mkdir $KOSHKAT_DOCS
  mkdir "${KOSHKAT_DOCS}/Examples/"
fi

cp koshkat "${KOSHKAT_HOME}/koshkat-linux"

if [ ! -f "/usr/bin/koshkat" ]; then
  ln -s "${KOSHKAT_HOME}/koshkat-linux" /usr/bin/koshkat
fi

cp libkoshka.core.so $KOSHKAT_LIBS
cp libkoshka.mm.so $KOSHKAT_LIBS
cp nasm_koshkat_linux $KOSHKAT_HOME
cp kls $KOSHKAT_HOME
cp kdi.asm $KOSHKAT_HOME
cp tree.h $KOSHKAT_HOME
cp libkoshka_core.h $KOSHKAT_HOME

if ! grep -Fxq "$APPEND_TO_PATH1" ~/.bashrc; then
  echo -e "$APPEND_TO_PATH1" >> ~/.bashrc
fi

if ! grep -Fxq "$APPEND_TO_PATH2" ~/.bashrc; then
  echo -e "$APPEND_TO_PATH2" >> ~/.bashrc
fi
