import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myapps/pages/first_fragment.dart';
import 'package:myapps/pages/vehicles_fragment.dart';
import 'package:myapps/shared_preferences_helper.dart';


class HomePage extends StatefulWidget {

  final drawerItems = [
    new DrawerItem("Fragment 1", Icons.rss_feed),
    new DrawerItem("Vehículos", Icons.directions_car),
    new DrawerItem("Cerrar sesión", Icons.exit_to_app)
  ];

  HomePage({Key key, this.logoutCallback})
      : super(key: key);

  final VoidCallback logoutCallback;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int _selectedDrawerIndex = 0;
  var user;

  signOut() async {
    try {
      await SharedPreferencesHelper.saveUser(null);
      await _firebaseMessaging.deleteInstanceID();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  _onSelectItem(int index) {
    if (index == widget.drawerItems.length - 1) { /* the last one */
      signOut();
      return;
    }

    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new FirstFragment();
      case 1:
        return new VehiclesFragment();
      case 2:

      default:
        return new Text("Error");
    }
  }

  loadUserData() async {
    final user = await SharedPreferencesHelper.getUser();

    setState(() {
      this.user = user;
    });
  }

  @override
  void initState() {
    loadUserData();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");// message: {notification: {title: '', body: ''}, data: {}}
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print("On token refresh: $newToken");
    });

    super.initState();
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

    var username = user != null ? user['Usuario'] : '';
    var email = user != null ? user['Email'] : '';

    return new Scaffold(
      appBar: AppBar(title: Text('App informativa')),
      drawer: Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountName: Text(username),
                  accountEmail: Text(email),
//                  currentAccountPicture: CircleAvatar(
//                    backgroundColor: Colors.transparent,
//                    radius: 48.0,
//                    child: Image.asset('assets/my-apps.png', width: 90, height: 90)
//                  )
              ),
              Column(children: drawerOptions)
            ],
          )
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }

}

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}
