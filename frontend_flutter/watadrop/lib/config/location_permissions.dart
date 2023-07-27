import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../common/style.dart';
import '../widgets/error_dialog_widget.dart';
import '../widgets/toast_widget.dart';


Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    showToastWidget('Location services are disabled. Please enable the services',colorFailed);
    return Future.error('Location services are disabled');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      showToastWidget('Location permissions are denied',colorFailed);
      return Future.error("Location permission denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    showToastWidget('Location permissions are permanently denied, we cannot request permissions.',colorFailed);
    return Future.error('Location permissions are permanently denied');
  }

  Position position = await Geolocator.getCurrentPosition();

  return position;
}

Future<String> getCurrentAddress() async {
  Position position = await determinePosition();
  return getAddress(position.latitude!, position.longitude!);
}

Future<String> getAddress(latitude, longitude) async {


  try{
    List<Placemark> newPlace = await placemarkFromCoordinates(latitude!, longitude!);

    Placemark? placeMark  = newPlace[0];
    String? street = placeMark.street;
    String? sublocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    String? address = "${street}, ${sublocality}, ${locality}, ${administrativeArea}, ${postalCode}, ${country}";

    return address;
  } catch(e){
    getAddress(latitude, longitude);
    throw Exception(showToastWidget(e.toString(), colorFailed));
  }
}

// Get distance between current location and entered address
Future<String> getDistance(context,departure_address,destination_address) async {

  return Future.delayed(Duration(seconds: 5), () async {
    try{
      List<Location> departure_locations = await locationFromAddress(departure_address!);
      List<Location> locations = await locationFromAddress(destination_address!);

      final distance = Geolocator.distanceBetween(
          departure_locations[0].latitude, departure_locations[0].longitude,
          locations[0].latitude, locations[0].longitude);
      return Future.value((distance/1000).toStringAsFixed(1));
    } catch(e){
      //getDistance(departure_address, destination_address);
      throw(showErrorDialog(context, e.toString()));
    }
  });



}

