-- Criação do Banco de Dados.
CREATE DATABASE exemplo_views;
USE exemplo_views;

-- Criando a tabela de clientes.
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    cidade VARCHAR(100),
    estado CHAR(2)
);

-- Criando a tabela de Pedidos.
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    produto VARCHAR(100),
    valor DECIMAL(10, 2),
    data_pedido DATE,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);


-- Inserindo dados na tabela de Clientes.
INSERT INTO clientes (nome, cidade, estado) VALUES
('João Silva', 'São Paulo', 'SP'),
('Maria Oliveira', 'Rio de Janeiro', 'RJ'),
('Carlos Souza', 'Campinas', 'SP');


-- Inserindo dados na tabela de pedidos.
INSERT INTO pedidos (cliente_id, produto, valor, data_pedido) VALUES
(1, 'Notebook', 3500.00, '2025-05-01'),
(1, 'Mouse', 80.00, '2025-05-03'),
(2, 'Teclado', 120.00, '2025-05-02'),
(3, 'Monitor', 800.00, '2025-05-04');


-- Criando uma View relatório de pedidos.
CREATE VIEW relatorio_pedidos AS
SELECT
    c.nome AS cliente,
    c.cidade,
    p.produto,
    p.valor,
    p.data_pedido
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.id;

-- Visualizar a View.
SELECT * FROM relatorio_pedidos;


-- Fazer uma inserção de valores na View.
INSERT INTO relatorio_pedidos
VALUES ('Ana','Marília','SSD',270.00,'2025-06-01');


-- Alternativas:
-- 1. Criando uma View de Pedidos e depois fazer a inserção dos dados.
CREATE VIEW pedidos_simples AS
SELECT id, cliente_id, produto, valor, data_pedido
FROM pedidos;

INSERT INTO pedidos_simples (cliente_id, produto, valor, data_pedido)
VALUES (4, 'SSD', 270.00, '2025-06-01');

-- Visualizar a View.
SELECT * FROM pedidos_simples;





-- 2. Inserir diretamente na tabela clientes e depois na tabela pedidos as informações.
INSERT INTO clientes (nome, cidade, estado) VALUES
('Ana', 'Marília', 'SP');

INSERT INTO pedidos (cliente_id, produto, valor, data_pedido)
VALUES (4, 'SSD', 270.00, '2025-06-01');

-- Visualizar a View.
SELECT * FROM relatorio_pedidos;





-- Excluindo a View.
DROP VIEW relatorio_pedidos;
DROP VIEW pedidos_simples;



-- ################################################################# 

-- Aula 02 Views
-- Usar o banco da aula anterior exemplo_views.
-- Criando a tabela de funcionarios.
CREATE TABLE funcionarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    departamento VARCHAR(50)
);


-- Criando uma View.
CREATE VIEW funcionarios_ti AS
SELECT * FROM funcionarios
WHERE departamento = 'TI'
WITH CHECK OPTION;

-- Visualizar a View.
SELECT * FROM funcionarios_ti;


-- Inserir um funcionario na views.
INSERT INTO funcionarios_ti (nome, departamento)
VALUES ('Carlos', 'TI');


-- Inserir outro funcionario na views.
INSERT INTO funcionarios_ti (nome, departamento)
VALUES ('Ana', 'RH');


-- Fazer um update trocando o departamento do Carlos.
UPDATE funcionarios_ti
SET departamento = 'Financeiro'
WHERE nome = 'Carlos';






-- Views aninhadas
-- Adicionar o campo salario na tabela de funcionarios.
ALTER TABLE funcionarios
ADD COLUMN salario DECIMAL(10,2);


-- View 1 já esta criada funcionarios_ti.


-- Criando uma view 2. 
CREATE VIEW funcionarios_ti_ricos AS
SELECT * FROM funcionarios_ti
WHERE salario > 8000
WITH CASCADED CHECK OPTION;


-- Inserir um funcionario na views.
INSERT INTO funcionarios_ti_ricos (nome, departamento, salario)
VALUES ('João', 'TI', 5000);

INSERT INTO funcionarios_ti_ricos (nome, departamento, salario)
VALUES ('Maria', 'RH', 9000);

INSERT INTO funcionarios_ti_ricos (nome, departamento, salario)
VALUES ('Pedro', 'TI', 9000);



-- Se não usamos o CASCADED na view aninhada.
-- View 1
CREATE VIEW funcionarios_ti AS
SELECT * FROM funcionarios
WHERE departamento = 'TI'
WITH CHECK OPTION;


--View 2
CREATE VIEW funcionarios_ti_ricos AS
SELECT * FROM funcionarios_ti
WHERE salario > 8000;


-- Agora você consegue inserir dados em funcionarios_ti
-- Mesmo que ele não devesse aparecer na view funcionarios_ti, o insert será feito porque a restrição da segunda view NÃO é aplicada.
INSERT INTO funcionarios_ti_ricos (nome, departamento, salario)
VALUES ('Lucas', 'TI', 5000);
