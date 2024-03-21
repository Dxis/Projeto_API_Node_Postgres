
CREATE OR REPLACE PROCEDURE SPR_INS_CLIENTE(
    _nm_cliente VARCHAR(150),
    _nrCpfCnpj VARCHAR(50),
    _email VARCHAR(130) = null,
    _dtNascimento DATE = null
) 
AS $$
DECLARE
    _cliente cli.tblCliente;  -- Variável para armazenar os dados completos do cliente
    _id_cliente INT;
    _id_cliente_tipo SMALLINT;
    _nrCpfCnpjCast text;
begin
	
	_nrCpfCnpjCast := CAST(CAST(replace(replace(replace(_nrCpfCnpj, '/', ''), '.', ''), '-', '') AS bigint) AS varchar(20));
	
    -- Verificar se o nrCpfCnpj já existe na tabela
    IF EXISTS (SELECT 1 FROM cli.tblCliente WHERE nrCpfCnpj = _nrCpfCnpj) THEN
        RAISE EXCEPTION 'O nrCpfCnpj já existe na tabela.';
    END IF;

    -- Validar o nrCpfCnpj e calcular o ID_Cliente e ID_ClienteTipo
    IF LENGTH(_nrCpfCnpjCast) > 11 THEN
        -- nrCpfCnpj é um CNPJ
        _id_cliente_tipo := 2;
        _id_cliente := SUBSTRING(_nrCpfCnpjCast, 1, 8)::INT;
    ELSE
        -- nrCpfCnpj é um CPF
        _id_cliente_tipo := 1;
        _id_cliente := SUBSTRING(_nrCpfCnpjCast, 5, 9)::INT;
    END IF;
   
    -- Imprimir valores para fins de depuração ou validação
    RAISE NOTICE 'nrCpfCnpj original: %', _nrCpfCnpj;
    RAISE NOTICE 'nrCpfCnpj convertido: %', _nrCpfCnpjCast;
   
    -- Inserir o novo cliente na tabela
    INSERT INTO cli.tblCliente (ID_Cliente, ID_ClienteTipo, nrCpfCnpj, nrCpfCnpj_Original, Nm_Cliente, Email, DtNascimento)
    VALUES (
        _id_cliente,
        _id_cliente_tipo, 
        _nrCpfCnpjCast,
        _nrCpfCnpj,
        _nm_cliente,
        _email,
        _dtNascimento
    )
    RETURNING * INTO _cliente;  -- Retornar os dados completos do cliente

    -- Confirmar a inserção
    RAISE NOTICE 'Cliente inserido com sucesso. ID_Registro: %', _cliente.ID_Registro;
END;
$$ LANGUAGE plpgsql;
