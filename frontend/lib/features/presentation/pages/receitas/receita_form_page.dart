import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/models/transacao_model.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';
import 'package:frontend/features/presentation/providers/transacao_provider.dart';
import 'package:frontend/features/presentation/providers/categoria_provider.dart';
import 'package:frontend/features/presentation/providers/conta_provider.dart';
import 'package:frontend/features/shared/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReceitaFormPage extends StatefulWidget {
  final TransacaoModel? receita;

  const ReceitaFormPage({super.key, this.receita});

  @override
  State<ReceitaFormPage> createState() => _ReceitaFormPageState();
}

class _ReceitaFormPageState extends State<ReceitaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final _periodoController = TextEditingController();

  DateTime _dataRecebimento = DateTime.now();
  FormaPagamento _formaPagamento = FormaPagamento.pix;
  bool _fixa = false;
  bool _repete = false;
  bool? _recebida = false;
  String? _contaId;
  String? _categoriaId;
  bool _isLoading = false;

  bool get isEdicao => widget.receita != null;

  @override
  void initState() {
    super.initState();
    // _carregarDados();
    if (isEdicao) {
      _preencherCampos();
    }

    Future(() {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.user;

      if (user != null) {
        context.read<CategoriaProvider>().carregarCategoriasAtivas(user.id);
        context.read<ContaProvider>().carregarContas(user.id);
      }
    });
  }

  // Future<void> _carregarDados() async {
  //   final authProvider = context.read<AuthProvider>();
  //   final user = authProvider.user;

  //   if (user != null) {

  //   }
  // }

  void _preencherCampos() {
    final receita = widget.receita!;
    _descricaoController.text = receita.descricao;
    _valorController.text = receita.valor.toStringAsFixed(2);
    _dataRecebimento = receita.data;
    _formaPagamento = receita.formaPagamento ?? FormaPagamento.pix;
    _fixa = receita.fixa ?? false;
    _repete = receita.repete ?? false;
    _recebida = receita.recebida;
    _periodoController.text = receita.periodo?.toString() ?? '';
    _contaId = receita.contaId;
    _categoriaId = receita.categoriaId;
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _periodoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataRecebimento,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      setState(() => _dataRecebimento = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdicao ? 'Editar Receita' : 'Nova Receita',
          style: const TextStyle(fontSize: 16),
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
              Column(
                children: [
                  TextFormField(
                    controller: _valorController,
                    decoration: InputDecoration(
                      labelText: 'Valor *',
                      hintText: '0,00',
                      prefixText: 'R\$ ',
                      labelStyle: TextStyle(color: AppColors.purpleDark),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\,?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Valor é obrigatório';
                      }
                      final numero = double.tryParse(
                        value.replaceAll(',', '.'),
                      );
                      if (numero == null || numero <= 0) {
                        return 'Valor deve ser positivo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              // Data de Recebimento
              InkWell(
                onTap: _selecionarData,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Data de Recebimento *',
                    labelStyle: TextStyle(color: AppColors.purpleDark),
                    border: const OutlineInputBorder(),
                  ),
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(_dataRecebimento),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Forma de Pagamento
              DropdownButtonFormField<FormaPagamento>(
                initialValue: _formaPagamento,
                decoration: InputDecoration(
                  labelText: 'Forma de Pagamento *',
                  labelStyle: TextStyle(color: AppColors.purpleDark),
                  border: const OutlineInputBorder(),
                ),
                items: FormaPagamento.values.map((forma) {
                  return DropdownMenuItem(
                    value: forma,
                    child: Text(_nomeFormaPagamento(forma)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _formaPagamento = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Conta
              Consumer<ContaProvider>(
                builder: (context, contaProvider, child) {
                  if (contaProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final contas = contaProvider.contasAtivas;

                  // Verifica se o _contaId existe na lista de contas
                  final contaExiste = contas.any(
                    (conta) => conta.id == _contaId,
                  );

                  // Se não existir, limpa o _contaId
                  if (_contaId != null && !contaExiste) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() => _contaId = null);
                    });
                  }

                  return DropdownButtonFormField<String>(
                    value: contaExiste
                        ? _contaId
                        : null, // Usa value ao invés de initialValue
                    decoration: InputDecoration(
                      labelText: 'Conta *',
                      labelStyle: TextStyle(color: AppColors.purpleDark),
                      border: const OutlineInputBorder(),
                    ),
                    hint: const Text('Selecione uma conta'),
                    items: contas.map((conta) {
                      return DropdownMenuItem(
                        value: conta.id,
                        child: Text(conta.nome),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _contaId = value),
                    validator: (value) {
                      if (value == null) return 'Selecione uma conta';
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // Categoria (Opcional)
              Consumer<CategoriaProvider>(
                builder: (context, categoriaProvider, child) {
                  if (categoriaProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final categorias = categoriaProvider.categoriasAtivas;

                  return DropdownButtonFormField<String>(
                    initialValue: _categoriaId,
                    decoration: InputDecoration(
                      labelText: 'Categoria (Opcional)',
                      labelStyle: TextStyle(color: AppColors.purpleDark),
                      border: const OutlineInputBorder(),
                    ),
                    hint: const Text('Selecione uma categoria'),
                    items: categorias.map((categoria) {
                      return DropdownMenuItem(
                        value: categoria.id,
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: categoria.colorValue,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                IconPicker.getIconByName(
                                  categoria.icone.toString(),
                                ),
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(categoria.nome),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _categoriaId = value),
                  );
                },
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição *',
                  hintText: 'Ex: Salário, Freelance...',
                  labelStyle: TextStyle(color: AppColors.purpleDark),
                  border: const OutlineInputBorder(),
                ),
                maxLength: 200,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Descrição é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Opções',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.purpleDark,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Receita Fixa
                      SwitchListTile(
                        value: _fixa,
                        onChanged: (value) => setState(() => _fixa = value),
                        title: const Text('Receita Fixa'),
                        subtitle: const Text('Receita recorrente mensalmente'),
                        activeThumbColor: AppColors.purpleDark,
                      ),

                      // Repetir
                      SwitchListTile(
                        value: _repete,
                        onChanged: (value) => setState(() => _repete = value),
                        title: const Text('Repetir'),
                        subtitle: const Text('Repetir por um período'),
                        activeThumbColor: AppColors.purpleDark,
                      ),

                      // Período (se repetir estiver ativo)
                      if (_repete) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _periodoController,
                          decoration: InputDecoration(
                            labelText: 'Período (meses)',
                            hintText: 'Ex: 12',
                            labelStyle: TextStyle(color: AppColors.purpleDark),
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (_repete) {
                              if (value == null || value.isEmpty) {
                                return 'Informe o período';
                              }
                              final periodo = int.tryParse(value);
                              if (periodo == null ||
                                  periodo < 1 ||
                                  periodo > 120) {
                                return 'Período deve ser entre 1 e 120 meses';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                      SwitchListTile(
                        value: _recebida ?? false,
                        onChanged: (value) => setState(() => _recebida = value),
                        title: const Text('Recebido?'),
                        subtitle: const Text('Marcar a receita como recebida'),
                        activeThumbColor: AppColors.purpleDark,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Botões
              Row(
                children: [
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_contaId == null) {
      _mostrarErro('Selecione uma conta');
      return;
    }

    if (_repete &&
        (_periodoController.text.isEmpty ||
            int.parse(_periodoController.text) < 1)) {
      _mostrarErro('Informe o período de repetição');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final transacaoProvider = context.read<TransacaoProvider>();
      final user = authProvider.user;

      if (user == null) {
        _mostrarErro('Usuário não encontrado');
        return;
      }

      bool sucesso;

      if (isEdicao) {
        sucesso = await transacaoProvider.atualizarReceita(
          widget.receita!.id,
          descricao: _descricaoController.text.trim(),
          valor: double.parse(_valorController.text.replaceAll(',', '.')),
          dataRecebimento: _dataRecebimento,
          formaPagamento: _formaPagamento.name.toUpperCase(),
          fixa: _fixa,
          recebida: _recebida,
          repete: _repete,
          periodo: _repete ? int.parse(_periodoController.text) : null,
          contaId: _contaId,
          categoriaId: _categoriaId,
        );
      } else {
        sucesso = await transacaoProvider.criarReceita(
          usuarioId: user.id,
          contaId: _contaId!,
          descricao: _descricaoController.text.trim(),
          valor: double.parse(_valorController.text.replaceAll(',', '.')),
          dataRecebimento: _dataRecebimento,
          formaPagamento: _formaPagamento.name.toUpperCase(),
          fixa: _fixa,
          recebida: _recebida,
          repete: _repete,
          periodo: _repete ? int.parse(_periodoController.text) : null,
          categoriaId: _categoriaId,
        );
      }

      if (!mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdicao
                  ? 'Receita atualizada com sucesso!'
                  : 'Receita criada com sucesso!',
            ),
            backgroundColor: AppColors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        _mostrarErro(
          transacaoProvider.errorMessage ?? 'Erro ao salvar receita',
        );
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

  String _nomeFormaPagamento(FormaPagamento forma) {
    switch (forma) {
      case FormaPagamento.dinheiro:
        return 'Dinheiro';
      case FormaPagamento.pix:
        return 'PIX';
      case FormaPagamento.transferencia:
        return 'Transferência';
      case FormaPagamento.debito:
        return 'Débito';
      case FormaPagamento.credito:
        return 'Crédito';
    }
  }
}
