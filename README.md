# 🤖 sdd-agentic-agnostic 

![Architecture Architecture](https://img.shields.io/badge/Architecture-SDD-blue?style=for-the-badge)
![Agentic Ready](https://img.shields.io/badge/Agentic-Ready-green?style=for-the-badge)
![Agnostic](https://img.shields.io/badge/Agnostic-Universal-orange?style=for-the-badge)
![MCP Protocol](https://img.shields.io/badge/MCP-Protocol-purple?style=for-the-badge)


Este repositório é um showcase de **Arquitetura de Software Moderna**, demonstrando a convergência entre **Specification-Driven Design (SDD)** e **Agentic Workflows**. Aqui, a IA não é apenas um "auto-complete", mas um agente de engenharia que opera sob regras rígidas de contrato e governança.

---

## 🌟 Por que "SDD-Agentic-Agnostic"?

1.  **SDD (Specification-Driven Design):** A "Fonte da Verdade" é o contrato em **Smithy IDL**. O código é um derivado fiel da especificação, eliminando alucinações da IA e garantindo integridade sistêmica.
2.  **Agentic:** O projeto é desenhado para ser operado por Agentes (Gemini CLI, Qwen Code, Claude Code). O diretório `.ai/` contém o "cérebro" e as instruções para que a IA atue como um Engenheiro Sênior.
3.  **Agnostic:** Total independência de ferramentas. Troque o LLM, a Linguagem de Programação ou o Banco de Dados sem perder a governança do projeto. O contrato (.smithy) e as instruções (.md) permanecem os mesmos.

---

## 🛠️ Arquitetura do Ecossistema

-   **`.ai/instructions.md`**: Protocolos de governança e regras de decisão para a IA.
-   **`specs/project.smithy`**: Definição formal de tipos, operações e erros (Agnóstico a protocolo).
-   **`.ai/journal.md`**: Registro histórico de decisões arquiteturais (ADRs) documentadas pelo Agente.
-   **`mcp-config.json`**: Ponte de conectividade via **Model Context Protocol**, permitindo que a IA inspecione o mundo real (DB/Filesystem).
-   **`docker/`**: Infraestrutura reprodutível para garantir que a IA teste o que constrói.

---

## 🚀 Workflow de Desenvolvimento

1.  **Definição:** O humano descreve a intenção.
2.  **Design-First:** O Agente atualiza a **Spec Smithy** e justifica a escolha no **Journal**.
3.  **Implementação:** O Agente gera o código seguindo as constraints da Spec.
4.  **Validação:** Testes de contrato são executados no ambiente Docker via comandos de terminal assistidos.

---
*Ready for Gemini 3 Flash, Qwen-2.5-Coder and Claude 3.7.*