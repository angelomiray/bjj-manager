import 'package:final_project/dao/championship_dao.dart';
import 'package:final_project/dao/fights_dao.dart';
import 'package:final_project/dao/user_dao.dart';
import 'package:final_project/model/championship.dart';
import 'package:final_project/model/enterprise.dart';
import 'package:final_project/utils/app_routes.dart';
import 'package:final_project/view/age_options_screen.dart';
import 'package:final_project/view/belt_options_screen.dart';
import 'package:final_project/view/brackets_screen.dart';
import 'package:final_project/view/championship_details_screen.dart';
import 'package:final_project/view/championship_form_screen.dart';
import 'package:final_project/view/main_screen.dart';
import 'package:final_project/view/search_screen.dart';
import 'package:final_project/view/signin_screen.dart';
import 'package:final_project/view/signup_competitor_screen.dart';
import 'package:final_project/view/signup_manager_screen.dart';
import 'package:final_project/view/signup_options_screen.dart';
import 'package:final_project/view/signup_submit.dart';
import 'package:final_project/view/user_championships_screen.dart';
import 'package:final_project/view/weight_options_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => UserDAO()),
      ChangeNotifierProvider(
        create: (context) => ChampionshipDAO(),
      ),
      ChangeNotifierProvider(
        create: (context) => FightsDAO(),
      ),
    ], child: const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Lato',
            scaffoldBackgroundColor: const Color.fromRGBO(23, 24, 28, 1),
            //primarySwatch: Colors.pink,
            colorScheme: ThemeData()
                .copyWith()
                .colorScheme
                .copyWith(primary: Colors.pink, secondary: Colors.red)),
        routes: {
          AppRoutes.SIGNUP_OPTIONS_SCREEN: (context) => SignUpScreen(),
          AppRoutes.SIGNUP_COMPETITOR_SCREEN: (context) =>
              SignUpCompetitorScreen(),
          AppRoutes.SIGNUP_MANAGER_SCREEN: (context) => SignUpManagerScreen(),
          AppRoutes.SIGNUP_SUBMIT_SCREEN: (context) => SignUpSubmitScreen(
                update: false,
                arg: null,
              ),
          AppRoutes.MAIN_SCREEN: (context) => MainScreen(),
          AppRoutes.SEARCH_SCREEN: (context) => SearchScreen(),
          AppRoutes.CHAMPIONSHIP_DETAILS_SCREEN: (context) =>
              ChampionshipDetailsScreen(
                  champ: Championship(
                id: 'null',
                name: 'null',
                description: 'null',
                location: 'null',
                competitors: [],
                creator: Enterprise(
                  id: '-1',
                  email: '',
                  name: '',
                  cnpj: '',
                  address: '',
                  phone: '',
                  password: '',
                  description: '',
                  imgUrl: "https://www.shutterstock.com/image-vector/profile-photo-vector-placeholder-pic-260nw-535853263.jpg",
                ),
                price: 0,
                imgUrl: '',
                startDate: '',
                endDate: '',
                bracketsGenerated: false,
                lat: 0,
                lng: 0,
              )),
          AppRoutes.BELT_OPTIONS_SCREEN: (context) => BeltOptionsScreen(champ: null),
          AppRoutes.AGE_OPTIONS_SCREEN: (context) => AgeOptionsScreen(),
          AppRoutes.WEIGHT_OPTIONS_SCREEN: (context) => WeightOptionsScreen(),
          AppRoutes.BRACKETS_SCREEN: (context) => BracketsScreen(
                belt: 'Branca',
                champ: null,
              ),
          AppRoutes.CHAMPIONSHIP_FORM_SCREEN: (context) =>
              ChampionshipFormScreen(),
          AppRoutes.USER_CHAMPIONSHIPS_SCREEN: (context) =>
              UserChampionshipsScreen(),
        },
        home: SignInScreen(),
      ),
    );
  }
}
