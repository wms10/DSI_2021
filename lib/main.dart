import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import 'package:dsi_app/dismissible.dart';
import 'package:dsi_app/editPage.dart';

Map<WordPair, bool> wordPairs;

void main() {
  initWordPairs();
  runApp(DSIApp());
}

void initWordPairs() {
  final generatedWordPairs = generateWordPairs().take(20);
  wordPairs =
      Map.fromIterable(generatedWordPairs, key: (e) => e, value: (e) => null);
}
class DSIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App DSI/BSI/UFRPE Para Listar',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}


// Classe para funcionalidade de pesquisa
class SearchItems extends SearchDelegate<String> {

  Map<WordPair, bool> wordPairs;
  SearchItems({this.wordPairs});

  List<WordPair> pairlist(){
   List<WordPair> list = [];
   wordPairs.forEach((key, value) {list.add(key);});
   return list;
   }

   String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    List<WordPair> list = pairlist();
    final suggestionList = list.where((element){
      final label = "${element.first} ${element.second}";
      return label.toLowerCase().startsWith(query.toLowerCase());
    }).toList();

    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
              leading: Icon(Icons.arrow_forward),
              title: Text("${capitalize(suggestionList[index].first)} ${capitalize(suggestionList[index].second)}"),
            ),
        itemCount: suggestionList.length);
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  List<Widget> _pages = [
    RandomWordsListPage(null),
    RandomWordsListPage(true),
    RandomWordsListPage(false)
  ];

  void _changePage(int value) {
    setState(() {
      pageIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App DSI/BSI/UFRPE Para Listar'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30,
            onPressed: () {
              showSearch(context: context, delegate: SearchItems(wordPairs: wordPairs));
            },
          )
        ],
      ),
      body: _pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _changePage,
        currentIndex: pageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up_outlined),
            label: 'Liked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumb_down_outlined),
            label: 'Disliked',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName:
                  Text('Bug', style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text('debug@gmail.com'),
              currentAccountPicture: Image.network(
                  "https://th.bing.com/th/id/Rb3a177132f56c7a5211e23c3b506a535?rik=cC8fIkfz6Op6FQ&pid=ImgRaw"),
            ),
            ListTile(
                trailing: Icon(Icons.account_box_outlined),
                title: Text('Account Settings',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            ListTile(
                trailing: Icon(Icons.settings),
                title: Text('Application Settings',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            ListTile(
                trailing: Icon(Icons.work_outline_sharp),
                title: Text('About us',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}

class RandomWordsListPage extends StatefulWidget {
  final bool _filter;

  RandomWordsListPage(this._filter);

  @override
  _RandomWordsListPageState createState() => _RandomWordsListPageState();
}


class _RandomWordsListPageState extends State<RandomWordsListPage> {

  String filterText = "";

  final _icons = {
    null: Icon(Icons.thumbs_up_down_outlined),
    true: Icon(Icons.thumb_up, color: Colors.blue),
    false: Icon(Icons.thumb_down, color: Colors.red),
  };


  void removePair(wordPair) {
    print(wordPair);
    wordPairs.remove(wordPair);
    setState(() {});
  }

  Iterable<WordPair> get items {
    if (widget._filter == null) {
      return wordPairs.keys;
    } else {

      return wordPairs.entries
          .where((element) => element.value == widget._filter)
          .map((e) => e.key);
    }
  }

  _toggle(WordPair wordPair) {
    bool like = wordPairs[wordPair];
    if (widget._filter != null) {
      wordPairs[wordPair] = null;
    } else if (like == null) {
      wordPairs[wordPair] = true;
    } else if (like == true) {
      wordPairs[wordPair] = false;
    } else {
      wordPairs[wordPair] = null;
    }
    setState(() {});
  }

  String capitalize(String s) {
    return '${s[0].toUpperCase()}${s.substring(1)}';
  }

  String asString(WordPair wordPair) {
    return '${capitalize(wordPair.first)} ${capitalize(wordPair.second)}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length * 2,
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider();
        }
        final int index = i ~/ 2;
        return _buildRow(index + 1, items.elementAt(index));
      },
    );
  }

  Widget _buildRow(int index, WordPair wordPair) {

    return DismissibleWidget(
      item: items,
      child: ListTile(
        title: Text('$index. ${asString(wordPair)}'),


        onTap: () async {
          final new_pair = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(wordPair)));
          if (new_pair == null) {return null;} 
          setState(() {   
            wordPairs[new_pair] = wordPairs[wordPair];
            wordPairs.remove(wordPair);
          });
        },


        trailing: IconButton(
          icon: _icons[wordPairs[wordPair]],
          onPressed: () {
            _toggle(wordPair);
          },
        ),
      ),
      onDismissed: (direction) => removePair(wordPair),
    );
  }
}

