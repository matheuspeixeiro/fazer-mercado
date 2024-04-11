import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tela_inicial.dart';

class DetalhesLista extends StatefulWidget {
  final ShoppingList? shoppingList;
  final Function(Item) addItemCallback;

  const DetalhesLista({Key? key, required this.shoppingList, required this.addItemCallback}) : super(key: key);

  @override
  State<DetalhesLista> createState() => _DetalhesListaState();
}

class _DetalhesListaState extends State<DetalhesLista> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController quantidadeController = TextEditingController(text: '1');
  TextEditingController searchController = TextEditingController(); // Adicionando o TextEditingController para capturar o termo de pesquisa
  bool isChecked = false;
  List<Item> filteredItems = []; // Lista de produtos filtrados

  @override
  Widget build(BuildContext context) {
    if (widget.shoppingList == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalhes da Lista'),
        ),
        body: Center(
          child: Text('Nenhuma lista selecionada'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 203, 234, 247),
      appBar: AppBar(
        title: Text('Detalhes da Lista'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _mostrarDialogoFiltrar(context); // Abre o diálogo de filtragem ao pressionar o botão de busca
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome da Lista: ${widget.shoppingList!.nome}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            // Colunas
            DataTable(
              columns: [
                DataColumn(label: Text('OK?')),
                DataColumn(label: Text('Produto')),
                DataColumn(label: Text('Quantidade')),
              ],
              rows: [], // Vazio porque as linhas serão adicionadas dinamicamente
            ),

            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                child: Text(
                  'Nenhum item na lista',
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return ListTile(
                    title: Row(
                      children: [
                        // CHECKBOX
                        Expanded(
                          child: Checkbox(
                            value: item.comprado,
                            onChanged: (value) {
                              setState(() {
                                item.comprado = value ?? false;
                              });
                            },
                          ),
                        ),

                        //NOME
                        Expanded(
                          flex: 3,
                          child: Text(
                            item.nome,
                            textAlign: TextAlign.center,
                          ),
                        ),

                        //QUANTIDADE
                        Expanded(
                          flex: 3,
                          child: Text(
                            item.quantidade.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    onLongPress: () {
                      _mostrarMenuOpcoes(context, item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogAdicionarItem(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarMenuOpcoes(BuildContext context, Item index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar Produto'),
                onTap: () {
                  _mostrarDialogEditar(context, index);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Excluir produto'),
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

  void _exibirDialogoExclusao(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Produto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Tem certeza de que deseja excluir o produto abaixo?\n\n'
                      'Nome: ${item.nome}\n'
                      'Quantidade: ${item.quantidade}',
                ),
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
                  widget.shoppingList!.itens!.remove(item);
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

  void _mostrarDialogEditar(BuildContext context, Item item) {
    TextEditingController nomeController = TextEditingController(text: item.nome);
    TextEditingController quantidadeController = TextEditingController(text: item.quantidade.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar o Produto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Novo Nome'),
              ),
              TextField(
                controller: quantidadeController,
                decoration: InputDecoration(labelText: 'Nova Quantidade'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  item.quantidade = int.tryParse(value) ?? 0;
                },
              ),
            ],
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
                String novoNome = nomeController.text;
                int novaQuantidade = int.tryParse(quantidadeController.text) ?? 0;

                if (novoNome.isNotEmpty) {
                  setState(() {
                    item.nome = novoNome;
                    item.quantidade = novaQuantidade;
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

  void _mostrarDialogAdicionarItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome do Produto'),
              ),
              TextField(
                controller: quantidadeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              Row(
                children: [
                  Text('Comprado:'),
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                String nome = nomeController.text;
                bool comprado = isChecked;
                int quantidade = int.tryParse(quantidadeController.text) ?? 0;

                if (nome.isNotEmpty) {
                  Item newItem = Item(nome, quantidade, comprado);
                  if (widget.shoppingList != null) {
                    setState(() {
                      widget.shoppingList!.itens!.add(newItem);
                      filteredItems = widget.shoppingList!.itens!; // Atualiza a lista de produtos filtrados após adicionar um novo item
                    });
                  }

                  nomeController.clear();
                  quantidadeController.clear();
                  isChecked = false;

                  Navigator.of(context).pop();
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoFiltrar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filtrar Produtos'),
          content: TextField(
            controller: searchController,
            decoration: InputDecoration(labelText: 'Termo de Pesquisa'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                searchController.clear();

                setState(() {
                  // Redefine a lista de itens filtrados para a lista original
                  filteredItems = widget.shoppingList!.itens!;
                });

                Navigator.of(context).pop();
              },
              child: Text('Limpar'),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                String searchTerm = searchController.text.toLowerCase(); // Converta o termo de pesquisa para minúsculas
                if (searchTerm.isNotEmpty) {
                  setState(() {
                    // Atualiza a lista de produtos filtrados com base no termo de pesquisa
                    filteredItems = widget.shoppingList!.itens!.where((item) => item.nome.toLowerCase().contains(searchTerm)).toList();
                  });
                } else {
                  setState(() {
                    // Se o campo de pesquisa estiver vazio, exiba todos os produtos
                    filteredItems = widget.shoppingList!.itens!;
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Filtrar'),
            ),
          ],
        );
      },
    );
  }
}