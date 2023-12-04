import 'package:final_project/model/championship.dart';
import 'package:final_project/model/competitor.dart';
import 'package:final_project/model/enterprise.dart';
import 'package:final_project/model/user.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:final_project/view/signup_submit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SignUpCompetitorScreen extends StatefulWidget {
  const SignUpCompetitorScreen({Key? key}) : super(key: key);

  @override
  State<SignUpCompetitorScreen> createState() => _SignUpCompetitorScreenState();
}

class _SignUpCompetitorScreenState extends State<SignUpCompetitorScreen> {
  final _lastNameFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  final _ageFocus = FocusNode();
  final _weightFocus = FocusNode();

  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool isUpdate = false;

  bool _validImage = true;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        isUpdate = true;
        final user = arg as User;
        _formData['id'] = user.id;
        _formData['email'] = user.email;
        _formData['description'] = user.description;
        _formData['imgUrl'] = user.imgUrl;
        _formData['name'] = user.name;

        if (user is Competitor) {
          _formData['lastName'] = user.lastName;
          _formData['age'] = user.age;
          _formData['weight'] = user.weight;
          _formData['belt'] = user.belt;
        } else if (user is Enterprise) {
          _formData['cnpj'] = user.cnpj;
          _formData['phone'] = user.phone;
          _formData['address'] = user.address;
        }

        _imageUrlController.text = user.imgUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _lastNameFocus.dispose();
    _descriptionFocus.dispose();
    _ageFocus.dispose();
    _weightFocus.dispose();

    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    print(_formData['belt']);

    User comp = Competitor(
      id: isUpdate ? _formData['id'] as String : '-1',
      email: '',
      password: '',
      name: _formData['name'] as String,
      lastName: _formData['lastName'] as String,
      age: int.parse(_formData['age'] as String),
      weight: double.parse(_formData['weight'] as String),
      description: _formData['description'] as String,
      belt: _formData['belt'] != null ? _formData['belt'] as String :"Branca",
      imgUrl: _imageUrlController.text,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpSubmitScreen(
          update: isUpdate,
          arg: comp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Competidor'),
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
              'Forneça seus dados de competidor.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
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
                                    Icons.person,
                                    color: Color.fromRGBO(63, 64, 69, 1),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _formData['name']?.toString(),
                                    decoration: const InputDecoration(
                                      hintText: 'Nome',
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_lastNameFocus);
                                    },
                                    onSaved: (name) =>
                                        _formData['name'] = name ?? '',
                                    validator: (_name) {
                                      final name = _name ?? '';

                                      if (name.trim().isEmpty) {
                                        return 'Campo obrigatório';
                                      }

                                      if (name.trim().length < 2 ||
                                          name.trim().length > 75) {
                                        return 'Nome precisa ter entre 2 e 75 letras.';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
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
                                    Icons.person,
                                    color: Color.fromRGBO(63, 64, 69, 1),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    initialValue:
                                        _formData['lastName']?.toString(),
                                    focusNode: _lastNameFocus,
                                    decoration: const InputDecoration(
                                      hintText: 'Sobrenome ',
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_descriptionFocus);
                                    },
                                    onSaved: (lastName) =>
                                        _formData['lastName'] = lastName ?? '',
                                    validator: (_lastName) {
                                      final lastName = _lastName ?? '';

                                      if (lastName.trim().isEmpty) {
                                        return 'Campo obrigatório';
                                      }

                                      if (lastName.trim().length < 2 ||
                                          lastName.trim().length > 75) {
                                        return 'Sobre precisa ter entre 2 e 75 letras.';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
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
                                    Icons.description,
                                    color: Color.fromRGBO(63, 64, 69, 1),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    initialValue:
                                        _formData['description']?.toString(),
                                    focusNode: _descriptionFocus,
                                    decoration: const InputDecoration(
                                      hintText: 'Descrição',
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_ageFocus);
                                    },
                                    onSaved: (description) => _formData[
                                            'description'] =
                                        description ??
                                            'Não há descrição para informar.',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
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
                                    Icons.calendar_today,
                                    color: Color.fromRGBO(63, 64, 69, 1),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _formData['age']?.toString(),
                                    focusNode: _ageFocus,
                                    decoration: const InputDecoration(
                                      hintText: 'Idade',
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_weightFocus);
                                    },
                                    onSaved: (age) =>
                                        _formData['age'] = age ?? '',
                                    validator: (_age) {
                                      final age = _age ?? '';

                                      if (age.trim().isEmpty) {
                                        return 'Campo obrigatório';
                                      }

                                      if (int.tryParse(age) == null) {
                                        return 'Idade inválida';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
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
                                    Icons.equalizer,
                                    color: Color.fromRGBO(63, 64, 69, 1),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                      initialValue:
                                          _formData['weight']?.toString(),
                                      focusNode: _weightFocus,
                                      decoration: const InputDecoration(
                                        hintText: 'Peso (kg)',
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                      style:
                                          const TextStyle(color: Colors.white),
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_imageUrlFocus);
                                      },
                                      onSaved: (weight) =>
                                          _formData['weight'] = weight ?? '',
                                      validator: (_weight) {
                                        final weight = _weight ?? '';

                                        if (weight.trim().isEmpty) {
                                          return 'Campo obrigatório';
                                        }

                                        if (double.tryParse(weight) == null) {
                                          return 'Valor inválido';
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(34, 37, 44, 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _formData['belt'] != null
                                          ? _formData['belt'] as String
                                          : 'Branca',
                                      items: [
                                        'Branca',
                                        'Azul',
                                        'Roxa',
                                        'Marrom',
                                        'Preta'
                                      ].map((belt) {
                                        return DropdownMenuItem<String>(
                                          value: belt,
                                          child: Text(
                                            belt,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (belt) {
                                        setState(() {
                                          _formData['belt'] = belt as String;
                                          print(belt);
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Faixa',
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Foto de Perfil',
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocus,
                            controller: _imageUrlController,
                            // onFieldSubmitted: (_) => _submitForm(),
                            onSaved: (imageUrl) =>
                                _formData['imageUrl'] = imageUrl ?? '',
                            // validator: (_imageUrl) {
                            //   if (_validImage == false) {
                            //     return 'URL inválido';
                            //   }

                            //   return null;
                            // },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? const Text(
                                  'Informe a URL',
                                  style: TextStyle(color: Colors.grey),
                                )
                              : Image.network(
                                  _imageUrlController.text,
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    // Retorna um widget personalizado para exibir quando a imagem não pode ser carregada
                                    _validImage = false;

                                    return Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Imagem não carregada',
                                          style: TextStyle(color: Colors.red),
                                        ));
                                  },
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    InkWell(
                      onTap: _submitForm,
                      child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                              child: Text(
                            'Próximo',
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
