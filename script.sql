CREATE TABLE Cliente (
  cpf CHAR(11),
  nome CHAR(100) NOT NULL,
  sexo CHAR,
  data_nascimento DATE,
  pontos_crm INT DEFAULT 0 NOT NULL,
  indicado CHAR(11),
  email CHAR(320) NOT NULL,
  rua CHAR(50),
  numero CHAR(6),
  bairro CHAR(10),
  cidade CHAR(20),
  estado CHAR(20),
  cep CHAR(8) NOT NULL,
  PRIMARY KEY(cpf),
  CONSTRAINT fk_indicado FOREIGN KEY (indicado) REFERENCES Cliente(cpf),
  CONSTRAINT check_pontos CHECK (pontos_crm >= 0),
  CONSTRAINT check_sexo CHECK (sexo = 'F' OR sexo = 'M')
);

CREATE TABLE Telefones(
  telefone CHAR(11),
  cpf_dono CHAR(11),
  PRIMARY KEY(cpf_dono, telefone),
  CONSTRAINT fk_cpf_dono FOREIGN KEY (cpf_dono) REFERENCES Cliente(cpf)
  ON DELETE CASCADE
);

CREATE SEQUENCE SEQ_PK_CATEGORIA;
CREATE TABLE Categoria(
  codigo INT DEFAULT SEQ_PK_CATEGORIA.NEXTVAL,
  nome CHAR(20) NOT NULL UNIQUE,
  PRIMARY KEY(codigo)
);

CREATE SEQUENCE SEQ_PK_TRANSPORTADORA;
CREATE TABLE Transportadora(
  codigo INT DEFAULT SEQ_PK_TRANSPORTADORA.NEXTVAL,
  site CHAR(100) NOT NULL,
  nome CHAR(50) NOT NULL,
  telefone CHAR(11) NOT NULL,
  email CHAR(320) NOT NULL,
  rua CHAR(50),
  numero CHAR(6),
  bairro CHAR(10),
  cidade CHAR(20),
  estado CHAR(20),
  cep CHAR(8) NOT NULL,
  PRIMARY KEY(codigo)
);

CREATE TABLE Fornecedor(
  cnpj CHAR(14),
  nome CHAR(100) NOT NULL,
  email CHAR(320) NOT NULL,
  telefone CHAR(11) NOT NULL,
  cep CHAR(8) NOT NULL,
  rua CHAR(50),
  numero CHAR(6),
  bairro CHAR(10),
  cidade CHAR(20),
  estado CHAR(20),
  PRIMARY KEY(cnpj)
);

CREATE SEQUENCE SEQ_PK_ORDEM;
CREATE TABLE OrdemDeCompra(
  codigo INT DEFAULT SEQ_PK_ORDEM.NEXTVAL,
  data_pedido TIMESTAMP NOT NULL,
  preco_frete NUMERIC(8, 2) NOT NULL,
  status CHAR(10) NOT NULL,
  desconto NUMERIC(5, 2) DEFAULT 0 NOT NULL,
  cod_transportadora INT NOT NULL,
  rua CHAR(50),
  numero CHAR(6),
  bairro CHAR(10),
  cidade CHAR(20),
  estado CHAR(20),
  cep CHAR(8) NOT NULL,
  cpf_cliente CHAR(11) NOT NULL,
  PRIMARY KEY(codigo),
  CONSTRAINT fk_cpf_cliente FOREIGN KEY (cpf_cliente) REFERENCES Cliente(cpf),
  CONSTRAINT fk_cod_transportadora FOREIGN KEY (cod_transportadora) REFERENCES Transportadora(codigo)
);

CREATE SEQUENCE SEQ_PK_PRODUTO;
CREATE TABLE Produto(
  codigo INT DEFAULT SEQ_PK_PRODUTO.NEXTVAL,
  cod_ordem INT,
  descricao_aval CHAR(300),
  nota INT,
  nome CHAR(20) NOT NULL,
  categoria INT UNIQUE NOT NULL,
  data_val DATE DEFAULT NULL,
  quantidade INT DEFAULT 1 NOT NULL,
  descricao CHAR(300) NOT NULL,
  especificacao CHAR(300) NOT NULl,
  data_fabric DATE NOT NULL,
  preco_venda NUMERIC(8, 2) NOT NULL,
  preco_compra NUMERIC(8, 2) NOT NULL,
  PRIMARY KEY(codigo),
  CONSTRAINT fk_categoria FOREIGN KEY (categoria) REFERENCES Categoria(codigo)
  ON DELETE CASCADE,
  CONSTRAINT fk_cod_ordem_avaliacao FOREIGN KEY (cod_ordem) REFERENCES OrdemDeCompra(codigo),
  CONSTRAINT check_nota CHECK (nota <= 5 AND nota >= 0),
  CONSTRAINT check_valores CHECK (preco_compra >= 0 AND preco_venda >= 0)
);

CREATE TABLE Fornece(
  cod_prod INT,
  cnpj_forn CHAR(14),
  PRIMARY KEY(cod_prod, cnpj_forn),
  CONSTRAINT fk_cod_prod FOREIGN KEY (cod_prod) REFERENCES Produto(codigo),
  CONSTRAINT fk_cnpj_forn FOREIGN KEY (cnpj_forn) REFERENCES Fornecedor(cnpj)
  ON DELETE CASCADE
);

CREATE TABLE Possui(
  cod_ordem INT,
  cod_produto INT,
  quantidade INT DEFAULT 1 NOT NULL,
  valor NUMERIC(8, 2) NOT NULL,
  PRIMARY KEY(cod_ordem, cod_produto),
  CONSTRAINT fk_cod_ordem FOREIGN KEY (cod_ordem) REFERENCES OrdemDeCompra(codigo) 
  ON DELETE CASCADE,
  CONSTRAINT fk_cod_produto FOREIGN KEY (cod_produto) REFERENCES Produto(codigo)
  ON DELETE CASCADE,
  CONSTRAINT check_valor CHECK (valor >= 0),
  CONSTRAINT check_quantidade CHECK (quantidade >= 0)
);


CREATE TABLE NotaFiscal(
  numero CHAR(9) NOT NULL,
  serie CHAR(3) NOT NULL,
  valor_total NUMERIC(8, 2) NOT NULL,
  inscricao_estadual CHAR(14) NOT NULL,
  chave_acesso CHAR(44) NOT NULL,
  codigo_ordem INT UNIQUE NOT NULL,
  PRIMARY KEY(chave_acesso),
  CONSTRAINT fk_codigo_ordem FOREIGN KEY (codigo_ordem) REFERENCES OrdemDeCompra(codigo)
);


