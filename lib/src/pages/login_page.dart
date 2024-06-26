// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:real_me_fitness_center/src/models/login.dart';
import 'package:real_me_fitness_center/src/pages/main_menu_page.dart';
import 'package:real_me_fitness_center/src/providers/loading.dart';
import 'package:real_me_fitness_center/src/sharedPrefs/loginToken.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class LogInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LoadingOption(),
        child: Consumer<LoadingOption>(builder: ((context, loadingOption, _) {
          return Stack(
            children: [
              FutureBuilder(
                  future: LoginToken.verifyToken(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                          body: Center(child: CircularProgressIndicator()));
                    } else if (snapshot.hasData && snapshot.data == true) {
                      return MainMenuPage();
                    } else {
                      return Scaffold(
                          key: _scaffoldKey,
                          body: Center(
                            child: SafeArea(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(width: double.infinity),
                                    _HeaderLogin(),
                                    _UserLoginForm(loadingOption)
                                  ],
                                ),
                              ),
                            ),
                          ));
                    }
                  }),
              if (loadingOption.isLoading)
                Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(child: CircularProgressIndicator()))
            ],
          );
        })));
  }
}

class _HeaderLogin extends StatelessWidget {
  final TextStyle estilo =
      GoogleFonts.cuteFont(textStyle: TextStyle(fontSize: 50));
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 200,
          child: Image.asset(
            'assets/realmelogo.png',
          ),
        ),
        Text('BIENVENIDO A', style: estilo),
        Text('TU CASA FITNESS', style: estilo),
      ],
    );
  }
}

class _UserLoginForm extends StatelessWidget {
  _UserLoginForm(this.loadingOption);
  LoadingOption loadingOption;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _UserForm(_usernameController),
          _PassForm(_passwordController),
          _BotonLogin(formKey, _usernameController, _passwordController)
        ],
      ),
    );
  }
}

class _BotonLogin extends StatelessWidget {
  TextEditingController _pwdCtrl;
  TextEditingController _uNameCtrl;
  final formKey;
  _BotonLogin(this.formKey, this._uNameCtrl, this._pwdCtrl);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Consumer<LoadingOption>(
          builder: (context, loadingOption, child) {
            return ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  loadingOption.isLoading = true;
                  LogIn login = LogIn(_uNameCtrl.text, _pwdCtrl.text);
                  String token = await login.enviarSolicitudLogin();
                  if (token.isNotEmpty) {
                    await LoginToken.setToken(token);
                    loadingOption.isLoading = false;
                    Navigator.popAndPushNamed(
                        _scaffoldKey.currentContext!, '/');
                  }
                }
              },
              child: Text('Ingresar'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                fixedSize: Size(double.infinity, 50),
              ),
            );
          },
        ));
  }
}

class _UserForm extends StatelessWidget {
  TextEditingController _usernameController;
  _UserForm(this._usernameController);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        controller: _usernameController,
        validator: ((value) {
          if (value!.isEmpty) {
            return 'Ingrese el nombre';
          }
          return null;
        }),
        onSaved: (value) {},
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            labelText: 'Usuario',
            hintText: 'Nombre de usuario',
            prefixIcon: Icon(Icons.person)),
      ),
    );
  }
}

class _PassForm extends StatelessWidget {
  TextEditingController _passwordController;
  _PassForm(this._passwordController);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
      child: TextFormField(
        controller: _passwordController,
        obscureText: true,
        validator: ((value) {
          if (value!.isEmpty) {
            return 'Ingrese la contraseña';
          }
          return null;
        }),
        onSaved: (value) {},
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            labelText: 'Contraseña',
            prefixIcon: Icon(Icons.password)),
      ),
    );
  }
}
