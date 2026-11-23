CRUD de Veículos — Dart e Supabase

Sobre o projeto

Aplicação desenvolvida em Dart para realizar o cadastro, a consulta, a atualização e a exclusão de veículos, utilizando o Supabase como banco de dados.

O sistema funciona pelo terminal e permite executar todas as operações por meio de um menu interativo.

Tecnologias utilizadas

Dart

Supabase

PostgreSQL

Pacote supabase

Pacote dotenv

Estrutura do projeto

CRUD_Veiculos/
├── bin/
│   └── main.dart
├── lib/
│   ├── conexao.dart
│   └── veiculos.dart
├── .env
├── .gitignore
├── pubspec.yaml
└── README.md

Funcionalidades

Cadastrar veículos.

Listar veículos cadastrados.

Atualizar informações de veículos.

Excluir veículos.

Validar os dados informados pelo usuário.

Configuração

1. Pré-requisitos

Dart SDK instalado.

Conta e projeto no Supabase.

2. Configurar as credenciais

Na raiz do projeto, crie um arquivo .env com as seguintes variáveis:

SUPABASE_URL=sua_url_do_supabase
SUPABASE_PUBLISHABLE_KEY=sua_chave_publica

Substitua os valores pelos dados do seu projeto Supabase.

3. Instalar as dependências

Na raiz do projeto, execute:

dart pub get

4. Executar o projeto

Execute:

dart run bin/main.dart

Banco de dados

O projeto utiliza a tabela veiculos, no schema public, com os seguintes campos:

Campo

Tipo

id

bigint (Identity / Primary Key)

marca

varchar(50)

modelo

varchar(100)

ano

integer

valor

numeric(12,2)

quilometragem

integer

O ID é gerado automaticamente pelo banco de dados.

Observação

O arquivo .env contém as credenciais de conexão e não deve ser enviado ao GitHub. Ele está incluído no .gitignore.

Desenvolvido como atividade acadêmica de Engenharia de Software.
