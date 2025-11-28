import 'package:flutter/material.dart';
import 'package:frontend/features/presentation/pages/categoria/categoria_form_page.dart';
import 'package:provider/provider.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/models/categoria_model.dart';
import 'package:frontend/features/presentation/providers/categoria_provider.dart';
import 'package:frontend/features/shared/widgets/icon_picker.dart';
import 'package:frontend/features/presentation/providers/auth_provider.dart';

class CategoriasPage extends StatefulWidget {
  const CategoriasPage({super.key});

  @override
  State<CategoriasPage> createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarCategorias();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _carregarCategorias() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    if (user == null) return;

    final categoriaProvider = context.read<CategoriaProvider>();
    await categoriaProvider.carregarCategorias(user.id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoriaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias', style: TextStyle(fontSize: 16)),
        backgroundColor: AppColors.purpleLight,
        foregroundColor: AppColors.purpleDark,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.purpleDark,
          indicatorColor: AppColors.purpleDark,
          tabs: [
            Tab(
              icon: const Icon(Icons.check_circle),
              text: 'Ativas (${provider.categoriasAtivas.length})',
            ),
            Tab(
              icon: const Icon(Icons.block),
              text: 'Inativas (${provider.categoriasInativas.length})',
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _carregarCategorias,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildListaCategorias(provider, ativas: true),
            _buildListaCategorias(provider, ativas: false),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CategoriaFormPage()),
          );
          if (resultado == true) {
            _carregarCategorias();
          }
        },
        backgroundColor: AppColors.purpleLight,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListaCategorias(
    CategoriaProvider provider, {
    required bool ativas,
  }) {
    if (provider.isLoading && provider.categorias.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.status == CategoriaStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.red),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? 'Erro ao carregar categorias',
              style: TextStyle(color: AppColors.grayDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final categorias = ativas
        ? provider.categoriasAtivas
        : provider.categoriasInativas;

    if (categorias.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ativas ? Icons.category : Icons.block,
              size: 64,
              color: AppColors.grayDark,
            ),
            const SizedBox(height: 16),
            Text(
              ativas ? 'Nenhuma categoria ativa' : 'Nenhuma categoria inativa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkPurple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ativas
                  ? 'Crie categorias para organizar\nsuas transações'
                  : 'As categorias desativadas\naparecerão aqui',
              style: TextStyle(fontSize: 14, color: AppColors.grayDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categorias.length,
      itemBuilder: (context, index) {
        final categoria = categorias[index];
        return _buildCategoriaCard(categoria, ativas: ativas);
      },
    );
  }

  Widget _buildCategoriaCard(CategoriaModel categoria, {required bool ativas}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: ativas ? null : Colors.grey[200],
      child: ListTile(
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: ativas ? categoria.colorValue : Colors.grey,
            shape: BoxShape.circle,
          ),
          child: Icon(
            IconPicker.getIconByName(categoria.icone ?? 'attach_money'),
            color: Colors.white,
            size: 18,
          ),
        ),
        title: Text(
          categoria.nome,
          style: TextStyle(
            color: ativas ? null : Colors.grey[600],
          ),
        ),
        subtitle: categoria.descricao != null
            ? Text(
                categoria.descricao!,
                style: TextStyle(color: ativas ? null : Colors.grey[500]),
              )
            : null,
        trailing: ativas
            ? _buildMenuAtiva(categoria)
            : _buildMenuInativa(categoria),
      ),
    );
  }

  Widget _buildMenuAtiva(CategoriaModel categoria) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Row(
            children: [Icon(Icons.edit), SizedBox(width: 8), Text('Editar')],
          ),
          onTap: () async {
            await Future.delayed(Duration.zero);
            if (!mounted) return;
            final resultado = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoriaFormPage(categoria: categoria),
              ),
            );
            if (resultado == true) {
              _carregarCategorias();
            }
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.block, color: AppColors.red),
              const SizedBox(width: 8),
              Text('Desativar', style: TextStyle(color: AppColors.red)),
            ],
          ),
          onTap: () async {
            await Future.delayed(Duration.zero);
            if (!mounted) return;
            _confirmarDesativar(categoria);
          },
        ),
      ],
    );
  }

  Widget _buildMenuInativa(CategoriaModel categoria) {
    return IconButton(
      icon: Icon(Icons.restore, color: AppColors.green),
      onPressed: () => _confirmarReativar(categoria),
      tooltip: 'Reativar',
    );
  }

  Future<void> _confirmarDesativar(CategoriaModel categoria) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desativar Categoria'),
        content: Text(
          'Deseja desativar a categoria "${categoria.nome}"?\n\n'
          'Ela não aparecerá mais nas listas, mas as transações '
          'já criadas não serão afetadas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Desativar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      final provider = context.read<CategoriaProvider>();
      final sucesso = await provider.desativarCategoria(categoria.id);

      if (mounted && sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Categoria desativada!'),
            backgroundColor: Colors.orange,
            action: SnackBarAction(
              label: 'Desfazer',
              textColor: Colors.white,
              onPressed: () {
                _reativarCategoria(categoria.id);
              },
            ),
          ),
        );
        _carregarCategorias();
      }
    }
  }

  Future<void> _confirmarReativar(CategoriaModel categoria) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reativar Categoria'),
        content: Text(
          'Deseja reativar a categoria "${categoria.nome}"?\n\n'
          'Ela voltará a aparecer nas listas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.green),
            child: const Text('Reativar'),
          ),
        ],
      ),
    );

    if (confirmar == true && mounted) {
      _reativarCategoria(categoria.id);
    }
  }

  Future<void> _reativarCategoria(String id) async {
    final provider = context.read<CategoriaProvider>();
    final sucesso = await provider.reativarCategoria(id);

    if (mounted && sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Categoria reativada!'),
          backgroundColor: Colors.green,
        ),
      );
      _carregarCategorias();
    }
  }
}
