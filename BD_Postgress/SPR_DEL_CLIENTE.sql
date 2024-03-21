-- DROP PROCEDURE cli.spr_del_cliente(int4);

CREATE OR REPLACE PROCEDURE cli.spr_del_cliente(IN _id_Registro integer)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- Exclui o cliente da tabela
    DELETE FROM cli.tblcliente WHERE ID_Registro = _id_Registro;
END;
$procedure$
;