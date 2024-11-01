import 'package:flex/controllers/auth_controller.dart';
import 'package:flex/routes/route_names.dart';
import 'package:flex/utils/helper.dart';
import 'package:flex/widgets/auth_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController(text: "");
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passwordController =
      TextEditingController(text: "");
  final TextEditingController confirmPasswordController =
      TextEditingController(text: "");
  final AuthController controller = Get.put(AuthController());

// Submit method >>
  void submit() {
    showSnackBar("Success", "Hey there!, im testing");
    if (_form.currentState!.validate()) {
      controller.register(
          nameController.text, emailController.text, passwordController.text);
    }
  }
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Image.asset(
                    "assets/image/logo.png",
                    width: 68.25,
                    height: 57.25,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Register",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        Text("Welcome to Flex!"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  AuthInput(
                    label: "Name",
                    hintText: "Enter your Name (Shall be Arabic)",
                    controller: nameController,
                    validatorCallback: ValidationBuilder()
                        .required()
                        .minLength(3)
                        .maxLength(50)
                        .build(),
                  ),
                  const SizedBox(height: 20),
                  AuthInput(
                    label: "Email",
                    hintText: "Enter your Email:",
                    controller: emailController,
                    validatorCallback:
                        ValidationBuilder().required().email().build(),
                  ),
                  const SizedBox(height: 20),
                  AuthInput(
                    label: "Password",
                    hintText: "Enter your password",
                    isPasswordField: true,
                    controller: passwordController,
                    validatorCallback: ValidationBuilder()
                        .required()
                        .minLength(6)
                        .maxLength(30)
                        .build(),
                  ),
                  const SizedBox(height: 20),
                  AuthInput(
                    label: "Confirm Password",
                    hintText: "Confirm your password",
                    isPasswordField: true,
                    controller: confirmPasswordController,
                    validatorCallback: (arg) {
                      if (passwordController.text != arg) {
                        return "The passwords are not matched!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => ElevatedButton(
                      onPressed: submit,
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                          const Size.fromHeight(40),
                        ),
                      ),
                      child: Text(controller.registerLoading.value
                          ? "Processing..."
                          : "Submit"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: "Login",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.toNamed(RouteNames.login),
                    ),
                  ], text: "Already have an account?   "))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
