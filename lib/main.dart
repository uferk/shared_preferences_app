import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const SharedPreferencesApp());
}

class SharedPreferencesApp extends StatelessWidget {
  const SharedPreferencesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SharedPreferences',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const ConfiguracoesScreen(),
    );
  }
}

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  State<ConfiguracoesScreen> createState() =>
      _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  bool receberNotificacoes = false;
  String tamanhoFonte = 'Médio';

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    carregarConfiguracoes();
  }

  // Carrega as configurações salvas no dispositivo
  Future<void> carregarConfiguracoes() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      receberNotificacoes =
          prefs.getBool('receberNotificacoes') ?? false;

      tamanhoFonte =
          prefs.getString('tamanhoFonte') ?? 'Médio';
    });
  }

  // Exercício 01:
  // Limpa todas as configurações salvas
  Future<void> limparConfiguracoes() async {
    await prefs.clear();

    setState(() {
      receberNotificacoes = false;
      tamanhoFonte = 'Médio';
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configurações limpas com sucesso!'),
      ),
    );
  }

  // Exercício 02:
  // Salva o tamanho da fonte escolhido
  Future<void> salvarTamanhoFonte(String novoTamanho) async {
    await prefs.setString('tamanhoFonte', novoTamanho);

    setState(() {
      tamanhoFonte = novoTamanho;
    });
  }

  // Exercício 03:
  // Salva o estado das notificações
  Future<void> salvarNotificacoes(bool valor) async {
    await prefs.setBool('receberNotificacoes', valor);

    setState(() {
      receberNotificacoes = valor;
    });
  }

  double get tamanhoFonteSelecionado {
    switch (tamanhoFonte) {
      case 'Pequeno':
        return 14;
      case 'Grande':
        return 24;
      case 'Médio':
      default:
        return 18;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tamanho = tamanhoFonteSelecionado;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: TextStyle(
            fontSize: tamanho,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Preferências',
            style: TextStyle(
              fontSize: tamanho + 6,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          // Exercício 02:
          // Seleção do tamanho da fonte
          Text(
            'Tamanho da fonte',
            style: TextStyle(
              fontSize: tamanho,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            initialValue: tamanhoFonte,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Escolha o tamanho',
            ),
            items: const [
              DropdownMenuItem(
                value: 'Pequeno',
                child: Text('Pequeno'),
              ),
              DropdownMenuItem(
                value: 'Médio',
                child: Text('Médio'),
              ),
              DropdownMenuItem(
                value: 'Grande',
                child: Text('Grande'),
              ),
            ],
            onChanged: (valor) {
              if (valor != null) {
                salvarTamanhoFonte(valor);
              }
            },
          ),

          const SizedBox(height: 25),

          // Exercício 03:
          // Switch para receber notificações
          SwitchListTile(
            title: Text(
              'Receber Notificações',
              style: TextStyle(
                fontSize: tamanho,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              receberNotificacoes
                  ? 'Notificações ativadas'
                  : 'Notificações desativadas',
              style: TextStyle(
                fontSize: tamanho - 2,
              ),
            ),
            value: receberNotificacoes,
            onChanged: salvarNotificacoes,
          ),

          const SizedBox(height: 25),

          // Exercício 01:
          // Botão para limpar todas as configurações
          ElevatedButton.icon(
            onPressed: limparConfiguracoes,
            icon: const Icon(Icons.delete_sweep),
            label: Text(
              'Limpar Configurações',
              style: TextStyle(
                fontSize: tamanho,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'As configurações ficam salvas no dispositivo usando SharedPreferences.',
                style: TextStyle(
                  fontSize: tamanho,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}