import 'dart:developer';

import 'package:customer_app/screen/followers/order_plan/cubit/follower_order_plan_cubit.dart';

import 'package:customer_app/widget/history_widget/histoy_body_order_widget.dart';
import 'package:customer_app/widget/history_widget/histoy_body_plan_widgetd.dart';
import 'package:flutter/material.dart';
import 'package:get_all_pkg/data/model/child_model.dart';
import 'package:get_all_pkg/get_all_pkg.dart';

class FollowerOrderPlanScreen extends StatelessWidget {
  const FollowerOrderPlanScreen({super.key, required this.childModel});

  final ChildModel childModel;

  @override
  Widget build(BuildContext context) {
    //replace it with Bloc

    //replace it with Bloc order.length

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => FollowerOrderPlanCubit()
          ..historyBring()
          ..childModel = childModel,
        child: Builder(builder: (context) {
          final cubit = context.read<FollowerOrderPlanCubit>();

          return BlocListener<FollowerOrderPlanCubit, FollowerOrderPlanState>(
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
                    'سجل الطلبات',
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
                              buttonLables: const ["خطة", "طلبات"],
                              buttonValues: const ["plan", "order"],
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
                              horizontal: 2.w, vertical: 1.h),
                          child: BlocBuilder<FollowerOrderPlanCubit,
                              FollowerOrderPlanState>(
                            builder: (context, state) {
                              return cubit.isOrder == true
                                  ? HistoyBodyOrderWidget(
                                      childModel: cubit.childModel,
                                      lisOrder: cubit.lisOrder)
                                  : HistoyBodyPlanWidgetd(
                                      childModel: cubit.childModel,
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
