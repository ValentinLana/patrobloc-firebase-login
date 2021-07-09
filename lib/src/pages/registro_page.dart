import 'package:flutter/material.dart';
import 'package:patronbloc/src/bloc/login_bloc.dart';
import 'package:patronbloc/src/bloc/provider.dart';
import 'package:patronbloc/src/providers/usuario_provider.dart';
import 'package:patronbloc/src/utils/utils.dart';

class RegistroPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _loginForm(BuildContext context) {
    //te da acceso a todas las caracteristicas del bloc.
    //osea para cambiar el email el password y todo eso
    final bloc = Provider.of(context);

    //Esto es para calcular las dimensiones de la pantalla
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(
            height: 180.0,
          )),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 30.0,
            ),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            width: size.width * 0.85,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    //color de la cjaa
                    color: Colors.black26,
                    //bordes de la caja
                    blurRadius: 3.0,
                    //sombra
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0,
                  )
                ]),
            child: Column(
              children: [
                Text(
                  "Crear cuenta",
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 60.0),
                _crearEmail(bloc),
                SizedBox(height: 30.0),
                _crearPassword(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearBoton(bloc)
              ],
            ),
          ),
          TextButton(
            child: Text("Ya tienes cuenta? Login"),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "login");
            },
          ),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ElevatedButton(
            onPressed: snapshot.hasData ? () => _register(bloc, context) : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: Text("Ingresar"),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
          );
        });
  }

  _register(LoginBloc bloc, BuildContext context) async {
    final info = await usuarioProvider.nuevoUsuario(bloc.email, bloc.password);

    /*  Navigator.pushReplacementNamed(context, 'home'); */
    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      mostrarAlerta(context, info['mensaje']);
    }
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
                    hintText: "ejemplo@correo.com",
                    labelText: "Correo electronico",
                    counterText: snapshot.data,
                    errorText: snapshot.error),
                //manda lo que se escribe al stream
                onChanged: bloc.changeEmail,
              ));
        });
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock, color: Colors.deepPurple),
                    labelText: "Contraseña",
                    counterText: snapshot.data,
                    errorText: snapshot.error),
                //captura la informacion
                onChanged: bloc.changePassword,
              ));
        });
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
        //esto hace q ocupe el 40% de la pantalla
        height: size.height * 0.4,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(63, 63, 156, 1.0),
          Color.fromRGBO(90, 70, 178, 1.0)
        ])));

    final circulo = Container(
        width: 90.0,
        height: 90.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Color.fromRGBO(255, 255, 255, 0.05)));

    return Stack(
      children: [
        fondoMorado,
        //con el positioned moves el widget de los circulos a donde queras
        Positioned(
          top: 50.0,
          left: 30.0,
          child: circulo,
        ),
        Positioned(
          top: -20.0,
          right: -30.0,
          child: circulo,
        ),
        Positioned(
          top: 190.0,
          left: -10.0,
          child: circulo,
        ),
        Positioned(
          top: 120.0,
          right: 20.0,
          child: circulo,
        ),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: [
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              //sized box separa y tambien centra el widget
              SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              Text("Valentin Lana",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ))
            ],
          ),
        )
      ],
    );
  }
}
