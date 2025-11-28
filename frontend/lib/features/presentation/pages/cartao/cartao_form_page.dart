import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/features/models/catao_model.dart';
import 'package:frontend/features/presentation/providers/cartao_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';

class CartaoFormPage extends StatefulWidget {
  final CartaoCreditoModel? cartao;

  const CartaoFormPage({super.key, this.cartao});

  @override
  State<CartaoFormPage> createState() => _CartaoFormPageState();
}

class _CartaoFormPageState extends State<CartaoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _iconeController = TextEditingController();
  final _limiteTotalController = TextEditingController();
  final _diaFechamentoController = TextEditingController();
  final _diaVencimentoController = TextEditingController();

  bool _isLoading = false;

  bool get isEdicao => widget.cartao != null;

  @override
  void initState() {
    super.initState();
    if (isEdicao) {
      _nomeController.text = widget.cartao!.nome;
      _iconeController.text = widget.cartao!.icone ?? '';
      _limiteTotalController.text = widget.cartao!.limiteTotal
          .toStringAsFixed(2)
          .replaceAll('.', ',');
      _diaFechamentoController.text = widget.cartao!.diaFechamento.toString();
      _diaVencimentoController.text = widget.cartao!.diaVencimento.toString();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _iconeController.dispose();
    _limiteTotalController.dispose();
    _diaFechamentoController.dispose();
    _diaVencimentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdicao ? 'Editar Cartão' : 'Novo Cartão',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: AppColors.purpleLight,
        foregroundColor: AppColors.purpleDark,
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nome
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do Cartão *',
                  labelStyle: TextStyle(color: AppColors.purpleDark),
                  hintText: 'Ex: Nubank Gold',
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

              // Ícone (opcional)
              TextFormField(
                controller: _iconeController,
                decoration: InputDecoration(
                  labelText: 'Ícone',
                  labelStyle: TextStyle(color: AppColors.purpleDark),
                  hintText: 'Ex: credit_card',
                  border: OutlineInputBorder(),
                ),
                maxLength: 50,
              ),
              const SizedBox(height: 20),

              // Limite Total
              TextFormField(
                controller: _limiteTotalController,
                decoration: InputDecoration(
                  labelText: 'Limite Total *',
                  labelStyle: TextStyle(color: AppColors.purpleDark),
                  hintText: '0,00',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d,]')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Limite total é obrigatório';
                  }
                  final valorTexto = value.replaceAll(',', '.');
                  final valor = double.tryParse(valorTexto);
                  if (valor == null || valor <= 0) {
                    return 'Limite total deve ser positivo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Dia de Fechamento
              TextFormField(
                controller: _diaFechamentoController,
                decoration: InputDecoration(
                  labelText: 'Dia de Fechamento *',
                  labelStyle: TextStyle(color: AppColors.purpleDark),
                  hintText: 'De 1 a 31',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Dia de fechamento é obrigatório';
                  }
                  final dia = int.tryParse(value);
                  if (dia == null || dia < 1 || dia > 31) {
                    return 'Dia deve ser entre 1 e 31';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Dia de Vencimento
              TextFormField(
                controller: _diaVencimentoController,
                decoration: InputDecoration(
                  labelText: 'Dia de Vencimento *',
                  labelStyle: TextStyle(color: AppColors.purpleDark),
                  hintText: 'De 1 a 31',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Dia de vencimento é obrigatório';
                  }
                  final dia = int.tryParse(value);
                  if (dia == null || dia < 1 || dia > 31) {
                    return 'Dia deve ser entre 1 e 31';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Informação sobre categoria
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
                        'A categoria do cartão pode ser configurada posteriormente.',
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
      final cartaoProvider = context.read<CartaoCreditoProvider>();
      final user = authProvider.user;

      if (user == null) {
        _mostrarErro('Usuário não encontrado');
        return;
      }

      final nome = _nomeController.text.trim();
      final icone = _iconeController.text.trim().isEmpty
          ? null
          : _iconeController.text.trim();
      final limiteTotalTexto = _limiteTotalController.text.replaceAll(',', '.');
      final limiteTotal = double.parse(limiteTotalTexto);
      final diaFechamento = int.parse(_diaFechamentoController.text);
      final diaVencimento = int.parse(_diaVencimentoController.text);

      bool sucesso;

      if (isEdicao) {
        // Atualizar cartão existente
        sucesso = await cartaoProvider.atualizarCartao(
          widget.cartao!.id,
          nome: nome,
          icone: icone,
          limiteTotal: limiteTotal,
          diaFechamento: diaFechamento,
          diaVencimento: diaVencimento,
        );
      } else {
        // Criar novo cartão
        sucesso = await cartaoProvider.adicionarCartao(
          nome: nome,
          icone: icone,
          limiteTotal: limiteTotal,
          diaFechamento: diaFechamento,
          diaVencimento: diaVencimento,
          usuarioId: user.id,
        );
      }

      if (!mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdicao
                  ? 'Cartão atualizado com sucesso!'
                  : 'Cartão criado com sucesso!',
            ),
            backgroundColor: AppColors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        _mostrarErro(cartaoProvider.errorMessage ?? 'Erro ao salvar cartão');
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
