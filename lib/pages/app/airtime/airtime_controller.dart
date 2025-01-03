import 'package:get/get.dart';

class AirtimeController extends GetxController {
  final savedBeneficiaries = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Mock data - replace with actual data storage later
    savedBeneficiaries.addAll([
      {'name': 'John Doe', 'number': '08012345678'},
      {'name': 'Jane Smith', 'number': '08087654321'},
      {'name': 'Alice Johnson', 'number': '08011112222'},
    ]);
  }

  void addBeneficiary(String name, String number) {
    savedBeneficiaries.add({
      'name': name,
      'number': number,
    });
  }

  void removeBeneficiary(int index) {
    savedBeneficiaries.removeAt(index);
  }
}
