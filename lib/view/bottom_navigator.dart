import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermercado/controller/bottom_navigator_controller.dart';
import 'package:supermercado/view/cart_screen.dart';
import 'package:supermercado/view/home_screen.dart';
import 'package:supermercado/view/products_screen.dart';

class BottomNavigator extends StatelessWidget {
  BottomNavigator({super.key});

  final List<Widget> _pages = [
    HomeScreen(),
    ProductsScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final index = context.watch<BottomNavigatorController>().index;

    return Scaffold(
      backgroundColor: Color(0xFF2E7D32),
      body: _pages[index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            currentIndex: index,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF2E7D32),
            unselectedItemColor: Colors.green,
            selectedFontSize: 12,
            unselectedFontSize: 11,
            onTap: (newIndex) => context.read<BottomNavigatorController>().index = newIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 26),
                activeIcon: Icon(Icons.home, size: 26),
                label: "Tela Inicial",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.storefront_outlined, size: 26),
                activeIcon: Icon(Icons.storefront_rounded, size: 26),
                label: "Produtos",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined, size: 26),
                activeIcon: Icon(Icons.shopping_cart, size: 26),
                label: "Carrinho",
              ),
            ],
          ),
        ),
      ),
    );
  }
}