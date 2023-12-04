import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:final_project/dao/championship_dao.dart';
import 'package:final_project/dao/user_dao.dart';
import 'package:final_project/model/championship.dart';
import 'package:final_project/model/competitor.dart';
import 'package:final_project/model/enterprise.dart';
import 'package:final_project/model/user.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:final_project/utils/location_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ChampionshipFormScreen extends StatefulWidget {
  const ChampionshipFormScreen({Key? key}) : super(key: key);

  @override
  State<ChampionshipFormScreen> createState() => _ChampionshipFormScreenState();
}

class _ChampionshipFormScreenState extends State<ChampionshipFormScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  final _addressFocus = FocusNode();
  final _startFocus = FocusNode();
  final _endFocus = FocusNode();

  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  bool _validImage = false;

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  
  bool isUpdate = false;

  String? _previewImageUrl;

  late final champ;
  double addressLat = 0;
  double addressLng = 0;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  bool _isValidDateFormat(String date) {
    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    return regex.hasMatch(date);
  }

  // @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        isUpdate = true;

        champ = arg as Championship;
        _formData['name'] = champ.name;
        _formData['description'] = champ.description;
        _formData['address'] = champ.location;
        _formData['startDate'] = champ.startDate;
        _formData['endDate'] = champ.endDate;
        _formData['price'] = champ.price;
        _formData['id'] = champ.id;
        _formData['bracketsGenerated'] = champ.bracketsGenerated;
        _formData['lng'] = champ.lng;
        _formData['lat'] = champ.lat;

        _formData['competitors'] = champ.competitors
            .map((competitor) => competitor.id.toString())
            .toList();
        ;

        _imageUrlController.text = champ.imgUrl;

        _searchAddress(champ.location);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _startFocus.dispose();
    _endFocus.dispose();
    _addressFocus.dispose();

    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  void _searchAddress(String address) async {
    final enteredAddress = address;

    final apiKey = 'AIzaSyCVofpmhGlUw5zBskGF6XvGUlik8Rtt0jY';

    //tive que ativar a opção GEOCODING API no google cloud

    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?address=$enteredAddress&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final location = data['results'][0]['geometry']['location'];

        setState(() {
          addressLat = location['lat'];
          addressLng = location['lng'];
        });

        final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
          latitude: addressLat,
          longitude: addressLng,
        );

        setState(() {
          _previewImageUrl = staticMapImageUrl;
        });
      } else {
        print('Geocoding request failed with status: ${data['status']}');
      }
    } else {
      print('HTTP request failed with status code: ${response.statusCode}');
    }
  }

  bool _submitForm(ChampionshipDAO provider, User creator) {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return false;
    }

    _formKey.currentState?.save();

    if (!isUpdate) {
      _formData['id'] = '-1';
      _formData['competitors'] = [];
      _formData['bracketsGenerated'] = false;
      _formData['lat'] = addressLat;
      _formData['lng'] = addressLng;
    }
    _formData['creator'] = creator as Enterprise;
    provider.saveChampionship(_formData);

    Navigator.of(context).pop();

    if (isUpdate) {
      Navigator.of(context).pop();
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final champs = Provider.of<ChampionshipDAO>(context);
    final user = Provider.of<UserDAO>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Competição'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _submitForm(champs, user);
            },
          ),
        ],
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
              'Forneça os dados da competição.',
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
                                      hintText: 'Nome da Competição',
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
                                    decoration: const InputDecoration(
                                      hintText: 'Descrição',
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    textInputAction: TextInputAction.next,
                                    focusNode: _descriptionFocus,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_addressFocus);
                                    },
                                    onSaved: (description) =>
                                        _formData['description'] =
                                            description ??
                                                'Não há nada para mostrar.',
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
                                    Icons.location_on,
                                    color: Color.fromRGBO(63, 64, 69, 1),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    initialValue:
                                        _formData['address']?.toString(),
                                    decoration: const InputDecoration(
                                      hintText: 'Localização do Evento',
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    textInputAction: TextInputAction.next,
                                    focusNode: _addressFocus,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_startFocus);
                                    },
                                    onChanged: (address) {
                                      _searchAddress(address);
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
                                    controller: _startDateController,
                                    focusNode: _startFocus,
                                    decoration: const InputDecoration(
                                      hintText: 'Início',
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_endFocus);
                                    },
                                    onChanged: (value) {
                                      // Realizar validação de formato de data conforme o usuário digita
                                      if (value.isNotEmpty) {
                                        final isValidFormat =
                                            _isValidDateFormat(value);

                                        if (!isValidFormat) {
                                          // Notificar o usuário sobre o formato de data inválido
                                          // Você pode exibir uma mensagem de erro ou realizar a ação desejada
                                        }
                                      }
                                    },
                                    onSaved: (startDate) =>
                                        _formData['startDate'] =
                                            startDate ?? '',
                                    validator: (_startDate) {
                                      final startDate = _startDate ?? '';

                                      if (startDate.trim().isEmpty) {
                                        return 'Campo obrigatório';
                                      }

                                      // Validar o formato da data
                                      if (!_isValidDateFormat(startDate)) {
                                        return 'Formato de data inválido';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
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
                                    controller: _endDateController,
                                    focusNode: _endFocus,
                                    decoration: const InputDecoration(
                                      hintText: 'Fim',
                                      hintStyle: TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_priceFocus);
                                    },
                                    onChanged: (value) {
                                      // Realizar validação de formato de data conforme o usuário digita
                                      if (value.isNotEmpty) {
                                        final isValidFormat =
                                            _isValidDateFormat(value);

                                        if (!isValidFormat) {
                                          // Notificar o usuário sobre o formato de data inválido
                                          // Você pode exibir uma mensagem de erro ou realizar a ação desejada
                                        }
                                      }
                                    },
                                    onSaved: (endDate) =>
                                        _formData['endDate'] = endDate ?? '',
                                    validator: (_endDate) {
                                      final endDate = _endDate ?? '';

                                      if (endDate.trim().isEmpty) {
                                        return 'Campo obrigatório';
                                      }

                                      // Validar o formato da data
                                      if (!_isValidDateFormat(endDate)) {
                                        return 'Formato de data inválido';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
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
                                    Icons.attach_money,
                                    color: Color.fromRGBO(63, 64, 69, 1),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                      initialValue:
                                          _formData['price']?.toString(),
                                      focusNode: _priceFocus,
                                      decoration: const InputDecoration(
                                        hintText: 'Preço',
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
                                      onSaved: (price) =>
                                          _formData['price'] = price ?? '',
                                      validator: (_price) {
                                        final price = _price ?? '';

                                        if (price.trim().isEmpty) {
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
                                _formData['imgUrl'] = imageUrl ?? '',
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
                    SizedBox(height: 65),
                    Container(
                      height: 170,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _previewImageUrl == null
                          ? Text(
                              'Localização não informada!',
                              style: TextStyle(color: Colors.white),
                            )
                          : Image.network(
                              _previewImageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
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
