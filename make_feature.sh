#!/bin/bash

# Caminho onde o módulo deve ser gerado
DESTINO_LIB="lib/src/features"
MASON_COMMAND="mason make flutter_feature"

# Verifica se está na raiz do projeto
if [[ ! -f "pubspec.yaml" || ! -d "lib" ]]; then
  echo "❌ Você deve rodar este script a partir da raiz do projeto (onde está o pubspec.yaml)."
  exit 1
fi

# Verifica se argumento foi passado
if [ -z "$1" ]; then
  echo "❌ Você deve passar o nome da feature. Ex: ./make_feature.sh empresa"
  exit 1
fi

# Garante que a pasta destino existe
mkdir -p "$DESTINO_LIB"

# Executa o mason com output forçado no lugar certo
$MASON_COMMAND --name "$1"

# Move para o destino se necessário
if [ -d "$1" ]; then
  mv "$1" "$DESTINO_LIB/$1"
  echo "✅ Feature '$1' criada em: $DESTINO_LIB/$1"
fi
