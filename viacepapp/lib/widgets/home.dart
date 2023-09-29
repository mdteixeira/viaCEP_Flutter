import 'package:flutter/material.dart';
import '../pages/historico_page.dart';
import '../pages/consultar_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ViaCep(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class ViaCep extends StatefulWidget {
  const ViaCep({super.key});

  @override
  State<ViaCep> createState() => _ViaCepState();
}

class _ViaCepState extends State<ViaCep> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Consultar CEP',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
        ],
      ),
      body: <Widget>[
        const ConsultarPage(),
        const HistoricoPage(),
      ][currentPageIndex],
    );
  }
}
