# Sistema de Biblioteca - Banco de Dados - (Avaliação UFMS)

Projeto acadêmico de modelagem e manipulação de banco de dados utilizando MySQL e Docker, com controle de versão via Git/GitHub.

## Descrição do Projeto

Sistema simple de gerenciamento de biblioteca que permite:

- Cadastro de usuários
- Cadastro de livros
- Controle de empréstimos e devoluções
- Consultas e relatórios diversos

## strutura do Banco de Dados

### Entidades

#### 1. **usuarios**

Armazena informações dos usuários da biblioteca.

- `id` (PK)
- `nome`
- `email` (UNIQUE)
- `telefone`
- `data_cadastro`
- `ativo`

#### 2. **livros**

Cadastro dos livros disponíveis.

- `id` (PK)
- `titulo`
- `autor`
- `isbn` (UNIQUE)
- `ano_publicacao`
- `categoria`
- `exemplares_total`
- `exemplares_disponiveis`

#### 3. **emprestimos**

Registro de empréstimos realizados.

- `id` (PK)
- `usuario_id` (FK)
- `livro_id` (FK)
- `data_emprestimo`
- `data_devolucao_prevista`
- `data_devolucao_efetiva`
- `status` (ativo, devolvido, atrasado)

### Relacionamentos

- **usuarios → emprestimos** (1:N)

  - Um usuário pode ter vários empréstimos

- **livros → emprestimos** (1:N)
  - Um livro pode ser emprestado várias vezes

## Como Executar

### Pré-requisitos

- Docker instalado
- Docker Compose instalado
- Git instalado

### Passo a Passo

1. **Clone o repositório**

```bash
git clone https://github.com/aNdReLuizMe/ufms-avaliacao.git
cd ufms-avaliacao
```

2. **Inicie o container MySQL**

```bash
docker-compose up -d
```

3. **Aguarde o MySQL inicializar** (cerca de 30 segundos)

4. **Acesse o MySQL**

```bash
docker exec -it biblioteca mysql -u user -p
# Senha: 123
```

5. **Os scripts SQL serão executados automaticamente** na ordem:
   - `01-schema.sql` - Cria as tabelas
   - `02-data.sql` - Insere dados de exemplo populando as tableas
   - `03-queries.sql` - Consultas disponíveis em separado

## Consultas Disponíveis

O arquivo `03-queries.sql` contém diversos exemplos de consultas:

- Listar usuários ativos
- Listar livros disponíveis
- Empréstimos ativos com detalhes
- Livros mais emprestados
- Empréstimos atrasados
- Histórico por usuário
- Estatísticas gerais

## Operações Implementadas

### CREATE (Inserção)

- Cadastro de novos usuários
- Cadastro de novos livros
- Registro de empréstimos

### READ (Consulta)

- Consultas simples e complexas com JOIN
- Agrupamentos e estatísticas
- Filtros por status, data, categoria

### UPDATE (Atualização)

- Atualização de dados de usuários
- Marcação de devoluções
- Atualização de quantidades de exemplares
- Marcação de empréstimos atrasados

### DELETE (Remoção)

- Remoção de usuários inativos
- Limpeza de empréstimos antigos
- Remoção de livros sem movimentação

## Recursos Avançados

### Triggers

- **after_emprestimo_insert**: Reduz exemplares disponíveis ao criar empréstimo
- **after_emprestimo_update**: Aumenta exemplares disponíveis ao devolver

### Índices

- Otimização de consultas por email, título, autor e categoria
- Melhoria de performance em INNER JOINs

### Constraints

- Chaves primárias e estrangeiras
- Campos únicos (email, ISBN)
- Valores padrão
- Enumerações (status)

## Estrutura de Arquivos

```
ufms-avaliacao/
├── compose.yml            # Configuração do Docker
├── sql/
│   ├── 01-schema.sql      # Criação das tabelas
│   ├── 02-data.sql        # Inserção de dados
│   └── 03-queries.sql     # Consultas e manipulações
├── docs/
│   └── diagrama-er.md     # Diagrama entidade-relacionamento
├── README.md              # Este arquivo
└── .gitignore             # Arquivos ignorados pelo Git
```

## Como Parar o Projeto

```bash
# Parar containers
docker-compose down

# Parar e remover volumes (apaga dados)
docker-compose down -v
```

## Autor

**[Andre Pereira](https://www.linkedin.com/in/andreluizme/)**
Avaliação do Módulo 3 - Banco de Dados e Controle de Versão
UFMS / Tecnologia da Informação
Out 2025

## Licença

Este projeto foi desenvolvido para fins educacionais, podendo ser replicado, alterado, remodelado à livre vontade de qualquer um.
