

import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
    final authService = Provider.of<AuthService>(context);
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
          BotonAzul(etiqueta: "Ingrese",
          onPressed: authService.autenticando 
          ? () =>{}
          : () async{
            //quitar el teclado
            FocusScope.of(context).unfocus();
            final loginOk = await authService.login(email: emailCtrl.text.trim(),password: passCtrl.text.trim());
            if(loginOk){
              //Todo conectar al socket server

              //TOdo Navegar a otra pantalla
              //usamos esto para q no se pueda regresar al login
              Navigator.pushReplacementNamed(context, "usuarios");

            }else{
              //Mostrar alerta
              mostrarAlerta(
                context: context, 
                titulo: "Login incorrecto", 
                subtitulo: "Revise sus credenciales nuevamente"
                );
            }
          }),
        
      ]),
    );
  }
}

