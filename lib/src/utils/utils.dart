import 'package:flutter/material.dart';

bool isNumeric(String s){
if(s.isEmpty) return false;

//transforma string en un numero

final n = num.tryParse(s);

// en el caso de que n , no se puede pasar a numero
// retorna un false y si se puede retorna un true
return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String mensaje){
  showDialog(
    context: context,
   builder: (context){
     return AlertDialog(
       title: Text('Información incorrecte'),
       content: Text(mensaje),
       actions: [
         TextButton(
           onPressed: (){
             Navigator.of(context).pop();
             }
         , child: Text('ok'),)
       ],
     );
   }
   );
}


