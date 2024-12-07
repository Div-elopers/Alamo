import 'dart:developer';

import 'package:alamo/src/constants/app_sizes.dart';
import 'package:alamo/src/constants/departments.dart';
import 'package:alamo/src/features/auth/account/account_screen_controller.dart';
import 'package:alamo/src/features/auth/data/users_repository.dart';
import 'package:alamo/src/features/auth/domain/app_user.dart';
import 'package:alamo/src/features/auth/sign_in/email_password/email_password_validators.dart';
import 'package:alamo/src/widgets/custom_image.dart';
import 'package:alamo/src/widgets/dropdown_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_html/html.dart' as html;

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  // Initialize selectedUser as null
  AppUser? selectedUser;

  @override
  Widget build(BuildContext context) {
    final usersStream = ref.watch(usersListStreamProvider);
    final repository = ref.read(userRepositoryProvider);
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administración de Usuarios'),
      ),
      body: Stack(
        children: [
          width > 1400 ? buildDecorativeImages() : const SizedBox.shrink(),
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width / 5),
            child: Column(
              children: [
                usersStream.when(
                  data: (users) {
                    return StreamBuilder<List<AppUser>>(
                      stream: Stream.value(users),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(child: Text('No hay usuarios disponibles.'));
                        }

                        final users = snapshot.data as List<AppUser>;
                        return Center(
                          child: DataTable(
                            columnSpacing: 12,
                            columns: const [
                              DataColumn(label: Text('Nombre')),
                              DataColumn(label: Text('Correo')),
                              DataColumn(label: Text('Correo verificado')),
                              DataColumn(label: Text('Número verificado')),
                              DataColumn(label: Text('Departamento')),
                              DataColumn(label: Text('Foto de perfil')),
                              DataColumn(label: Text('Acciones')),
                            ],
                            rows: users.map((user) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(user.name),
                                  ),
                                  DataCell(Text(user.email!)),
                                  DataCell(
                                    Center(
                                      child: Icon(
                                        user.emailVerified ? Icons.check_circle : Icons.cancel,
                                        color: user.emailVerified ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Icon(
                                        user.phoneVerified ? Icons.check_circle : Icons.cancel,
                                        color: user.phoneVerified ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(user.department ?? 'N/A'),
                                  ),
                                  DataCell(
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (user.profileUrl.isNotEmpty) {
                                            html.window.open(user.profileUrl, '_blank');
                                          }
                                        },
                                        child: user.profileUrl != ''
                                            ? MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: Icon(
                                                  Icons.photo,
                                                  color: Colors.blue[300],
                                                ))
                                            : const Text(
                                                'N/A',
                                              ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () {
                                            setState(() {
                                              selectedUser = user;
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            // Add delete logic
                                            if (user.uid != "") {
                                              repository.deleteUser(user.uid);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) {
                    log(error.toString());
                    return Center(child: Text('Error: $error'));
                  },
                ),
                // Only show the edit form if there's a selected user
                if (selectedUser != null) _buildEditUserRow(context, selectedUser!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditUserRow(BuildContext context, AppUser user) {
    final validators = EmailAndPasswordValidators();

    final departmentController = TextEditingController(text: user.department);
    final phoneController = TextEditingController(text: user.phoneNumber);
    final controller = ref.watch(accountScreenControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editando a: ${user.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              gapH16,
              buildDropdownField(
                label: user.department ?? 'Departamento',
                controller: departmentController,
                items: uruguayDepartments,
                validator: (value) => validators.departmentErrorText(value!),
              ),
              gapH16,
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Número de telefono',
                  hintText: user.phoneNumber ?? 'Ingrese un número de telefono.',
                  border: const OutlineInputBorder(),
                ),
              ),
              gapH16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.updateManagedUser(
                          name: user.name,
                          phoneNumber: phoneController.text,
                          department: departmentController.text,
                          email: user.email!,
                          uid: user.uid);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Usuario modificado con éxito!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Actualizar'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Delete user logic here
                      controller.deleteAccount(user.uid);
                    },
                    child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
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
