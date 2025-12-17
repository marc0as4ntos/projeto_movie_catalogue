import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 
import 'package:movie_catalogue/layout.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // iNICIANDO o Supabase
  await Supabase.initialize(
    url: 'https://tbiwqohkylwjjhugunth.supabase.co', // Substitua pela sua URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRiaXdxb2hreWx3ampodWd1bnRoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU5NDQzODgsImV4cCI6MjA4MTUyMDM4OH0.QRjG0Hy-q4Pv1pDJY61ld-BJU9Al2qdMhKxRNxfaf4c',      // Substitua pela sua Anon Key
  );
  runApp(const TheMovieCatalogue());
}

class TheMovieCatalogue extends StatelessWidget {
  const TheMovieCatalogue({Key? key}) : super(key: key);
  // Widget raíz da aplicação
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catalogo De Filmes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: AppLayout(),
      ),
    );
  }
}
