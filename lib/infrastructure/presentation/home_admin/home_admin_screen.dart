import 'package:flutter/material.dart';

class HomeAdminScreen extends StatelessWidget {
  const HomeAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: const Text("Tela Inicial", 
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50, right: 70, left: 70),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                ),
                onPressed: () {

                }, 
                child: const Text("Lista de Produtos", style: TextStyle(color: Colors.black)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, right: 70, left: 70),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                ),
                onPressed: () {

                }, 
                child: const Text("Adicionar Produto", style: TextStyle(color: Colors.black))
              ),
            ),
          ],
        ),
      ),
    );
  }
}