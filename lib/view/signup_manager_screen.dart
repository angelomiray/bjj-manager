import 'package:final_project/model/championship.dart';
import 'package:final_project/model/enterprise.dart';
import 'package:final_project/model/user.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:final_project/view/signup_submit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SignUpManagerScreen extends StatefulWidget {
  const SignUpManagerScreen({
    super.key,
  });

  @override
  State<SignUpManagerScreen> createState() => _SignUpManagerScreenState();
}

class _SignUpManagerScreenState extends State<SignUpManagerScreen> {
  final _cnpjFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  final _addressFocus = FocusNode();
  final _phoneFocus = FocusNode();

  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool isUpdate = false;

  bool _validImage = false;

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
        final enterprise = arg as Enterprise;
        _formData['id'] = enterprise.id;
        _formData['email'] = enterprise.email;
        _formData['password'] = enterprise.password;
        _formData['description'] = enterprise.description;
        _formData['name'] = enterprise.name;
        _formData['cnpj'] = enterprise.cnpj;
        _formData['phone'] = enterprise.phone;
        _formData['address'] = enterprise.address;
        _formData['champs'] = enterprise.champs;
        _formData['imgUrl'] = enterprise.imgUrl;
        _imageUrlController.text = enterprise.imgUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cnpjFocus.dispose();
    _descriptionFocus.dispose();
    _phoneFocus.dispose();
    _addressFocus.dispose();

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

    User enterprise = Enterprise(
      id: isUpdate ? _formData['id'] as String : '-1',
      email: '',
      password: '',
      name: _formData['name'] as String,
      cnpj: _formData['cnpj'] as String,
      address: _formData['address'] as String,
      phone: _formData['phone'] as String,
      description: _formData['description'] as String,
      imgUrl: _imageUrlController.text,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpSubmitScreen(
          update: isUpdate,
          arg: enterprise,
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
              'Forneça seus dados de empresa.',
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
                                          .requestFocus(_cnpjFocus);
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
                                    Icons.work,
                                    color: Color.fromRGBO(63, 64, 69, 1),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _formData['cnpj']?.toString(),
                                    focusNode: _cnpjFocus,
                                    decoration: const InputDecoration(
                                      hintText: 'CNPJ',
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
                                    onSaved: (cnpj) =>
                                        _formData['cnpj'] = cnpj ?? '',
                                    validator: (_cnpj) {
                                      final cnpj = _cnpj ?? '';

                                      if (cnpj.trim().isEmpty) {
                                        return 'Campo obrigatório';
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
                                          .requestFocus(_addressFocus);
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
                                    Icons.location_on,
                                    color: Color.fromRGBO(63, 64, 69, 1),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    initialValue:
                                        _formData['address']?.toString(),
                                    focusNode: _addressFocus,
                                    decoration: const InputDecoration(
                                      hintText: 'Endereço',
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_phoneFocus);
                                    },
                                    onSaved: (address) =>
                                        _formData['address'] = address ?? '',
                                    validator: (_address) {
                                      final address = _address ?? '';

                                      if (address.trim().isEmpty) {
                                        return 'Campo obrigatório';
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
                                    Icons.phone,
                                    color: Color.fromRGBO(63, 64, 69, 1),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                      initialValue:
                                          _formData['phone']?.toString(),
                                      focusNode: _phoneFocus,
                                      decoration: const InputDecoration(
                                        hintText: 'Telefone',
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
                                      onSaved: (phone) =>
                                          _formData['phone'] = phone ?? '',
                                      validator: (_phone) {
                                        final phone = _phone ?? '';

                                        if (phone.trim().isEmpty) {
                                          return 'Campo obrigatório';
                                        }
                                      }),
                                ),
                              ],
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
                            //   if (!_validImage) {
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
                            color: Colors
                                .red, // obs: talvez mudar para red ou para um amber com menos intensidade
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
