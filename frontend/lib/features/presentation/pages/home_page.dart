import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const _ResumoCards(),
              const SizedBox(height: 20),
              const _SecaoContas(),
              const SizedBox(height: 10),
              const _SecaoCartoes(),
              const SizedBox(height: 10),
              const _SecaoMetas(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.purpleDark,
      unselectedItemColor: AppColors.grayDark,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_outlined),
          label: 'Carteira',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.purpleLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.add, color: AppColors.purpleDark),
          ),
          label: 'Adicionar',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Estatísticas',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const _AppBarContent(),
      centerTitle: true,
      toolbarHeight: 140,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      backgroundColor: AppColors.purpleLight,
      foregroundColor: AppColors.purpleDark,
    );
  }
}

// ===== CONTEÚDO DO APPBAR =====
class _AppBarContent extends StatelessWidget {
  const _AppBarContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.purpleDark,
                  child: Icon(
                    Icons.person,
                    color: AppColors.purpleLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text("Isabela", style: TextStyle(fontSize: 16)),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: AppColors.purpleDark,
                size: 28,
              ),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text("Saldo Total", style: TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/cofrinho_logo.png',
              height: 35,
              width: 35,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            const Text(
              "1.654,36",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ===== CARDS DE RESUMO =====
class _ResumoCards extends StatelessWidget {
  const _ResumoCards();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ResumoCard(
            valor: "654,54",
            label: "Ganhos",
            icon: Icons.trending_up,
            color: AppColors.green,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ResumoCard(
            valor: "654,54",
            label: "Gastos",
            icon: Icons.trending_down,
            color: AppColors.red,
          ),
        ),
      ],
    );
  }
}

class _ResumoCard extends StatelessWidget {
  final String valor;
  final String label;
  final IconData icon;
  final Color color;

  const _ResumoCard({
    required this.valor,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundCard,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(valor, style: TextStyle(color: color, fontSize: 18)),
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.darkPurple,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ===== SEÇÃO DE CONTAS =====
class _SecaoContas extends StatelessWidget {
  const _SecaoContas();

  @override
  Widget build(BuildContext context) {
    return _SecaoCard(
      titulo: "Minhas contas",
      onAdd: () {},
      children: const [
        _ContaTile(nome: 'Itaú', tipo: 'Conta Corrente', saldo: 'R\$ 1000,00'),
        _ContaTile(nome: 'Itaú', tipo: 'Conta Corrente', saldo: 'R\$ 1000,00'),
      ],
    );
  }
}

class _ContaTile extends StatelessWidget {
  final String nome;
  final String tipo;
  final String saldo;

  const _ContaTile({
    required this.nome,
    required this.tipo,
    required this.saldo,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const _LogoContainer(cor: Colors.orange),
      title: Text(
        nome,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        tipo,
        style: TextStyle(color: AppColors.grayDark, fontSize: 14),
      ),
      trailing: Text(
        saldo,
        style: TextStyle(color: AppColors.blue, fontSize: 16),
      ),
    );
  }
}

// ===== SEÇÃO DE CARTÕES =====
class _SecaoCartoes extends StatelessWidget {
  const _SecaoCartoes();

  @override
  Widget build(BuildContext context) {
    return _SecaoCard(
      titulo: "Cartões de crédito",
      onAdd: () {},
      children: const [
        _CartaoTile(
          nome: 'Itaú',
          vencimento: '- Vence amanhã',
          disponivel: 'R\$ 2500,00',
          faturaAtual: 'R\$ 2500,00',
        ),
        Divider(),
        _CartaoTile(
          nome: 'Itaú',
          vencimento: '- Vence amanhã',
          disponivel: 'R\$ 2500,00',
          faturaAtual: 'R\$ 2500,00',
        ),
      ],
    );
  }
}

class _CartaoTile extends StatelessWidget {
  final String nome;
  final String vencimento;
  final String disponivel;
  final String faturaAtual;

  const _CartaoTile({
    required this.nome,
    required this.vencimento,
    required this.disponivel,
    required this.faturaAtual,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 16),
          const _LogoContainer(cor: Colors.purple),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      nome,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      vencimento,
                      style: TextStyle(color: AppColors.grayDark, fontSize: 13),
                    ),
                    const Spacer(),

                    // FilledButton(
                    //   onPressed: () {},
                    //   style: FilledButton.styleFrom(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 30,
                    //       vertical: 15,
                    //     ),
                    //     backgroundColor: AppColors.greenLight,
                    //     minimumSize: Size.zero,
                    //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //   ),
                    //   child: Text(
                    //     'Ver fatura',
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       color: AppColors.greenDark,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _InfoColuna(label: 'Disponível', valor: disponivel),
                    const SizedBox(width: 50),
                    _InfoColuna(
                      label: 'Fatura atual',
                      valor: faturaAtual,
                      corValor: AppColors.red,
                    ),
                    Spacer(),
                    Text(
                      "Aberta",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.purpleAccent,
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoColuna extends StatelessWidget {
  final String label;
  final String valor;
  final Color? corValor;

  const _InfoColuna({required this.label, required this.valor, this.corValor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(label, style: TextStyle(color: AppColors.grayDark, fontSize: 12)),
        SizedBox(height: 10),
        Text(
          valor,
          style: TextStyle(color: corValor ?? AppColors.grayDark, fontSize: 12),
        ),
      ],
    );
  }
}

// ===== WIDGETS REUTILIZÁVEIS =====
class _SecaoCard extends StatelessWidget {
  final String titulo;
  final VoidCallback onAdd;
  final List<Widget> children;

  const _SecaoCard({
    required this.titulo,
    required this.onAdd,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: AppColors.backgroundCard,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(onPressed: onAdd, icon: const Icon(Icons.add)),
                ],
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _SecaoMetas extends StatelessWidget {
  const _SecaoMetas();

  @override
  Widget build(BuildContext context) {
    return _SecaoCard(
      titulo: "Minhas metas",
      onAdd: () {},
      children: const [
        _MetaTile(
          nome: 'Viagem',
          categoria: 'Lazer',
          valorAtual: 20.00,
          valorTotal: 2500.00,
        ),
        SizedBox(height: 10),
        _MetaTile(
          nome: 'Celular novo',
          categoria: 'Compras',
          valorAtual: 800.00,
          valorTotal: 3000.00,
        ),
      ],
    );
  }
}

class _MetaTile extends StatelessWidget {
  final String nome;
  final String categoria;
  final double valorAtual;
  final double valorTotal;

  const _MetaTile({
    required this.nome,
    required this.categoria,
    required this.valorAtual,
    required this.valorTotal,
  });

  double get progresso => valorAtual / valorTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nome,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.purpleLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  categoria,
                  style: TextStyle(fontSize: 12, color: AppColors.purpleDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'R\$ ${valorAtual.toStringAsFixed(2).replaceAll('.', ',')}',
                style: TextStyle(fontSize: 13, color: AppColors.grayDark),
              ),
              Text(
                'R\$ ${valorTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                style: TextStyle(fontSize: 13, color: AppColors.grayDark),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progresso,
              minHeight: 8,
              backgroundColor: AppColors.grayLight,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.purpleDark),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoContainer extends StatelessWidget {
  final Color cor;

  const _LogoContainer({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
