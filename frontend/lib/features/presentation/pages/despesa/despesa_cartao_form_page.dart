import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/models/transacao_model.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';
import 'package:frontend/features/presentation/providers/cartao_provider.dart';
import 'package:frontend/features/presentation/providers/transacao_provider.dart';
import 'package:frontend/features/presentation/providers/categoria_provider.dart';
import 'package:frontend/features/presentation/providers/fatura_provider.dart';
import 'package:frontend/features/shared/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DespesaCartaoFormPage extends StatefulWidget {
  final TransacaoModel? despesa;

  const DespesaCartaoFormPage({super.key, this.despesa});

  @override
  State<DespesaCartaoFormPage> createState() => _DespesaCartaoFormPageState();
}

class _DespesaCartaoFormPageState extends State<DespesaCartaoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final _parcelasController = TextEditingController();

  DateTime _data = DateTime.now();
  bool _fixa = false;
  bool _parcelado = false;
  int _numeroParcelas = 1;
  String? _cartaoId;
  String? _faturaId;
  String? _categoriaId;
  bool _isLoading = false;

  bool get isEdicao => widget.despesa != null;

  @override
  void initState() {
    super.initState();
    _carregarDados();
    if (isEdicao) {
      _preencherCampos();
    }
  }

  Future<void> _carregarDados() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    if (user != null) {
      context.read<CategoriaProvider>().carregarCategoriasAtivas(user.id);
      context.read<CartaoCreditoProvider>().carregarCartoes(user.id);
    }
  }

  void _preencherCampos() {
    final despesa = widget.despesa!;
    _descricaoController.text = despesa.descricao;
    _valorController.text = despesa.valor.toStringAsFixed(2);
    _data = despesa.data;
    _fixa = despesa.fixa ?? false;
    _cartaoId = despesa.cartaoId;
    _categoriaId = despesa.categoriaId;
    _faturaId = despesa.faturaId;

    if (_cartaoId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<FaturaProvider>().carregarFaturas(_cartaoId!);
      });
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _parcelasController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      setState(() => _data = data);
    }
  }

  double get _valorParcela {
    if (!_parcelado || _numeroParcelas <= 0) return 0;
    final valor =
        double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0;
    return valor / _numeroParcelas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdicao ? 'Editar Despesa de Cartão' : 'Nova Despesa de Cartão',
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
              // Valor
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: 'Valor Total *',
                  hintText: '0,00',
                  prefixText: 'R\$ ',
                  labelStyle: TextStyle(color: AppColors.purpleDark),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\,?\d{0,2}')),
                ],
                onChanged: (_) =>
                    setState(() {}),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Valor é obrigatório';
                  }
                  final numero = double.tryParse(value.replaceAll(',', '.'));
                  if (numero == null || numero <= 0) {
                    return 'Valor deve ser positivo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Descrição
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição *',
                  hintText: 'Ex: Compra no supermercado...',
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

              // Data
              InkWell(
                onTap: _selecionarData,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Data da Compra *',
                    labelStyle: TextStyle(color: AppColors.purpleDark),
                    border: const OutlineInputBorder(),
                  ),
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(_data),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Consumer<CartaoCreditoProvider>(
                builder: (context, cartaoProvider, child) {
                  if (cartaoProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final cartoes = cartaoProvider.cartoesAtivos;

                  return DropdownButtonFormField<String>(
                    value: _cartaoId,
                    decoration: InputDecoration(
                      labelText: 'Cartão de Crédito *',
                      labelStyle: TextStyle(color: AppColors.purpleDark),
                      border: const OutlineInputBorder(),
                    ),
                    hint: const Text('Selecione um cartão'),
                    items: cartoes.map((cartao) {
                      return DropdownMenuItem(
                        value: cartao.id,
                        child: Text(cartao.nome),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _cartaoId = value;
                        _faturaId = null;
                      });
                      if (value != null) {
                        context.read<FaturaProvider>().carregarFaturas(value);
                      }
                    },
                    validator: (value) {
                      if (value == null) return 'Selecione um cartão';
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              Consumer<FaturaProvider>(
                builder: (context, faturaProvider, child) {
                  if (faturaProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final faturas = faturaProvider.faturas;

                  return DropdownButtonFormField<String>(
                    value: _faturaId,
                    decoration: InputDecoration(
                      labelText: 'Fatura *',
                      labelStyle: TextStyle(color: AppColors.purpleDark),
                      border: const OutlineInputBorder(),
                    ),
                    hint: const Text('Selecione uma fatura'),
                    items: faturas.map((fatura) {
                      final dataFormatada =
                          '${fatura.dataVencimento.day.toString().padLeft(2, '0')}/'
                          '${fatura.dataVencimento.month.toString().padLeft(2, '0')}/'
                          '${fatura.dataVencimento.year}';

                      final texto = 'Venc: $dataFormatada';

                      return DropdownMenuItem(
                        value: fatura.id,
                        child: Text(
                          texto,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _faturaId = value),
                    validator: (value) {
                      if (value == null) return 'Selecione uma fatura';
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // Categoria
              Consumer<CategoriaProvider>(
                builder: (context, categoriaProvider, child) {
                  if (categoriaProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final categorias = categoriaProvider.categoriasAtivas;

                  return DropdownButtonFormField<String>(
                    value: _categoriaId,
                    decoration: InputDecoration(
                      labelText: 'Categoria *',
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
                    validator: (value) {
                      if (value == null) return 'Selecione uma categoria';
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // Opções
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

                      // Despesa Fixa
                      SwitchListTile(
                        value: _fixa,
                        onChanged: (value) => setState(() => _fixa = value),
                        title: const Text('Despesa Fixa'),
                        subtitle: const Text('Despesa recorrente mensalmente'),
                        activeThumbColor: AppColors.purpleDark,
                      ),

                      // Parcelado
                      SwitchListTile(
                        value: _parcelado,
                        onChanged: (value) {
                          setState(() {
                            _parcelado = value;
                            if (!value) {
                              _numeroParcelas = 1;
                              _parcelasController.clear();
                            }
                          });
                        },
                        title: const Text('Parcelado'),
                        subtitle: const Text('Dividir em parcelas'),
                        activeThumbColor: AppColors.purpleDark,
                      ),

                      // Número de Parcelas
                      if (_parcelado) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _parcelasController,
                          decoration: InputDecoration(
                            labelText: 'Número de Parcelas *',
                            hintText: 'Ex: 12',
                            labelStyle: TextStyle(color: AppColors.purpleDark),
                            border: const OutlineInputBorder(),
                            helperText: _numeroParcelas > 0 && _valorParcela > 0
                                ? '${_numeroParcelas}x de R\$ ${_valorParcela.toStringAsFixed(2)}'
                                : null,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            setState(() {
                              _numeroParcelas = int.tryParse(value) ?? 1;
                            });
                          },
                          validator: (value) {
                            if (_parcelado) {
                              if (value == null || value.isEmpty) {
                                return 'Informe o número de parcelas';
                              }
                              final parcelas = int.tryParse(value);
                              if (parcelas == null ||
                                  parcelas < 2 ||
                                  parcelas > 48) {
                                return 'Parcelas deve ser entre 2 e 48';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
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

    if (_cartaoId == null) {
      _mostrarErro('Selecione um cartão');
      return;
    }

    if (_categoriaId == null) {
      _mostrarErro('Selecione uma categoria');
      return;
    }

    if (_parcelado && _numeroParcelas < 2) {
      _mostrarErro('Número de parcelas deve ser maior que 1');
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
        sucesso = await transacaoProvider.atualizarDespesaCartao(
          widget.despesa!.id,
          categoriaId: _categoriaId!,
          cartaoId: _cartaoId!,
          descricao: _descricaoController.text.trim(),
          valor: double.parse(_valorController.text.replaceAll(',', '.')),
          dataDespesa: _data,
          faturaId: _faturaId,
          fixa: _fixa,
          quantidadeParcelas: _parcelado ? _numeroParcelas : 1,
          juros: 0.0,
        );
      } else {
        sucesso = await transacaoProvider.criarDespesaCartao(
          usuarioId: user.id,
          categoriaId: _categoriaId!,
          cartaoId: _cartaoId!,
          descricao: _descricaoController.text.trim(),
          valor: double.parse(_valorController.text.replaceAll(',', '.')),
          faturaId: _faturaId,
          fixa: _fixa,
          quantidadeParcelas: _parcelado ? _numeroParcelas : 1,
          juros: 0.0,
        );
      }

      if (!mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdicao
                  ? 'Despesa atualizada com sucesso!'
                  : _faturaId == null
                  ? 'Despesa criada com sucesso! Fatura criada automaticamente.'
                  : 'Despesa criada com sucesso!',
            ),
            backgroundColor: AppColors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        _mostrarErro(
          transacaoProvider.errorMessage ?? 'Erro ao salvar despesa',
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
}
