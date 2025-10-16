-- ============================================
-- SISTEMA DE BIBLIOTECA - DADOS
-- ============================================

USE biblioteca_db;

-- ============================================
-- INSERIR USUÁRIOS
-- ============================================
INSERT INTO usuarios (nome, email, telefone, data_cadastro, ativo) VALUES
('João Silva', 'joao.silva@email.com', '11987654321', '2024-01-15', TRUE),
('Maria Santos', 'maria.santos@email.com', '11976543210', '2024-02-20', TRUE),
('Pedro Oliveira', 'pedro.oliveira@email.com', '11965432109', '2024-03-10', TRUE),
('Ana Costa', 'ana.costa@email.com', '11954321098', '2024-04-05', TRUE),
('Carlos Souza', 'carlos.souza@email.com', '11943210987', '2024-05-12', FALSE);

-- ============================================
-- INSERIR LIVROS
-- ============================================
INSERT INTO livros (titulo, autor, isbn, ano_publicacao, categoria, exemplares_total, exemplares_disponiveis) VALUES
('1984', 'George Orwell', '978-0451524935', 1949, 'Ficção', 3, 3),
('Dom Casmurro', 'Machado de Assis', '978-8535911664', 1899, 'Romance', 2, 2),
('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', '978-8522008803', 1943, 'Infantil', 4, 4),
('Clean Code', 'Robert C. Martin', '978-0132350884', 2008, 'Tecnologia', 2, 2),
('Sapiens', 'Yuval Noah Harari', '978-0062316097', 2011, 'História', 3, 3),
('Harry Potter e a Pedra Filosofal', 'J.K. Rowling', '978-8532530788', 1997, 'Fantasia', 5, 5),
('O Senhor dos Anéis', 'J.R.R. Tolkien', '978-8533613379', 1954, 'Fantasia', 2, 2),
('A Culpa é das Estrelas', 'John Green', '978-8580572261', 2012, 'Romance', 3, 3);

-- ============================================
-- INSERIR EMPRÉSTIMOS
-- ============================================
INSERT INTO emprestimos (usuario_id, livro_id, data_emprestimo, data_devolucao_prevista, data_devolucao_efetiva, status) VALUES
(1, 1, '2024-08-01', '2024-08-15', '2024-08-14', 'devolvido'),
(2, 3, '2024-08-10', '2024-08-24', '2024-08-23', 'devolvido'),
(3, 5, '2024-09-01', '2024-09-15', NULL, 'ativo'),
(1, 4, '2024-09-05', '2024-09-19', NULL, 'ativo'),
(4, 6, '2024-09-10', '2024-09-24', NULL, 'ativo'),
(2, 2, '2024-07-20', '2024-08-03', '2024-08-10', 'devolvido'),
(3, 7, '2024-08-15', '2024-08-29', '2024-09-05', 'devolvido'),
(1, 8, '2024-09-12', '2024-09-26', NULL, 'ativo');

-- ============================================
-- VERIFICAR DADOS INSERIDOS
-- ============================================
SELECT 'Usuários cadastrados:' AS Info;
SELECT COUNT(*) AS total FROM usuarios;

SELECT 'Livros cadastrados:' AS Info;
SELECT COUNT(*) AS total FROM livros;

SELECT 'Empréstimos registrados:' AS Info;
SELECT COUNT(*) AS total FROM emprestimos;
