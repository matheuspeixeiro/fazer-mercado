// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import '../controller/file_helper.dart';
import '../model/usuario.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MainApp(),
    ),
  );
}

//
// MainApp
//
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CadastroView(),
    );
  }
}

//
// CadastroView
//
class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  //Chave para o formulário
  var formKey = GlobalKey<FormState>();
  var status = false;

  //Controladores para os Campos de Texto
  var _nomeControl = TextEditingController();
  var _emailCadastroControl = TextEditingController();
  var _senhaCadastroControl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    String? validateEmail(String? value) {
      const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
      final regex = RegExp(pattern);

      return value!.isNotEmpty && !regex.hasMatch(value)
          ? 'Enter a valid email address'
          : null;
    }

    String? validatePassword(String? value) {
      if (value!.isEmpty) {
        return 'Informe sua senha';
      } else if ((value.length < 6)
                  || (!value.contains(RegExp(r'[A-Z]')))
                    || (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')))) {

        return 'Requisitos:\n• 6 caracteres\n• 1 letra maiúscula\n• 1 caractere especial\nExemplo: Un43rp@';
      }
      return null;
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 60, 50, 60),
        child: SingleChildScrollView(

          //Direção da barra de rolagem
          scrollDirection: Axis.vertical,


          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [

                //
                // IMAGEM
                //
                Image.asset(
                  'lib/images/logo.png',
                  width: 230,
                  height: 230,
                ),

                SizedBox(height: 5),

                Text(
                  'Cadastre-se',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                
                SizedBox(height: 30),

                TextFormField(
                  controller: _nomeControl,

                  decoration: InputDecoration(
                    labelText: 'Primeiro Nome',
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe seu nome';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 30),

                TextFormField(
                  controller: _emailCadastroControl,

                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe seu e-mail';
                    }
                    return validateEmail(value);
                  },
                ),

                SizedBox(height: 30),

                TextFormField(
                  controller: _senhaCadastroControl,
                
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),

                validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe uma senha';
                    }
                    return validatePassword(value);
                  },

                  //
                  // Esconder senha
                  //
                  obscureText: true,
                ),


                SizedBox(height: 30),

                // BOTÃO
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(200, 60),
                    backgroundColor: Color.fromRGBO(5, 149, 172, 1),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    //
                    // Executar o processo de VALIDAÇÃO
                    //
                    if (formKey.currentState!.validate()) {
                      
                      // Crie um novo objeto Usuario com os dados fornecidos
                      Usuario novoUsuario = Usuario(nome: _nomeControl.text, email: _emailCadastroControl.text, senha: _senhaCadastroControl.text);
                      FileHelper.adicionarUsuario(novoUsuario);
                      print('Usuário adicionado com sucesso: $novoUsuario');

                      //Validação com sucesso, avisar que deu certo
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cadastro realizado com sucesso')),
                      );

                      //Voltar para tela de login
                      Navigator.popAndPushNamed(
                        context,
                        'login',
                      );

                    } else {
                      //Erro na Validação
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Preencha os campos corretamente')),
                      );
                    }
                  },

                  child: Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}