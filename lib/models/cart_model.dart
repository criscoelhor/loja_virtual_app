import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual_app/datas/cart_product.dart';
import 'package:loja_virtual_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  UserModel user;

  bool isLoading = false;

  List<CartProduct> products = [];

  CartModel(this.user){
    if(user.isLoggedIn())
      _loadCartItems();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cart){
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

  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
    .document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void  _loadCartItems() async {
     QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .getDocuments();

     products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

     notifyListeners();
  }
}