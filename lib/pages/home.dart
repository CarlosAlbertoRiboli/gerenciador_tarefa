// ignore_for_file: deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_tarefa_app/models/tarefa.dart';
import 'package:lista_de_tarefa_app/models/usuario.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  final dataControler = TextEditingController();
  final tarefaControler = TextEditingController();

  List<ListaTarefa> itens = [];
  var colecao = FirebaseFirestore.instance.collection('lista-registros');

  @override
  void initState() {
    super.initState();
    carregaDados();
  }

  void carregaDados() {
    colecao.snapshots().listen((event) {
      setState(() {
        itens.clear();
      });
      for (var c in event.docs) {
        if (c['email'] == User.email) {
          String id = c.id;
          String email = c['email'];
          String tarefa = c['tarefa'];
          String data = c['data'];
          ListaTarefa t = ListaTarefa(id, email, tarefa, data);
          setState(() {
            itens.add(t);
          });
        }
      }
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget continueButton = FlatButton(
      child: const Text("Confirmar"),
      onPressed: () {
        ListaTarefa t = ListaTarefa(
            '1', User.email, tarefaControler.text, dataControler.text);
        colecao.doc().set(t.toMap());
        dataControler.clear();
        tarefaControler.clear();
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Adicionar nova tarefa"),
      content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tarefa',
                ),
                controller: tarefaControler,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Data',
                      ),
                      controller: dataControler,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                      onPressed: () async {
                        DateTime? dataAtual = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2025),
                        );
                        dataControler.text =
                            dataAtual.toString().substring(0, 10);
                      },
                      child: const Icon(Icons.calendar_month),
                    ),
                  ),
                ],
              ),
            ],
          )),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Tarefa'),
          backgroundColor: Colors.indigo,
          centerTitle: true,
          actions: <Widget>[
            IconButton(onPressed: () {
              Navigator.of(context)
                                    .pushReplacementNamed('/login');
            }, icon: const Icon(Icons.exit_to_app))
          ],
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            showAlertDialog(context);
          },
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: itens.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      tooltip: 'Excluir',
                      onPressed: () {
                        colecao.doc(itens[index].id).delete();
                      },
                    ),
                    title: Text(itens[index].tarefa),
                    subtitle: Text(itens[index].data),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
