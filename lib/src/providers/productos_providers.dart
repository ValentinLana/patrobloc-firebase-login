import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:patronbloc/src/models/producto_model.dart';
import 'package:patronbloc/src/preferencias_usuario/preferencias_usuario.dart';

class ProductosProvider {
  final String _url = "https://intento2-662a8-default-rtdb.firebaseio.com";
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = "$_url/productos.json?auth=${_prefs.token}";

    final resp =
        await http.post(Uri.parse(url), body: productoModelToJson(producto));

    // ignore: unused_local_variable
    final decodedData = json.decode(resp.body);

    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = "$_url/productos/${producto.id}.json?auth=${_prefs.token}";

    final resp =
        await http.put(Uri.parse(url), body: productoModelToJson(producto));

    // ignore: unused_local_variable
    final decodedData = json.decode(resp.body);

    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = "$_url/productos.json?auth=${_prefs.token}";

    final resp = await http.get(Uri.parse(url));

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    final List<ProductoModel> productos = [];

    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);

      prodTemp.id = id;

      productos.add(prodTemp);
    });

    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = "$_url/productos/$id.json?auth=${_prefs.token}";
    // ignore: unused_local_variable
    final resp = await http.delete(Uri.parse(url));

    return 1;
  }

  Future subirImage(foto) async {
    if (foto != null) {
      // ignore: todo
      // TODO ESTO ES PARA SUBIR EL ARCHIVO

      // Esto crea una carpeta en firebase con ese nombre

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("Post Images");
      var timeKey = DateTime.now();
      UploadTask uploadTask =
          ref.child(timeKey.toString() + ".jpg").putFile(foto);

      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      var urlImagen;
      urlImagen = imageUrl.toString();
      return urlImagen;

      // GUARDAR LA INFO
      //

      // REGRESAR A HOME
      //

    }
  }
}
