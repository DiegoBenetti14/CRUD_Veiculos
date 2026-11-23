import 'dart:io';

import '../lib/conexao.dart';
import '../lib/veiculos.dart';

void main() async {
  final supabase = conexao();

  try {
    bool executando = true;

    while (executando) {
      print('\n===== CADASTRO DE VEÍCULOS =====');
      print('1 - Cadastrar veículo');
      print('2 - Listar veículos');
      print('3 - Atualizar veículo');
      print('4 - Excluir veículo');
      print('0 - Sair');
      stdout.write('O que deseja fazer? ');

      final opcao = stdin.readLineSync();

      try {
        switch (opcao) {
          case '1':
            await cadastrar(supabase);
            break;

          case '2':
            await listar(supabase);
            break;

          case '3':
            await atualizar(supabase);
            break;

          case '4':
            await excluir(supabase);
            break;

          case '0':
            print('Sistema encerrado.');
            executando = false;
            break;

          default:
            print('Opção inválida. Tente novamente.');
        }
      } catch (erro) {
        print('Ocorreu um erro: $erro');
      }
    }
  } finally {
    await supabase.dispose();
  }
}

// CADASTRAR
Future<void> cadastrar(supabase) async {
  final dados = solicitarDados();

  final veiculo = await cadastrarVeiculo(
    supabase,
    dados['marca'],
    dados['modelo'],
    dados['ano'],
    dados['valor'],
    dados['quilometragem'],
  );

  print('Veículo cadastrado!');
  exibirVeiculo(veiculo);
}

// LISTAR
Future<void> listar(supabase) async {
  final veiculos = await listarVeiculos(supabase);

  if (veiculos.isEmpty) {
    print('Nenhum veículo cadastrado.');
    return;
  }

  for (final veiculo in veiculos) {
    exibirVeiculo(veiculo);
  }
}

// ATUALIZAR
Future<void> atualizar(supabase) async {
  final id = solicitarId();
  final dados = solicitarDados();

  final veiculo = await atualizarVeiculo(
    supabase,
    id,
    dados['marca'],
    dados['modelo'],
    dados['ano'],
    dados['valor'],
    dados['quilometragem'],
  );

  if (veiculo == null) {
    print('Nenhum veículo encontrado com esse ID.');
    return;
  }

  print('Veículo atualizado!');
  exibirVeiculo(veiculo);
}

// EXCLUIR
Future<void> excluir(supabase) async {
  final id = solicitarId();

  stdout.write('Confirma a exclusão? S/N: ');
  final confirmacao = stdin.readLineSync()?.trim();

  if (confirmacao == 'N' || confirmacao == 'n') {
    print('Exclusão cancelada.');
    return;
  }

  if (confirmacao != 'S' && confirmacao != 's') {
    print('Confirmação inválida. Exclusão rejeitada.');
    return;
  }

  final veiculo = await excluirVeiculo(supabase, id);

  if (veiculo == null) {
    print('Nenhum veículo encontrado com esse ID.');
    return;
  }

  print('Veículo excluído!');
  exibirVeiculo(veiculo);
}

// SOLICITAR DADOS DO VEÍCULO
Map<String, dynamic> solicitarDados() {
  stdout.write('Marca: ');
  final marca = stdin.readLineSync()?.trim() ?? '';

  if (marca.isEmpty || marca.length > 50) {
    throw FormatException('Marca vazia ou com mais de 50 caracteres.');
  }

  stdout.write('Modelo: ');
  final modelo = stdin.readLineSync()?.trim() ?? '';

  if (modelo.isEmpty || modelo.length > 100) {
    throw FormatException('Modelo vazio ou com mais de 100 caracteres.');
  }

  stdout.write('Ano: ');
  final ano = int.tryParse(stdin.readLineSync() ?? '');

  if (ano == null || ano < 1900 || ano > DateTime.now().year) {
    throw FormatException('Ano inválido.');
  }

  stdout.write('Valor: ');
  final entradaValor = stdin.readLineSync()?.trim() ?? '';

  if (!RegExp(r'^\d+([,.]\d{1,2})?$').hasMatch(entradaValor)) {
    throw FormatException('Valor inválido. Use até duas casas decimais.');
  }

  final valor = double.tryParse(entradaValor.replaceAll(',', '.'));

  if (valor == null ||
      !valor.isFinite ||
      valor <= 0 ||
      valor >= 10000000000) {
    throw FormatException('O valor deve ser maior que zero e menor que 10 bilhões.');
  }

  stdout.write('Quilometragem: ');
  final quilometragem = int.tryParse(stdin.readLineSync() ?? '');

  if (quilometragem == null || quilometragem < 0) {
    throw FormatException('Quilometragem inválida.');
  }

  return {
    'marca': marca,
    'modelo': modelo,
    'ano': ano,
    'valor': valor,
    'quilometragem': quilometragem,
  };
}

// SOLICITAR ID
int solicitarId() {
  stdout.write('ID do veículo: ');
  final id = int.tryParse(stdin.readLineSync() ?? '');

  if (id == null || id <= 0) {
    throw FormatException('ID inválido. Digite um número inteiro positivo.');
  }

  return id;
}

// EXIBIR VEÍCULO
void exibirVeiculo(Map<String, dynamic> veiculo) {
  print('''
ID: ${veiculo['id']}
Marca: ${veiculo['marca']}
Modelo: ${veiculo['modelo']}
Ano: ${veiculo['ano']}
Valor: R\$ ${(veiculo['valor'] as num).toStringAsFixed(2)}
Quilometragem: ${veiculo['quilometragem']} km
-------------------------------
''');
}
