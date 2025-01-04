import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:deliverapp/core/services/notification_service.dart';
import '../../core/colors.dart';
import '../../core/models/history_model.dart';
import '../../core/models/vehicle_list_model.dart';
import '../../core/services/api_service.dart';
import '../../widgets/order_history_card_widget.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({
    super.key,
  });
  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  bool success = false;
  OrderHistoryModel? historyList;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int skip = 0;
  final int limit = 10;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _getMoreData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Fetch paginated data
  Future<void> _getMoreData() async {
    if (isLoading || !hasMoreData) return;

    setState(() {
      isLoading = true;
    });

    // try {
    final response = await ApiService().getOrderHistory(
      skip: skip.toString(),
      limit: limit.toString(),
    );
    // debugPrint("order history List:::::::::: ${response['data'][0]['vehicleImage']}");

    if (response['success']) {
      OrderHistoryModel tempList = OrderHistoryModel.fromJson(response);

      setState(() {
        success = true;
        if (historyList == null) {
          historyList = tempList;
        } else {
          historyList!.data!.addAll(tempList.data!);
        }
        if (tempList.data!.length < limit) {
          hasMoreData = false;
        } else {
          skip += limit;
        }
      });
    } else {
      notificationService.showToast(context, response['message'],
          type: NotificationType.error);
    }
    setState(() {
      isLoading = false;
    });
  }

  /// Scroll listener to trigger pagination
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoading &&
        hasMoreData) {
      _getMoreData();
    }
  }

  /// Builds loading indicator for pagination
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : hasMoreData
                ? const SizedBox()
                : const Text("No more orders"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[200], // Example: lightWhiteColor
      body: success
          ? SafeArea(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(color: primaryColor),
                  ),
                  Positioned(
                    child: Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Orders",
                                  style: GoogleFonts.inter(
                                    color: Colors.black, // Example: pureBlack
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: historyList == null ||
                                        historyList!.data!.isEmpty
                                    ? const Center(
                                        child: Text(
                                          "No Orders",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        controller: _scrollController,
                                        itemCount: historyList!.data!.length +
                                            1, // Extra item for loader
                                        padding: EdgeInsets.zero,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index ==
                                              historyList!.data!.length) {
                                            return _buildProgressIndicator();
                                          }

                                          return ConnectHistoryListCardWidget(
                                              historyList:
                                                  historyList!.data![index]);
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
