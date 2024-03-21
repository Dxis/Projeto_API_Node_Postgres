-- DROP PROCEDURE cli.spr_upd_cliente(int4, text, text, text);

CREATE OR REPLACE PROCEDURE cli.spr_upd_cliente(IN _ID_Registro integer, IN _nm_cliente text,in _nrCpfCnpj text, IN _email text, IN _DtNascimento date)
 LANGUAGE plpgsql
AS $procedure$
DECLARE
    _cliente cli.tblCliente;  -- Variável para armazenar os dados completos do cliente
    _id_cliente INT;
    _id_clientetipo SMALLINT;
    _nrCpfCnpjCast text;
   
begin
	
	-- Verificar se o nrCpfCnpj já existe na tabela
	IF EXISTS (SELECT 1 FROM cli.tblCliente WHERE nrCpfCnpj = _nrCpfCnpj) then
	
    -- REFAZ ID_Cliente e ID_ClienteTipo
	    IF LENGTH(_nrCpfCnpjCast) > 11 THEN
	        -- nrCpfCnpj é um CNPJ
	        _id_clientetipo := 2;
	        _id_cliente := SUBSTRING(_nrCpfCnpjCast, 1, 8)::INT;
	    ELSE
	        -- nrCpfCnpj é um CPF
	        _id_clientetipo := 1;
	        _id_cliente := SUBSTRING(_nrCpfCnpjCast, 5, 9)::INT;
	    END IF;  
		
		--RAISE EXCEPTION 'O nrCpfCnpj já existe na tabela.';
		END IF;	
    -- Atualiza os dados do cliente na tabela
    UPDATE cli.tblcliente
    SET    nm_cliente      = COALESCE(_nm_cliente, nm_cliente)
    ,      nrCpfCnpj       = COALESCE(_nrCpfCnpj, nrCpfCnpj)
    ,      email           = COALESCE(_email, email)
    ,      DtNascimento    = COALESCE(_DtNascimento, DtNascimento)
    ,      id_clientetipo = COALESCE(_id_clientetipo, id_clientetipo) 
     ,     id_cliente      = COALESCE(_id_cliente, id_cliente) 

	WHERE  ID_Registro  = _ID_Registro;

   
END;
$procedure$
;