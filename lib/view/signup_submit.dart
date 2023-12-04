import 'package:final_project/dao/user_dao.dart';
import 'package:final_project/model/user.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpSubmitScreen extends StatefulWidget {
  final update;
  final arg;
  const SignUpSubmitScreen(
      {super.key, required this.arg, required this.update});

  @override
  State<SignUpSubmitScreen> createState() => _SignUpSubmitScreenState();
}

class _SignUpSubmitScreenState extends State<SignUpSubmitScreen> {
  final _passwordFocus = FocusNode();
  final _repeatPasswordFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  String currentPass = '';

  @override
  void initState() {
    super.initState();
    // _imageUrlFocus.addListener(updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    _passwordFocus.dispose();
    _repeatPasswordFocus.dispose();
  }

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  void showRegistrationConfirmation(
      BuildContext context, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(''),
          content: Container(
              margin: EdgeInsets.only(top: 50),
              child: Text(message,
                  textAlign: TextAlign.center, style: TextStyle(color: color))),
          backgroundColor: Color.fromRGBO(23, 24, 28, 1),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (color == Colors.red) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Prosseguir', style: TextStyle(color: Colors.amber)),
            ),
          ],
        );
      },
    );
  }

  bool _submitForm(UserDAO provider) {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return false;
    }

    _formKey.currentState?.save();

    //todo: criar o usuário, verificar o tipo (poliosfismo), tentar adicionar no firebase verificando se o email nao está em uso.

    if (provider.checkEmail(_formData['email'] as String) == true && widget.update == false) {
      return false;
    }

    if (widget.arg != null) {
      final user = widget.arg as User;
      user.setEmail(_formData['email'] as String);
      user.setPassword(_formData['password'] as String);

      if (widget.update) {
        provider.updateUser(user);
      } else {
        provider.addUser(user).then((value) {
          return true;
        });
      }
    }

    return true; //problema com return: pq as vezes ele realiza a opr mas retorna false? mudei para return true. talvez seja problema com assincronismo.
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDAO>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalização de Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
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
                      color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Forneça seus dados de login.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
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
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.email,
                              color: Color.fromRGBO(63, 64, 69, 1),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: _formData['email']?.toString(),
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                hintStyle:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocus);
                              },
                              onSaved: (email) =>
                                  _formData['email'] = email ?? '',
                              validator: (_email) {
                                final email = _email ?? '';

                                if (email.trim().isEmpty) {
                                  return 'Campo obrigatório';
                                }

                                if (isEmailValid(email) == false) {
                                  return 'Formato inválido';
                                }

                                return null;
                              },
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
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.lock,
                              color: Color.fromRGBO(63, 64, 69, 1),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: _formData['password']?.toString(),
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Senha',
                                hintStyle:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_repeatPasswordFocus);
                              },
                              onSaved: (password) =>
                                  _formData['password'] = password ?? '',
                              validator: (_password) {
                                currentPass = _password ?? '';

                                if (currentPass.trim().isEmpty) {
                                  return 'Campo obrigatório';
                                }

                                //todo: validador de senhas fortes
                                if (currentPass.trim().length < 8) {
                                  return 'Sennha precisa no mínimo de 8 letras.';
                                }

                                return null;
                              },
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
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.repeat,
                              color: Color.fromRGBO(63, 64, 69, 1),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              initialValue: '',
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Repetir senha',
                                hintStyle:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.next,
                              validator: (_repeatedPassword) {
                                final repeatedPassword =
                                    _repeatedPassword ?? '';

                                if (currentPass != repeatedPassword) {
                                  return 'As senhas não coincidem.';
                                }

                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 150),
                    InkWell(
                      onTap: () {
                        bool result = _submitForm(provider);
                        var message = '';
                        var color = Colors.green;
                        print('result');
                        print(result);
                        if (result == true) {
                          message = 'Operação realizada com sucesso.';
                        } else {
                          message = 'Falha na operação. Email já está em uso.';
                          color = Colors.red;
                        }

                        showRegistrationConfirmation(context, message, color);
                      },
                      child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors
                                .red, // obs: talvez mudar para red ou para um amber com menos intensidade
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                              child: Text(
                            'Cadastrar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
