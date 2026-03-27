#!/bin/bash

# 0. Parametrização do Nome do Projeto
PROJECT_NAME=${1:-"sdd-agentic-project"}

echo "🚀 Iniciando bootstrap do projeto Agentic SDD: $PROJECT_NAME..."

# 1. Criar estrutura de pastas profissional
mkdir -p $PROJECT_NAME/{specs,.ai,docker,src/core,tests/contract}

# 2. Criar o Contrato Universal (Smithy IDL)
cat <<EOF > $PROJECT_NAME/specs/project.smithy
\$version: "2.0"

namespace com.generic.api

/// Core Service Definition - Template Universal 2026
service CoreService {
    version: "2026-03-27",
    operations: [GetResource, CreateResource, ListResources]
}

@readonly
@http(method: "GET", uri: "/resource/{id}")
operation GetResource {
    input: GetResourceInput,
    output: ResourceOutput,
    errors: [ResourceNotFound, InternalError]
}

structure GetResourceInput {
    @required
    id: String
}

structure ResourceOutput {
    @required
    id: String,
    @required
    name: String,
    metadata: Document,
    createdAt: Timestamp
}

operation CreateResource {
    input: CreateResourceInput,
    output: ResourceOutput,
    errors: [ValidationError, ConflictError]
}

structure CreateResourceInput {
    @required
    @length(min: 3)
    name: String,
    @idempotencyToken
    clientToken: String,
    tags: StringList
}

@readonly
@http(method: "GET", uri: "/resources")
operation ListResources {
    input: ListResourcesInput,
    output: ListResourcesOutput,
    errors: [InternalError]
}

structure ListResourcesInput {
    @httpQuery("nextToken")
    nextToken: String,
    @httpQuery("maxResults")
    @range(min: 1, max: 100)
    maxResults: Integer
}

structure ListResourcesOutput {
    @required
    items: ResourceList,
    nextToken: String
}

list ResourceList {
    member: ResourceOutput
}

list StringList {
    member: String
}

@error("client")
structure ResourceNotFound { message: String }

@error("client")
structure ValidationError { message: String }

@error("client")
structure ConflictError { message: String }

@error("server")
structure InternalError { message: String }
EOF

# 3. Criar as Instruções do Agente (Governança IA)
cat <<EOF > $PROJECT_NAME/.ai/instructions.md
# 🤖 Agentic Governance Instructions

## 🎯 Objetivo
Este repositório utiliza **Specification-Driven Development (SDD)** para garantir que a IA atue como um Engenheiro de Software rigoroso, evitando alucinações.

## 🏗️ Protocolo de Design & Arquitetura
- **Prioridade da Spec:** Nenhuma alteração de código deve ser feita sem validar o contrato em \`./specs/project.smithy\`.
- **Anti-Overengineering:** O Agente deve sugerir a arquitetura mais simples possível para o requisito atual, justificando no \`journal.md\`.
- **Validação de Constraints:** O código gerado deve implementar TODAS as regras da Spec (ex: @length, @range, @pattern).

## 🛠️ Stack & Conectividade
- **Modelagem:** Smithy IDL (Agnóstico a protocolo).
- **Ambiente:** Docker para isolamento e reprodutibilidade.
- **Ferramental:** Protocolo MCP (Model Context Protocol) para inspeção de Banco de Dados e Sistema de Arquivos.
EOF

# 4. Criar o Diário de Decisões (Contexto Histórico)
cat <<EOF > $PROJECT_NAME/.ai/journal.md
# 📔 Decision Log & Architecture Journal

## [$(date +%Y-%m-%d)] - Initial Project Setup
- **Decisão:** Inicialização do projeto utilizando SDD e Agentic Workflow.
- **Contexto:** Estrutura agnóstica preparada para escalabilidade.
- **Arquitetura Base:** Modular Monolith (YAGNI).
EOF

# 5. Criar Dockerfile (O que faltava para o build funcionar)
cat <<EOF > $PROJECT_NAME/Dockerfile
FROM node:20-slim

WORKDIR /app

# Instalação mínima para desenvolvimento agêntico
RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
# Ignora erro se não houver package.json ainda (o agente criará)
RUN npm install || true

COPY . .

CMD [ "node", "src/core/index.js" ]
EOF

# 6. Criar o Docker Compose (Infraestrutura)
cat <<EOF > $PROJECT_NAME/docker/docker-compose.yml
services:
  db:
    image: postgres:16
    container_name: ${PROJECT_NAME}_db
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: password
      POSTGRES_DB: app_db
    ports:
      - "5432:5432"

  app:
    build: 
      context: ..
      dockerfile: Dockerfile
    container_name: ${PROJECT_NAME}_app
    volumes:
      - ..:/app
    environment:
      DATABASE_URL: postgresql://admin:password@db:5432/app_db
    depends_on:
      - db
EOF

# 7. Criar o MCP Config (Model Context Protocol)
cat <<EOF > $PROJECT_NAME/mcp-config.json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "./"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://admin:password@localhost:5432/app_db"
      }
    }
  }
}
EOF

# 8. Criar o README de Portfólio
cat <<EOF > $PROJECT_NAME/README.md
# $PROJECT_NAME (2026)

Este repositório é um showcase de **Engenharia AI-Native**, demonstrando como orquestrar Agentes de IA sob uma governança rígida de arquitetura (SDD).

### 🌟 Diferenciais Técnicos:
- **Specification-Driven Development (SDD):** Contratos Smithy como única fonte da verdade.
- **Agentic Workflow:** Diretório \`.ai/\` com instruções semânticas para LLMs.
- **Observabilidade por IA:** Configurado com **MCP Servers** (File/DB).

### 🚀 Como Começar:
1. **Ambiente:** \`docker-compose -f docker/docker-compose.yml up -d\`
2. **IA:** Conecte seu Agente e peça para ele ler \`.ai/instructions.md\`.
3. **Contrato:** Evolua o sistema a partir de \`specs/project.smithy\`.

### 🛠️ Requisitos:
- Docker & Docker Compose
- Node.js (para rodar servidores MCP locais via npx)
EOF

# 9. Inicializar Git e criar Commit Inicial
cd $PROJECT_NAME
git init -q
git add .
git commit -m "feat: initial bootstrap via Agentic SDD generator" -q
cd ..

# Finalização
chmod +x generate-agentic-sdd.sh
echo "--------------------------------------------------------"
echo "✅ Projeto '$PROJECT_NAME' gerado com sucesso!"
echo "📂 Pasta: ./$PROJECT_NAME"
echo "🛠️ Git inicializado e commit de bootstrap realizado."
echo "--------------------------------------------------------"