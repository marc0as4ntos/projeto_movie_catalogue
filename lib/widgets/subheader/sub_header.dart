import 'package:flutter/material.dart';
import 'package:movie_catalogue/widgets/subheader/sort_control.dart';
import 'package:movie_catalogue/widgets/subheader/view_control.dart';

class SubHeader extends StatelessWidget{
  const SubHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const Row(
      children: [
        SortControl(),
        ViewControls()
      ]
    );
  }

}