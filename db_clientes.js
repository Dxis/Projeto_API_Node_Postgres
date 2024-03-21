const { Pool } = require('pg'); //biblioteca postgres 
const {  cnpj, cpf } = require('cpf-cnpj-validator'); // Importa biblioteca para validação de CPF/CNPJ
const { isDate } = require('date-fns'); // Importa biblioteca para validação de data
const { isValidEmail } = require("./functions");// Importe a função isValidEmail do arquivo functions.js

require('dotenv').config(); // Carrega as variáveis de ambiente do arquivo .env


// Configurações do pool de conexões
const pool = new Pool({
  connectionString: process.env.CONNECTION_STRING, // Utiliza a string de conexão definida no arquivo .env  
});

// Função para selecionar clientes com base nos parâmetros fornecidos
async function selectClientes(_ID_Cliente, _ID_ClienteTipo, _nrCpfCnpj, _nm_Cliente, _ID_Registro) {
    try {
        const client = await pool.connect();
        let result;

        // Verificar se um ID de registro foi fornecido
        if ( _ID_Registro || (_ID_Cliente & _ID_ClienteTipo) || _nrCpfCnpj || _nm_Cliente ) {
          
           if( _ID_Registro ){  console.log("Registro identificado:   " + _ID_Registro); }
           if( _nrCpfCnpj )  {  console.log("_nrCpfCnpj identificado: " + _nrCpfCnpj );  }
           if( _nm_Cliente ) {  console.log("_nm_Cliente identificado:" + _nm_Cliente);  }
           if( _ID_Cliente & _ID_ClienteTipo){ console.log("_ID_Cliente e _ID_ClienteTipo identificado: " + _ID_Cliente + ' -' + _ID_ClienteTipo); }

           // Se encontrar algum valodar não nulo ou combinção .. 
            result = await client.query("SELECT * FROM cli.fnt_sel_cliente_v2($1, $2, $3, $4, $5);", [_ID_Cliente, _ID_ClienteTipo, _nrCpfCnpj, _nm_Cliente, _ID_Registro]);
     
        }else {
            // Se nenhum ID de registro foi fornecido, selecione todos os clientes 
            result = await client.query("SELECT * FROM cli.fnt_sel_cliente_v2($1, $2, $3, $4, $5);", [_ID_Cliente, _ID_ClienteTipo, _nrCpfCnpj, _nm_Cliente, _ID_Registro]);
     
        }
                
        client.release();
        return result.rows;
    } catch (error) {
        console.error('Erro ao executar a consulta', error);
        throw error;
    }
}

// Função para inserir dados de um novo cliente na tabela
async function insertcliente(nm_cliente, nrCpfCnpj, email, DtNascimento) {
    try {
        // Validar o formato da data
        if (!isDate(new Date(DtNascimento))) {
            throw new Error('Data de nascimento inválida.');
        }

        //Valida CPF ou CPJ valido 
        if (nrCpfCnpj.length >=12){            
            if (cnpj.isValid(nrCpfCnpj) == false) {
                throw new Error(' CNPJ inválido.');
            };
        } else if (cpf.isValid(nrCpfCnpj) ==false) {
            throw new Error(' CPF inválido.');
        };

       // console.log("validação teste email",isValidEmail(email));

         // Validar o e-mail usando a função do módulo functions_x
         if ( isValidEmail(email) ==false)  {
            throw new Error('Endereço de e-mail inválido.');
        }
        
        const client = await pool.connect();
        await client.query("CALL cli.spr_ins_cliente($1, $2, $3, $4);", [nm_cliente, nrCpfCnpj, email, DtNascimento]);
        client.release();
   
        // Após a inserção, recupere os dados do cliente inserido
        const retornoInsert = await client.query("SELECT * FROM cli.fnt_sel_cliente_v2(null, null, $1, null, null);", [nrCpfCnpj]);
        //const retornoInsert = await selectClientes(null, null, nrCpfCnpj, null, null); // Supondo que você tenha uma função para obter o cliente inserido

        console.log('Cliente inserido com sucesso:', retornoInsert.rows);        
        
        //return insertedCliente; // Retorna os dados do cliente inserido
    } catch (error) {
        console.error('Erro ao inserir cliente:', error);
        throw error;
    }
}

// Função para deletar os dados de um cliente na tabela
async function deletecliente(ID_Registro) {
    try {
        const client = await pool.connect();
        //await client.query("delete from cli.tblclientes where id_cliente =$1;", [id_cliente]);
        await client.query("call cli.spr_del_cliente($1);", [ID_Registro]); 
        //console.log(client.query("delete from cli.tblclientes where id_cliente =$1;", [id_cliente]));
        client.release();
        console.log('Cliente deletado com sucesso.');
    } catch (error) {
        console.error('Erro ao deletar cliente:', error);
        throw error;
    }
}

// Função para atualizar os dados de um cliente na tabela
async function updclientev3(ID_Registro,nm_cliente, nrCpfCnpj, email, DtNascimento) {
    try {
        const client = await pool.connect();
        const result = await client.query("CALL cli.SPR_UPD_CLIENTE($1, $2, $3, $4, $5);", [ID_Registro,nm_cliente, nrCpfCnpj, email, DtNascimento]);
        client.release();
        return result.rows[0]; // Retorna os dados atualizados do cliente
    } catch (error) {
        console.error('Erro ao atualizar cliente', error);
        throw error;
    }
}

/*
// Função para atualizar os dados de um cliente na tabela
async function updclientev2(id_cliente, nm_cliente, ds_endereco, vltelefone) {
    try {
        const client = await pool.connect();
        const result = await client.query("CALL cli.SPR_UPD_CLIENTE($1, $2, $3, $4);", [id_cliente, nm_cliente, ds_endereco, vltelefone]);
        client.release();
        return result.rows[0]; // Retorna os dados atualizados do cliente
    } catch (error) {
        console.error('Erro ao atualizar cliente', error);
        throw error;
    }
    */
/*
// Função para inserir dados de um novo cliente na tabela
async function insertcliente(nm_cliente, nrCpfCnpj, email, DtNascimento) {
    try {
        const client = await pool.connect();
        await client.query("CALL cli.spr_ins_cliente($1, $2, $3, $4);", [nrCpfCnpj, nm_cliente, email, DtNascimento]);
        client.release();
        console.log('Cliente inserido com sucesso.');
    } catch (error) {
        console.error('Erro ao inserir cliente:', error);
        throw error;
    }
}
*/


// Adiciona a função deleteMarca às exportações do módulo
module.exports = {
    updclientev3,
    deletecliente,
    insertcliente,
    selectClientes
    
}
