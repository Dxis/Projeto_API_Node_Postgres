

/*Seleção clientes*/
/*(  _ID_Cliente ,_ID_ClienteTipo ,_nrCpfCnpj, _nmCliente, _ID_Registro )*/
SELECT * FROM cli.fnt_sel_cliente_v2(NULL, NULL, NULL, null,2);
/*API*  *http://localhost:3000/clientes?_ID_Registro=2*/

SELECT * FROM cli.fnt_sel_cliente_v2(null, null, null, 'Diego',null);
/*API*   http://localhost:3000/clientes?_nm_Cliente=%Diego% */

SELECT * FROM cli.fnt_sel_cliente_v2(null, null, '39149997807', null,null);
/*API*   http://localhost:3000/clientes?_nrCpfCnpj=39149997807*/

SELECT * FROM cli.fnt_sel_cliente_v2(9997807, 1, null, null,null);
/*API*   http://localhost:3000/clientes?_ID_Cliente=9997807&_ID_ClienteTipo=1*/

/*insert cliente*/
CALL cli.spr_ins_cliente(
    'João da Silva',
    '67997265000187',
    'joao@example.com',
    '1989-05-15'
);

SELECT * FROM cli.tblcliente;
SELECT * FROM cli.tblclientes_old;







select cast(CAST(12345678901234 AS bigint) as text)


select CAST(12345678901234 AS bigint)

SELECT LENGTH('46902133000154');

select * from cli.tblcliente t 