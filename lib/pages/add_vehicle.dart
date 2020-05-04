import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:myapps/networking/VehicleRepository.dart';


class AddVehiclePage extends StatefulWidget {

  AddVehiclePage();

  @override
  State<StatefulWidget> createState() => new _AddVehiclePageState();

}

class _AddVehiclePageState extends State<AddVehiclePage> {

  var _vehiclesList;
  var _vehicleObj;
  var index;

  VehicleRepository vehicleRepository = VehicleRepository();
  final _formKey = new GlobalKey<FormState>();

  String _brand;
  String _licensePlate;
  String _model;
  String _color;
  var selectedCity;
  var selectedClass;
  var selectedType;
  var citiesList = new List();
  var classesList = new List();
  var typesList = new List();

  @override
  void initState() {
    fetchCities();
    fetchClasses();
    fetchTypes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LinkedHashMap args = ModalRoute.of(context).settings.arguments;

    _vehiclesList = args['list'];
    index = args['i'];

    if (index != -1) {
      _vehicleObj = _vehiclesList[index];
    }

    if (_vehicleObj != null) {
      _brand = _vehicleObj['marca'];
      _licensePlate = _vehicleObj['placa'];
      _model = _vehicleObj['modelo'];
      _color = _vehicleObj['color'];

      if (selectedCity == null) {
        selectedCity = _vehicleObj['ciudad_id'].toString();
      }

      if (selectedClass == null) {
        selectedClass = _vehicleObj['clase_vehiculo_id'].toString();
      }

      if (selectedType == null) {
        selectedType = _vehicleObj['tipo_vehiculo_id'].toString();
      }
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Nuevo vehículo'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () {
                  validateAndSubmit();
                },
              )
            ]
        ),
        body: Stack(
          children: <Widget>[
            _showForm(),
          ],
        ));
  }

  void validateAndSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    var response = await saveVehicle();

    if (response != null) {// response.data['data']['mensaje']
      if (index != -1) {
        _vehiclesList[index] = response;
      } else {
        _vehiclesList.add(response);
      }

      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text('Listo!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showClassDropdown(),
              showTypeDropdown(),
              showBrandInput(),
              showLicensePlateInput(),
              showModelInput(),
              showColorInput(),
              showCityDropdown(),
            ],
          ),
        ));
  }

  Widget showBrandInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Marca',
        ),
        initialValue: _brand,
        validator: (value) {
          if (value.isEmpty) {
            return 'Debe colocar la marca.';
          }

          return null;
        },
        onSaved: (value) => _brand = value.trim(),
      ),
    );
  }

  Widget showLicensePlateInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Placa',
        ),
        initialValue: _licensePlate,
        validator: (value) {
          if (value.isEmpty) {
            return 'Debe colocar la placa.';
          }

          return null;
        },
        onSaved: (value) => _licensePlate = value.trim(),
      ),
    );
  }

  Widget showModelInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Modelo',
        ),
        initialValue: _model,
        validator: (value) {
          if (value.isEmpty) {
            return 'Debe colocar el modelo.';
          }

          return null;
        },
        onSaved: (value) => _model = value.trim(),
      ),
    );
  }

  Widget showColorInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Color',
        ),
        initialValue: _color,
        validator: (value) {
          if (value.isEmpty) {
            return 'Debe colocar el color.';
          }

          return null;
        },
        onSaved: (value) => _color = value.trim(),
      ),
    );
  }

  Widget showCityDropdown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Card(
        // This ensures that the Card's children (including the ink splash) are clipped correctly.
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: DropdownButton<String>(
            icon: Icon(Icons.arrow_downward, size: 24),
            elevation: 16,
            isExpanded: true,
            underline: Container(height: 0),
            onChanged: (var newValue) {
              setState(() {
                selectedCity = newValue;
              });
            },
            items: citiesList.map((item) {
              return DropdownMenuItem(
                child: Text(item['nombre']),
                value: item['ciudad_id'].toString(),
              );
            }).toList(),
            hint: Text('Seleccione la ciudad'),
            value: selectedCity,
          ),
        )
      )
    );
  }

  Widget showClassDropdown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Card(
        // This ensures that the Card's children (including the ink splash) are clipped correctly.
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: DropdownButton<String>(
            icon: Icon(Icons.arrow_downward, size: 24),
            elevation: 16,
            isExpanded: true,
            underline: Container(height: 0),
            onChanged: (var newValue) {
              setState(() {
                selectedClass = newValue;
              });
            },
            items: classesList.map((item) {
              return DropdownMenuItem(
                child: Text(item['nombre']),
                value: item['clase_vehiculo_id'].toString(),
              );
            }).toList(),
            hint: Text('Seleccione la clase'),
            value: selectedClass,
          )
        )
      )
    );
  }

  Widget showTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Card(
        // This ensures that the Card's children (including the ink splash) are clipped correctly.
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: DropdownButton<String>(
            icon: Icon(Icons.arrow_downward, size: 24),
            elevation: 16,
            isExpanded: true,
            underline: Container(height: 0),
            onChanged: (var newValue) {
              setState(() {
                selectedType = newValue;
              });
            },
            items: typesList.map((item) {
              return DropdownMenuItem(
                child: Text(item['nombre']),
                value: item['tipo_vehiculo_id'].toString(),
              );
            }).toList(),
            hint: Text('Seleccione el tipo'),
            value: selectedType,
          )
        )
      )
    );
  }

  Future saveVehicle() async {
    int id = _vehicleObj != null ? _vehicleObj['vehiculo_id'] : 0;

    try {
      final response = await vehicleRepository.saveVehicle(id, _brand,
          _licensePlate, _model, _color, int.parse(selectedClass),
          int.parse(selectedCity), int.parse(selectedType));
      print(response);
      return response;
    } catch (e) {
      print(e);
    }
  }

  Future fetchCities() async {
    try {
      final response = await vehicleRepository.fetchCities();

      setState(() {
        citiesList = response['data'];
      });
    } catch (e) {
      print(e);
    }
  }

  Future fetchTypes() async {
    try {
      final response = await vehicleRepository.fetchTypes();

      setState(() {
        typesList = response['data'];
      });
    } catch (e) {
      print(e);
    }
  }

  Future fetchClasses() async {
    try {
      final response = await vehicleRepository.fetchClasses();

      setState(() {
        classesList = response['data'];
      });
    } catch (e) {
      print(e);
    }
  }

}
