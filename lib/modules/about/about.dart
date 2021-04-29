import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre Nós'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 50),
            child: const Icon(
              Icons.access_time,
              size: 150,
              color: Colors.blueAccent,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
                child: Text(
              'Time is Money',
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold),
            )),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
                child: Text(
              'Criadores:',
              style: TextStyle(fontSize: 25),
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildCreator(
                  imageAsset: 'images/helton_isac.jpeg', name: 'Helton Isac'),
              buildCreator(
                  imageAsset: 'images/helton_souza.jpeg', name: 'Helton Souza'),
              buildCreator(
                  imageAsset: 'images/lyan_masterson.jpeg',
                  name: 'Lyan Masterson'),
              buildCreator(
                  imageAsset: 'images/ricardo_kerr.jpeg', name: 'Ricardo Kerr'),
            ],
          )
        ],
      ),
    );
  }

  Expanded buildCreator({String imageAsset, String name}) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(child: Image.asset(imageAsset)),
          ),
          Text(
            name,
            textAlign: TextAlign.center,
          )
        ],
      ),
    ));
  }
}
