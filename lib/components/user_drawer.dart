import 'package:final_project/dao/user_dao.dart';
import 'package:final_project/model/competitor.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:final_project/view/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDAO>(context).currentUser;

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.name),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user.imgUrl), 
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Página Inicial'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.of(context).pushNamed(AppRoutes.MAIN_SCREEN);
            },
          ),
          ListTile(
            leading: Icon(Icons.emoji_events),
            title: Text('Campeonatos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamed(AppRoutes.USER_CHAMPIONSHIPS_SCREEN);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Atualizar Dados'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(
                  user is Competitor
                      ? AppRoutes.SIGNUP_COMPETITOR_SCREEN
                      : AppRoutes.SIGNUP_MANAGER_SCREEN,
                  arguments: user);
            },
          ),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text('Sair'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ),
                (route) => false, // Essa função desempilhará todas as telas
              );
            },
          ),
        ],
      ),
    );
  }
}
