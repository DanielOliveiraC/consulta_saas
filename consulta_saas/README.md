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

- Flutter SDK (^3.6.1)
- Conta e projeto Firebase
- Dart SDK

### Instalação

1. Clone o repositório
```bash
git clone [url-do-repositório]
```

2. Instale as dependências
```bash
flutter pub get
```

3. Configure o Firebase
- Adicione seus arquivos de configuração do Firebase
- Atualize o arquivo firebase_options.dart com suas credenciais

4. Execute o aplicativo
```bash
flutter run
```

## 📱 Arquitetura do Aplicativo

O projeto segue um padrão de arquitetura limpa com a seguinte estrutura:

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
- equatable

## 🔐 Segurança

- Firebase Authentication para gerenciamento seguro de usuários
- Regras de segurança do Firestore para proteção de dados
- Controle de acesso baseado em funções

## 🤝 Contribuindo

1. Faça um Fork do projeto
2. Crie sua Branch de Feature (`git checkout -b feature/RecursoIncrivel`)
3. Faça commit das suas alterações (`git commit -m 'Adiciona algum RecursoIncrivel'`)
4. Faça Push para a Branch (`git push origin feature/RecursoIncrivel`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo LICENSE para detalhes.
