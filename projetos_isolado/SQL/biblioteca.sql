-- Criação das Tabelas

-- Tabela Autores
CREATE TABLE Autores (
    AutorID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Nacionalidade VARCHAR(50)
);

-- Tabela Livros
CREATE TABLE Livros (
    LivroID INT PRIMARY KEY AUTO_INCREMENT,
    Titulo VARCHAR(200) NOT NULL,
    AutorID INT,
    AnoPublicacao INT,
    ISBN VARCHAR(20),
    FOREIGN KEY (AutorID) REFERENCES Autores(AutorID)
);

-- Tabela Usuários
CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefone VARCHAR(15)
);

-- Tabela Empréstimos
CREATE TABLE Emprestimos (
    EmprestimoID INT PRIMARY KEY AUTO_INCREMENT,
    LivroID INT,
    UsuarioID INT,
    DataEmprestimo DATE NOT NULL,
    DataDevolucao DATE,
    FOREIGN KEY (LivroID) REFERENCES Livros(LivroID),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

-- Inserção de Dados

-- Inserindo autores
INSERT INTO Autores (Nome, Nacionalidade) VALUES
('Machado de Assis', 'Brasileiro'),
('Clarice Lispector', 'Brasileira'),
('J.K. Rowling', 'Britânica');

-- Inserindo livros
INSERT INTO Livros (Titulo, AutorID, AnoPublicacao, ISBN) VALUES
('Dom Casmurro', 1, 1899, '978-85-7232-144-9'),
('A Hora da Estrela', 2, 1977, '978-85-325-0261-2'),
('Harry Potter e a Pedra Filosofal', 3, 1997, '978-85-325-1111-9');

-- Inserindo usuários
INSERT INTO Usuarios (Nome, Email, Telefone) VALUES
('João Silva', 'joao.silva@example.com', '11987654321'),
('Maria Oliveira', 'maria.oliveira@example.com', '21987654321');

-- Inserindo empréstimos
INSERT INTO Emprestimos (LivroID, UsuarioID, DataEmprestimo, DataDevolucao) VALUES
(1, 1, '2023-10-01', NULL),  -- Livro ainda não devolvido
(2, 2, '2023-10-05', '2023-10-12');  -- Livro já devolvido

-- Consultas Úteis

-- 1. Consultar livros emprestados no momento
SELECT L.Titulo, A.Nome AS Autor, U.Nome AS Usuario, E.DataEmprestimo
FROM Emprestimos E
JOIN Livros L ON E.LivroID = L.LivroID
JOIN Autores A ON L.AutorID = A.AutorID
JOIN Usuarios U ON E.UsuarioID = U.UsuarioID
WHERE E.DataDevolucao IS NULL;

-- 2. Relatório de livros mais populares (mais emprestados)
SELECT L.Titulo, COUNT(E.EmprestimoID) AS TotalEmprestimos
FROM Emprestimos E
JOIN Livros L ON E.LivroID = L.LivroID
GROUP BY L.Titulo
ORDER BY TotalEmprestimos DESC;

-- 3. Controle de devolução (livros que estão com a devolução atrasada)
SELECT L.Titulo, U.Nome AS Usuario, E.DataEmprestimo, E.DataDevolucao
FROM Emprestimos E
JOIN Livros L ON E.LivroID = L.LivroID
JOIN Usuarios U ON E.UsuarioID = U.UsuarioID
WHERE E.DataDevolucao IS NULL AND E.DataEmprestimo < DATE_SUB(CURDATE(), INTERVAL 14 DAY);