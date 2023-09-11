import 'package:bindworks_test_app/entities/item.dart';
import 'package:bindworks_test_app/services/clip_board_services.dart';
import 'package:bindworks_test_app/theme/theme.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_strength/password_strength.dart';

typedef ItemCallback = Function(Item item);

class DetailDialog extends StatefulWidget {
  final String title;
  final ItemCallback callback;
  final Item? item;

  const DetailDialog(
      {required this.title, required this.callback, this.item, super.key});

  @override
  State<DetailDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<DetailDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      loadData(widget.item!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loadData(Item item) {
    _nameController.text = item.name;
    _usernameController.text = item.userName;
    _passwordController.text = item.password;
  }

  void copy() {
    FlutterClipboard.copy('copy');
  }

  bool showPassword = false;
  double percentage = 0.0;
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: context.colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: padding16, vertical: padding20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Name',
                  suffixIcon: IconButton(
                    icon: const Icon(
                      FluentIcons.copy_16_regular,
                    ),
                    onPressed: () {},
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
                focusNode: _nameFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_usernameFocusNode);
                },
              ),
              TextFormField(
                controller: _usernameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Username',
                  suffixIcon: IconButton(
                    icon: const Icon(
                      FluentIcons.copy_16_regular,
                    ),
                    onPressed: () {},
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Username cannot be empty';
                  }
                  return null;
                },
                focusNode: _usernameFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
              TextFormField(
                controller: _passwordController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(showPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            FluentIcons.copy_16_regular,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
                obscureText: !showPassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  /*   if (value.length < 8) {
                    return 'Heslo musí mít alespoň 8 znaků';
                  }
                  if (!RegExp(r'[A-Z]').hasMatch(value) ||
                      !RegExp(r'[a-z]').hasMatch(value) ||
                      !RegExp(r'[0-9]').hasMatch(value) ||
                      !RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
                    return 'Heslo musí obsahovat velká a malá písmena, číslice a speciální znaky';
                  }*/
                  return null;
                },
                onChanged: (password) {
                  setState(
                    () {
                      percentage = estimatePasswordStrength(password);
                    },
                  );
                },
                focusNode: _passwordFocusNode,
                onFieldSubmitted: (_) {
                  _passwordFocusNode.unfocus();
                },
              ),
              verticalMargin16,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: borderRadius100,
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 8,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.lerp(Colors.red, Colors.green, percentage)!,
                      ),
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  verticalMargin12,
                  Text(
                    'Síla hesla: ${(percentage * 100).round().toInt()}%',
                    style: TextStyle(
                      color: Color.lerp(Colors.red, Colors.green, percentage),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  horizontalMargin16,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final newItem = Item(
                            name: _nameController.text,
                            userName: _usernameController.text,
                            password: _passwordController.text,
                          );
                          widget.callback(newItem);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
