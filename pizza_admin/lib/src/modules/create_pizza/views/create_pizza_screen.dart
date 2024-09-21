import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pizza_admin/src/components/macro.dart';
import 'package:pizza_admin/src/components/my_text_field.dart';
import 'package:pizza_admin/src/modules/create_pizza/blocs/create_pizza_bloc/create_pizza_bloc.dart';
import 'package:pizza_admin/src/modules/create_pizza/blocs/upload_picture_bloc/upload_picture_bloc.dart';
import 'package:pizza_admin/src/routes/routes.dart';
import 'package:pizza_repository/pizza_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreatePizzaScreen extends StatefulWidget {
  const CreatePizzaScreen({super.key});

  @override
  State<CreatePizzaScreen> createState() => _CreatePizzaScreenState();
}

class _CreatePizzaScreenState extends State<CreatePizzaScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();

  final calorieController = TextEditingController();
  final proteinController = TextEditingController();
  final fatController = TextEditingController();
  final carbsController = TextEditingController();

  bool creationRequired = false;

  final _formKey = GlobalKey<FormState>();
  String? _errorMsg;
  late Pizza pizza;

  @override
  void initState() {
    pizza = Pizza.empty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UploadPictureBloc, UploadPictureState>(
          listener: (context, state) {
            if (state is UploadPictureLoading) {
            } else if (state is UploadPictureSuccess) {
              setState(() {
                pizza.picture = state.url;
              });
            }
          },
        ),
        BlocListener<CreatePizzaBloc, CreatePizzaState>(
          listener: (context, state) {
            if (state is CreatePizzaSuccess) {
              setState(() {
                creationRequired = false;
                context.go('/');
              });
              context.go('/');
            } else if (state is CreatePizzaLoading) {
              setState(() {
                creationRequired = true;
              });
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create a New Pizza !',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxHeight: 1000,
                      maxWidth: 2000,
                    );
                    if (image != null && context.mounted) {
                      context.read<UploadPictureBloc>().add(
                            UploadPicture(
                              await image.readAsBytes(),
                              basename(image.path),
                            ),
                          );
                    }
                  },
                  child: pizza.picture.isNotEmpty
                      ? Ink(
                          width: 400,
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(pizza.picture),
                            ),
                          ),
                        )
                      : Ink(
                          width: 400,
                          height: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo,
                                size: 150,
                                color: Colors.grey.shade200,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              const Text(
                                'Add a Picture here..',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300.0,
                        child: MyTextField(
                          controller: nameController,
                          hintText: 'Name',
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          errorMsg: _errorMsg,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please fill in this field';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300.0,
                        child: MyTextField(
                          controller: descriptionController,
                          hintText: 'Description',
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          errorMsg: _errorMsg,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please fill in this field';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: Row(
                          children: [
                            Expanded(
                              child: MyTextField(
                                controller: priceController,
                                hintText: 'Price',
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                errorMsg: _errorMsg,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: MyTextField(
                                controller: discountController,
                                hintText: 'Discount',
                                suffixIcon: const Icon(
                                  Icons.percent,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                errorMsg: _errorMsg,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Is Veg :'),
                          const SizedBox(
                            width: 10,
                          ),
                          Checkbox(
                            value: pizza.isVeg,
                            onChanged: (value) {
                              setState(() {
                                pizza.isVeg = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text('Is Spicy :'),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              setState(() {
                                pizza.spicy = 1;
                              });
                            },
                            child: Ink(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                                border: pizza.spicy == 1
                                    ? Border.all(width: 2)
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              setState(() {
                                pizza.spicy = 2;
                              });
                            },
                            child: Ink(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange,
                                  border: pizza.spicy == 2
                                      ? Border.all(width: 2)
                                      : null),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              setState(() {
                                pizza.spicy = 3;
                              });
                            },
                            child: Ink(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                  border: pizza.spicy == 3
                                      ? Border.all(width: 2)
                                      : null),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Macros'),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 400,
                        child: Row(
                          children: [
                            MacroWidget(
                              controller: calorieController,
                              title: 'Calories',
                              value: 23,
                              icon: FontAwesomeIcons.fire,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            MacroWidget(
                                controller: proteinController,
                                title: 'Protein',
                                value: 11,
                                icon: FontAwesomeIcons.dumbbell),
                            const SizedBox(
                              width: 10,
                            ),
                            MacroWidget(
                              controller: fatController,
                              title: 'Fat',
                              value: 20,
                              icon: FontAwesomeIcons.oilWell,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            MacroWidget(
                              controller: carbsController,
                              title: 'Carbs',
                              value: 35,
                              icon: FontAwesomeIcons.breadSlice,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                !creationRequired
                    ? SizedBox(
                        width: 400,
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                pizza.name = nameController.text;
                                pizza.description = descriptionController.text;
                                pizza.price = int.parse(priceController.text);
                                pizza.discount =
                                    int.parse(discountController.text);
                                pizza.macros.calories =
                                    int.parse(calorieController.text);
                                pizza.macros.proteins =
                                    int.parse(proteinController.text);
                                pizza.macros.fat =
                                    int.parse(fatController.text);
                                pizza.macros.carbs =
                                    int.parse(carbsController.text);
                              });

                              print(pizza.toString());
                              context
                                  .read<CreatePizzaBloc>()
                                  .add(CreatePizza(pizza));
                            }
                          },
                          style: TextButton.styleFrom(
                            elevation: 3.0,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Text(
                              'Create new Pizza',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
