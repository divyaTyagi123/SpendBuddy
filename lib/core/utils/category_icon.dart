import 'package:flutter/material.dart';

IconData getCategoryIcon(String category){
  switch(category){
    case "Food":
      return Icons.restaurant;
    case "Travel":
      return Icons.directions_car;
    case "Shopping":
      return Icons.shopping_bag;
    case "Bills":
      return Icons.receipt;
    case "Health":
      return Icons.local_hospital;
    case "Entertainment":
      return Icons.movie;
    default:
      return Icons.category;

  }
}