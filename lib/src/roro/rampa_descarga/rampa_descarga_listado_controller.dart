import 'package:consumar_app/models/roro/rampa_descarga/sp_rampa_descarga_listado_model.dart';
import 'package:consumar_app/services/roro/rampa_descarga/rampa_descarga_services.dart';
import 'package:get/get.dart';

class RampaDescargaListadoController extends GetxController {
  RampaDescargaServices rampaDescargaServices = RampaDescargaServices();
  late BigInt idServiceOrder;

  RxList<SpRampaDescargaListadoModel> listadoRampaDescarga =
      <SpRampaDescargaListadoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    //ListarRampaDescarga(serviceOrder: idServiceOrder);
  }

  Future<void> ListarRampaDescarga({required BigInt serviceOrder}) async {
    try {
      var response = await rampaDescargaServices
          .getVwRampaDescargaListadoPorServiceOrder(serviceOrder);
      listadoRampaDescarga.value = response;
    } catch (e) {}
  }
}
