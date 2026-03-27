#!/bin/bash

# Nome do projeto (Agnóstico a domínio)
PROJECT_NAME="sdd-agentic-project"

# 1. Criar estrutura de pastas profissional
mkdir -p $PROJECT_NAME/{specs,.ai,docker,src/core,tests/contract}

# 2. Criar o Contrato Universal (Smithy IDL)
# Este arquivo é a "Fonte da Verdade" que a IA deve obedecer.
cat <<EOF > $PROJECT_NAME/specs/project.smithy
\$version: "2.0"

namespace com.generic.api

/// Core Service Definition - Template Universal 2026
/// Este contrato define as interfaces fundamentais para o sistema via SDD.
service CoreService {
    version: "2026-03-27",
    operations: [GetResource, CreateResource, ListResources]
}

/// Recupera um recurso específico por ID (Read-only)
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

/// Criação de novos recursos com validação estrita e idempotência
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

/// Listagem paginada de recursos
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
# Este arquivo ensina o Gemini/Qwen como se comportar no projeto.
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
- **Ferramental:** Protocolo MCP (Model Context Protocol) para inspeção de Banco de Dados e Sistema de Arquivos em tempo real.
EOF

# 4. Criar o Diário de Decisões (Contexto Histórico)
cat <<EOF > $PROJECT_NAME/.ai/journal.md
# 📔 Decision Log & Architecture Journal

## [2026-03-27] - Initial Project Setup
- **Decisão:** Inicialização do projeto utilizando SDD e Agentic Workflow.
- **Contexto:** Estrutura agnóstica preparada para escalabilidade.
- **Arquitetura Base:** Modular Monolith (YAGNI - You Ain't Gonna Need It).
EOF

# 5. Criar o Docker Compose (Infraestrutura)
cat <<EOF > $PROJECT_NAME/docker/docker-compose.yml
services:
  db:
    image: postgres:16
    container_name: core_db
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: password
      POSTGRES_DB: app_db
    ports:
      - "5432:5432"

  app:
    build: ..
    container_name: core_app
    volumes:
      - ..:/app
    environment:
      DATABASE_URL: postgresql://admin:password@db:5432/app_db
    depends_on:
      - db
EOF

# 6. Criar o README de Portfólio (A Vitrine para Recrutadores)
cat <<EOF > $PROJECT_NAME/README.md
# Agentic SDD Project (2026)

Este repositório é um showcase de **Engenharia AI-Native**, demonstrando como orquestrar Agentes de IA (Gemini, Qwen, Claude) sob uma governança rígida de arquitetura.

### 🌟 Diferenciais Técnicos:
- **Specification-Driven Development (SDD):** Contratos Smithy como única fonte da verdade.
- **Agentic Workflow:** Diretório \`.ai/\` com instruções semânticas para LLMs.
- **Observabilidade por IA:** Pronto para integração com **MCP Servers** para debug autônomo.

### 🚀 Como Explorar:
1. Analise o contrato inicial em \`specs/project.smithy\`.
2. Veja como a IA é instruída em \`.ai/instructions.md\`.
3. Suba a infraestrutura: \`docker-compose -f docker/docker-compose.yml up -d\`.
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

# Finalização
chmod +x generate-agentic-sdd.sh
echo "--------------------------------------------------------"
echo "✅ Projeto '$PROJECT_NAME' gerado com sucesso!"
echo "📂 Entre na pasta, inicie o Git e chame seu Agente."
echo "--------------------------------------------------------"