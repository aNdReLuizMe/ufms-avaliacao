-- ============================================
-- SISTEMA DE BIBLIOTECA - SCHEMA
-- ============================================

-- Criar banco de dados (caso não exista)
CREATE DATABASE IF NOT EXISTS biblioteca_db;
USE biblioteca_db;

-- ============================================
-- TABELA: usaurios
-- ============================================
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    data_cadastro DATE NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- TABELA: livros
-- ============================================
CREATE TABLE livros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    ano_publicacao INT,
    categoria VARCHAR(50),
    exemplares_total INT NOT NULL DEFAULT 1,
    exemplares_disponiveis INT NOT NULL DEFAULT 1,
    INDEX idx_titulo (titulo),
    INDEX idx_autor (autor),
    INDEX idx_categoria (categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- TABELA: emprestimos
-- ============================================
CREATE TABLE emprestimos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    livro_id INT NOT NULL,
    data_emprestimo DATE NOT NULL,
    data_devolucao_prevista DATE NOT NULL,
    data_devolucao_efetiva DATE,
    status ENUM('ativo', 'devolvido', 'atrasado') DEFAULT 'ativo',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE CASCADE,
    INDEX idx_usuario (usuario_id),
    INDEX idx_livro (livro_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- TRIGGER: Atualizar disponibilidade ao emprestar
-- ============================================
DELIMITER //
CREATE TRIGGER after_emprestimo_insert
AFTER INSERT ON emprestimos
FOR EACH ROW
BEGIN
    IF NEW.status = 'ativo' THEN
        UPDATE livros 
        SET exemplares_disponiveis = exemplares_disponiveis - 1 
        WHERE id = NEW.livro_id;
    END IF;
END//
DELIMITER ;

-- ============================================
-- TRIGGER: Atualizar disponibilidade ao devolver
-- ============================================
DELIMITER //
CREATE TRIGGER after_emprestimo_update
AFTER UPDATE ON emprestimos
FOR EACH ROW
BEGIN
    IF OLD.status = 'ativo' AND NEW.status = 'devolvido' THEN
        UPDATE livros 
        SET exemplares_disponiveis = exemplares_disponiveis + 1 
        WHERE id = NEW.livro_id;
    END IF;
END//
DELIMITER ;
