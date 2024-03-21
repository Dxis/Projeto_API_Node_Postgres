
DROP TABLE IF EXISTS  cli.tblCliente ;


CREATE TABLE cli.tblCliente (
  ID_Registro SERIAL 	PRIMARY key
, ID_Cliente 			INT NOT null
, ID_ClienteTipo 		SMALLINT NOT null
, nrCpfCnpj 			VARCHAR(30) NOT null
, nrCpfCnpj_Original    VARCHAR(60) NOT null
, Nm_Cliente 			VARCHAR(150) NOT null
, Email 				VARCHAR(130) null
, DtNascimento 			DATE null
, DtCadastro 			TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  
);


-- Drop table se já existir
DROP TABLE IF EXISTS cli.tblendereco;

CREATE TABLE cli.tblendereco (
    ID_Endereco  SERIAL PRIMARY KEY
, ID_Cliente 			INT NOT null
, ID_ClienteTipo 		SMALLINT NOT null
,    Rua VARCHAR(100)
 ,   Cidade VARCHAR(100)
 ,   Estado VARCHAR(50)
 ,   CEP VARCHAR(20)
 ,   Pais VARCHAR(100)
 , DtCadastro 			TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DROP TABLE IF EXISTS cli.tblcontato;

CREATE TABLE cli.tblcontato (
    ID_Contato  SERIAL PRIMARY KEY
, ID_Cliente 			INT NOT null
, ID_ClienteTipo 		SMALLINT NOT null
 ,   Email VARCHAR(100)
,    Telefone VARCHAR(20)
,    Celular VARCHAR(20)
, DtCadastro 			TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

