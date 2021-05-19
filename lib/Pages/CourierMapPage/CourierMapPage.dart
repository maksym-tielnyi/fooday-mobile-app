import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:fooday_mobile_app/Models/UserOrderData.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CourierMapPage extends StatefulWidget {
  UserOrderData _orderData;

  CourierMapPage(this._orderData);

  @override
  State<StatefulWidget> createState() => _CourierMapPageState(_orderData);
}

class _CourierMapPageState extends State<CourierMapPage> {
  UserOrderData _orderData;
  GoogleMapController _controller;
  Marker _courierPos;
  Marker _destination;
  Location _location;

  final CameraPosition _initialCameraPos = CameraPosition(
    zoom: 15,
    target: LatLng(49.988358, 36.232845),
  );

  _CourierMapPageState(this._orderData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            _headerWidget(context),
            Expanded(
                child: GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPos,
              markers: {
                if (_courierPos != null) _courierPos,
                if (_destination != null) _destination
              },
              onMapCreated: _onMapCreated,
            ))
          ],
        ));
  }

  void _onMapCreated(GoogleMapController controller) async {
    const MarkerId courierMarkerId = MarkerId("Ваше місцезнаходження");
    const MarkerId destMarkerId = MarkerId("Ціль");
    _controller = controller;
    _location = Location();
    LatLng destCoord = await _getDestinationCoordinates();
    _destination = destCoord == null
        ? null
        : Marker(
            markerId: destMarkerId,
            position: destCoord,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen));
    _location.onLocationChanged.listen((l) {
      setState(() {
        _courierPos = Marker(
            markerId: courierMarkerId,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
            position: LatLng(l.latitude, l.longitude));
      });
      // _controller.animateCamera(CameraUpdate.newCameraPosition(
      //   CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
      // ));
    });
  }

  Widget _headerWidget(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.deepOrange,
        ),
        child: SafeArea(
            child: Padding(
                padding: EdgeInsets.only(bottom: 5, top: 0),
                child: Stack(
                  children: [
                    Container(
                        height: 40,
                        child: Center(
                            child: Text("Карта замовлення",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .merge(TextStyle(color: Colors.white70))))),
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ))));
  }

  Future<LatLng> _getDestinationCoordinates() async {
    const String CITY_NAME = "Харків";
    String query = "${_orderData.street} ${_orderData.house}, ${CITY_NAME}";
    List<Address> addr = await Geocoder.local.findAddressesFromQuery(query);
    if (addr.isEmpty) {
      return null;
    }
    return LatLng(addr[0].coordinates.latitude, addr[0].coordinates.longitude);
  }
}
