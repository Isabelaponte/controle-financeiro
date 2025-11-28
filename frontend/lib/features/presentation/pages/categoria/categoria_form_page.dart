import 'package:flutter/material.dart';
import 'package:frontend/features/models/categoria_model.dart';
import 'package:frontend/features/presentation/providers/categoria_provider.dart';
import 'package:frontend/features/shared/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';

class CategoriaFormPage extends StatefulWidget {
  final CategoriaModel? categoria;

  const CategoriaFormPage({super.key, this.categoria});

  @override
  State<CategoriaFormPage> createState() => _CategoriaFormPageState();
}

class _CategoriaFormPageState extends State<CategoriaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  Color _corSelecionada = const Color(0xFF5E35B1);
  String _iconeSelecionado = 'attach_money';
  bool _isLoading = false;

  bool get isEdicao => widget.categoria != null;

  @override
  void initState() {
    super.initState();
    if (isEdicao) {
      _nomeController.text = widget.categoria!.nome;
      _descricaoController.text = widget.categoria!.descricao ?? '';
      _corSelecionada = widget.categoria!.colorValue;
      _iconeSelecionado = widget.categoria!.icone ?? 'attach_money';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdicao ? 'Editar Categoria' : 'Nova Categoria', style: TextStyle(fontSize: 16),),
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
              // Preview da categoria
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _corSelecionada,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    IconPicker.getIconByName(_iconeSelecionado),
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Nome
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome da Categoria *',
                  hintText: 'Ex: Alimentação',

                  labelStyle: TextStyle(color: AppColors.purpleDark),
                  border: OutlineInputBorder(),
                ),
                maxLength: 25,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Seleção de Cor
              ColorPicker(
                selectedColor: _corSelecionada,
                onColorSelected: (color) {
                  setState(() => _corSelecionada = color);
                },
              ),
              const SizedBox(height: 30),

              // Seleção de Ícone
              IconPicker(
                selectedIconName: _iconeSelecionado,
                onIconSelected: (iconName) {
                  setState(() => _iconeSelecionado = iconName);
                },
              ),
              const SizedBox(height: 40),

              // Botão Salvar
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
      final categoriaProvider = context.read<CategoriaProvider>();
      final user = authProvider.user;

      if (user == null) {
        _mostrarErro('Usuário não encontrado');
        return;
      }

      final nome = _nomeController.text.trim();
      final descricao = _descricaoController.text.trim();
      final cor =
          '#${_corSelecionada.value.toRadixString(16).substring(2).toUpperCase()}';

      bool sucesso;

      if (isEdicao) {
        sucesso = await categoriaProvider.atualizarCategoria(
          widget.categoria!.id,
          nome: nome,
          cor: cor,
          icone: _iconeSelecionado,
          descricao: descricao.isEmpty ? null : descricao,
        );
      } else {
        sucesso = await categoriaProvider.adicionarCategoria(
          nome: nome,
          usuarioId: user.id,
          cor: cor,
          icone: _iconeSelecionado,
          descricao: descricao.isEmpty ? null : descricao,
        );
      }

      if (!mounted) return;

      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdicao
                  ? 'Categoria atualizada com sucesso!'
                  : 'Categoria criada com sucesso!',
            ),
            backgroundColor: AppColors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        _mostrarErro(
          categoriaProvider.errorMessage ?? 'Erro ao salvar categoria',
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
