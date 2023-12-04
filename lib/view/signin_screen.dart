import 'package:final_project/dao/user_dao.dart';
import 'package:final_project/model/user.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  void showResultDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(''),
          content: Container(
              margin: EdgeInsets.only(top: 50),
              child: Text('Email ou senha inválidos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red))),
          backgroundColor: Color.fromRGBO(23, 24, 28, 1),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Prosseguir', style: TextStyle(color: Colors.amber)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserDAO provider = Provider.of<UserDAO>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                          color: Colors.pink),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Por favor, entre na sua conta.',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 70),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(34, 37, 44, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.all(10.0), // Espaço ao redor do ícone
                        child: Icon(
                          Icons
                              .email, // Ícone de usuário (pode ser substituído por outro ícone)
                          color: Color.fromRGBO(63, 64, 69, 1), // Cor do ícone
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            // labelText: 'Nome de usuário',
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Email',
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.white),
                          controller: _emailController,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(34, 37, 44, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.all(10.0), // Espaço ao redor do ícone
                        child: Icon(
                          Icons
                              .lock, // Ícone de usuário (pode ser substituído por outro ícone)
                          color: Color.fromRGBO(63, 64, 69, 1), // Cor do ícone
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            // labelText: 'Nome de usuário',
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: 'Senha',
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.white),
                          controller: _pwController,
                        ),
                      ),
                    ],
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Esqueceu a senha?',
                      style: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(63, 64, 69, 1)),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                InkWell(
                  onTap: () {                    

                    //talvez mudar a área de calculo do SHA256 logo aqui. talvez no outro arquivo cause insegurança?
                    User result = provider.tryLogin(
                        _emailController.text, _pwController.text);

                    if (result.name != 'null') {
                      provider.setCurrentUser(result);
                      Navigator.of(context).pushNamed(AppRoutes.MAIN_SCREEN);
                    } else {
                      showResultDialog(context);
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors
                            .pink, // obs: talvez mudar para red ou para um amber com menos intensidade
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                          child: Text(
                        'Entrar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ))),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                          'http://pngimg.com/uploads/google/google_PNG19635.png',
                          height: 24,
                          width: 24,
                          fit: BoxFit.cover),
                      const SizedBox(width: 8),
                      const Text(
                        'Entrar com o Google',
                        style: TextStyle(
                          color: Color.fromRGBO(102, 101, 105, 1),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.facebook,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Entrar com o Facebook',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Não possui uma conta?  ',
                      style: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(63, 64, 69, 1)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.SIGNUP_OPTIONS_SCREEN);
                      },
                      child: const Text(
                        'Cadastre-se',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
