
# 📝 UnoList-Hive

UnoList-Hive é um aplicativo de **lista de tarefas offline**, desenvolvido em **Flutter**, com back-end local utilizando **Hive Database**, suporte total a **backup em JSON**, restauração, e uma interface leve e funcional.

Este projeto é uma **migração** do [UnoList](https://github.com/paulocastelo/unolist), que utilizava **Isar Database**, para **Hive** com o objetivo de explorar uma alternativa mais leve e compatível com múltiplas plataformas.

---

## 🚀 Funcionalidades Principais

* ✅ Criar, editar, excluir e concluir tarefas.
* ✅ Gerenciar categorias com seleção de cores.
* ✅ Aplicar filtros por categorias e busca textual.
* ✅ Backup e restauração dos dados via arquivos JSON.
* ✅ Backup avançado:

  * 🔸 Por categoria.
  * 🔸 Por status (Concluído/Pendente).
  * 🔸 Por intervalo de datas.
* ✅ Função de reset total do banco (**Truncate**).
* ✅ Garantia de que nenhuma tarefa fique sem categoria, com a categoria fixa **"Sem Categoria"** protegida contra remoção.

---

## 🏗️ Arquitetura do Projeto

```plaintext
lib/
├── database/        # Configuração do banco (HiveService)
├── models/          # Entidades (Task e Category)
├── services/        # Lógica de dados: CRUD, Queries, Backup, Restore, Truncate
├── ui/              # Interface do usuário (Flutter)
│   ├── pages/       # Telas (Home, TaskForm, Categories, Settings)
│   └── widgets/     # Componentes reutilizáveis (TaskItem, etc.)
├── utils/           # Extensões e funções auxiliares
├── lab/             # Laboratório para testes no console
└── main.dart        # Ponto de entrada do app
```

---

## 🔥 Tecnologias Utilizadas

* 🏗️ **Flutter** — UI e lógica
* 💙 **Dart** — Linguagem principal
* 🐝 **Hive** — Banco de dados local NoSQL leve e rápido
* 📂 **path\_provider** — Diretórios locais
* 📦 **file\_picker** — Importação de arquivos JSON
* 🗃️ **dart\:convert** e **dart\:io** — Manipulação de JSON e arquivos

---

## 🔗 Estrutura dos Dados (Models)

### 🗂️ Category

```dart
Category {
int id;
String name;
int color;
DateTime createdAt;
}
```

### ✅ Task

```dart
Task {
int id;
String title;
String? description;
DateTime? dueDate;
int? categoryId;
bool isCompleted;
String priority; // Alta | Média | Baixa
DateTime createdAt;
}
```

Ambos possuem suporte total a JSON (`toJson()` e `fromJson()`).

---

## 🧠 Funcionalidades de Backup e Restore

* ✔️ **Backup completo:** Exporta todas as tarefas e categorias para um arquivo `.json`.
* ✔️ **Restore completo:** Importa os dados de um backup.
* ✔️ **Backup avançado:** Permite selecionar:

  * Por categoria.
  * Por status (Concluído ou Pendente).
  * Por período (`createdAt`).
* ✔️ **Arquivos nomeados automaticamente:**

```plaintext
backup_2025-05-30_18-42-00.json
```

* ✔️ O backup funciona como transporte de dados entre dispositivos.

---

## 🏗️ Como Executar o Projeto

### 🔥 Instale as dependências:

```bash
flutter pub get
```

### 🚀 Execute o app:

```bash
flutter run
```

Ou clique em **"Run"** no `main.dart` no Android Studio ou VSCode.

---

## 🧪 Rodando o Lab (Testes no Console)

Execute comandos de CRUD, Backup, Restore, Truncate e Queries diretamente no terminal:

```bash
flutter run -t lib/lab/lab_main.dart
```

---

## 🚦 Status Atual do Projeto

| Módulo                 | Status                  |
| ---------------------- | ----------------------- |
| Back-End Local (Hive)  | ✅ Finalizado e validado |
| Front-End (UI Flutter) | 🚀 Funcional e completo |

---

## 🧠 Boas Práticas e Design

* ✅ **Arquitetura limpa:**

  * Models isolados.
  * Serviços responsáveis pela lógica de dados.
  * UI desacoplada da lógica de persistência.
* ✅ **Singleton do banco (HiveService)**.
* ✅ **Categoria protegida "Sem Categoria"**:

  * Nunca pode ser deletada.
  * Tarefas órfãs são automaticamente movidas para ela.
* ✅ **Backup seguro com timestamp no nome dos arquivos**.
* ✅ **Código documentado, limpo e organizado.**

---

## 🧰 Melhorias Futuras (Ideias)

* 🔗 Sincronização na nuvem (Google Drive, Dropbox ou outro).
* 🔔 Notificações locais para tarefas com prazo.
* 📅 Integração com calendário.
* 🌓 Tema escuro/claro.
* 📊 Relatórios e gráficos de produtividade.
* 🌐 Multi-idioma (Internacionalização).

---

## 📜 Licença

MIT License — [Leia aqui](./LICENSE)

---

## ✨ Autor

**Paulo Castelo** – *a.k.a* **ZeroAvenger**
🚀 [GitHub](https://github.com/paulocastelo)
🔗 [LinkedIn](https://www.linkedin.com/in/paulo-castelo)

---