import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cart_hive/model/product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  // referencia a la box previamente abierta (en el main)
  Box _cartBox = Hive.box("Carrito");
  List<dynamic> _prodsList = List();

  CartBloc() : super(CartInitial());

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is LoadProductsEvent) {
      if (_cartBox.isNotEmpty)
        _prodsList = List<Product>.from(_cartBox.get("bebidas"));
      yield ElementsLoadedState(prodsList: _prodsList);
    } else if (event is RemoveProductEvent) {
      _prodsList.removeAt(event.element);
      _cartBox.put("bebidas", _prodsList);
      yield ElementsLoadedState(prodsList: _prodsList);
    }
  }
}
