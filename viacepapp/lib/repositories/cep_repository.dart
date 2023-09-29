import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:viacepapp/model.dart';

class CepRepository {
  var viacep = Dio();
  var b4app = Dio();

  obterDadosCep(String cep) async {
    Response response;
    response = await viacep.get('https://viacep.com.br/ws/$cep/json/');
    if (response.statusCode == 200) {
      var json = jsonDecode(response.toString());
      return CepModel.fromJson(json);
    }
  }

  salvarCep(CepModel model) async {
    b4app.options.headers['X-Parse-Application-Id'] =
        'kt6jUQvLM0lif5lGB7wDrWii61UJlexNA1qhSDjN';
    b4app.options.headers['X-Parse-REST-API-Key'] =
        'Vs7b51sCBN4E9UhkhnVsAoAjtJHHzrZe2dAnBFzw';
    b4app.options.headers['Content-Type'] = 'application/json';

    var response =
        await b4app.post('https://parseapi.back4app.com/classes/CEP', data: {
      'cep': model.cep,
      'logradouro': model.logradouro,
      'bairro': model.bairro,
      'localidade': model.localidade,
      'uf': model.uf
    });
    if (response.statusCode == 201) {
      print('sucesso!');
    } else {
      print(response.statusCode);
    }
  }

  var model = CepModel();

  obterHistorico() async {
    b4app.options.headers['X-Parse-Application-Id'] =
        'kt6jUQvLM0lif5lGB7wDrWii61UJlexNA1qhSDjN';
    b4app.options.headers['X-Parse-REST-API-Key'] =
        'Vs7b51sCBN4E9UhkhnVsAoAjtJHHzrZe2dAnBFzw';
    b4app.options.headers['Content-Type'] = 'application/json';

    var resultado = [];
    var response = await b4app.get('https://parseapi.back4app.com/classes/CEP');
    var teste = jsonDecode(response.toString());
    var lista = teste['results'].toList();
    for (var element in lista) {
      var dado = CepModel.fromJson(element);
      resultado.add(dado);
    }
    return resultado;
  }

  delete(String cep) async {
    var response = await b4app.get(
      'https://parseapi.back4app.com/classes/CEP/?where={"cep":"$cep"}',
    );
    var teste = jsonDecode(response.toString());
    var lista = teste['results'].toList();
    for (var element in lista) {
      var objectId = element['objectId'];
      await b4app.delete('https://parseapi.back4app.com/classes/CEP/$objectId');
    }
  }
}
