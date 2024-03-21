DO $$
DECLARE
    _nrCpfCnpj NUMERIC(15, 0) := '39149997807'; 
    _ID_Cliente int;
    _ID_ClienteTipo smallint;
BEGIN
    -- Aqui você pode fazer operações com a variável _nrCpfCnpj
    -- Outras operações...
    
    _ID_ClienteTipo := CASE WHEN length(_nrCpfCnpj::text) <= 11 THEN 1 ELSE 2 END;
    _ID_Cliente := CASE WHEN length(_nrCpfCnpj::text) <= 11 THEN substring(_nrCpfCnpj::text, 5, 9)::int ELSE substring(_nrCpfCnpj::text, 1, 9)::int END;
    
    -- Exibir os resultados
    RAISE NOTICE 'ID_Cliente: %, ID_ClienteTipo: %', _ID_Cliente, _ID_ClienteTipo;
    
    -- Armazenar os resultados em uma tabela temporária
    CREATE TEMP TABLE temp_results (
        id_cliente int,
        id_cliente_tipo smallint
    );
    
    INSERT INTO temp_results (id_cliente, id_cliente_tipo) VALUES (_ID_Cliente, _ID_ClienteTipo);
    
    -- Retornar resultados
    PERFORM * FROM temp_results;
END;
$$;
