### 🛒 Supermercado

Aplicação simples de supermercado em Flutter e SQLite com funcionalidades para usuários e administradores.

### 📌 Sobre o Projeto

Este é um projeto de supermercado com suporte a dois tipos de usuários:

Usuário comum, que pode visualizar e comprar produtos.

Administrador, que pode criar, editar, remover e visualizar produtos.

A aplicação utiliza SQLite como banco de dados local para armazenamento das informações dos usuários e produtos.

A arquitetura é organizada em camadas, separando entidades, infraestrutura, apresentação e módulos de lógica de negócio.

### 🗂 Estrutura de Arquivos

```
/lib
├── /entities - Modelos da aplicação (Usuário e Produto)
│ 
├── /infrastructure
│ ├── /database - Banco de dados da aplicação (Criação das tabelas e do banco)
│ └── /presentation - Telas da aplicação e Providers (Gerenciamento de Estado)
│ 
├── /modules - Implementação dos Modelos (Contratos, Casos de Uso e Repositórios)
│ └── /exemplo
│   ├── exemplo_spec.dart - Contrato
│   ├── exemplo_usecase.dart - Caso de Uso
│   └── exemplo_repository.dart - Repositório
│ 
└── main.dart
```
