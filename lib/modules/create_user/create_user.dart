import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CreateUser extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
        margin: EdgeInsets.only(top: 50),
        child: const Icon(Icons.person_add, size: 150, color: Colors.blueAccent,),
      ),
      Column(
          children: inputs
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 150, height: 50),
          child:  ElevatedButton(
              onPressed: () {
              },
              child: const Text('cadastrar', style: TextStyle(fontSize: 16),)),
        ),
      ),
    ];
  }


  List <Widget> inputs = [
    _containerInput(
      TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.email_outlined),
          hintText: 'Insira seu e-mail',
          labelText: 'e-mail',
        ),
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
      ),
    )
  ];

}
