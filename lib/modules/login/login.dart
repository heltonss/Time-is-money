import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:time_is_money/modules/model/user.dart' as user_main;
import 'package:time_is_money/modules/utils/biometrics_util.dart';

class Login extends StatelessWidget {
  static BiometricsUtil biometricsUtil = BiometricsUtil();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  static Widget _containerInput(Widget input) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: input,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('login'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: form(context)))));
  }

  List<Widget> form(BuildContext context) {
    return <Widget>[
      Container(
        alignment: Alignment.topCenter,
        child: const Icon(
          Icons.access_time,
          size: 150,
          color: Colors.blueAccent,
        ),
      ),
      Column(children: inputs(context)),
      Container(
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, 'create-user');
          },
          child: Text(
            'criar usuario'.toUpperCase(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      )
    ];
  }

  List <Widget> inputs (BuildContext context) {
    final TextEditingController _email = TextEditingController();
    final TextEditingController _password = TextEditingController();

    return <Widget>[
    _containerInput(
      TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.email_outlined),
          hintText: 'Insira seu e-mail de login',
          labelText: 'e-mail',
        ),
        controller: _email,
        validator: (String value){
          if(value.isEmpty){
            return 'Insira um e-mail';
          }

          return null;
        },
        onTap: () async {
          biometricsUtil.tryLoginWithBiometrics(context,
                  (user_main.User user) {
                signin(user, context);
              });
        },
       ),
    ),
    _containerInput(
      TextFormField(
        obscureText: true,
        obscuringCharacter: '*',
        decoration: const InputDecoration(
          icon: Icon(Icons.lock),
          hintText: 'Insira sua senha',
          labelText: 'password',
        ),
        controller: _password,
        validator: (String value){
          if(value.isEmpty){
            return 'Insira uma senha';
          }
          return null;
        },
        onTap: () async {
          biometricsUtil.tryLoginWithBiometrics(context,
                  (user_main.User user) {
                signin(user, context);
              });
        },
      ),
    ),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 150, height: 50),
        child:  ElevatedButton(
            onPressed: () {
              final user_main.User user = user_main.User(email: _email.text, password: _password.text);
              signin(user, context);
            },
            child: const Text('acessar', style: TextStyle(fontSize: 16),)),
      ),
      )
  ];}


  signin(user_main.User user, BuildContext context) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: user.email, password: user.password);
      if (userCredential.user.email != null) {
        final user_main.User firestoreUser =
            await getOrCreateUserInFirestore(user);
        biometricsUtil.checkBiometrics(context, user, () {
          Navigator.pushReplacementNamed(context, 'home',
              arguments: firestoreUser);
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // ignore: avoid_print
        print('Usu??rio n??o encontrado.');
      } else if (e.code == 'wrong-password') {
        // ignore: avoid_print
        print('Senha incorreta');
      }
    }
  }

  Future<user_main.User> getOrCreateUserInFirestore(user_main.User user) async {
    final DocumentSnapshot snapshot = await userCollection.doc(user.email).get();
    final Map<String, dynamic> firebaseUser = snapshot.data();
    user_main.User firestoreUser;
    if (firebaseUser == null) {
      user.userName = user.email
          .substring(0, user.email.indexOf('@'))
          .replaceAll('.', ' ')
          .replaceAll('_', ' ');
      await userCollection.doc(user.email).set(user.toJson());
      firestoreUser = user;
    } else {
      firestoreUser = user_main.User.fromJson(firebaseUser);
    }
    return firestoreUser;
  }
}
