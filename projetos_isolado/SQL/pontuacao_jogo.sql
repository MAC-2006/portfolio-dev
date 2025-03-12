-- Criação das Tabelas

-- Tabela Jogadores
CREATE TABLE Jogadores (
    JogadorID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    DataCadastro DATE NOT NULL
);

-- Tabela Jogos
CREATE TABLE Jogos (
    JogoID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Descricao TEXT
);

-- Tabela Competições
CREATE TABLE Competicoes (
    CompeticaoID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    DataInicio DATE NOT NULL,
    DataFim DATE
);

-- Tabela Pontuações
CREATE TABLE Pontuacoes (
    PontuacaoID INT PRIMARY KEY AUTO_INCREMENT,
    JogadorID INT,
    JogoID INT,
    CompeticaoID INT,
    Pontos INT NOT NULL,
    DataPontuacao DATE NOT NULL,
    FOREIGN KEY (JogadorID) REFERENCES Jogadores(JogadorID),
    FOREIGN KEY (JogoID) REFERENCES Jogos(JogoID),
    FOREIGN KEY (CompeticaoID) REFERENCES Competicoes(CompeticaoID)
);

-- Inserção de Dados

-- Inserindo jogadores
INSERT INTO Jogadores (Nome, Email, DataCadastro) VALUES
('João Silva', 'joao.silva@example.com', '2023-10-01'),
('Maria Oliveira', 'maria.oliveira@example.com', '2023-10-02'),
('Carlos Souza', 'carlos.souza@example.com', '2023-10-03');

-- Inserindo jogos
INSERT INTO Jogos (Nome, Descricao) VALUES
('Xadrez', 'Jogo de tabuleiro estratégico'),
('Poker', 'Jogo de cartas'),
('Futebol', 'Esporte coletivo');

-- Inserindo competições
INSERT INTO Competicoes (Nome, DataInicio, DataFim) VALUES
('Torneio de Xadrez 2023', '2023-10-10', '2023-10-15'),
('Campeonato de Poker 2023', '2023-11-01', '2023-11-05'),
('Copa de Futebol 2023', '2023-12-01', '2023-12-10');

-- Inserindo pontuações
INSERT INTO Pontuacoes (JogadorID, JogoID, CompeticaoID, Pontos, DataPontuacao) VALUES
(1, 1, 1, 100, '2023-10-11'),  -- João no Xadrez
(2, 1, 1, 150, '2023-10-12'),  -- Maria no Xadrez
(3, 1, 1, 200, '2023-10-13'),  -- Carlos no Xadrez
(1, 2, 2, 500, '2023-11-02'),  -- João no Poker
(2, 2, 2, 600, '2023-11-03'),  -- Maria no Poker
(3, 2, 2, 700, '2023-11-04');  -- Carlos no Poker

-- Consultas Úteis

-- 1. Ranking de jogadores em uma competição específica
SELECT J.Nome AS Jogador, SUM(P.Pontos) AS TotalPontos
FROM Pontuacoes P
JOIN Jogadores J ON P.JogadorID = J.JogadorID
WHERE P.CompeticaoID = 1  -- Substitua pelo ID da competição desejada
GROUP BY J.JogadorID
ORDER BY TotalPontos DESC;

-- 2. Relatório de desempenho de um jogador em todos os jogos
SELECT Jg.Nome AS Jogo, SUM(P.Pontos) AS TotalPontos
FROM Pontuacoes P
JOIN Jogos Jg ON P.JogoID = Jg.JogoID
WHERE P.JogadorID = 1  -- Substitua pelo ID do jogador desejado
GROUP BY Jg.JogoID
ORDER BY TotalPontos DESC;

-- 3. Jogos disputados por um jogador em uma competição específica
SELECT Jg.Nome AS Jogo, P.Pontos, P.DataPontuacao
FROM Pontuacoes P
JOIN Jogos Jg ON P.JogoID = Jg.JogoID
WHERE P.JogadorID = 1 AND P.CompeticaoID = 1  -- Substitua pelos IDs desejados
ORDER BY P.DataPontuacao;

-- 4. Competições com maior pontuação total
SELECT C.Nome AS Competicao, SUM(P.Pontos) AS TotalPontos
FROM Pontuacoes P
JOIN Competicoes C ON P.CompeticaoID = C.CompeticaoID
GROUP BY C.CompeticaoID
ORDER BY TotalPontos DESC;

-- 5. Jogadores que participaram de uma competição específica
SELECT DISTINCT J.Nome AS Jogador
FROM Pontuacoes P
JOIN Jogadores J ON P.JogadorID = J.JogadorID
WHERE P.CompeticaoID = 1;  -- Substitua pelo ID da competição desejada