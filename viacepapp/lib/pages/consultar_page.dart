import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viacepapp/model.dart';
import 'package:viacepapp/repositories/cep_repository.dart';

class ConsultarPage extends StatefulWidget {
  const ConsultarPage({super.key});

  @override
  State<ConsultarPage> createState() => _ConsultarPageState();
}

class _ConsultarPageState extends State<ConsultarPage> {
  var cep = TextEditingController();

  var model = CepModel();
  var repository = CepRepository();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Consulta de CEP'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextFormField(
                controller: cep,
                keyboardType: TextInputType.number,
                maxLength: 8,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (cep.text.length == 8) {
                      setState(() {
                        loading = true;
                      });
                      model = await repository.obterDadosCep(cep.text);
                      repository.salvarCep(model);
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  child: const Text('Consultar CEP')),
              if (loading)
                const LinearProgressIndicator()
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Endereço',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(model.logradouro ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                        Text(model.bairro ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                        Text('${model.localidade ?? ' '}, ${model.uf ?? ''}',
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
