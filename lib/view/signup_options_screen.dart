import 'package:final_project/components/option_card.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Opções de Usuário', ),
            ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'BLACK',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    'BELT',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
              const Text(
                'Escolha um tipo de usuário.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 100),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.SIGNUP_COMPETITOR_SCREEN);
                      },
                      child: OptionCard(
                        icon: Icons.military_tech_outlined,
                        title: 'Competidor',
                        description:
                            'Ingresse em competições e cresça no cenário',
                      ),
                    ),
                  ),
                  SizedBox(width: 8), // Espaçamento entre os cards
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.SIGNUP_MANAGER_SCREEN);
                      },
                      child: OptionCard(
                        icon: Icons.work,
                        title: 'Empresa',
                        description: 'Promova torneios e mostre seus serviços',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
