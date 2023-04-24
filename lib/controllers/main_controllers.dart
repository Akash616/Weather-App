import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather/services/api_services.dart';

class MainController extends GetxController {
  @override
  void onInit() async {
    //getx method same as statefullwidget initstate method.
    super.onInit();
    await getUserLocation();
    currentWeatherData = getCurrentWeather(latitude.value, longitude.value);
    hourlyWeatherData = getHourlyWeather(latitude.value, longitude.value);
  }

  late Future currentWeatherData; //dynamic currentWeatherData;
  late Future hourlyWeatherData; //var hourlyWeatherData;

  var isDark = false.obs; //listener observable variable

  //user loaction
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  //for refresh automatically
  var isLoaded = false.obs;

  changeTheme() {
    isDark.value = !isDark.value; //isDark = true
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  }

  getUserLocation() async {
    //function
    bool isLocationEnabled;
    LocationPermission userPermission;

    isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      return Future.error("Location is not enabled");
    }

    userPermission = await Geolocator.checkPermission();
    if (userPermission == LocationPermission.deniedForever) {
      return Future.error("Permission is denied forever");
    } else if (userPermission == LocationPermission.denied) {
      userPermission = await Geolocator.requestPermission();
      if (userPermission == LocationPermission.denied) {
        return Future.error("Permission ids denied");
      }
    }
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      latitude.value = value.latitude;
      longitude.value = value.longitude;
      isLoaded.value = true;
    });
  }
}
