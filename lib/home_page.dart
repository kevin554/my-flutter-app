import 'package:flutter/material.dart';
import 'dart:async';

import 'package:myapps/first_fragment.dart';
import 'package:myapps/vehicles_fragment.dart';

class HomePage extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Fragment 1", Icons.rss_feed),
    new DrawerItem("Vehículos", Icons.local_pizza),
    new DrawerItem("Fragment 3", Icons.info)
  ];

  HomePage({Key key, this.userId, this.logoutCallback})
      : super(key: key);

  final String userId;
  final VoidCallback logoutCallback;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  signOut() async {
    try {
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  showAddTodoDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                      controller: _textEditingController,
                      autofocus: true,
                      decoration: new InputDecoration(
                        labelText: 'Add new todo',
                      ),
                    ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Widget showTodoList() {
    return Center(
        child: Text(
          "Welcome. Your list is empty",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30.0),
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }
//
//    return new Scaffold(
//      appBar: new AppBar(
//        // here we display the title corresponding to the fragment
//        // you can instead choose to have a static title
//        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
//      ),
//      drawer: new Drawer(
//        child: new Column(
//          children: <Widget>[
//            new UserAccountsDrawerHeader(
//                accountName: new Text("John Doe"), accountEmail: null),
//            new Column(children: drawerOptions)
//          ],
//        ),
//      ),
//      body: _getDrawerItemWidget(_selectedDrawerIndex),
//    );

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('App informativa'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(accountName: new Text("John Doe"), accountEmail: null),
              new Column(children: drawerOptions)
            ],
          )
        ),
//        drawer: Drawer(
//          child: ListView(
//            padding: EdgeInsets.zero,
//            children: <Widget>[
//              DrawerHeader(
//                decoration: BoxDecoration(
//                  color: Colors.blue,
//                ),
//                child: Text(
//                  'Drawer header',
//                  style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 24,
//                  )
//                )
//              ),
//              ListTile(
//                leading: Icon(Icons.message),
//                title: Text('Messages'),
//                onTap: () {
//                  // change app state...
//                  Navigator.pop(context); // close the drawer
//                },
//              ),
//              ListTile(
//                leading: Icon(Icons.account_circle),
//                title: Text('Profile'),
//              ),
//              ListTile(
//                leading: Icon(Icons.settings),
//                title: Text('Settings'),
//              )
//            ],
//          ),
//        ),
        body: _getDrawerItemWidget(_selectedDrawerIndex), // showTodoList(),
//        floatingActionButton: FloatingActionButton(
//          onPressed: () {
//            showAddTodoDialog(context);
//          },
//          tooltip: 'Increment',
//          child: Icon(Icons.add),
        // )
    );
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }
  int _selectedDrawerIndex = 0;
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new FirstFragment();
      case 1:
        return new VehiclesFragment();
      case 2:
        // return new ThirdFragment();

      default:
        return new Text("Error");
    }
  }

}

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}
