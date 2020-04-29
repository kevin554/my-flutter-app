import 'package:flutter/material.dart';
import 'package:myapps/networking/VehicleRepository.dart';


class VehiclesFragment extends StatefulWidget {

  VehiclesFragment();

  @override
  State<StatefulWidget> createState() {
    return new _VehiclesFragment();
  }

}

class _VehiclesFragment extends State<VehiclesFragment> {

  VehicleRepository vehicleRepository = VehicleRepository();
  var _vehiclesList = new List();

  @override
  void initState() {
    fetchVehicles();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: showVehiclesList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/add_vehicle', arguments: {"list": _vehiclesList, "i": -1});
          },
          tooltip: 'Agregar vehículo',
          child: Icon(Icons.add),
        ));
  }

  Widget showVehiclesList() {
    if (_vehiclesList.length > 0) {
      return RefreshIndicator(
        child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            itemCount: _vehiclesList.length,
            itemBuilder: (BuildContext context, int index) {
              String vehicle = _vehiclesList[index]['marca'] + " " + _vehiclesList[index]['modelo'] + " " + _vehiclesList[index]['color'];
              return ListTile(
                title: Text(
                  vehicle,
                  style: TextStyle(fontSize: 16.0),
                ),
                trailing: Text(
                  _vehiclesList[index]['placa'],
                  style: TextStyle(color: Color(0xFF06377A)),
                ),
                onTap: (){
                  Navigator.of(context).pushNamed('/add_vehicle', arguments: {"list": _vehiclesList, "i": index});
                },
              );
            }),
        onRefresh: _getData,
      );
    } else {
      return Center(child: Text("Welcome. Your list is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),));
    }
  }

  fetchVehicles() async {
    try {
      var response = await vehicleRepository.fetchVehicles();

      setState(() {
        _vehiclesList = response['data'];
      });
    } catch (e) {
      print('on catch');
    }
  }

  Future<void> _getData() async {
    setState(() {
      fetchVehicles();
    });
  }


}