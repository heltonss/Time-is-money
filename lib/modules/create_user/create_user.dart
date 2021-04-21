import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:time_is_money/modules/model/user.dart' as user_main;

class CreateUser extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          title: const Text('Cadastrar usuario'),
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
        margin: const EdgeInsets.only(top: 50),
        child: const Icon(Icons.person_add, size: 150, color: Colors.blueAccent,),
      ),
      Column(
          children: inputs (context)
      )
    ];
  }


  List <Widget> inputs(BuildContext context) {
    final TextEditingController _email = TextEditingController();
    final TextEditingController _password = TextEditingController();

    return [
    _containerInput(
      TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.email_outlined),
          hintText: 'Insira seu e-mail',
          labelText: 'e-mail',
        ),
        controller: _email,
        validator: (String value){
          print(EmailValidator.validate(value));
          if(value.isEmpty || !EmailValidator.validate(value)){
            return 'Insira um e-mail válido';
          }

          return null;
        },
      ),
    ),
    _containerInput(
      TextFormField(
        obscureText: true,
        obscuringCharacter: '*',
        controller: _password,
        decoration: const InputDecoration(
          icon: Icon(Icons.lock),
          hintText: 'Insira sua senha',
          labelText: 'password',
        ),
        validator: (value){
          if(value.length < 6){
            return 'Sua senha deve ter no minimo 6 caracteres';
          }
        },
      ),
    ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 150, height: 50),
          child:  ElevatedButton(
              onPressed: () {
                if(_formKey.currentState.validate()){
                  final user_main.User user = user_main.User(email: _email.text, password: _password.text);
                  createUser(user, context);
                }
              },
              child: const Text('cadastrar', style: TextStyle(fontSize: 16),)),
        ),
      ),
  ];
  }

  Future<Object> createUser(user_main.User user, BuildContext context) async {
    try {
     final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password
      );
     if(userCredential.additionalUserInfo.isNewUser){
       Navigator.pushNamed(context, '/');
     }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('A senha fornecida é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        print('Já existe uma conta com esse email.');
      }
    } catch (e) {
      print(e);
    }
  }

}
