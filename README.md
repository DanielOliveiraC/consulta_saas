# SaaS Consultas - Sistema de Gerenciamento de Consultas Médicas

Uma aplicação Flutter para gerenciamento de consultas médicas entre médicos e pacientes, construída com integração Firebase.

## 🌟 Funcionalidades

- **Sistema de Autenticação**
  - Autenticação segura de usuários usando Firebase Auth
  - Acesso baseado em funções (Médicos e Pacientes)

- **Gerenciamento de Médicos**
  - Perfis de médicos com especialidades
  - Gerenciamento de disponibilidade
  - Agendamento de consultas

- **Sistema de Agendamento**
  - Criar e gerenciar consultas
  - Visualizar histórico de consultas
  - Atualizações em tempo real usando Firebase

## 🚀 Como Começar

### Pré-requisitos

- Flutter SDK
- Conta e projeto Firebase
- Dart SDK

## 📱 Arquitetura do Aplicativo
```
lib/
├── config/         # Arquivos de configuração
├── models/         # Modelos de dados
├── services/       # Lógica de negócios e serviços Firebase
├── views/          # Telas da interface do usuário
├── widgets/        # Widgets reutilizáveis
└── main.dart       # Ponto de entrada do aplicativo
```

## 🛠️ Construído Com

- **Flutter** - Framework de UI
- **Firebase** - Serviços de backend
  - Firebase Auth - Autenticação
  - Cloud Firestore - Banco de dados
- **Provider** - Gerenciamento de estado

## 📄 Dependências

- firebase_core
- firebase_auth
- cloud_firestore
- provider

## 🔐 Segurança

- Firebase Authentication para gerenciamento seguro de usuários
- Regras de segurança do Firestore para proteção de dados

