-- ============================================
-- SISTEMA DE BIBLIOTECA - CONSULTAS E MANIPULAÇÕES
-- ============================================

USE biblioteca_db;

-- ============================================
-- CONSLUTAS (SELECT)
-- ============================================

-- 1. Listar todos os usuários ativos:
SELECT id, nome, email, telefone 
FROM usuarios 
WHERE ativo = TRUE
ORDER BY nome;

-- 2. Listar todos os livros disponíveis::
SELECT titulo, autor, categoria, exemplares_disponiveis 
FROM livros 
WHERE exemplares_disponiveis > 0
ORDER BY titulo;

-- 3. Listar empréstimos ativos com detalhes:
SELECT 
    e.id AS emprestimo_id,
    u.nome AS usuario,
    l.titulo AS livro,
    e.data_emprestimo,
    e.data_devolucao_prevista,
    DATEDIFF(e.data_devolucao_prevista, CURDATE()) AS dias_restantes
FROM emprestimos e
JOIN usuarios u ON e.usuario_id = u.id
JOIN livros l ON e.livro_id = l.id
WHERE e.status = 'ativo'
ORDER BY e.data_devolucao_prevista;

-- 4. Livros mais emprestados:
SELECT 
    l.titulo,
    l.autor,
    COUNT(e.id) AS total_emprestimos
FROM livros l
LEFT JOIN emprestimos e ON l.id = e.livro_id
GROUP BY l.id, l.titulo, l.autor
ORDER BY total_emprestimos DESC;

-- 5. Usuários com empréstimos ativos :
SELECT 
    u.nome,
    u.email,
    COUNT(e.id) AS emprestimos_ativos
FROM usuarios u
JOIN emprestimos e ON u.id = e.usuario_id
WHERE e.status = 'ativo'
GROUP BY u.id, u.nome, u.email
ORDER BY emprestimos_ativos DESC;

-- 6. Livros por categorias;
SELECT 
    categoria,
    COUNT(*) AS quantidade_livros,
    SUM(exemplares_total) AS total_exemplares
FROM livros
GROUP BY categoria
ORDER BY quantidade_livros DESC;

-- 7. Histórico de empréstimos de um usuário específico:
SELECT 
    l.titulo,
    e.data_emprestimo,
    e.data_devolucao_prevista,
    e.data_devolucao_efetiva,
    e.status
FROM emprestimos e
JOIN livros l ON e.livro_id = l.id
WHERE e.usuario_id = 1
ORDER BY e.data_emprestimo DESC;

-- 8. Empréstimos atrasados (data entrega expirou e  não foi devolvid):
SELECT 
    u.nome AS usuario,
    u.email,
    l.titulo AS livro,
    e.data_devolucao_prevista,
    DATEDIFF(CURDATE(), e.data_devolucao_prevista) AS dias_atraso
FROM emprestimos e
JOIN usuarios u ON e.usuario_id = u.id
JOIN livros l ON e.livro_id = l.id
WHERE e.status = 'ativo' 
  AND e.data_devolucao_prevista < CURDATE()
ORDER BY dias_atraso DESC;

-- ============================================
-- ATUALIZAÇÕES (UPDATE)
-- ============================================

-- 9. Atualizar telefone de um usário:
UPDATE usuarios 
SET telefone = '11999887766' 
WHERE id = 1;

-- 10. Marcar empréstimo como devolvido:
UPDATE emprestimos 
SET status = 'devolvido',
    data_devolucao_efetiva = CURDATE()
WHERE id = 3;

-- 11. Desativar um usuário:
UPDATE usuarios 
SET ativo = FALSE 
WHERE id = 5;

-- 12. Atualizar quantidade de exemplares de um livro:
UPDATE livros 
SET exemplares_total = 4,
    exemplares_disponiveis = exemplares_disponiveis + 1
WHERE id = 2;

-- 13. Marcar empréstimos atrasados:
UPDATE emprestimos 
SET status = 'atrasado'
WHERE status = 'ativo' 
  AND data_devolucao_prevista < CURDATE();

-- ============================================
-- REMOÇÕES (DELETE)
-- ============================================

-- 14. Remover usuário inativo (em CASCADE remove os empréstimos):
-- DELETE FROM usuarios WHERE id = 5 AND ativo = FALSE;

-- 15. Remover empréstimos devolvidos há mais de 1 ano:
-- DELETE FROM emprestimos 
-- WHERE status = 'devolvido' 
--   AND data_devolucao_efetiva < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- 16. Remover livro sem empréstimos:
-- DELETE FROM livros 
-- WHERE id NOT IN (SELECT DISTINCT livro_id FROM emprestimos);

-- NOTA/PS/OBS: deixei os comandos DELETE comentados para não dar problemas, só descomentar pra uso/teste.

-- ============================================
-- CONSULTAS DE VERIFICAÇÃO
-- ============================================

-- 17. Estatísticas gerais do sistema:
SELECT 
    'Usuários Ativos' AS metrica,
    COUNT(*) AS valor
FROM usuarios WHERE ativo = TRUE
UNION ALL
SELECT 
    'Total de Livros' AS metrica,
    COUNT(*) AS valor
FROM livros
UNION ALL
SELECT 
    'Empréstimos Ativos' AS metrica,
    COUNT(*) AS valor
FROM emprestimos WHERE status = 'ativo'
UNION ALL
SELECT 
    'Total de Empréstimos' AS metrica,
    COUNT(*) AS valor
FROM emprestimos;
