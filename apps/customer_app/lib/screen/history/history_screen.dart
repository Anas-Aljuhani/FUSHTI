import 'dart:developer';

import 'package:customer_app/screen/history/cubit/history_cubit.dart';
import 'package:customer_app/screen/product/cubit/product_cubit.dart';
import 'package:customer_app/widget/button/custom_button.dart';
import 'package:customer_app/widget/history_widget/bottom_info.dart';
import 'package:customer_app/widget/history_widget/content_history.dart';
import 'package:customer_app/widget/history_widget/histoy_body_order_widget.dart';
import 'package:customer_app/widget/history_widget/histoy_body_plan_widgetd.dart';
import 'package:flutter/material.dart';
import 'package:get_all_pkg/get_all_pkg.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //replace it with Bloc

    //replace it with Bloc order.length

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => HistoryCubit()..historyBring(),
        child: Builder(builder: (context) {
          final cubit = context.read<HistoryCubit>();

          return BlocListener<HistoryCubit, HistoryState>(
            listener: (context, state) {
              if (state is ErorrState) {
                Navigator.pop(context);
                showSnackBar(context: context, msg: state.msg, isError: true);
              }

              if (state is LodingState) {
                log("in lodaing");
                showLoadingDialog(context: context);
              }

              if (state is DoneState) {
                Navigator.pop(context);
                log("very good history");
              }
            },
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                  ),
                  title: Text(
                    'الفواتير',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  centerTitle: true,
                  flexibleSpace: Container(
                    //height: 15.h,
                    decoration: const BoxDecoration(
                      color: Color(0xff6FBAE5),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35),
                      ),
                    ),
                  ),
                  toolbarHeight: 11.h,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomRadioButton(
                              buttonTextStyle: ButtonTextStyle(
                                  selectedColor: Colors.black,
                                  unSelectedColor: Colors.black,
                                  textStyle: TextStyle(fontSize: 16.sp)),
                              enableShape: true,
                              elevation: 2,
                              customShape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              buttonLables: ["plan", "order"],
                              buttonValues: ["plan", "order"],
                              unSelectedColor: const Color(0xffffffff),
                              unSelectedBorderColor: Colors.grey,
                              selectedColor:
                                  const Color.fromARGB(56, 12, 154, 236),
                              defaultSelected: "order",
                              radioButtonValue: (p0) {
                                log(p0);
                                cubit.tabClick(tabName: p0);
                              },
                            )
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 2.h),
                          child: BlocBuilder<HistoryCubit, HistoryState>(
                            builder: (context, state) {
                              return cubit.isOrder == true
                                  ? HistoyBodyOrderWidget(
                                      lisOrder: cubit.lisOrder)
                                  : HistoyBodyPlanWidgetd(
                                      planLis: cubit.planLis);
                            },
                          )),
                    ],
                  ),
                )
                // : Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image.asset('assets/image/history_img.png'),
                //         SizedBox(
                //           height: 2.h,
                //         ),
                //         const Text(
                //           "ليس لديك طلبات :(",
                //           style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //               fontFamily: 'Rosarivo',
                //               color: Colors.black),
                //         ),
                //         CustomButton(onPressed: () {}, title: 'اطلب الأن'),
                //         SizedBox(
                //           height: 15.h,
                //         )
                //       ],
                //     ),
                //   ),
                ),
          );
        }),
      ),
    );
  }
}
