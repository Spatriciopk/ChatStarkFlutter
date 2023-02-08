import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  
  final String etiqueta;
  final Function onPressed;

  const BotonAzul(
    {super.key, 
    required this.etiqueta,
    required this.onPressed, 
  
    });


  @override
  Widget build(BuildContext context) {
    return   ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            elevation: 2,
            shape: StadiumBorder(),

          ),
          onPressed: () => onPressed(),
          child: Container(
            width: double.infinity,
            height: 50,
            child: Center(
              child: Text("$etiqueta",style: TextStyle(color: Colors.white,fontSize: 18),),
            ),
          ),
        );
  }
}