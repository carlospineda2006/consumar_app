import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../services/auth/auth_service.dart';
import '../../utils/constants.dart';
import '../menu_principal_page.dart';
import '../widgets/custom_snack_bar.dart';

class LoginPantalla extends StatefulWidget {
  const LoginPantalla({Key? key}) : super(key: key);

  @override
  State<LoginPantalla> createState() => _LoginState();
}

class _LoginState extends State<LoginPantalla> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;
  late String password;
  late String user;
  bool loggingIn = false;

  getLogin() async {
    AuthService authService = AuthService();

    if (_formKey.currentState!.validate()) {
      CustomSnackBar.infoSnackBar(
          context, 'Validando credenciales ... por favor espere');

      var userAuthenticatedModel = await authService.login(user, password);

      if (userAuthenticatedModel.id != null) {
        var message =
            'Inicio de sesión exitoso, bienvenido ${userAuthenticatedModel.firstname} ${userAuthenticatedModel.lastname}';
        if (context.mounted) {
          CustomSnackBar.successSnackBar(context, message);
        }

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MenuPrincipal(userAuthenticatedModel: userAuthenticatedModel),
            ),
                (route) => false, // Remove all previous routes
          );
        }
      } else {
        if (context.mounted) {
          CustomSnackBar.errorSnackBar(
              context, 'Usuario o contraseña incorrecta!');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // propiedad de orden
      body: SafeArea(
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: Image.asset("assets/images/background.png",
                      fit: BoxFit.fill)),
            ],
          ),
          SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  const SizedBox(
                    //caja de texto
                    height: 50,
                  ),
                  Image.asset(
                    'assets/images/logo_vertical_negativo.png',
                    width: 250.0,
                  ),
                  const SizedBox(
                    //caja de texto
                    height: 50,
                  ),
                  Center(
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(
                        maxWidth: 500,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.white70,
                              offset: Offset(0, 5),
                              blurRadius: 5.0),
                          BoxShadow(
                              color: Colors.white70,
                              offset: Offset(0, -5),
                              blurRadius: 5),
                        ],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // ingresar texto
                              'Inicio de sesión',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: kColorAzul,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              //caja de texto
                              height: 30,
                            ),
                            TextFormField(
                                enableInteractiveSelection: false,
                                autofocus: true,
                                controller: loginController,
                                decoration: InputDecoration(
                                  hintText: 'Ingrese su usuario',
                                  labelText: 'Usuario',
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.blueAccent,
                                  ),
                                  //suffixIcon: const Icon(Icons.verified_user),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.blueAccent, width: 2.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, Ingrese su usuario';
                                  }
                                  user = value;
                                  return null;
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                enableInteractiveSelection: false,
                                autofocus: true,
                                obscureText: hidePassword,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors.blueAccent,
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: 'Ingrese su contraseña',
                                  labelText: 'Contraseña',
                                  prefixIcon: const Icon(
                                    Icons.vpn_key,
                                    color: Colors.blueAccent,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: hidePassword
                                        ? const Icon(
                                            CupertinoIcons.eye_slash,
                                          )
                                        : const Icon(
                                            CupertinoIcons.eye,
                                          ),
                                    onPressed: () {
                                      hidePassword = !hidePassword;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su contraseña';
                                  }
                                  password = value;

                                  return null;
                                }),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Center(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 300,
                      ),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        minWidth: double.infinity,
                        height: 50.0,
                        color: kColorNaranja,
                        onPressed: () async {
                          EasyLoading.show(
                              indicator: const CircularProgressIndicator(),
                              status: "Iniciando sesión",
                              maskType: EasyLoadingMaskType.black);
                          await getLogin();
                          EasyLoading.dismiss();
                        },
                        child: const Text(
                          "INICIAR SESIÓN",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
