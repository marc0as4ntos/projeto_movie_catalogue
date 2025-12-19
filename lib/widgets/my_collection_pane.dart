import 'package:flutter/material.dart';
import 'package:movie_catalogue/database_service.dart';
import 'package:movie_catalogue/data.dart';

class MyCollectionPane extends StatefulWidget {
  const MyCollectionPane({Key? key}) : super(key: key);

  @override
  State<MyCollectionPane> createState() => _MyCollectionPaneState();
}

class _MyCollectionPaneState extends State<MyCollectionPane> {
  final DatabaseService _dbService = DatabaseService();

  // Função para abrir o diálogo de edição (UPDATE)
  void _mostrarDialogoEdicao(BuildContext context, int id, String tituloAtual) {
    TextEditingController controller = TextEditingController(text: tituloAtual);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1d1e23),
        title: const Text("Editar Título", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "Nome do Filme",
            labelStyle: TextStyle(color: Colors.white70),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            onPressed: () async {
              await _dbService.atualizarFilme(id, controller.text);
              Navigator.pop(context);
              setState(() {}); // Recarrega a lista para mostrar o nome novo
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  void _abrirFormularioReview(BuildContext context, int movieId) async {
  // Busca a review existente no banco (Read)
  final reviewExistente = await _dbService.obterReview(movieId);
  
  TextEditingController commentController = TextEditingController(
    text: reviewExistente != null ? reviewExistente['comentario'] : ""
  );
  int notaSelecionada = reviewExistente != null ? reviewExistente['nota'] : 5;

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder( // Necessário para mudar as estrelas dentro do diálogo
      builder: (context, setDialogState) => AlertDialog(
        backgroundColor: const Color(0xff1d1e23),
        title: const Text("Sua Avaliação", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sistema Simples de Estrelas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < notaSelecionada ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => setDialogState(() => notaSelecionada = index + 1),
                );
              }),
            ),
            TextField(
              controller: commentController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "O que achou do filme?",
                hintStyle: TextStyle(color: Colors.white38),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700]),
            onPressed: () async {
              if (reviewExistente == null) {
                // CREATE
                await _dbService.adicionarReview(movieId, commentController.text, notaSelecionada);
              } else {
                // UPDATE
                await _dbService.atualizarReview(reviewExistente['id'], commentController.text, notaSelecionada);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Review salva com sucesso!")),
              );
            },
            child: const Text("Salvar Review", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbService.obterMinhaLista(),
        builder: (context, snapshot) {
          // 1. Carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }

          // 2. Erro
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erro ao carregar: ${snapshot.error}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          // 3. Lista Vazia
          final filmes = snapshot.data ?? [];
          if (filmes.isEmpty) {
            return const Center(
              child: Text(
                "Sua coleção está vazia. Favorite algum filme!",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          // 4. Grid de Filmes (READ)
          return GridView.builder(
            itemCount: filmes.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.7,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              final filme = filmes[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // Imagem do Poster
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            pImageBase + (filme['poster_url'] ?? ""),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.white10,
                              child: const Icon(Icons.broken_image, color: Colors.white24),
                            ),
                          ),
                        ),
                        // Botão de Editar (UPDATE)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: GestureDetector(
                            onTap: () => _mostrarDialogoEdicao(
                              context,
                              filme['id'],
                              filme['titulo'] ?? "",
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, color: Colors.blueAccent, size: 18),
                            ),
                          ),
                        ),
                        // Botão de Deletar (DELETE)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () async {
                              await _dbService.deletarFilme(filme['id']);
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => _abrirFormularioReview(context, filme['id']),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.star, color: Colors.amber, size: 20),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    filme['titulo'] ?? "Sem título",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}