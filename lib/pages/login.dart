import 'package:flutter/material.dart';
import 'package:myapps/constants.dart';
import 'package:myapps/networking/VehicleRepository.dart';
import 'package:myapps/shared_preferences_helper.dart';


class LoginPage extends StatefulWidget {
  LoginPage({this.loginCallback});

  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  VehicleRepository vehicleRepository = VehicleRepository();

  String _username;
  String _password;
  String _errorMessage;

  // Initially password is obscure
  bool _obscureText = true;

  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Toggles the password show status
  void showHidePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Perform login or signup
  void validateAndSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

//    setState(() {
//      _errorMessage = "";
//      _isLoading = true;
//    });

    var response = await login();

//    setState(() {
//      _isLoading = false;
//    });

    if (response != null && isSuccessful(response['response'])) {
      var user = response['data'];
      await SharedPreferencesHelper.saveUser(user);

      widget.loginCallback();
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey,
      body: Stack( children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 35, // 30% of space => (3/(3 + 7))
                child: Container(
                  color: Color(colorPrimary),
                ),
              ),
              Expanded(
                flex: 65, // 70% of space
                child: Container(
                  color: Color(0xFFe6e6e6),
                ),
              ),
            ],
          )
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            showLogo(),
            _showForm(),
            // _showCircularProgress(),
          ],
        )
      ])
    );
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

  Widget _showForm() {
    return Card(
      margin: const EdgeInsets.all(20),
      // This ensures that the Card's children (including the ink splash) are clipped correctly.
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(16),
              child: new Form(
                key: _formKey,
                child: new ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 35),
                        child: Text('Ingresar',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center)
                    ),
                    // showLogo(),
                    showEmailInput(),
                    showPasswordInput(),
                    showPrimaryButton(),
                    showErrorMessage(),
                  ],
                ),
              )
          )
        ],
      ),
    );

//    return Container(
//
//      child: Card(
//        margin: const EdgeInsets.all(40),
//        // This ensures that the Card's children (including the ink splash) are clipped correctly.
//        clipBehavior: Clip.antiAlias,
//        child: Padding(
//            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//            child: Column(
//                children: <Widget>[
//                  Container(
//                      padding: EdgeInsets.all(16.0),
//                      child: new Form(
//                        key: _formKey,
//                        child: new ListView(
//                          shrinkWrap: true,
//                          children: <Widget>[
//                            // showLogo(),
//                            showEmailInput(),
//                            showPasswordInput(),
//                            showPrimaryButton(),
//                            showErrorMessage(),
//                        ],
//                      ),
//                    )
//                  )
//                ],
//            ),
//        ),
//      )
//    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 64, 0, 20),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/my-apps.png', width: 90, height: 90),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Usuario',
        ),
        validator: (value) {
          return value.isEmpty ? 'Debe ingresar su nombre de usuario.' : null;
        },
        onSaved: (value) => _username = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: _obscureText,
        autofocus: false,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Contraseña',
            suffixIcon: IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility),
                color: Colors.grey,
                onPressed: () => showHidePassword())),
        validator: (value) {
          return value.isEmpty ? 'Debe ingresar su contraseña.' : null;
        },
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Color(colorPrimary),
            child: new Text('Iniciar sesión',
                style: new TextStyle(color: Colors.white)),
            onPressed: () => validateAndSubmit(),
          ),
        ));
  }

  Future login() async {
    try {
      final response = await vehicleRepository.login(_username, _password);
      print(response);
      return response;
    } catch (e) {
      print(e);
    }
  }

  /* Returns true if code is in the range [200...300]*/
  bool isSuccessful(response) {
    return response >= 200 && response <= 300;
  }

}
