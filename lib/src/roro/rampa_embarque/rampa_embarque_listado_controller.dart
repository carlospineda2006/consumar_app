import 'package:consumar_app/models/roro/rampa_descarga/sp_rampa_descarga_listado_model.dart';
import 'package:consumar_app/services/roro/rampa_embarque/rampa_embarque_services.dart';
import 'package:get/get.dart';

class RampaEmbarqueListadoController extends GetxController {
  RampaEmbarqueService rampaEmbarqueService = RampaEmbarqueService();
  //BigInt
  RxList<SpRampaDescargaListadoModel> listadoRampaEmbarque =
      <SpRampaDescargaListadoModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    //ListarRampaDescarga(serviceOrder: idServiceOrder);
  }

  Future<void> ListarRampaDescarga({required BigInt serviceOrder}) async {
    isLoading.value = true;
    try {
      var response = await rampaEmbarqueService
          .getVwRampaEmbarqueListadoPorServiceOrder(serviceOrder);
      listadoRampaEmbarque.value = response;
      isLoading.value = false;
    } catch (e) {}
  }
}
