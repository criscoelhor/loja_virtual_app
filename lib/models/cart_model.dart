import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual_app/datas/cart_product.dart';
import 'package:loja_virtual_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  UserModel user;

  List<CartProduct> products = [];

  CartModel(this.user);

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addcartItem(CartProduct cart){
    products.add(cart);
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
    .collection("cart").add(cart.toMap()).then((doc){
      cart.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cart){
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").document(cart.cid).delete();

    products.remove(cart);

    notifyListeners();
  }
}