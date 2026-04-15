// api.js - O cérebro centralizado do sistema
const URL_DATABASE = "https://script.google.com/macros/s/AKfycbyx6kGtlzS0q1s3chrRhdNG0YGJ4VwRIDLjmttJN_vE4UVa2CPmVRFqQlU9nQ1DPkmjnA/exec"; 

// Função genérica para buscar qualquer dado da planilha
async function fetchData(params = "") {
    try {
        const response = await fetch(URL_DATABASE + params);
        if (!response.ok) throw new Error("Erro na rede");
        return await response.json();
    } catch (error) {
        console.error("Falha ao buscar dados:", error);
        return null;
    }
}

// Futura função para salvar dados (POST)
async function sendData(payload) {
    try {
        const response = await fetch(URL_DATABASE, {
            method: 'POST',
            body: JSON.stringify(payload)
        });
        return await response.json();
    } catch (error) {
        console.error("Erro ao enviar:", error);
        return { status: "erro" };
    }
}
