import 'package:consumar_app/src/silos/silos_page.dart';
import 'package:consumar_app/src/widgets/boton_menu.dart';
import 'package:consumar_app/src/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';

import '../models/auth/user_authenticated_model.dart';
import '../utils/constants.dart';
import 'auth/login_page.dart';

import 'carga_liquida/carga_liquida.dart';
import 'carga_proyecto/carga_proyecto_dart.dart';
import 'registro_usuario/menu_registro_usuario_page.dart';
import 'roro/roro_cargarodante_page.dart';
import 'survey/survey_cargagranel_page.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({Key? key, required this.userAuthenticatedModel})
      : super(key: key);

  final UserAuthenticatedModel userAuthenticatedModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "CONSUMARPORT",
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: kColorAzul),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: kColorNaranja,
                      radius: 40.0,
                      child: Text(
                        userAuthenticatedModel.firstname!
                                .substring(0, 1)
                                .toUpperCase() +
                            userAuthenticatedModel.lastname!
                                .substring(0, 1)
                                .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Wrap(
                      children: [
                        Text(
                          'Bienvenido ${userAuthenticatedModel.firstname} ${userAuthenticatedModel.lastname}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: kColorAzul,
                size: 32,
              ),
              title: Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: kColorAzul,
                  fontSize: 16.0,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const LoginPantalla(),
                  ),
                );
              },
            ),
          ],
        )),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BotonMenu(
                      title: 'REGISTRO DE USUARIOS',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MenuRegistroUsuarios()));
                      },
                      icon: Icons.person_add,
                    ),
                    const SizedBox(width: 20),
                    BotonMenu(
                      title: 'RORO CARGA RODANTE',
                      icon: Icons.car_repair,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RoroCargaRodantePage()));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BotonMenu(
                      title: 'SILOS',
                      icon: Icons.storage,
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => silos()));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Silos(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    BotonMenu(
                      title: 'SURVEY CARGA GRANEL',
                      icon: Icons.agriculture,
                      onTap: () {
                        //CustomSnackBar.infoSnackBar(context,'Función Survey Carga Granel disponible proximamente.');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SurveyCargaGranel(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BotonMenu(
                      title: 'CARGA LIQUIDA',
                      icon: Icons.water,
                      onTap: () {
                        /*  CustomSnackBar.infoSnackBar(context,
                            'Función Carga Liquida disponible proximamente.'); */
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CargaLiquida()));
                      },
                    ),
                    const SizedBox(width: 20),
                    BotonMenu(
                      title: 'CARGA GENERAL',
                      icon: Icons.grid_4x4,
                      onTap: () {
                        CustomSnackBar.infoSnackBar(context,
                            'Función Carga General disponible proximamente.');
                        /*                      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => cargaGeneral()));*/
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BotonMenu(
                      title: 'CARGA PROYECTO',
                      icon: Icons.engineering,
                      onTap: () {
                        /*   CustomSnackBar.infoSnackBar(context,
                            'Función Carga Proyecto disponible proximamente.'); */
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CargaProyectoPage()));
                      },
                    ),
                    const SizedBox(width: 20),
                    const SizedBox(
                      height: 150,
                      width: 150,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
