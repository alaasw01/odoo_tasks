import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odoo_task/models/partners.dart';
import 'package:odoo_task/services/odoo_api_service.dart';
import 'package:odoo_task/services/partner_services.dart';
import 'package:odoo_task/views/partners/cubit/partners_state.dart';

class PartnerCubit extends Cubit<PartnerState> {
  PartnerCubit(this.api) : super(PartnerInitial());
  final OdooApiService api;
  List<Partner> partners = [];
  int? uid;

  Future<void> fetchPartners() async {
    try {
      emit(PartnerLoading());

      uid = await api.authenticate();
      if (uid == 0) {
        debugPrint('Authentication failed');
      }
      partners = await getPartners(uid ?? 0);
      emit(PartnerSuccess());
    } catch (e) {
      emit(PartnerError(e.toString()));
    }
  }

  createPrtner() async {
    await createPartnerApi(
      uId: uid ?? 0,
      name: 'Sama Osama',
      email: 'so@gmail.com',
      phone: '01025888215',
    );
    await fetchPartners();
  }

  editPrtner() async {
    await updatePartnerApi(
      partnerId: 11, // partnerId
      uId: uid ?? 0,
      name: 'Sama Osama',
      email: 'soma@gmail.com',
      phone: '0105556888',
    );
    await fetchPartners();
  }

  deletePartner() async {
    bool isDelete = await deletePartnerApi(uId: uid ?? 0, partnerId: 8);
    if (isDelete == true) {
      await fetchPartners();
    } else {
      debugPrint('error to delete partner');
    }
  }
}
