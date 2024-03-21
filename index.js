require("dotenv").config();

const db_Cliente = require("./db_clientes");

const express = require ("express");
const app = express();

app.use(express.json());



// Endpoint para selecionar clientes com base nos parâmetros fornecidos
app.get("/clientes", async (request, response) => {
    try {
        // Obtenha os parâmetros da consulta
        const { _ID_Cliente, _ID_ClienteTipo, _nrCpfCnpj, _nm_Cliente, _ID_Registro } = request.query;

        // Chame a função selectClientes com os parâmetros fornecidos
        const clientes = await db_Cliente.selectClientes(_ID_Cliente, _ID_ClienteTipo, _nrCpfCnpj, _nm_Cliente, _ID_Registro);
        response.json(clientes);
    } catch (error) {
        console.error('Erro ao obter Cliente', error);
        response.status(500).json({ error: 'Erro ao obter Cliente' });
    }
});

// Endpoint para inserir um novo cliente
app.post('/clientes', async (request, response) => {
    try {
        const { nm_cliente, nrCpfCnpj, email, DtNascimento } = request.body; // Extrai os dados do corpo da requisição
        await db_Cliente.insertcliente(nm_cliente, nrCpfCnpj, email, DtNascimento); // Chama a função para inserir o cliente
        response.status(201).json({ message: 'Cliente inserido com sucesso.' }); // Responde com um status 201 (Created)
    } catch (error) {
        console.error('Erro ao inserir cliente:', error);
        //return response.status(500).json({ error: 'Erro ao inserir cliente.' });    
        response.status(500).json({ error: 'Erro ao inserir cliente.' }); // Responde com um status 500 (Internal Server Error) em caso de erro
    }
});


// Endpoint para atualizar um cliente
app.patch("/clientes/:ID_Registro", async (request, response) => {
    try {
        const ID_Registro = parseInt(request.params.ID_Registro);
        const {  nm_cliente ,nrCpfCnpj , email , DtNascimento } = request.body; // Dados atualizados do cliente
        const clienteAtualizado = await db_Cliente.updclientev3(ID_Registro ,  nm_cliente ,nrCpfCnpj , email , DtNascimento);
        response.json(clienteAtualizado);
    } catch (error) {
        console.error('Erro ao atualizar Cliente', error);
        response.status(500).json({ error: 'Erro ao atualizar Cliente' });
    }
});


// Endpoint para deletar um cliente
app.delete('/clientes/:ID_Registro', async (request, response) => {
    try {
        const ID_Registro = parseInt(request.params.ID_Registro); //  capturando  e convertendo id_cliente para inteiro
        await db_Cliente.deletecliente(ID_Registro); // Passando id_cliente como argumento
        response.status(200).json({ message: 'Cliente deletado com sucesso.' });
    } catch (error) {
        console.error('Erro ao deletar cliente:', error);
        response.status(500).json({ error: 'Erro ao deletar cliente.' });
    }
});

/*
// Endpoint para atualizar um cliente
app.patch("/clientes/:id_cliente", async (request, response) => {
    try {
        const id_cliente = parseInt(request.params.id_cliente);
        const { nm_cliente, ds_endereco, vltelefone } = request.body; // Dados atualizados do cliente
        const clienteAtualizado = await db_Cliente.updclientev2(id_cliente, nm_cliente, ds_endereco, vltelefone);
        response.json(clienteAtualizado);
    } catch (error) {
        console.error('Erro ao atualizar Cliente', error);
        response.status(500).json({ error: 'Erro ao atualizar Cliente' });
    }
});
*/

/*
// Endpoint para inserir um novo cliente
app.post('/clientes', async (request, response) => {
    try {
        const { nm_cliente, ds_endereco, vltelefone } = request.body; // Extrai os dados do corpo da requisição
        await db_Cliente.insertcliente(nm_cliente, ds_endereco, vltelefone); // Chama a função para inserir o cliente
        response.status(201).json({ message: 'Cliente inserido com sucesso.' }); // Responde com um status 201 (Created)
    } catch (error) {
        console.error('Erro ao inserir cliente:', error);
        response.status(500).json({ error: 'Erro ao inserir cliente.' }); // Responde com um status 500 (Internal Server Error) em caso de erro
    }
});

*/
app.get("/", (request, response, next) => {
    response.json({
        message: "teste ok"
    })

})

app.listen(process.env.PORT,() =>{

    console.group("APP esta rodando v2!");
});

