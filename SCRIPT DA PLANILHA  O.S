function doGet(e) {
  var sheetOS = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("o.s");
  
  // --- LÓGICA DE EXCLUSÃO ---
  if (e.parameter.deleteID) {
    var idParaDeletar = e.parameter.deleteID.toString().padStart(3, '0');
    var data = sheetOS.getDataRange().getValues();
    
    for (var i = 1; i < data.length; i++) {
      if (data[i][0].toString().padStart(3, '0') === idParaDeletar) {
        sheetOS.deleteRow(i + 1);
        return ContentService.createTextOutput(JSON.stringify({"status": "success", "message": "Excluído"}))
          .setMimeType(ContentService.MimeType.JSON);
      }
    }
    return ContentService.createTextOutput(JSON.stringify({"status": "error", "message": "ID não encontrado"}))
      .setMimeType(ContentService.MimeType.JSON);
  }

  // --- LÓGICA DE LEITURA (EXISTENTE) ---
  var data = sheetOS.getDataRange().getValues();
  var rows = data.slice(1); 
  
  var result = rows.map(function(row) {
    return {
      "ID_OS": row[0],
      "CLIENTE": row[1],
      "ENDERECO": row[2],
      "CPF": row[3],
      "DATA_DO_SERVICO": row[4],
      "TIPO_DE_SERVICO": row[5],
      "TECNICO_RESPONSVEL": row[6],
      "VALOR_TOTAL": row[7],
      "GARANTIA_DIAS": row[8],
      "DATA_FIM_GARANTIA": row[9],
      "OBSERVACAO": row[10],
      "TERMINO_SERVICO": row[11]
    };
  });
  
  return ContentService.createTextOutput(JSON.stringify(result))
    .setMimeType(ContentService.MimeType.JSON);
}

function doPost(e) {
  var sheetOS = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("o.s");
  var p = e.parameter;
  var data = sheetOS.getDataRange().getValues();
  
  var idFinal;
  var linhaParaEditar = -1;

  if (!p.ID_OS || p.ID_OS === "" || p.ID_OS === "---") {
    var idsExistentes = data.slice(1).map(function(row) {
      return parseInt(row[0].toString().replace(/\D/g, '')) || 0;
    }).sort(function(a, b) { return a - b; });

    var proximo = 1;
    for (var i = 0; i < idsExistentes.length; i++) {
      if (idsExistentes[i] === proximo) proximo++;
    }
    idFinal = proximo.toString().padStart(3, '0');
  } else {
    idFinal = p.ID_OS.toString().padStart(3, '0');
    for (var i = 1; i < data.length; i++) {
      if (data[i][0].toString().padStart(3, '0') === idFinal) {
        linhaParaEditar = i + 1;
        break;
      }
    }
  }

  var dadosLinha = [
    idFinal, p.CLIENTE, p.ENDERECO, p.CPF, p.DATA_DO_SERVICO, 
    p.TIPO_DE_SERVICO, p.TECNICO_RESPONSVEL, p.VALOR_TOTAL, 
    p.GARANTIA_DIAS, p.DATA_FIM_GARANTIA, p.OBSERVACAO, p.TERMINO_SERVICO
  ];

  if (linhaParaEditar !== -1) {
    sheetOS.getRange(linhaParaEditar, 1, 1, dadosLinha.length).setValues([dadosLinha]);
  } else {
    sheetOS.appendRow(dadosLinha);
  }
  
  return ContentService.createTextOutput(JSON.stringify({"status": "success", "id": idFinal}))
    .setMimeType(ContentService.MimeType.JSON);
}
