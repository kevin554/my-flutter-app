import 'package:flutter/material.dart';


// Only put constants shared between files here.
const colorPrimary = 0xFF06377A;

const _baseUrl = "http://192.168.0.14:8089/";
const urlServices = _baseUrl + "rl-servicios/";
const urlAuth = _baseUrl + "rl-authentication/";

const MaterialColor colorPrimaryMap = MaterialColor(
  colorPrimary,
  <int, Color>{
    50: Color(0xFFE1E7EF),
    100: Color(0xFFB4C3D7),
    200: Color(0xFF839BBD),
    300: Color(0xFF5173A2),
    400: Color(0xFF2B558E),
    500: Color(colorPrimary),
    600: Color(0xFF053172),
    700: Color(0XFF042A67),
    800: Color(0xFF03235D),
    900: Color(0xFF02164A),
  },
);