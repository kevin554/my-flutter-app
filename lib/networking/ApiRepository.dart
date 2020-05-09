import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:myapps/constants.dart';
import 'package:myapps/networking/ApiProvider.dart';

class ApiRepository {
  ApiProvider _provider = ApiProvider();

  Future fetchVehicles() async {
    final response = await _provider.get(urlServices + 'consultas/v1/vehicles');
    return response;
  }

  Future fetchCities() async {
    final response = await _provider.get(urlServices + 'consultas/v1/cities');
    return response;
  }

  Future fetchTypes() async {
    final response = await _provider.get(urlServices + 'consultas/v1/vehicle_types');
    return response;
  }

  Future fetchClasses() async {
    final response = await _provider.get(urlServices + 'consultas/v1/vehicle_classes');
    return response;
  }
// TODO: send images to the server
  Future saveVehicle(id, brand, licensePlate, model, color, classId, cityId, typeId, newImages, currentImages) async {
    var newImagesParam = [newImages.length];
    for (int i = 0; i < newImages.length; i++) {
      var image = newImages[i];

      var partFile = MultipartFile.fromFileSync(image.path, filename: '6789123423.png');
      newImagesParam[i] = partFile;
    }

    var params = new Map<String, dynamic>();
    params['vehiculo_id'] = id;
    params['marca'] = brand;
    params['placa'] = licensePlate;
    params['modelo'] = model;
    params['color'] = color;
    params['clase_vehiculo_id'] = classId;
    params['ciudad_id'] = cityId;
    params['tipo_vehiculo_id'] = typeId;
    params['nuevas_imagenes'] = [MultipartFile.fromFileSync(newImages[0].path, filename: '6789123423.png')];
    params['imagenes'] = json.encode(currentImages);

    var formData = {
      'vehiculo_id': id,
      'marca': brand,
      'placa': licensePlate,
      'modelo': model,
      'color': color,
      'clase_vehiculo_id': classId,
      'ciudad_id': cityId,
      'tipo_vehiculo_id': typeId,
      'nuevas_imagenes': [
        MultipartFile.fromFileSync(newImages[0].path, filename: '6789123423.png')
      ],
      'imagenes': '[0]'
    };

    final response = await _provider.dioPost2(urlServices + 'consultas/v1/save_vehicle', formData);
    return response;
  }

  Future login(username, password) async {
    var body = {
      'login': username,
      'password': password
    };

    final response = await _provider.post(urlAuth + 'rest/api/auth/login', body);
    return response;
  }

  String getFile(id) {
    return urlAuth + "auth/login/servlet?id=$id";
  }

}