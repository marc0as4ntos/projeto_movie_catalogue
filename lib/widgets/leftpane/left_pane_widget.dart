import 'package:flutter/material.dart';
import 'package:movie_catalogue/data.dart';
import 'package:movie_catalogue/widgets/leftpane/main_nav_item.dart';
import 'package:movie_catalogue/widgets/leftpane/sub_nav.dart';

class LeftPane extends StatelessWidget{
  final int selected;
  final Function mainNavAction;

  const LeftPane({Key? key, required this.selected, required this.mainNavAction}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: 170,
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white, width: 4)),
              image: DecorationImage(image: AssetImage("assets/img/logo.jpg"),fit: BoxFit.cover)
          ),
        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50,),
            MainNavItem("Novos Lançamentos", Icons.rocket_launch_outlined, selected == 1 ,() => mainNavAction(1, newReleases)),
            MainNavItem("Mais Populares", Icons.emoji_events_outlined, selected == 2, () => mainNavAction(2, mostPopular)),
            MainNavItem("Recomendado", Icons.verified_outlined, selected == 3, () => mainNavAction(3, recommended)),
            MainNavItem("Top Charts", Icons.diamond_outlined, selected == 4, () => mainNavAction(4, topChart)),
          ],
        )),
        Expanded(
          child: Column(
            children: [
              SubNavItem(
                "Minha Coleção", 
                20, 
                Icons.stop_circle_rounded, 
                Icons.arrow_drop_down, 
                selected == 5, // Agora usamos o ID 5 para não conflitar com o Top Chart
                () => mainNavAction(5, []) // Dispara a ação para mudar para a página 5
              ),
              SubNavItem("Marcador",null, null, null, false, (){}),
              SubNavItem("Histórico", null,null, null, false, (){}),
              SubNavItem("Inscrições", null,null, null, false, (){}),
            ]
          )
        ),
      ],
    );
  }
}