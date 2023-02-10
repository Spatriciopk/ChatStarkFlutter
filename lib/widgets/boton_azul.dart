import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class BotonAzul extends StatelessWidget {
  
  final String etiqueta;
  Function onPressed ;

    BotonAzul(
    {super.key, 
    required this.etiqueta,
    required this.onPressed,
  
    });

  

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return   ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: !authService.autenticando ? Colors.blue : Colors.grey,
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