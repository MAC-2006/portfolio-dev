CREATE DATABASE ControleEstoque;
USE ControleEstoque;

-- Tabela de Fornecedores
CREATE TABLE Fornecedores (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    contato VARCHAR(100),
    telefone VARCHAR(20),
    email VARCHAR(100)
);

-- Tabela de Categorias
CREATE TABLE Categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Tabela de Produtos
CREATE TABLE Produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    quantidade INT NOT NULL DEFAULT 0,
    preco DECIMAL(10,2) NOT NULL,
    id_categoria INT,
    id_fornecedor INT,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria),
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedores(id_fornecedor)
);

-- Tabela de Vendas
CREATE TABLE Vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT,
    quantidade INT NOT NULL,
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

-- Ajuste automático do estoque após uma venda
DELIMITER $$
CREATE TRIGGER AtualizaEstoqueVenda
AFTER INSERT ON Vendas
FOR EACH ROW
BEGIN
    UPDATE Produtos
    SET quantidade = quantidade - NEW.quantidade
    WHERE id_produto = NEW.id_produto;
END $$
DELIMITER ;

-- Relatório de produtos mais vendidos
CREATE VIEW ProdutosMaisVendidos AS
SELECT p.id_produto, p.nome, SUM(v.quantidade) AS total_vendido
FROM Vendas v
JOIN Produtos p ON v.id_produto = p.id_produto
GROUP BY p.id_produto, p.nome
ORDER BY total_vendido DESC;

-- Controle de entradas no estoque
CREATE TABLE EntradasEstoque (
    id_entrada INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT,
    quantidade INT NOT NULL,
    data_entrada TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

DELIMITER $$
CREATE TRIGGER AtualizaEstoqueEntrada
AFTER INSERT ON EntradasEstoque
FOR EACH ROW
BEGIN
    UPDATE Produtos
    SET quantidade = quantidade + NEW.quantidade
    WHERE id_produto = NEW.id_produto;
END $$
DELIMITER ;
