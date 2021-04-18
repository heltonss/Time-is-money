import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:time_is_money/modules/time_entry/time_entry_page.dart';

class Login extends StatelessWidget {
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
        margin: EdgeInsets.only(top: 50),
        child: const Icon(Icons.access_time, size: 150, color: Colors.blueAccent,),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => TimeEntryPage() ));
            },
            child: const Text('acessar', style: TextStyle(fontSize: 16),)),
      ),
    ),
      Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 30),
        child:  TextButton(
          onPressed: () {
            acessar();
          },
          child: Text('criar usuario'.toUpperCase(),
          style: const TextStyle(fontSize: 16),
          ),
        ),
      )
    ];
  }


  List <Widget> inputs = [
    _containerInput(
      TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.email_outlined),
          hintText: 'Insira seu e-mail de login',
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




  void acessar() {
    print('acessando');
  }
}
