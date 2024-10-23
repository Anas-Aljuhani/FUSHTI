import 'dart:developer';

import 'package:customer_app/screen/plan/cubit/plan_cart_cubit/plan_cart_cubit.dart';
import 'package:customer_app/widget/button/custom_button.dart';
import 'package:customer_app/widget/container/add_plan_card.dart';
import 'package:customer_app/widget/container/pay_plan_bottom.dart';
import 'package:customer_app/widget/container/product_small_container.dart';
import 'package:customer_app/widget/devider/custom_dot_line.dart';
import 'package:customer_app/widget/row/cal_row.dart';
import 'package:customer_app/widget/row/item_details.dart';
import 'package:customer_app/widget/row/plan_date_row.dart';
import 'package:flutter/material.dart';
import 'package:get_all_pkg/data/model/plan_model.dart';
import 'package:get_all_pkg/get_all_pkg.dart';

class PlanCartScreen extends StatelessWidget {
  final PlanModel planModel;

  const PlanCartScreen({super.key, required this.planModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlanCartCubit(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Builder(builder: (context) {
          final cubit = context.read<PlanCartCubit>();
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'دفع الخطة',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
              ),
              centerTitle: true,
              actions: [
                Image.asset('assets/image/homeicon.png'),
                SizedBox(
                  width: 2.h,
                )
              ],
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffFEFEFD), Color(0xffE0D1BB)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    )),
              ),
            ),
            body: Center(
              child: Column(
                children: [
                  BlocBuilder<PlanCartCubit, PlanCartState>(
                    builder: (context, state) {
                      return TableCalendar(
                        rangeStartDay: cubit.startDate,
                        rangeEndDay: cubit.endDate,
                        headerVisible: false,
                        locale: 'en_US',
                        firstDay: DateTime.now(),
                        lastDay: DateTime(2024, 12, 31),
                        focusedDay: cubit.focusedDay, // Managed by Cubit

                        selectedDayPredicate: (day) {
                          // Use this to determine which day is currently selected.

                          return isSameDay(cubit.focusedDay, day);
                        },

                        onDaySelected: (selectedDay, focusedDay) {
                          cubit.focusedDay = selectedDay;

                          log("${cubit.focusedDay}");

                          cubit.upDateDate();
                        },
                        rangeSelectionMode: RangeSelectionMode
                            .toggledOn, // Enable range selection

                        calendarFormat:
                            CalendarFormat.week, // Show single row (week)
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        onRangeSelected: (start, end, focusedDay) {
                          cubit.dateRange(
                              start: start, end: end, day: focusedDay);
                        },
                        enabledDayPredicate: (day) {
                          bool isWeekend = day.weekday == DateTime.saturday ||
                              day.weekday == DateTime.sunday;

                          bool isHoliday = cubit.holidays.any((holiday) =>
                              holiday.year == day.year &&
                              holiday.month == day.month &&
                              holiday.day == day.day);

                          return !isWeekend && !isHoliday;
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    'الخطة',
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 37.h,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: BlocBuilder<PlanCartCubit, PlanCartState>(
                        builder: (context, state) {
                          return Column(
                            children: List.generate(
                              planModel.mealPlanItemLis.length,
                              (index) {
                                return AddPlanCard(
                                  productName: planModel.mealPlanItemLis[index]
                                      .foodMenuModel.foodName,
                                  cal: planModel
                                      .mealPlanItemLis[index].foodMenuModel.cal
                                      .toString(),
                                  price: planModel.mealPlanItemLis[index]
                                      .foodMenuModel.price
                                      .toString(),
                                  quantity: planModel
                                      .mealPlanItemLis[index].quantity
                                      .toString(),
                                  imagePath: 'assets/image/boxImage.png',
                                  onAdd: () {
                                    cubit.onAdd(
                                        mealPlanItemModel:
                                            planModel.mealPlanItemLis[index]);
                                  },
                                  onMinus: () {
                                    cubit.onMinus(
                                        mealPlanItemModel:
                                            planModel.mealPlanItemLis[index]);
                                  },
                                  withoutDelete: true,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const CustomDotLine(),
                  SizedBox(
                    height: 1.h,
                  ),
                  SizedBox(
                    height: 22.h,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            const Text('الطلبات'),
                            SizedBox(
                              height: 1.h,
                            ),
                            //coulmn for order
                            const Column(
                              children: [
                                ItemDetails(
                                  productName: 'بوكس السعادة',
                                  price: '12',
                                  quantity: '2',
                                ),
                                ItemDetails(
                                  productName: 'بوكس السعادة',
                                  price: '12',
                                  quantity: '2',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            PlanDateRow(
                              startDate: '2024/10/5',
                              endDate: '2024/10/9',
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Row(
                              children: [
                                Text(
                                  'عدد الأيام',
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                                Spacer(),
                                Text(
                                  '4 أيام',
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            CalRow(
                              totalCal: '120',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  PayPlanBottom(
                    totalPrice: '24',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
