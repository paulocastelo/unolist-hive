# 📝 UnoList

UnoList é um aplicativo de **lista de tarefas offline**, desenvolvido em **Flutter**, com back-end local utilizando **Isar Database** e interface simples, intuitiva e leve.

O projeto foi pensado para ser minimalista, funcional e com foco total em produtividade, permitindo ao usuário:

- ✅ Organizar tarefas.
- ✅ Criar categorias.
- ✅ Filtrar, concluir e gerenciar tarefas.
- ✅ Realizar backup e restauração dos dados localmente (arquivo JSON).

---

## 🚀 Tecnologias Utilizadas

- **Flutter** — UI e lógica
- **Dart** — Linguagem principal
- **Isar Database** — Banco de dados local NoSQL ultra rápido
- **path_provider** — Localização dos diretórios no dispositivo
- **dart:convert / dart:io** — Manipulação de arquivos e JSON (Backup/Restore)

---

## 🏛️ Arquitetura do Projeto

```

lib/
├── database/       # Configuração do banco de dados (IsarService)
├── models/         # Entidades: Task e Category
├── services/       # Serviços de dados: CRUD, Queries, Backup/Restore
├── ui/             # Interface (UI) - Páginas e Componentes Flutter
│   ├── pages/      # Telas principais do app
│   └── widgets/    # (Opcional) Componentes reutilizáveis
├── lab/            # Laboratório de testes (CRUD, Backup, Queries)
└── main.dart       # Entrada do app - inicializa backend + frontend

```

---

## 🔥 Funcionalidades

### 🏗️ **Back-End Local (Camada de Dados)**
- CRUD completo para Tarefas e Categorias.
- Filtros:
    - Por status (Concluído/Pendente)
    - Por categoria
- Backup em JSON.
- Restauração dos dados via JSON.
- Gerenciado pelo banco local **Isar** (super rápido e offline).

### 🎨 **Front-End (Interface)**
- Tela inicial com lista de tarefas.
- Tela para criar e editar tarefas.
- Tela de categorias.
- Tela de configurações:
    - Backup dos dados.
    - Restauração de dados.
- UI moderna, minimalista e responsiva.

---

## 💾 Backup e Restore

- O arquivo de backup é salvo no diretório local do app:

```

\<diretório\_do\_app>/uno\_list\_backup.json

````

- Pode ser usado para transferir dados entre dispositivos ou fazer restaurações manuais.

---

## 🏗️ Como Executar o Projeto

### 1️⃣ Instale as dependências:

```bash
flutter pub get
````

### 2️⃣ Gere os arquivos do Isar (modelos):

```bash
dart run build_runner build
```

### 3️⃣ Execute o app:

```bash
flutter run
```

🟢 Ou rode diretamente pelo Android Studio clicando em **"Run"** no arquivo `main.dart`.

---

## 🧪 Executando o Lab (Testes Internos)

### ✔️ Para rodar os testes manuais de backend:

```bash
flutter run -t lib/lab/lab_main.dart
```

→ O Lab executa sequencialmente testes de CRUD, Backup, Restore e Queries, exibindo os resultados no console.

---

## 🚦 Status do Projeto

| Módulo                 | Status                 |
| ---------------------- | ---------------------- |
| Back-End Local (Isar)  | ✅ Finalizado e testado |
| Front-End (UI Flutter) | 🚧 Em desenvolvimento  |

---

## 🧠 Boas Práticas no Projeto

* Arquitetura limpa com separação de responsabilidades:

    * `/models/` → Entidades
    * `/services/` → Lógica de dados
    * `/database/` → Configuração do Isar
    * `/ui/` → Telas e componentes Flutter
    * `/lab/` → Laboratório de testes manuais
* Uso de `IsarService` como **Singleton**, evitando erros de múltiplas instâncias do banco.

---

## 📜 Licença

Este projeto está licenciado sob a [MIT License](./LICENSE).

---

## ✨ Autor

**Paulo Castelo** – *aka* **ZeroAvenger**
🔗 [LinkedIn](https://www.linkedin.com/in/paulo-castelo/) | 🚀 [GitHub](https://github.com/paulocastelo)

---
