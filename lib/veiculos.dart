import 'package:supabase/supabase.dart';

// CREATE
Future<Map<String, dynamic>> cadastrarVeiculo(
  SupabaseClient supabase,
  String marca,
  String modelo,
  int ano,
  double valor,
  int quilometragem,
) async {
  final veiculo = await supabase
      .from('veiculos')
      .insert({
        'marca': marca,
        'modelo': modelo,
        'ano': ano,
        'valor': valor,
        'quilometragem': quilometragem,
      })
      .select()
      .single();

  return veiculo;
}

// READ
Future<List<Map<String, dynamic>>> listarVeiculos(
  SupabaseClient supabase,
) async {
  final veiculos = await supabase
      .from('veiculos')
      .select()
      .order('id');

  return veiculos;
}

// UPDATE
Future<Map<String, dynamic>?> atualizarVeiculo(
  SupabaseClient supabase,
  int id,
  String marca,
  String modelo,
  int ano,
  double valor,
  int quilometragem,
) async {
  final resultado = await supabase
      .from('veiculos')
      .update({
        'marca': marca,
        'modelo': modelo,
        'ano': ano,
        'valor': valor,
        'quilometragem': quilometragem,
      })
      .eq('id', id)
      .select();

  if (resultado.isEmpty) {
    return null;
  }

  return resultado.first;
}

// DELETE
Future<Map<String, dynamic>?> excluirVeiculo(
  SupabaseClient supabase,
  int id,
) async {
  final resultado = await supabase
      .from('veiculos')
      .delete()
      .eq('id', id)
      .select();

  if (resultado.isEmpty) {
    return null;
  }

  return resultado.first;
}
