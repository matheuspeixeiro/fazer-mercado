import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //Chave para o formulário
  var formKey = GlobalKey<FormState>();
  var status = false;

  //Controladores para os Campos de Texto
  var emailControl = TextEditingController();
  var senhaControl = TextEditingController();

  //Variaveis do Esconder/Mostrar Senha
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  // Método esconder senha
  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
    });
  }

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
          ? 'Informe um e-mail válido'
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

                Text(
                  'Bem-vindo(a) ao',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),

                Text(
                  'FAZER MERCADO',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontFamily: 'Impact',
                    color: Color.fromRGBO(5, 149, 172, 1),
                  ),
                ),

                SizedBox(height: 30),

                 TextFormField(
                  controller: emailControl,

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
                  keyboardType: TextInputType.visiblePassword,
                  controller: senhaControl,

                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                    suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: _toggleObscured,
                      child: Icon(
                        _obscured
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                      ),
                    ),
                   ),
                  ),

                  //
                  // Validação
                  //
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe uma senha';
                    }
                    return validatePassword(value);
                  },

                  //
                  // Toogle senha
                  //
                  obscureText: _obscured,
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
                      //Avançar para tela principal
                      Navigator.pushNamed(
                        context,
                        'tela_inicial',
                      );

                    } else {
                      //Erro na Validação
                    }
                  },

                  child: Text(
                    'Entrar',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                
                SizedBox(height: 20),

                //
                // LEVA PARA TELA DE CADASTRO
                //
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, 'cadastro', arguments: 'Hello from Home Screen!');
                  },

                  child: Text(
                    'Novo por aqui? Cadastre-se',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
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
