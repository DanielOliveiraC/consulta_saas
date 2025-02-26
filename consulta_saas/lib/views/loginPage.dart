import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consulta_saas/services/authServices.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final senha = TextEditingController();
  final nome = TextEditingController();
  final specialty = TextEditingController();

  bool isLogin = true;
  bool isDoctor = false;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'Bem vindo';
        actionButton = 'Login';
        toggleButton = 'Ainda não tem conta? Cadastre-se agora.';
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao Login.';
      }
    });
  }

  login() async {
    setState(() => loading = true);
    try {
      print('Attempting login with email: ${email.text}'); // Debug print
      await context.read<Authservices>().login(email.text, senha.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  registrar() async {
    if (formKey.currentState!.validate()) {
      setState(() => loading = true);
      try {
        print('Registering user:'); // Debug prints
        print('Email: ${email.text}');
        print('Name: ${nome.text}');
        print('Is Doctor: $isDoctor');
        if (isDoctor) print('Specialty: ${specialty.text}');

        if (isDoctor) {
          await context.read<Authservices>().registerDoctor(
                email.text,
                senha.text,
                nome.text,
                specialty.text,
              );
        } else {
          await context.read<Authservices>().registerPatient(
                email.text,
                senha.text,
                nome.text,
              );
        }
      } on AuthException catch (e) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      if (!isLogin)
                        TextFormField(
                          controller: nome,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nome',
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Informe o nome corretamente!';
                            }
                            return null;
                          },
                        ),
                      if (!isLogin) SizedBox(height: 10),
                      TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe o email corretamente!';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: senha,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Senha',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informa sua senha!';
                          } else if (value.length < 6) {
                            return 'Sua senha deve ter no mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      if (!isLogin)
                        Column(
                          children: [
                            SizedBox(height: 10),
                            CheckboxListTile(
                              title: Text("Registrar como médico"),
                              subtitle: Text(isDoctor 
                                ? "Você será registrado como médico"
                                : "Marque esta opção se você é um médico"),
                              value: isDoctor,
                              onChanged: (bool? value) {
                                setState(() {
                                  isDoctor = value ?? false;
                                });
                              },
                            ),
                            if (isDoctor) ...[
                              SizedBox(height: 10),
                              TextFormField(
                                controller: specialty,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Especialização',
                                ),
                                validator: (value) {
                                  if (isDoctor && (value == null || value.isEmpty)) {
                                    return 'Informe a especialização!';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ],
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (isLogin) {
                              login();
                            } else {
                              registrar();
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: (loading)
                              ? [
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ]
                              : [
                                  Icon(Icons.check),
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      actionButton,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => setFormAction(!isLogin),
                        child: Text(toggleButton),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
