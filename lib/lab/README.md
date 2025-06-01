# 🧪 UnoList-Hive Lab — Laboratório de Testes

Este diretório contém o **laboratório de testes manuais e exploratórios** do projeto **UnoList-Hive**.

O objetivo deste ambiente é permitir que os desenvolvedores:

* ✅ Validem os serviços do back-end local baseado em **Hive**.
* ✅ Realizem testes de CRUD, Queries e Backup/Restore.
* ✅ Testem o sistema com **UUIDs** como identificadores (`String`).
* ✅ Executem testes organizados, modulares e reaproveitáveis.
* ✅ Mantenham o `main.dart` limpo e focado na aplicação real.

---

## 🏗️ Estrutura do `/lab/`

```plaintext
lab/
├── crud_tests/          # Testes de CRUD (Create, Read, Update, Delete)
│   ├── category_crud_test.dart
│   └── task_crud_test.dart
├── backup_tests/        # Testes de Backup e Restore
│   └── backup_test.dart
├── query_tests/         # Testes de filtros e buscas
│   └── task_query_test.dart
├── lab_main.dart        # 🚀 Arquivo principal que executa todos os testes sequencialmente
└── README.md            # Este arquivo de documentação
````

---

## 🚀 Como executar o UnoList-Hive Lab

No terminal:

```bash
flutter run -t lib/lab/lab_main.dart
```

Ou no Android Studio:

1. Clique com o botão direito no arquivo **`lab_main.dart`**.
2. Selecione **"Run 'lab\_main.dart'"**.

---

## 🔥 Fluxo de execução

O arquivo **`lab_main.dart`** executa os testes de forma **sequencial e automática**, na seguinte ordem:

1️⃣ **CRUD de Categorias**
2️⃣ **CRUD de Tarefas**
3️⃣ **Consultas (Queries) de Tarefas**
4️⃣ **Backup e Restore**

Todos os testes são rodados em sequência, e os resultados são exibidos no console.

---

## 🧠 Descrição dos Testes

| Diretório       | Arquivo                   | Descrição                                                         |
| --------------- | ------------------------- | ----------------------------------------------------------------- |
| `crud_tests/`   | `category_crud_test.dart` | Testes de criação, listagem e exclusão de categorias usando UUID. |
|                 | `task_crud_test.dart`     | Testes completos de CRUD para tarefas com UUIDs.                  |
| `backup_tests/` | `backup_test.dart`        | Teste de exportação e importação de backup JSON.                  |
| `query_tests/`  | `task_query_test.dart`    | Testes de filtros de tarefas (concluídas/pendentes).              |
| 🔗 Raiz         | `lab_main.dart`           | Arquivo principal que executa todos os testes sequencialmente.    |

---

## 💎 Vantagens deste Lab

* 🔥 Ambiente seguro para testar sem afetar o app real.
* 🆔 Testes já adaptados para UUID v4 como chave primária.
* 🏗️ Arquitetura limpa, modular e escalável.
* 🧠 Serve como documentação viva do funcionamento dos serviços do back-end local (**Hive**).
* ✅ Facilita debugging, desenvolvimento e validação de novas features.

---

## 🧠 Boas práticas recomendadas

* 🔸 Crie novos subdiretórios caso precise de mais categorias de testes (`performance_tests/`, `stress_tests/`, `integration_tests/`, etc.).
* 🔸 Sempre mantenha os testes no Lab separados do app principal.
* 🔸 O Lab não deve ser incluído no build de produção.

---

## 🚫 Atenção

> Este diretório é **exclusivo para desenvolvimento interno**.
> **Não deve ser incluído em builds de produção ou distribuição do app final.**

---

## ✨ Autor

**Paulo Castelo** – *a.k.a* **ZeroAvenger**
🔗 [LinkedIn](https://www.linkedin.com/in/paulo-castelo/) | 🚀 [GitHub](https://github.com/paulocastelo)

---

## 📜 Licença

Este projeto está licenciado sob a [MIT License](../../LICENSE).

---
