import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_admin/src/modules/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'dart:html' as html;

class BaseScreen extends StatefulWidget {
  final Widget child;
  const BaseScreen(this.child, {super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          html.window.location.reload();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: kToolbarHeight,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            context.go('/home');
                          },
                          child: const Text(
                            'Pizza Admin',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: () {
                            context.go('/create');
                          },
                          child: const Text(
                            'Create a Pizza',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        context.read<SignInBloc>().add(SignOutRequired());
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(Icons.logout)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(child: widget.child)
          ],
        ),
      ),
    );
  }
}
