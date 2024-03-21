-- Função para selecionar clientes com base no número de CPF/CNPJ ou nome
CREATE OR REPLACE FUNCTION cli.fnt_sel_cliente_v2(
    _ID_Cliente numeric(20,0),  /*qdo int não aceitou enviar via chamada*/
    _ID_ClienteTipo numeric(1,0), /*qdo smallint não aceitou enviar via chamada*/
    _nrCpfCnpj VARCHAR(30),
    _nm_Cliente VARCHAR(150),
    _ID_Registro INT
)
RETURNS SETOF cli.tblCliente 
AS $$
BEGIN
    IF _ID_Registro IS NOT NULL THEN
        -- Se um ID de registro foi fornecido, selecione o cliente correspondente
        RETURN QUERY 
        SELECT * 
        FROM cli.tblCliente 
        WHERE ID_Registro = _ID_Registro;
    ELSIF _ID_Cliente IS NOT NULL AND _ID_ClienteTipo IS NOT NULL THEN
        -- Se ambos o ID do cliente e o tipo de cliente foram fornecidos
        RETURN QUERY 
        SELECT * 
        FROM cli.tblCliente 
        WHERE ID_Cliente = _ID_Cliente 
        AND ID_ClienteTipo = _ID_ClienteTipo;
    ELSIF _nrCpfCnpj IS NOT NULL  THEN
        -- Se apenas o número de CPF/CNPJ foi fornecido
        RETURN QUERY 
        SELECT * 
        FROM cli.tblCliente 
        WHERE nrCpfCnpj = _nrCpfCnpj;
    ELSIF _nm_Cliente IS NOT NULL THEN
        -- Se apenas o nome do cliente foi fornecido
        RETURN QUERY 
        SELECT * 
        FROM cli.tblCliente 
        WHERE Nm_Cliente ILIKE '%' || _nm_Cliente || '%';
    ELSE
        -- Se nenhum parâmetro foi fornecido, selecionar todos os clientes
        RETURN QUERY 
        SELECT * 
        FROM cli.tblCliente;
    END IF;
END;
$$ LANGUAGE plpgsql;
