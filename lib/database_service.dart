// ignore_for_file: avoid_print

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

  Future<void> deletarFilme(int id) async {
    try {
      await _supabase
          .from('minha_lista') // Nome da sua tabela
          .delete()
          .match({'id': id}); // Filtra pelo ID para deletar apenas o filme certo
      print("Filme deletado com sucesso!");
    }
    catch (e) {
      print("Erro ao deletar filme: $e");
    }

  } 

  Future<void> atualizarFilme(int id, String novoTitulo) async {
    try {
      await _supabase
          .from('minha_lista')
          .update({'titulo': novoTitulo}) // Mapeia a coluna para o novo valor
          .match({'id': id}); // Garante que altera apenas o filme selecionado
      print("Filme atualizado com sucesso!");
    } 
    catch (e) {
      print("Erro ao atualizar filme: $e");
    }
  } 

  // CREATE: Salvar uma nova review
Future<void> adicionarReview(int movieId, String comentario, int nota) async {
  await _supabase.from('reviews').insert({
    'movie_id': movieId,
    'comentario': comentario,
    'nota': nota,
  });
}

// READ: Buscar review de um filme específico
Future<Map<String, dynamic>?> obterReview(int movieId) async {
  final response = await _supabase
      .from('reviews')
      .select()
      .eq('movie_id', movieId)
      .maybeSingle(); // Retorna um único registro ou nulo
  return response;
}

// UPDATE: Editar review existente
Future<void> atualizarReview(int reviewId, String novoComentario, int novaNota) async {
  await _supabase.from('reviews').update({
    'comentario': novoComentario,
    'nota': novaNota,
  }).match({'id': reviewId});
}

// DELETE: Apagar review
Future<void> deletarReview(int reviewId) async {
  await _supabase.from('reviews').delete().match({'id': reviewId});
}

}