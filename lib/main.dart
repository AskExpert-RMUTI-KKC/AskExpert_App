import 'package:askexpertapp/login.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

import 'example/fb.dart';
import 'example/google.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: GoogleSingIn(),
  ));
}
