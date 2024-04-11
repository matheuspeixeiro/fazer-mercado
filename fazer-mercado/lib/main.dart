import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'view/cadastro_view.dart';
import 'view/detalhes_lista_view.dart'; // Importe o arquivo detalhes_lista_view.dart
import 'view/login_view.dart';
import 'view/sobre_view.dart';
import 'view/tela_inicial.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Compras',

      // ROTAS DE NAVEGAÇÃO
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginView(),
        'cadastro': (context) => CadastroView(),
        'tela_inicial': (context) => const TelaInicial(),
        'detalhes_lista': (context) => DetalhesLista(
          shoppingList: null,
          addItemCallback: (Item newItem) {
            // Callback para adicionar um novo item à lista
          },
        ),
        'about': (context) => Sobre(),
      },
    );
  }
}