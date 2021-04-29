import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_is_money/modules/model/user.dart' as user_main;

import 'dialog_util.dart';

class BiometricsUtil {
  static const MethodChannel _channel =
      MethodChannel('simpleBiometricAPI:1.0.1');

  Future<void> checkBiometrics(
      BuildContext context, user_main.User user, Function() callback) async {
    final bool hasBiometrics = await canAuthenticateUsingBiometrics();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (hasBiometrics) {
      if (!prefs.containsKey('isBiometricsEnabled') ||
          !prefs.getBool('isBiometricsEnabled')) {
        DialogUtil.showDialogWithActions(
            context,
            'Biometria',
            'Deseja utilizar o login por biometria?',
            'Sim',
            () async {
              final String result = await showBiometricPromptForEncryption(
                  user.email, user.password);
              if (result == 'AuthenticationSucceeded') {
                await prefs.setBool('isBiometricsEnabled', true);
              } else {
                await prefs.setBool('isBiometricsEnabled', false);
              }
              callback();
            },
            'Não',
            () async {
              await prefs.setBool('isBiometricsEnabled', false);
              Navigator.of(context).pop();
              callback();
            });
      } else {
        callback();
      }
    } else {
      callback();
    }
  }

  Future<bool> canAuthenticateUsingBiometrics() async {
    try {
      return await _channel.invokeMethod('canAuthenticate');
    } on PlatformException catch (e) {
      return false;
    }
  }

  Future<void> tryLoginWithBiometrics(BuildContext context, Function(user_main.User user) loginCallback) async {
    try {
      final bool hasBiometrics = await canAuthenticateUsingBiometrics();
      if (hasBiometrics) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('isBiometricsEnabled') &&
            prefs.getBool('isBiometricsEnabled')) {
          final String token = await _channel.invokeMethod(
              'showBiometricPromptForDecryption', <String, dynamic>{
            'title': 'Time is Money',
            'subtitle': 'Faça o login para continuar',
            'negativeButtonText': 'Utilizar usuário e senha',
          }) as String;
          final List<String> encodedObject = token.split(':');
          final String email = utf8.decode(base64.decode(encodedObject[0]));
          final String pass = utf8.decode(base64.decode(encodedObject[1]));
          final user_main.User user =
              user_main.User(email: email, password: pass);
          loginCallback(user);

        }
      }
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('Unable to authenticate: ${e.message}');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isBiometricsEnabled', false);
    }
  }

  static Future<String> showBiometricPromptForEncryption(
      String email, String pass) async {
    try {
      final String encodedEmail = base64.encode(utf8.encode(email));
      final String encodedPass = base64.encode(utf8.encode(pass));
      return await _channel
          .invokeMethod('showBiometricPromptForEncryption', <String, dynamic>{
        'title': 'Time is Money',
        'subtitle': 'Faça o login para continuar',
        'negativeButtonText': 'Utilizar usuário e senha',
        'token': '$encodedEmail:$encodedPass'
      });
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('Unable to authenticate: ${e.message}');
    }
  }
}
