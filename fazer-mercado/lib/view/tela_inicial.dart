import 'package:flutter/material.dart';
import 'detalhes_lista_view.dart';

class Item {
  String nome;
  int quantidade;
  bool comprado;

  Item(this.nome, this.quantidade, this.comprado);
}

class ShoppingList {
  String nome;
  List<Item>? itens;

  ShoppingList(this.nome, this.itens);
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  List<ShoppingList> shoppingLists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 203, 234, 247),
      appBar: AppBar(
        title: Text('Tela Inicial'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Sobre o App'),
              onTap: () {
                Navigator.popAndPushNamed(context, 'about');
              },
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                Navigator.popAndPushNamed(context, 'login');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: shoppingLists.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Você ainda não tem nenhuma lista de compras',
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: shoppingLists.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(shoppingLists[index].nome),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              _mostrarMenuOpcoes(context, index);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalhesLista(
                              shoppingList: shoppingLists[index],
                              addItemCallback: (Item newItem) {
                                setState(() {
                                  shoppingLists[index].itens?.add(newItem); // Alteração aqui
                                });
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exibirAlertDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarMenuOpcoes(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar Nome'),
                onTap: () {
                  Navigator.pop(context);
                  _editarNomeLista(context, index);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Excluir Lista'),
                onTap: () {
                  Navigator.pop(context);
                  _exibirDialogoExclusao(context, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editarNomeLista(BuildContext context, int index) {
    TextEditingController novoNomeController =
        TextEditingController(text: shoppingLists[index].nome);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Nome da Lista'),
          content: TextField(
            controller: novoNomeController,
            decoration: InputDecoration(
              labelText: 'Novo Nome',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                String novoNome = novoNomeController.text;
                if (novoNome.isNotEmpty) {
                  setState(() {
                    shoppingLists[index].nome = novoNome;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _exibirDialogoExclusao(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Lista de Compras'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Tem certeza de que deseja excluir a lista "${shoppingLists[index].nome}"?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  shoppingLists.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _exibirAlertDialog(BuildContext context) {
    TextEditingController nomeListaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Criar Nova Lista de Compras'),
          content: TextField(
            controller: nomeListaController,
            decoration: InputDecoration(
              labelText: 'Nome da Lista',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                String nomeLista = nomeListaController.text;
                if (nomeLista.isNotEmpty) {
                  setState(() {
                    shoppingLists.add(ShoppingList(nomeLista, []));
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
