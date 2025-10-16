# Diagrama Entidade-Relacionamento (ER)

## Modelo Conceitual

```
┌─────────────────┐
│    USUARIOS     │
├─────────────────┤
│ PK id           │
│    nome         │
│    email        │
│    telefone     │
│    data_cadastro│
│    ativo        │
└─────────────────┘
         │
         │ 1
         │
         │ tem
         │
         │ N
         ▼
┌─────────────────┐
│  EMPRESTIMOS    │
├─────────────────┤
│ PK id           │
│ FK usuario_id   │───┐
│ FK livro_id     │   │
│    data_emprest │   │
│    data_prev    │   │
│    data_efetiva │   │
│    status       │   │
└─────────────────┘   │
         ▲            │
         │ N          │
         │            │
         │ pertence a │
         │            │
         │ 1          │
         │            │
┌─────────────────┐   │
│     LIVROS      │◄──┘
├─────────────────┤
│ PK id           │
│    titulo       │
│    autor        │
│    isbn         │
│    ano_public   │
│    categoria    │
│    exempl_total │
│    exempl_disp  │
└─────────────────┘
```

## Relacionamentos

### 1. usuarios ↔ emprestimos (1:N)

- **Cardinalidade**: Um usuário pode ter vários empréstimos
- **Obrigatoriedade**: Um empréstimo deve pertencer a um usuário
- **Chave Estrangeira**: `emprestimos.usuario_id` → `usuarios.id`
- **Ação de Cascata**: `ON DELETE CASCADE`

### 2. livros ↔ emprestimos (1:N)

- **Cardinalidade**: Um livro pode ter vários empréstimos ao longo do tempo
- **Obrigatoriedade**: Um empréstimo deve referenciar um livro
- **Chave Estrangeira**: `emprestimos.livro_id` → `livros.id`
- **Ação de Cascata**: `ON DELETE CASCADE`

## Restrições e Regras de Negócio

### Tabela: usuarios

- `email` deve ser único
- `ativo` indica se o usuário pode fazer empréstimos
- `data_cadastro` não pode ser nula

### Tabela: livros

- `isbn` deve ser único
- `exemplares_disponiveis` não pode ser negativo
- `exemplares_disponiveis` ≤ `exemplares_total`

### Tabela: emprestimos

- `status` pode ser: 'ativo', 'devolvido' ou 'atrasado'
- `data_devolucao_prevista` = `data_emprestimo` + 14 dias (padrão)
- Se `data_devolucao_efetiva` > `data_devolucao_prevista` → empréstimo atrasado
- Quando status muda para 'devolvido', incrementa `exemplares_disponiveis`
- Quando novo empréstimo é criado, decrementa `exemplares_disponiveis`

## Índices Criados

### usuarios

- `idx_email` - Busca rápida por email

### livros

- `idx_titulo` - Busca por título
- `idx_autor` - Busca por autor
- `idx_categoria` - Filtro por categoria

### emprestimos

- `idx_usuario` - Empréstimos por usuário
- `idx_livro` - Histórico do livro
- `idx_status` - Filtro por status

## Triggers Implementados

### after_emprestimo_insert

**Evento**: Após inserir um novo empréstimo  
**Ação**: Reduz `exemplares_disponiveis` do livro em 1  
**Condição**: Apenas se status = 'ativo'

### after_emprestimo_update

**Evento**: Após atualizar um empréstimo  
**Ação**: Aumenta `exemplares_disponiveis` do livro em 1  
**Condição**: Quando status muda de 'ativo' para 'devolvido'

## Normalização

O banco de dados está na **3ª Forma Normal (3FN)**:

**1FN**: Todos os campos são atômicos (não há grupos repetidos)  
**2FN**: Não há dependências parciais da chave primária  
**3FN**: Não há dependências transitivas entre atributos não-chave
