import 'package:final_project/components/confirmation_dialog.dart';
import 'package:final_project/components/custom_button.dart';
import 'package:final_project/dao/championship_dao.dart';
import 'package:final_project/dao/fights_dao.dart';
import 'package:final_project/dao/user_dao.dart';
import 'package:final_project/model/championship.dart';
import 'package:final_project/model/competitor.dart';
import 'package:final_project/model/user.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:final_project/utils/location_util.dart';
import 'package:final_project/view/belt_options_screen.dart';
import 'package:final_project/view/brackets_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChampionshipDetailsScreen extends StatefulWidget {
  Championship champ;
  ChampionshipDetailsScreen({required this.champ});

  @override
  State<ChampionshipDetailsScreen> createState() =>
      _ChampionshipDetailsScreenState();
}

class _ChampionshipDetailsScreenState extends State<ChampionshipDetailsScreen> {
  bool isCreator(User u, Championship c) {
    return u.email == c.creator.email;
  }

  String formatedString(String text, int amount) {
    List<String> words = text.split(' ');

    List<String> groupedWords = [];
    for (int i = 0; i < words.length; i += amount) {
      int endIndex = i + amount;
      if (endIndex > words.length) {
        endIndex = words.length;
      }
      groupedWords.add(words.sublist(i, endIndex).join(' '));
    }

    String result = groupedWords.join('\n');
    return result;
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneCallUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneCallUri)) {
      await launchUrl(phoneCallUri);
    } else {
      print('Não foi possível realizar a chamada.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChampionshipDAO>(context);
    final user = Provider.of<UserDAO>(context).currentUser;
    final fightsProvider = Provider.of<FightsDAO>(context);

    final _previewImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: widget.champ.lat,
      longitude: widget.champ.lng,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
        actions: [
          Visibility(
            visible: isCreator(user, widget.champ),
            child: PopupMenuButton(
              onSelected: (value) async {
                if (value == 'update') {
                  Navigator.of(context).pushNamed(
                      AppRoutes.CHAMPIONSHIP_FORM_SCREEN,
                      arguments: widget.champ);
                } else if (value == 'generateBrackets') {
                  if (!widget.champ.bracketsGenerated) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController controller =
                            TextEditingController();
                        return Center(
                          child: SingleChildScrollView(
                            child: AlertDialog(
                              title: Text('Confirmação'),
                              content: Column(
                                children: [
                                  Text(
                                      'Tem certeza de que deseja gerar as chaves?'),
                                  TextField(
                                    obscureText: true,
                                    controller: controller,
                                    decoration: InputDecoration(
                                        labelText: 'Digite sua senha'),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    String input = controller.text;

                                    if (user.password ==
                                        user.calculateSHA256(input)) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Chaves sendo geradas'),
                                            content: Text(
                                                'Aguarde enquanto as chaves estão sendo geradas...'),
                                          );
                                        },
                                      );
                                      await fightsProvider
                                          .initialize(widget.champ.id);
                                      await fightsProvider.generateBrackets(
                                        widget.champ.id,
                                        widget.champ.competitors,
                                      );
                                      widget.champ.bracketsGenerated = true;
                                      await provider
                                          .updateChampionship(widget.champ);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Center(
                                            child: Text(
                                              'Senha incorreta. Tente novamente.',
                                              style: TextStyle(fontSize: 24),
                                            ),
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text('Confirmar'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(child: Text('Aviso')),
                          content: Text(
                              'As chaves só podem ser geradas uma vez por campeonato.'),
                        );
                      },
                    );
                  }
                } else if (value == 'delete') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog(
                        title: 'Confirmação',
                        content: 'Tem certeza de que deseja continuar?',
                        onConfirm: () {
                          provider.removeChampionship(widget.champ);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  );

                  // provider.removeChampionship(widget.champ);
                  // Navigator.of(context).pop();
                }
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem(
                    value: 'update',
                    child: Row(
                      children: [
                        Icon(Icons.update, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Atualizar'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'generateBrackets',
                    child: Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                        ), // Ícone
                        SizedBox(width: 8),
                        Text('Gerar Chaves'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Deletar'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 150, // Largura desejada
                    height: 175, // Altura desejada
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          25), // Metade da largura/altura para fazer um círculo
                      // 'https://ocvmty.com.mx/wp-content/uploads/ajp-2.jpg'
                      child: Image.network(
                        widget.champ.imgUrl,
                        fit: BoxFit
                            .cover, // Ajuste da imagem (pode ser alterado conforme necessário)
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                    height: 40,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatedString(widget.champ.name, 2),
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.champ.creator.name,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(34, 37, 44, 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.verified_user,
                                color: Colors.green,
                                size: 30,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(34, 37, 44, 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.group,
                                color: Colors.amber,
                                size: 30,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _makePhoneCall(widget.champ.creator.phone);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(34, 37, 44, 1),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.phone,
                                  color: Colors.pink,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                'Sobre',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 15),
              Text(
                widget.champ.description,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(Icons.location_on,
                                    color: Colors.white)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Endereço',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                Text(
                                  //todo: ajeitar wrap
                                  formatedString(widget.champ.location, 3),
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                  maxLines:
                                      4, // Define o número máximo de linhas
                                  overflow: TextOverflow
                                      .ellipsis, // Define um overflow para texto
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(Icons.phone, color: Colors.white)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    'Telefone',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                                Text(
                                  widget.champ.creator.phone,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                  maxLines:
                                      4, // Define o número máximo de linhas
                                  overflow: TextOverflow
                                      .ellipsis, // Define um overflow para texto
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    width: 150,
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
                            fit: BoxFit
                                .cover, // Ajuste para cobrir completamente o Container
                            width: 150,
                            height:
                                200, // Ajuste o tamanho da imagem para o mesmo que o Container
                          ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      if (!widget.champ.bracketsGenerated) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(
                              child: Text(
                                'As chaves ainda não foram geradas.',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BeltOptionsScreen(
                              champ: widget.champ,
                            ),
                          ),
                        );
                      }
                    },
                    child: CustomButton(
                        icon: Icons.emoji_events,
                        title: 'Chaves',
                        subtitle: '01/01/2001',
                        color: Colors.amberAccent),
                  ),
                  InkWell(
                    onTap: () {
                      if (user is Competitor) {
                        if (!user.champs.contains(widget.champ)) {
                          provider.addUserToChamp(user, widget.champ);
                        } else {
                          provider.removeUserFromChamp(user, widget.champ);
                        }
                      }
                    },
                    child: !user.champs.contains(widget.champ)
                        ? InkWell(
                            onTap: () {
                              if (!widget.champ.bracketsGenerated) {
                                user.champs.add(widget.champ);
                                widget.champ.addCompetitor(user as Competitor);
                                provider.updateChampionship(widget.champ);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Text(
                                        'As chaves já foram geradas.',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: CustomButton(
                              icon: Icons.add,
                              title: 'Inscrever-se',
                              subtitle: '01/01/2001',
                              color: Colors.pink,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              if (!widget.champ.bracketsGenerated) {
                                user.champs.remove(widget.champ);
                                widget.champ
                                    .removeCompetitor(user as Competitor);
                                provider.updateChampionship(widget.champ);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Text(
                                        'As chaves já foram geradas.',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: CustomButton(
                              icon: Icons.remove,
                              title: 'Desistir',
                              subtitle: '01/01/2001',
                              color: Colors.red,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
