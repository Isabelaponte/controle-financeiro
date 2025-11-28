import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/features/models/conta_model.dart';
import 'package:frontend/features/presentation/providers/conta_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';

class ContaFormPage extends StatefulWidget {
  final ContaModel? conta;

  const ContaFormPage({super.key, this.conta});

  @override
  State<ContaFormPage> createState() => _ContaFormPageState();
}

class _ContaFormPageState extends State<ContaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _saldoController = TextEditingController();

  String _tipoSelecionado = 'CORRENTE';
  bool _isLoading = false;

  final List<Map<String, String>> _tiposConta = [
    {'valor': 'CORRENTE', 'label': 'Conta Corrente'},
    {'valor': 'POUPANCA', 'label': 'Conta Poupança'},
    {'valor': 'INVESTIMENTO', 'label': 'Investimento'},
    {'valor': 'CARTEIRA', 'label': 'Carteira'},
  ];

  bool get isEdicao => widget.conta != null;

  @override
  void initState() {
    super.initState();
    if (isEdicao) {
      _nomeController.text = widget.conta!.nome;
      _saldoController.text = widget.conta!.saldo
          .toStringAsFixed(2)
          .replaceAll('.', ',');
      _tipoSelecionado = widget.conta!.tipo.toUpperCase();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _saldoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdicao ? 'Editar Conta' : 'Nova Conta',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: AppColors.purpleLight,
        foregroundColor: AppColors.purpleDark,
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nome
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome da Conta *',
                  labelStyle: TextStyle(color: AppColors.purpleDark),
                  hintText: 'Ex: Conta Itaú',
                  border: OutlineInputBorder(),
                ),
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Tipo de Conta
              DropdownButtonFormField<String>(
                initialValue: _tipoSelecionado,
                decoration: InputDecoration(
                  labelText: 'Tipo de Conta *',
                  labelStyle: TextStyle(color: AppColors.purpleDark),
                  border: OutlineInputBorder(),
                ),
                items: _tiposConta.map((tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo['valor'],
                    child: Text(tipo['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _tipoSelecionado = value);
                  }
                },
              ),
              const SizedBox(height: 20),

              if (!isEdicao) ...[
                TextFormField(
                  controller: _saldoController,
                  decoration: InputDecoration(
                    labelText: 'Saldo Inicial',
                    labelStyle: TextStyle(color: AppColors.purpleDark),
                    hintText: '0,00',
                    prefixText: 'R\$ ',
                    border: OutlineInputBorder(),
                    helperText: 'Deixe vazio para iniciar com R\$ 0,00',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d,]')),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              if (isEdicao) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.purpleDark),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'O saldo não pode ser editado diretamente. Use transações para alterar o saldo.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.darkPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              const SizedBox(height: 20),

              // Botões
              Row(
                children: [
                  // Botão Cancelar
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.greenDark,
                        side: BorderSide(color: AppColors.greenDark),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Botão Salvar
                  Expanded(
                    child: FilledButton(
                      onPressed: _isLoading ? null : _salvar,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.greenMedium,
                        foregroundColor: AppColors.greenDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isEdicao ? 'Salvar' : 'Criar',
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final contaProvider = context.read<ContaProvider>();
      final user = authProvider.user;

      if (user == null) {
        _mostrarErro('Usuário não encontrado');
        return;
      }

      final nome = _nomeController.text.trim();
      final saldoTexto = _saldoController.text.replaceAll(',', '.');
      final saldo = double.tryParse(saldoTexto) ?? 0.0;

      bool sucesso;

      if (isEdicao) {
        sucesso = await contaProvider.atualizarConta(
          widget.conta!.id,
          nome: nome,
          tipo: _tipoSelecionado,
        );
      } else {
        sucesso = await contaProvider.adicionarConta(
          nome: nome,
          tipo: _tipoSelecionado,
          saldo: saldo,
          usuarioId: user.id,
        );
      }

      if (!mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdicao
                  ? 'Conta atualizada com sucesso!'
                  : 'Conta criada com sucesso!',
            ),
            backgroundColor: AppColors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        _mostrarErro(contaProvider.errorMessage ?? 'Erro ao salvar conta');
      }
    } catch (e) {
      _mostrarErro('Erro inesperado: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: AppColors.red),
    );
  }
}
