import 'package:flutter/material.dart';
import '../database_service.dart';
import '../data.dart';

class MainPane extends StatelessWidget {
  final  List<Map<String,dynamic>> data;

  const MainPane({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        itemCount: data.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 50,
            mainAxisSpacing: 20,
            maxCrossAxisExtent: 300,
            childAspectRatio: 2.8/5
        ),
        itemBuilder: (BuildContext context, int index){
          return Column(
            children:[
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GridTile(
                    child: (data[index]["poster_path"] != null && data[index]["poster_path"] != "")
                    
                    ?Image(
                      
                      image:NetworkImage(pImageBase + data[index]["poster_path"]),
                      fit: BoxFit.fill,
                    )
                    : const Center(
                        child: Icon(Icons.movie, color: Colors.white60, size: 50),
                      ),

                    footer: Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.all(12),
                      child: Row( // Utilizei Row para ter dois itens
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // --- BOTÃO DE FAVORITAR (CREATE) ---
                          GestureDetector(
                            onTap: () async {
                              final movie = data[index]; // Pega o mapa do filme atual
                              try {
                                await DatabaseService().favoritarFilme(movie);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${movie["title"]} salvo em My Collection!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Erro ao salvar ou filme já está na lista'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                color: Colors.white24, // Fundo sutil para o ícone
                                child: const Icon(Icons.bookmark_add, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                          
                          // --- INDICADOR DE NOTA --
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                              color: Colors.yellowAccent,
                              child: Text(
                                "\u{2605} ${data[index]["vote_average"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text( data[index]["original_title"],
                      style: const TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    Text(getGenre(data[index]["genre_ids"]),
                      style: const TextStyle(fontSize: 15, color: Colors.white60),
                    ),
                  ],
                )
              ),
            ]
          );
        }
    );
  }

  String getGenre( List<int> gIndex){
    String genre = "";
    gIndex.asMap().forEach((index, value) {
      var g =  genres.firstWhere((element) => element["id"] == value, orElse: () => {});
      if (index < 2 && g.isNotEmpty){
        genre += g["name"]+" ";
      }
    });
    return genre;
  }
}