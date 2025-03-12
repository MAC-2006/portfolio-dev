-- Criação do banco de dados (se necessário)
CREATE DATABASE IF NOT EXISTS GerenciamentoClientesPedidos;
USE GerenciamentoClientesPedidos;

-- Tabela Clientes
CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefone VARCHAR(15),
    Endereco VARCHAR(255),
    Cidade VARCHAR(100),
    Estado VARCHAR(50),
    CEP VARCHAR(10)
);

-- Tabela Produtos
CREATE TABLE Produtos (
    ProdutoID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Descricao TEXT,
    Preco DECIMAL(10, 2) NOT NULL,
    Estoque INT NOT NULL
);

-- Tabela Pedidos
CREATE TABLE Pedidos (
    PedidoID INT PRIMARY KEY AUTO_INCREMENT,
    ClienteID INT,
    DataPedido DATE NOT NULL,
    EnderecoEntrega VARCHAR(255),
    Status ENUM('Pendente', 'Pago', 'Enviado', 'Entregue') DEFAULT 'Pendente',
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- Tabela ItensPedido (para relacionar produtos e pedidos)
CREATE TABLE ItensPedido (
    ItemPedidoID INT PRIMARY KEY AUTO_INCREMENT,
    PedidoID INT,
    ProdutoID INT,
    Quantidade INT NOT NULL,
    PrecoUnitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID),
    FOREIGN KEY (ProdutoID) REFERENCES Produtos(ProdutoID)
);

-- Tabela Pagamentos
CREATE TABLE Pagamentos (
    PagamentoID INT PRIMARY KEY AUTO_INCREMENT,
    PedidoID INT,
    MetodoPagamento ENUM('Cartao', 'Boleto', 'Transferencia') NOT NULL,
    ValorPago DECIMAL(10, 2) NOT NULL,
    DataPagamento DATE NOT NULL,
    Status ENUM('Pendente', 'Concluido') DEFAULT 'Pendente',
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID)
);

-- Inserindo dados de exemplo

-- Clientes
INSERT INTO Clientes (Nome, Email, Telefone, Endereco, Cidade, Estado, CEP)
VALUES 
    ('João Silva', 'joao.silva@example.com', '11987654321', 'Rua A, 123', 'São Paulo', 'SP', '01234-567'),
    ('Maria Oliveira', 'maria.oliveira@example.com', '21987654321', 'Rua B, 456', 'Rio de Janeiro', 'RJ', '12345-678');

-- Produtos
INSERT INTO Produtos (Nome, Descricao, Preco, Estoque)
VALUES 
    ('Notebook', 'Notebook 15 polegadas, 8GB RAM, 256GB SSD', 3500.00, 10),
    ('Smartphone', 'Smartphone 128GB, 6.5 polegadas, 4 câmeras', 2000.00, 20);

-- Pedidos
INSERT INTO Pedidos (ClienteID, DataPedido, EnderecoEntrega, Status)
VALUES 
    (1, '2023-10-01', 'Rua A, 123', 'Pendente'),
    (2, '2023-10-02', 'Rua B, 456', 'Pago');

-- ItensPedido
INSERT INTO ItensPedido (PedidoID, ProdutoID, Quantidade, PrecoUnitario)
VALUES 
    (1, 1, 1, 3500.00),
    (2, 2, 2, 2000.00);

-- Pagamentos
INSERT INTO Pagamentos (PedidoID, MetodoPagamento, ValorPago, DataPagamento, Status)
VALUES 
    (1, 'Cartao', 3500.00, '2023-10-01', 'Pendente'),
    (2, 'Boleto', 4000.00, '2023-10-02', 'Concluido');

-- Consultas e Relatórios

-- Relatório de Vendas
SELECT 
    P.PedidoID,
    C.Nome AS Cliente,
    P.DataPedido,
    SUM(IP.Quantidade * IP.PrecoUnitario) AS TotalPedido,
    PG.Status AS StatusPagamento
FROM 
    Pedidos P
JOIN Clientes C ON P.ClienteID = C.ClienteID
JOIN ItensPedido IP ON P.PedidoID = IP.PedidoID
JOIN Pagamentos PG ON P.PedidoID = PG.PedidoID
GROUP BY 
    P.PedidoID, C.Nome, P.DataPedido, PG.Status;

-- Controle de Pedidos Pendentes e Pagos
SELECT 
    P.PedidoID,
    C.Nome AS Cliente,
    P.DataPedido,
    P.Status AS StatusPedido,
    PG.Status AS StatusPagamento
FROM 
    Pedidos P
JOIN Clientes C ON P.ClienteID = C.ClienteID
JOIN Pagamentos PG ON P.PedidoID = PG.PedidoID
WHERE 
    P.Status = 'Pendente' OR PG.Status = 'Pendente';

-- Análise de Clientes Mais Frequentes
SELECT 
    C.ClienteID,
    C.Nome,
    COUNT(P.PedidoID) AS TotalPedidos,
    SUM(IP.Quantidade * IP.PrecoUnitario) AS TotalGasto
FROM 
    Clientes C
JOIN Pedidos P ON C.ClienteID = P.ClienteID
JOIN ItensPedido IP ON P.PedidoID = IP.PedidoID
GROUP BY 
    C.ClienteID, C.Nome
ORDER BY 
    TotalPedidos DESC, TotalGasto DESC;