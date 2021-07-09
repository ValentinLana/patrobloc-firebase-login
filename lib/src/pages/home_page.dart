import 'package:flutter/material.dart';
import 'package:patronbloc/src/bloc/provider.dart';

import 'package:patronbloc/src/models/producto_model.dart';
import 'package:patronbloc/src/providers/productos_providers.dart';

class HomePage extends StatelessWidget {
  /* final productosProvider = new ProductosProvider(); */

  @override
  Widget build(BuildContext context) {
    /* final bloc = Provider.of(context); */

    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: _crearListado(productosBloc),
        floatingActionButton: _crearBoton(context));
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;

          return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, i) =>
                  _crearItem(productos[i], productosBloc, context));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    //el codigo antes de poner el bloc

    /*  return FutureBuilder(
      future: productosProvider.cargarProductos(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;

          return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, i) => _crearItem(productos[i], context));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ); */
  }

  Widget _crearItem(ProductoModel producto, ProductosBloc productosBloc,
      BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          productosBloc.borrarProducto(producto.id);
        },
        child: Card(
          child: Column(
            children: [
              (producto.fotoUrl == null)
                  ? Image(image: AssetImage("assets/no-image.png"))
                  : FadeInImage(
                      image: NetworkImage(producto.fotoUrl),
                      placeholder: AssetImage("assets/jar-loading.gif"),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                  title: Text("${producto.titulo} - ${producto.valor}"),
                  subtitle: Text(producto.id),
                  onTap: () {
                    Navigator.pushNamed(context, "producto",
                        arguments: producto);
                  }),
            ],
          ),
        ));

    /*  */
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto'),
    );
  }
}
