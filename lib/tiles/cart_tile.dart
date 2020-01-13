import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_app/datas/cart_product.dart';
import 'package:loja_virtual_app/datas/products_data.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      return Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(cartProduct.productData.images[0],
                fit: BoxFit.cover),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                Text(
                  cartProduct.productData.title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17.0),
                ),
                Text(
                  'Tamanaho: ${cartProduct.size}',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
                Text("R\$ ${cartProduct.productData.price.toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold)),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: (){},
                    ),
                    Text(cartProduct.quantity.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: (){},
                    ),
                    FlatButton(
                      child: Text("Remover"),
                      textColor: Colors.grey,
                      onPressed: (){

                      },
                    )
                  ],

                )
              ]),
            ),
          )
        ],
      );
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: cartProduct.productData == null
            ? FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance
                    .collection("products")
                    .document(cartProduct.category)
                    .collection("items")
                    .document(cartProduct.pid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    cartProduct.productData =
                        ProductData.fromDocument(snapshot.data);
                    return _buildContent();
                  } else {
                    return Container(
                      height: 7.0,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  }
                },
              )
            : _buildContent());
  }
}
