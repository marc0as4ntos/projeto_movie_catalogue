import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:movie_catalogue/data.dart';
import 'package:movie_catalogue/widgets/main_pane.dart';
import 'package:movie_catalogue/widgets/my_collection_pane.dart';
import 'package:movie_catalogue/widgets/subheader/sub_header.dart';
import 'package:movie_catalogue/widgets/leftpane/left_pane_widget.dart';
import 'package:movie_catalogue/widgets/mainheader/main_header.dart';



class AppLayout extends StatefulWidget {
  const AppLayout({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppLayoutState();
  }
}

class _AppLayoutState extends State<AppLayout> {
  List<Map<String, dynamic>> data = topChart;
  int _currentPage = 4;

  Widget _getBody() {
  switch (_currentPage) {
    case 5:
      // O cast 'as Widget' força o compilador a aceitar o tipo 
      // enquanto o Analysis Server sincroniza os arquivos.
      return const MyCollectionPane() as Widget; 
   
    default:
      return MainPane(data: data) as Widget;
  }
}

void menuAction(int page, List dataList) {
  setState(() {
    _currentPage = page;
    
    if (page != 5) {
      // O '.cast<...>()' transforma a lista genérica no tipo que sua variável 'data' exige
      data = dataList.cast<Map<String, dynamic>>(); 
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left pane
            Container(
              width: 300,
              color: const Color(0xFF253089),
              child: LeftPane(
                mainNavAction: menuAction,
                selected: _currentPage,
              ),
            ),
            // Main Content Area
            Expanded(
              child: Column(
                children: [
                  // Main Header
                  Container(
                    height: 120,
                    color: Colors.indigo,
                    child: const MainHeader(),
                  ),
                  // Sub header
                  Container(
                    height: 120,
                    color: Colors.deepPurple,
                    child: const SubHeader(),
                  ),
                  // 2. Lógica de troca de Painel (CRUD READ)
                 // No seu layout.dart, dentro do Row -> Expanded -> Column
                  Expanded(
                    child: Center(
                      child: _getBody(), // Chamada da função sem operador ternário
                    ),
                  )
                                  ],
              ),
            )
          ],
        ),
      ),
    );
  }


}