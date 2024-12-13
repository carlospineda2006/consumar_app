import 'package:consumar_app/services/roro/rampa_embarque/rampa_embarque_services.dart';
import 'package:get/get.dart';

class RampaEmbarqueListadoController extends GetxController {
  RampaEmbarqueService rampaEmbarqueService = RampaEmbarqueService();
  //BigInt

  @override
  void onInit() {
    super.onInit();
    //ListarRampaDescarga(serviceOrder: idServiceOrder);
  }

  Future<void> ListarRampaDescarga({required BigInt serviceOrder}) async {
    try {
      // var response = await rampaDescargaServices
      //     .getVwRampaDescargaListadoPorServiceOrder(serviceOrder);
      // listadoRampaDescarga.value = response;
    } catch (e) {}
  }
}
