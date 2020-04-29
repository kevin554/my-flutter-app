import 'dart:async';

import 'package:myapps/networking/ApiProvider.dart';


class VehicleRepository {
  ApiProvider _provider = ApiProvider();

  Future fetchVehicles() async {
    final response = await _provider.get('consultas/v1/vehicles');
    return response;
  }

  Future fetchCities() async {
    final response = await _provider.get('consultas/v1/cities');
    return response;
  }

  Future fetchTypes() async {
    final response = await _provider.get('consultas/v1/vehicle_types');
    return response;
  }

  Future fetchClasses() async {
    final response = await _provider.get('consultas/v1/vehicle_classes');
    return response;
  }

  Future saveVehicle(id, brand, licensePlate, model, color, classId, cityId,
      typeId) async {
    var params = new Map<String, dynamic>();
    params['vehiculo_id'] = id;
    params['marca'] = brand;
    params['placa'] = licensePlate;
    params['modelo'] = model;
    params['color'] = color;
    params['clase_vehiculo_id'] = classId;
    params['ciudad_id'] = cityId;
    params['tipo_vehiculo_id'] = typeId;
    params['imagenes'] = '[0]';

    final response = await _provider.post('consultas/v1/save_vehicle', params);
    return response;
  }

}