

import 'package:chat/widgets/widgets.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(), // para el rebote 
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9, // el tamaño de la pantalla
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Logo(titulo: "Messenger"),
              _Form(),
              Labels(ruta: "register",titulo: "¿No tienes cuenta?",subtitulo: "Crea una ahora!"),
              Text("Términos y condiciones de uso",style: TextStyle(fontWeight: FontWeight.w200),)
            ]),
          ),
        ),
      ),
  );
  }
}




class _Form extends StatefulWidget {
  const _Form({super.key});

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        CustomInput(
          icon: Icons.mail_outline,
          placeholder: "Correo",
          keyboardType: TextInputType.emailAddress,
          textController: emailCtrl,
        ),
          CustomInput(
          icon: Icons.lock_outline,
          placeholder: "Contraseña",
          isPassword: true,
          textController: passCtrl,
        ),
        
        
        //Todo crear un boton
          BotonAzul(etiqueta: "Ingrese",onPressed: (){
            print(emailCtrl.text);
            print(passCtrl.text);
          }),
        
      ]),
    );
  }
}

