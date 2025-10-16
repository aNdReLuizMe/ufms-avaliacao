# Sistema de Biblioteca — Banco de Dados (Avaliação UFMS)

Projeto acadêmico de modelagem e manipulação de banco de dados utilizando MySQL e Docker, com controle de versão via Git/GitHub.

## Descrição do Projeto

Sistema simples de gerenciamento de biblioteca que permite:

- Cadastro de usuários
- Cadastro de livros
- Controle de empréstimos e devoluções
- Consultas e relatórios diversos

## Estrutura do Banco de Dados

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
docker compose up -d
```

3. **Aguarde o MySQL inicializar** (cerca de 30 segundos)

4. **Acesse o MySQL**

```bash
docker exec -it biblioteca mysql -u user -p123
```

5. **Os scripts SQL serão executados automaticamente (apenas na primeira inicialização do volume)** na ordem:
   - `01-schema.sql` - Cria as tabelas
   - `02-data.sql` - Insere dados de exemplo populando as tabelas
   - `03-queries.sql` - Consultas disponíveis em separado

### Notas importantes sobre a inicialização

- Os arquivos em `sql/` são executados automaticamente pelo MySQL apenas quando o volume de dados é criado pela primeira vez.
- Após a primeira execução, subir o container novamente não reexecuta os scripts. Para repetir a carga do zero, apague o volume (veja abaixo em “Como Parar/Resetar”).

### Verificação rápida

```bash
docker exec -it biblioteca mysql -u user -p123 -e "USE biblioteca_db; SELECT COUNT(*) AS usuarios FROM usuarios; SELECT COUNT(*) AS livros FROM livros; SELECT COUNT(*) AS emprestimos FROM emprestimos;"
```

### Executar scripts manualmente (sem resetar o volume)

Se o banco já está criado e você apenas quer repopular dados de exemplo:

```bash
# pra executar apenas o script de dados
docker exec -i biblioteca sh -c "mysql -uuser -p123 biblioteca_db < /docker-entrypoint-initdb.d/02-data.sql"
```

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
│   └── diagram-er.md      # Diagrama entidade-relacionamento
├── README.md              # Este arquivo
└── .gitignore             # Arquivos ignorados pelo Git
```

## Como Parar/Resetar o Projeto

```bash
# Parar containers
docker compose down

# Parar e remover volumes
docker compose down -v

# Subir novamente após reset (reexecutará os scripts 01 - cria db/tables / 02 - popula tudo / 03 - executa queries)
docker compose up -d
```

## Autor

**[Andre Pereira](https://www.linkedin.com/in/andreluizme/){:target="\_blank"}**

- Avaliação do Módulo 3 - Banco de Dados e Controle de Versão
- UFMS / Tecnologia da Informação ~ Out 2025

## Licença

Este projeto foi desenvolvido para fins educacionais, podendo ser replicado, alterado, remodelado à livre vontade de qualquer um.
