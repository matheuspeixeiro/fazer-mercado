import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

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
      home: Sobre(),
    );
  }
}

class Sobre extends StatefulWidget {
  const Sobre({Key? key}) : super(key: key);

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centralizando a imagem do logo
              Center(
                child: Image.asset(
                  'lib/images/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
              SizedBox(height: 20),
              // Objetivo do aplicativo
              Text(
                'Objetivo do App:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Economizar tempo na hora de fazer mercado, de forma que você possa centralizar todas suas listas de compras em um único lugar',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),
              // Desenvolvedor
              Text(
                'Desenvolvedor:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Matheus Simões Peixeiro\n'
                'Graduando da 7ª etapa de Engenharia de Computação - UNAERP',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}