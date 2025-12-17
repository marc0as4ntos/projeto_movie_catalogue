import 'package:flutter/material.dart';

class ViewControls extends StatelessWidget{
  const ViewControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.view_list, size: 35, color: Colors.white,),
        SizedBox(width: 20,),
        Icon(Icons.view_module, size: 35, color: Colors.white,),
        SizedBox(width: 100,)
      ],
    );
  }
}