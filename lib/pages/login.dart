import 'package:flutter/material.dart';
import 'package:myapps/constants.dart';
import 'package:myapps/networking/ApiRepository.dart';
import 'package:myapps/shared_preferences_helper.dart';


class LoginPage extends StatefulWidget {
  LoginPage({this.loginCallback});

  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = new GlobalKey<FormState>();
  ApiRepository apiRepository = ApiRepository();

  String _username;
  String _password;
  bool _obscureText = true; // Initially password is obscure
  bool _isLoading;

  void showHidePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void validateAndSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    var response = await apiRepository.login(_username, _password);

    setState(() {
      _isLoading = false;
    });

    if (response != null && isSuccessful(response['response'])) {
      var user = response['data'];
      await SharedPreferencesHelper.saveUser(user);

      widget.loginCallback();
    }
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  /* Returns true if code is in the range [200...300]*/
  bool isSuccessful(response) {
    return response >= 200 && response <= 300;
  }

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  colorPrimaryMap[800],
                  colorPrimaryMap[700],
                  colorPrimaryMap[400]
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Iniciar sesión", style: TextStyle(color: Colors.white, fontSize: 40),),
                  SizedBox(height: 10),
                  Text("Bienvenido de nuevo", style: TextStyle(color: Colors.white, fontSize: 18),),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(6, 55, 122, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )]
                          ),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          hintText: "Usuario",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none
                                      ),
                                      validator: (value) {
                                        return value.isEmpty ? 'Debe ingresar su nombre de usuario.' : null;
                                      },
                                      onSaved: (value) => _username = value.trim(),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                    ),
                                    child: TextFormField(
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                          hintText: "Contraseña",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                          suffixIcon: IconButton(
                                              icon: Icon(
                                                  _obscureText ? Icons.visibility_off : Icons.visibility
                                              ),
                                              color: Colors.grey,
                                              onPressed: showHidePassword
                                          )
                                      ),
                                      validator: (value) {
                                        return value.isEmpty ? 'Debe ingresar su contraseña.' : null;
                                      },
                                      onSaved: (value) => _password = value.trim(),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ),
                        _showCircularProgress(),
                        SizedBox(height: 40,),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          child: RaisedButton(
                            elevation: 5.0,
                            color: Color(colorPrimary),
                            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            child: Text('Iniciar sesión', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            onPressed: validateAndSubmit
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
