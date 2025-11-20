import 'package:flutter/material.dart';
import 'package:frontend/core/app_colors.dart';
import 'package:frontend/features/shared/widgets/logo_container.dart';
import 'package:frontend/features/shared/widgets/secao_card.dart';

class SecaoContas extends StatelessWidget {
  const SecaoContas({super.key});

  @override
  Widget build(BuildContext context) {
    return SecaoCard(
      titulo: "Minhas contas",
      onAdd: () {},
      children: const [
        ContaTile(nome: 'Itaú', tipo: 'Conta Corrente', saldo: 'R\$ 1000,00'),
        ContaTile(nome: 'Itaú', tipo: 'Conta Corrente', saldo: 'R\$ 1000,00'),
      ],
    );
  }
}

class ContaTile extends StatelessWidget {
  final String nome;
  final String tipo;
  final String saldo;

  const ContaTile({
    super.key,
    required this.nome,
    required this.tipo,
    required this.saldo,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const LogoContainer(cor: Colors.orange),
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
