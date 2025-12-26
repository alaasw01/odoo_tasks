import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_task/services/odoo_api_service.dart';
import 'package:odoo_task/views/partners/cubit/partners_cubit.dart';
import 'package:odoo_task/views/partners/cubit/partners_state.dart';

class PartnersView extends StatelessWidget {
  const PartnersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Partners')),
      body: BlocProvider(
        create: (context) => PartnerCubit(OdooApiService()),
        child: BlocBuilder<PartnerCubit, PartnerState>(
          builder: (context, state) {
            var cubit = context.read<PartnerCubit>();
            if (state is PartnerLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PartnerSuccess) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cubit.partners.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(cubit.partners[index].name),
                          subtitle: Text(cubit.partners[index].email ?? ''),
                          trailing: Text(cubit.partners[index].phone ?? ''),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue),
                      ),
                      onPressed: () {
                        context.read<PartnerCubit>().createPrtner();
                      },
                      child: const Text(
                        'create Partners',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.pink),
                      ),
                      onPressed: () {
                        context.read<PartnerCubit>().editPrtner();
                      },
                      child: const Text(
                        'edit Partners',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.deepOrange,
                        ),
                      ),
                      onPressed: () {
                        context.read<PartnerCubit>().deletePartner();
                      },
                      child: const Text(
                        'delete Partners',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is PartnerError) {
              return Center(child: Text(state.message));
            }

            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<PartnerCubit>().fetchPartners();
                },
                child: const Text('Load Partners'),
              ),
            );
          },
        ),
      ),
    );
  }
}
