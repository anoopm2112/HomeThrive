import 'package:fostershare/app/locator.dart';
import 'package:fostershare/app/router/app_router.gr.dart';
import 'package:fostershare/core/models/data/support_service/support_service.dart';
import 'package:fostershare/core/models/input/get_support_services_input/get_support_services_input.dart';
import 'package:fostershare/core/models/input/pagination_input/pagination_input.dart';
import 'package:fostershare/core/models/response/get_support_services_response/get_support_services_response.dart';
import 'package:fostershare/core/services/navigation_service.dart';
import 'package:fostershare/core/services/support_service_service.dart';
import 'package:stacked/stacked.dart';

class SupportServicesViewModel extends BaseViewModel {
  final _supportServiceService = locator<SupportServiceService>();
  final _navigationService = locator<NavigationService>();

  int _limit = 10;
  GetSupportServicesResponse _getSupportServicesResponse;
  List<SupportService> supportServices = [];
  int get totalCount => _getSupportServicesResponse.pageInfo.count;
  bool _loading = false;

  Future<void> onModelReady() async {
    setBusy(true);
    await _loadSupportServices();
    setBusy(false);
  }

  onTileCreated(int index) async {
    if (index <= supportServices.length - 5) {
      // Load at 5 images before end
      return;
    }
    if (supportServices.length >= _getSupportServicesResponse.pageInfo.count) {
      return;
    }
    if (_getSupportServicesResponse.pageInfo.hasNextPage == false) {
      return;
    }
    if (_loading) {
      return;
    }
    await _loadSupportServices();
    notifyListeners();
  }

  onTileTap(String supportServiceId) async {
    await _navigationService.navigateTo(
      Routes.supportServiceView,
      arguments:
          SupportServiceViewArguments(supportServiceId: supportServiceId),
    );
  }

  _loadSupportServices() async {
    _loading = true;
    var result = await _supportServiceService.getSupportServices(
      GetSupportServicesInput(
        pagination: PaginationInput(
          cursor: this._getSupportServicesResponse?.pageInfo?.cursor,
          limit: this._limit,
        ),
      ),
    );
    _getSupportServicesResponse = result;
    supportServices.addAll(result.items);
    _loading = false;
  }
}
