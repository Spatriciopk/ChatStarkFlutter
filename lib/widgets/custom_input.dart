import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController; //esto permite obtener el texto d ela caja de texto
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomInput(
    {super.key, 
    required this.icon, 
    required this.placeholder, 
    required this.textController, 
    this.keyboardType = TextInputType.text, 
    this.isPassword = false
    }
    );

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.only(top: 5,left: 5,bottom: 5,right: 20),
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0,5),
                blurRadius: 5
              )
            ],
          ),
          child: TextField(
            controller: this.textController,
            autocorrect: false,
            keyboardType: this.keyboardType,
            obscureText: this.isPassword,
            decoration: InputDecoration(
              prefixIcon: Icon(this.icon),
              //para quitar la linea de abajo del formulario
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: this.placeholder
            ),
          ),
      );
  }
}