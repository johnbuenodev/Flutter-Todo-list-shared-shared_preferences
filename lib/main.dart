import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>();
  //metodo construtor
  HomePage() {
    //passando array para a variavel do tipo lista
    items = [];
    //passando objetos para array list
   // items.add(Item(title: "john", done: true));
    //items.add(Item(title: "Mariana", done: false));
    //items.add(Item(title: "Marcos", done: true));
    //items.add(Item(title: "Marquinhos", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var addvar = TextEditingController();

  void add_task(){
    if(addvar.text.isEmpty) return;

    setState(() {
      widget.items.add(Item(title: addvar.text, done: false,),);
      //addvar.text = "";
      addvar.clear();
      save();

    });

  }

  void remove(int index){
    setState(() {
      widget.items.removeAt(index);
      save();
    });

  }

  //future é uma promessa
  Future load() async {
    //criando uma instancia do SharedPreferences
     var prefs = await SharedPreferences.getInstance();
     //chave key valor salvos os dados em json
     var data = prefs.getString('data');

     if(data != null){
       //iterable coluna q tem interaçao
       //Convertendo aqui
       Iterable decoded = jsonDecode(data);
       List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();

       setState(() {
         widget.items = result;
       });
     }

  }
  
  save() async{

    //cria a estancia 
    var prefs = await SharedPreferences.getInstance();
    //aguarda o prefs salvar os dados dentro da base de dados chamada data
    //usa jsonEnconde para transformar o widget.item em um json para ser salvo
    await prefs.setString('data', jsonEncode(widget.items));
    
  }
  
  
  //construtor para fazer load dos dados de items dentro do shared
  _HomePageState(){
    load();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),

        title: TextFormField(
          controller: addvar,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white,
          fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: "Add a Tarefa:",
            labelStyle: TextStyle(
              color: Colors.white
            ),
          ),
        ),
        // actions: <Widget>[
        //   Icon(Icons.audiotrack),
        //   Icon(Icons.create_new_folder),
        //   Icon(Icons.add_shopping_cart)
        // ],
      ),
      //builder vai executar e criar renderizar por demanda conforme por descendo ou subindo
      body: ListView.builder(
        //acessa os items q estão na classe pai
        itemCount: widget.items.length,
        //função q pergunta como vai construir os items na tela
        itemBuilder: (BuildContext ctxt, int index) {
          final item = widget.items[index];

          //return Text(widget.items[index].title);
          return Dismissible(
            child: CheckboxListTile(
              title: Text(item.title),

              value: item.done,
              onChanged: (value){
                setState(() {
                  item.done = value;
                  save();
                });
              },
            ),
            key: Key(item.title),
            background: Container(
              color: Colors.red.withOpacity(0.2),
              //child: Text("Excluir"),
            ),
            onDismissed: (direction){
              print(direction);
              if(direction == DismissDirection.endToStart){
                print(direction);
                remove(index);

                //toma uma ação
              }
              if(direction == DismissDirection.startToEnd){
                print(direction);
                remove(index);

                //toma outra ação
              }


            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: add_task,
          child: Icon(Icons.add_circle_outline),
        backgroundColor: Colors.orangeAccent,

      ),
    );
  }
}
