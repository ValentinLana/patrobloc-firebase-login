import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:patronbloc/src/bloc/provider.dart';
import 'package:patronbloc/src/models/producto_model.dart';

import 'package:patronbloc/src/utils/utils.dart' as utils;

import 'package:firebase_core/firebase_core.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  // ignore: unused_field
  bool _initialized = false;
  // ignore: unused_field
  bool _error = false;

  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();
/* 
 final productoProvider = new ProductosProvider(); */
  ProductosBloc productosBloc;

  ProductoModel producto = new ProductoModel();

  bool _guardando = false;

  File foto; // imagen
  String urlImagen; // url de la imagen

  PickedFile photo;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Producto"),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          //imagina un formulario html
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
        onPressed: (_guardando) ? null : _submit,
        icon: Icon(Icons.save),
        label: Text("Guardar"),
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: Colors.deepPurple,
        ));
  }

  Widget _crearDisponible() {
    return SwitchListTile(
        title: Text("Disponible"),
        activeColor: Colors.deepPurple,
        value: producto.disponible,
        onChanged: (value) => setState(() {
              producto.disponible = value;
            }));
  }

  void _submit() async {
    // regresa true si el formulario es valido y false si no lo es
    // formKey.currentState.validate()
    if (!formKey.currentState.validate()) return;

    //guarda y cambia la info de los botones
    //si no se pone esto no se guarda
    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      producto.fotoUrl = await productosBloc.subirFoto(foto);
    }

    if (producto.id == null) {
      productosBloc.agregarProducto(producto);
    } else {
      productosBloc.editarProducto(producto);
    }
    /* setState(() {
              _guardando = false;
            }); */
    mostrarSnackbar("Registro guardado");

    Navigator.pop(context);
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: "Producto"),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return "Ingrese el nombre del producto";
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.number,

      decoration: InputDecoration(labelText: "Precio"),
      onSaved: (value) => producto.valor = double.parse(value),
      //este es el validador
      //se pone utils por el tipo de importacion de la pagina "as utils"
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return "Sólo numeros";
        }
      },
    );
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage("assets/jar-loding.gif"),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    photo = await ImagePicker().getImage(
      source: origen,
    );

    if (photo != null) {
      foto = File(photo.path);
      producto.fotoUrl = null;
    }
    setState(() {});

    //ESTE ES EL CODIGO DEL Q FUE SACADO EL PROCESAR IMAGEN

    /* foto = await ImagePicker().getImage(
       source: ImageSource.camera,
    );

    if (foto != null) {

    }
    setState((){}); */
  }
}
