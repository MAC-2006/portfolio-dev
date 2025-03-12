-- Criação das Tabelas

-- Tabela Pacientes
CREATE TABLE Pacientes (
    PacienteID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefone VARCHAR(15),
    DataNascimento DATE NOT NULL
);

-- Tabela Medicos
CREATE TABLE Medicos (
    MedicoID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Especialidade VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefone VARCHAR(15)
);

-- Tabela HorariosDisponiveis
CREATE TABLE HorariosDisponiveis (
    HorarioID INT PRIMARY KEY AUTO_INCREMENT,
    MedicoID INT,
    DataHora DATETIME NOT NULL,
    Disponivel BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (MedicoID) REFERENCES Medicos(MedicoID)
);

-- Tabela Consultas
CREATE TABLE Consultas (
    ConsultaID INT PRIMARY KEY AUTO_INCREMENT,
    PacienteID INT,
    MedicoID INT,
    HorarioID INT,
    DataHora DATETIME NOT NULL,
    Status ENUM('Agendada', 'Realizada', 'Cancelada') DEFAULT 'Agendada',
    Observacoes TEXT,
    FOREIGN KEY (PacienteID) REFERENCES Pacientes(PacienteID),
    FOREIGN KEY (MedicoID) REFERENCES Medicos(MedicoID),
    FOREIGN KEY (HorarioID) REFERENCES HorariosDisponiveis(HorarioID)
);

-- Inserção de Dados

-- Inserindo pacientes
INSERT INTO Pacientes (Nome, Email, Telefone, DataNascimento) VALUES
('João Silva', 'joao.silva@example.com', '11987654321', '1980-05-15'),
('Maria Oliveira', 'maria.oliveira@example.com', '21987654321', '1990-08-25'),
('Carlos Souza', 'carlos.souza@example.com', '31987654321', '1975-12-10');

-- Inserindo médicos
INSERT INTO Medicos (Nome, Especialidade, Email, Telefone) VALUES
('Dr. Pedro Almeida', 'Cardiologia', 'pedro.almeida@example.com', '11912345678'),
('Dra. Ana Costa', 'Dermatologia', 'ana.costa@example.com', '21912345678'),
('Dr. Lucas Fernandes', 'Ortopedia', 'lucas.fernandes@example.com', '31912345678');

-- Inserindo horários disponíveis
INSERT INTO HorariosDisponiveis (MedicoID, DataHora, Disponivel) VALUES
(1, '2023-11-01 09:00:00', TRUE),  -- Dr. Pedro
(1, '2023-11-01 10:00:00', TRUE),
(2, '2023-11-02 14:00:00', TRUE),  -- Dra. Ana
(3, '2023-11-03 11:00:00', TRUE);  -- Dr. Lucas

-- Inserindo consultas
INSERT INTO Consultas (PacienteID, MedicoID, HorarioID, DataHora, Status, Observacoes) VALUES
(1, 1, 1, '2023-11-01 09:00:00', 'Agendada', 'Consulta de rotina'),
(2, 2, 3, '2023-11-02 14:00:00', 'Agendada', 'Avaliação de pele'),
(3, 3, 4, '2023-11-03 11:00:00', 'Agendada', 'Dor no joelho');

-- Consultas Úteis

-- 1. Consultas agendadas para um médico específico
SELECT C.ConsultaID, P.Nome AS Paciente, C.DataHora, C.Status
FROM Consultas C
JOIN Pacientes P ON C.PacienteID = P.PacienteID
WHERE C.MedicoID = 1  -- Substitua pelo ID do médico desejado
ORDER BY C.DataHora;

-- 2. Horários disponíveis de um médico específico
SELECT H.HorarioID, H.DataHora
FROM HorariosDisponiveis H
WHERE H.MedicoID = 1 AND H.Disponivel = TRUE  -- Substitua pelo ID do médico desejado
ORDER BY H.DataHora;

-- 3. Consultas de um paciente específico
SELECT C.ConsultaID, M.Nome AS Medico, C.DataHora, C.Status
FROM Consultas C
JOIN Medicos M ON C.MedicoID = M.MedicoID
WHERE C.PacienteID = 1  -- Substitua pelo ID do paciente desejado
ORDER BY C.DataHora;

-- 4. Relatório de consultas realizadas por especialidade
SELECT M.Especialidade, COUNT(C.ConsultaID) AS TotalConsultas
FROM Consultas C
JOIN Medicos M ON C.MedicoID = M.MedicoID
WHERE C.Status = 'Realizada'
GROUP BY M.Especialidade
ORDER BY TotalConsultas DESC;

-- 5. Consultas canceladas
SELECT C.ConsultaID, P.Nome AS Paciente, M.Nome AS Medico, C.DataHora, C.Observacoes
FROM Consultas C
JOIN Pacientes P ON C.PacienteID = P.PacienteID
JOIN Medicos M ON C.MedicoID = M.MedicoID
WHERE C.Status = 'Cancelada'
ORDER BY C.DataHora;