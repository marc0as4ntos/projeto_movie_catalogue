import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

  // --- CREATE: Salvar filme na coleção ---
  Future<void> favoritarFilme(Map movieMap) async {
    try {
    await _supabase.from('minha_lista').insert({
      'movie_id': movieMap['id'], // Certifique-se que na tabela é int8 ou bigint
      'titulo': movieMap['title'],
      'poster_url': movieMap['poster_path'],
      'vote_average': movieMap['vote_average'],
    });
      }catch (e) {
    //print("Erro detalhado: $e"); // Isso ajudará a ver o erro real no console
    throw Exception(e);
    }
  }

  // --- READ: Buscar filmes da coleção ---
  Future<List<Map<String, dynamic>>> obterMinhaLista() async {
    try {
      final response = await _supabase
          .from('minha_lista')
          .select()
          .order('criado_em', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      //print('Erro ao ler lista: $e');
      return [];
    }
  }

  Future<void> atualizarNotaFilme(int idNoBanco, double novaNota) async {
    try {
      await _supabase
          .from('minha_lista')
          .update({'vote_average': novaNota})
          .match({'id': idNoBanco});
    } catch (e) {
      //print('Erro ao atualizar: $e');
    }
  }

  // --- DELETE: Remover filme ---
  Future<void> removerDaColecao(int idNoBanco) async {
    await _supabase.from('minha_lista').delete().match({'id': idNoBanco});
  }
}