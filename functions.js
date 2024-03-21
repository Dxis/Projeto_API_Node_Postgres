// functions.js

// Função para validar o formato de um endereço de e-mail
function isValidEmail(email) {
    // Expressão regular para validar o formato de um e-mail
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Exporte a função isValidEmail
module.exports = { isValidEmail };
