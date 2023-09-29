import 'package:flutter/material.dart';
import 'package:viacepapp/model.dart';
import 'package:viacepapp/repositories/cep_repository.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  var repository = CepRepository();
  var model = CepModel();
  var loading = false;

  var _historico = [];

  @override
  void initState() {
    obterHistorico();
    super.initState();
  }

  obterHistorico() async {
    setState(() {
      loading = true;
    });
    _historico = await repository.obterHistorico();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LinearProgressIndicator()
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: _historico.length,
                    itemBuilder: (BuildContext bc, int index) {
                      var item = _historico[index];
                      return Column(
                        children: [
                          ListTile(
                              leading: CircleAvatar(child: Text(item.uf ?? '')),
                              trailing: InkWell(
                                  child: const Icon(Icons.delete_outlined),
                                  onTap: () async {
                                    await repository.delete(item.cep);
                                    obterHistorico();
                                  }),
                              title: Text(item.cep!),
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(32.0),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              item.cep!,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(item.logradouro ?? '',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                )),
                                            Text(item.bairro ?? '',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                )),
                                            Text(
                                                '${item.localidade ?? ''}, ${item.uf ?? ''}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                          const Divider(),
                        ],
                      );
                    }),
              ),
            ],
          );
  }
}
