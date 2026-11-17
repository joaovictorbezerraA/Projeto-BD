  CREATE TABLE Cliente (
    cpf CHAR(11),
    nome VARCHAR(30) NOT NULL,
    sexo CHAR,
    data_nascimento DATE,
    pontos_crm INT DEFAULT 0,
    email CHAR(320),
    rua VARCHAR(50),
    numero VARCHAR(6),
    bairro VARCHAR(10),
    cidade VARCHAR(20),
    estado VARCHAR(20),
    cep CHAR(8) NOT NULL,
    PRIMARY KEY(cpf),
    CONSTRAINT chk_cpf_tamanho CHECK (LENGTH(TRIM(cpf)) = 11),
    CONSTRAINT chk_cep_tamanho CHECK (LENGTH(TRIM(cep)) = 8)
  )

  CREATE TABLE Telefones(
    telefone CHAR(11),
    cpf_dono CHAR(11),
    PRIMARY KEY(cpf_dono, telefone),
    FOREIGN KEY(cpf_dono) REFERENCES Cliente(cpf)
    CONSTRAINT chk_telefone_tamanho CHECK (LENGTH(TRIM(telefone)) = 11)
  )

  CREATE TABLE Transportadora(
    codigo CHAR(14),
    site VARCHAR(100),
    nome VARCHAR(50),
    telefone CHAR(11),
    email CHAR(320),
    rua VARCHAR(50),
    numero VARCHAR(6),
    bairro VARCHAR(10),
    cidade VARCHAR(20),
    estado VARCHAR(20),
    PRIMARY KEY(codigo),
    CONSTRAINT chk_codigo_tamanho CHECK (LENGTH(TRIM(codigo)) = 14)
    CONSTRAINT chk_telefone_tamanho CHECK (LENGTH(TRIM(telefone)) = 11)
  )

  CREATE TABLE OrdemDeCompra(
    codigo CHAR(15),
    data_pedido TIMESTAMP NOT NULL,
    preco_frete NUMERIC(8, 2) NOT NULL,
    status VARCHAR(10) NOT NULL,
    desconto REAL,
    cod_transportadora CHAR(14) NOT NULL,
    rua VARCHAR(50),
    numero VARCHAR(6),
    bairro VARCHAR(10),
    cidade VARCHAR(20),
    estado VARCHAR(20),
    cep CHAR(8) NOT NULL,
    cpf_cliente CHAR(11) NOT NULL,
    PRIMARY KEY(codigo),
    FOREING KEY(cpf_cliente) REFERENCES Cliente(cpf),
    FOREING KEY(cod_transportadora) REFERENCES Transportadora(codigo),
    CONSTRAINT chk_cep_tamanho CHECK (LENGTH(TRIM(cep)) = 8)
  )

  CREATE TABLE NotaFiscal(
    numero CHAR(9) NOT NULL,
    serie CHAR(3) NOT NULL,
    valor_total NUMERIC(8, 2) NOT NULL,
    inscricao_estadual CHAR(14) NOT NULL,
    chave_acesso CHAR(44) NOT NULL,
    codigo_ordem CHAR(10) NOT NULL,
    PRIMARY KEY(chave_acesso),
    FOREIGN KEY(codigo_ordem) REFERENCES OrdemDeCompra(codigo),
    CONSTRAINT chk_numero_tamanho CHECK (LENGTH(TRIM(numero)) = 9),
    CONSTRAINT chk_chave_acesso_tamanho CHECK (LENGTH(TRIM(chave_acesso)) = 44),
    CONSTRAINT chk_serie_tamanho CHECK (LENGTH(TRIM(serie)) = 3)
  )


