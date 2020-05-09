import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapps/networking/ApiRepository.dart';


class AddVehiclePage extends StatefulWidget {

  AddVehiclePage();

  @override
  State<StatefulWidget> createState() => new _AddVehiclePageState();

}

class _AddVehiclePageState extends State<AddVehiclePage> {

  var _images = new List();
  var _vehiclesList;
  var _vehicleObj;
  var index;

  ApiRepository apiRepository = ApiRepository();
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
    _images.add({'documento_id': 0});

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

      if (_images.length == 1) {
        _images.insertAll(0, _vehicleObj['listDocumentos']);
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
//    if (!_formKey.currentState.validate()) {
//      return;
//    }

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
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          showClassDropdown(),
          showTypeDropdown(),
          showBrandInput(),
          showLicensePlateInput(),
          showModelInput(),
          showColorInput(),
          showCityDropdown(),
          showImagePicker(),
        ],
      ),
    );
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

  Widget showImagePicker() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'Fotos',
                  style: TextStyle(color: Color(0xFF263238), fontSize: 22)
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Text(
                  'Carge las imágenes una por una',
                  style: TextStyle(color: Color(0xFF666666), fontSize: 14)
                )
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                      height: 90,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _images.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                                alignment: Alignment.topRight,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    child: FlatButton(
                                      child: getImageWidget(index),
                                      padding: EdgeInsets.all(0),
                                      onPressed: takePicture
                                    ),
                                  ),
                                  if (index != _images.length - 1)
                                    IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () => removeImage(index)
                                    )
                                ]
                            );
                          }
                      )
                  )
              )
            ]
        ),
      ),
    );
  }

  Widget getImageWidget(index) {
    if (index == (_images.length - 1)) {
      return Image(image:AssetImage('assets/add-black.png'), width: 90, height: 90);
    }

    var id = _images[index]['documento_id'];
    if (id != null && id > 0) {
      return Image.network(apiRepository.getFile(id));
    }

    return Image.file(_images[index]['path'], width: 90, height: 90);
  }

  removeImage(index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future takePicture() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _images.insert(0, {'path': image});
      });
    }
  }

  Future saveVehicle() async {
    int id = _vehicleObj != null ? _vehicleObj['vehiculo_id'] : 0;

    var currentImages = List();
    var newImages = List();
    for (final image in _images) {
      if (image['path'] != null) {
        newImages.add(image['path']);
      }

      if (image['documento_id'] != null && image['documento_id'] > 0) {
        currentImages.add(image['documento_id']);
      }
    }

    if (currentImages.isEmpty) {
      currentImages.add(0);
    }

    try {
      final response = await apiRepository.saveVehicle(id, _brand,
          _licensePlate, _model, _color, int.parse(selectedClass),
          int.parse(selectedCity), int.parse(selectedType), newImages,
          currentImages);
      print(response);
      return response;
    } catch (e) {
      print(e);
    }
  }

  Future fetchCities() async {
    try {
      final response = await apiRepository.fetchCities();

      setState(() {
        citiesList = response['data'];
      });
    } catch (e) {
      print(e);
    }
  }

  Future fetchTypes() async {
    try {
      final response = await apiRepository.fetchTypes();

      setState(() {
        typesList = response['data'];
      });
    } catch (e) {
      print(e);
    }
  }

  Future fetchClasses() async {
    try {
      final response = await apiRepository.fetchClasses();

      setState(() {
        classesList = response['data'];
      });
    } catch (e) {
      print(e);
    }
  }

}
