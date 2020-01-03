import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_app/datas/cart_product.dart';
import 'package:loja_virtual_app/datas/products_data.dart';

class CartTile extends StatelessWidget {

  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){
      return Row(
        children: <Widget>[

        ],
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.productData == null ?
      FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection("products").document(
              cartProduct.category)
              .collection("items").document(cartProduct.pid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              cartProduct.productData = ProductData.fromDocument(snapshot.data);
              return _buildContent();
            } else {
              return Container(
                height: 7.0,
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
            }
          },
      ) :
          _buildContent()
    );
  }
}