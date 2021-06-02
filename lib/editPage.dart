import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  
  WordPair editWordPair;

  EditPage(this.editWordPair);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController _newPairController = TextEditingController();

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  void initState() {
    super.initState();
    _newPairController.text = '${capitalize(widget.editWordPair.first)} ${capitalize(widget.editWordPair.second)}';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      title: Text('Edição de Par'),
      backgroundColor: Colors.green,
      actions: <Widget>[
        IconButton(
          color: Colors.green,
          onPressed: () {Navigator.pop(context, null);},
          icon: Icon(Icons.arrow_back)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _newPairController,
                keyboardType: TextInputType.number,
                maxLength: 15,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    icon: Icon(Icons.edit),
                    hintText: 'Par de Palavra',
                    labelText: 'Edite este par de palavras',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular((20)),
                        borderSide: BorderSide(color: Colors.black)),
                    labelStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: () {
                  List<String> labels = _newPairController.value.text.split(' ');
                  if (labels.length == 2) {
                    final newWordPair = new WordPair(labels[0], labels[1]);
                    print((newWordPair).toString());
                    Navigator.pop(context, newWordPair);
                  }
                },
                child: Text('Ok'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}