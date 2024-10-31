import 'dart:developer';

import 'package:customer_app/screen/home/cubit/home_cubit.dart';
import 'package:customer_app/screen/order_cart/order_cart_screen.dart';
import 'package:customer_app/screen/product/product_screen.dart';
import 'package:customer_app/widget/avatar/followers_avatar.dart';
import 'package:customer_app/widget/container/home_card.dart';
import 'package:customer_app/widget/container/screen_header.dart';
import 'package:customer_app/widget/coulmn/child_avatar.dart';
import 'package:customer_app/widget/row/app_bar_row_button.dart';
import 'package:flutter/material.dart';
import 'package:get_all_pkg/get_all_pkg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<HomeCubit>();
        cubit.initHome();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wallet,
                  color: Colors.white,
                ),
                Text(
                  '${cubit.appModel.userModel?.funds.toString()}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderCartScreen(childModel: HomeCubit.currentChild),
                      )),
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  )),
            ],
            title: Image.asset('assets/image/mainLogo.png'),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const ShapeDecoration(
                shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius.only(
                  bottomLeft:
                      SmoothRadius(cornerRadius: 50, cornerSmoothing: 0.1),
                  bottomRight:
                      SmoothRadius(cornerRadius: 50, cornerSmoothing: 0.1),
                )),
                color: Color(0xff6FBAE5),
              ),
            ),
            toolbarHeight: 15.h,
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 1.h,
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التابعين',
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.w500),
                        ),
                        BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                  cubit.childModelList.length,
                                  (index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: FollowersAvatar(
                                        onTap: () {
                                          log("chnageChild start");
                                          cubit.chnageChild(
                                              cubit.childModelList[index]);
                                        },
                                        childImage: 'assets/image/kid1.png',
                                        childName:
                                            cubit.childModelList[index].name,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          'الأفضل مبيعا',
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                        BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: List.generate(
                                  HomeCubit.currentChild.schoolModel
                                      .foodMenuModelList.length,
                                  (index) {
                                    return OldHomeCard(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) {
                                            return ProductScreen(
                                              childModel:
                                                  HomeCubit.currentChild,
                                              foodMenuModel: HomeCubit
                                                  .currentChild
                                                  .schoolModel
                                                  .foodMenuModelList[index],
                                            );
                                          },
                                        ));
                                      },
                                      onRestriction: !cubit
                                              .checkRestrictionsFood(
                                                  productId: HomeCubit
                                                      .currentChild
                                                      .schoolModel
                                                      .foodMenuModelList[index]
                                                      .id)
                                          ? () {
                                              cubit.addToRestrictionsFood(
                                                  childId:
                                                      HomeCubit.currentChild.id,
                                                  productId: HomeCubit
                                                      .currentChild
                                                      .schoolModel
                                                      .foodMenuModelList[index]
                                                      .id);
                                            }
                                          : null,
                                      cal: HomeCubit.currentChild.schoolModel
                                          .foodMenuModelList[index].cal,
                                      imagePath: cubit.checkRestrictionsFood(
                                              productId: HomeCubit
                                                  .currentChild
                                                  .schoolModel
                                                  .foodMenuModelList[index]
                                                  .id)
                                          ? 'assets/image/no.png'
                                          : 'assets/image/lez.png',
                                      itemName: HomeCubit
                                          .currentChild
                                          .schoolModel
                                          .foodMenuModelList[index]
                                          .foodName,
                                      price: HomeCubit
                                          .currentChild
                                          .schoolModel
                                          .foodMenuModelList[index]
                                          .price as double,
                                      rate: '4.8',
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        const Text(
                          'البوكسات',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              HomeCard(),
                              OldHomeCard(
                                cal: 30,
                                imagePath: 'assets/image/lez.png',
                                itemName: 'بوكس السعادة',
                                price: 2,
                                rate: '4.8',
                              ),
                              OldHomeCard(
                                cal: 30,
                                imagePath: 'assets/image/lez.png',
                                itemName: 'بوكس التغذية',
                                price: 2,
                                rate: '4.8',
                              ),
                              OldHomeCard(
                                cal: 30,
                                imagePath: 'assets/image/lez.png',
                                itemName: 'بوكس المفرحات',
                                price: 2,
                                rate: '4.8',
                              ),
                              OldHomeCard(
                                cal: 30,
                                imagePath: 'assets/image/lez.png',
                                itemName: 'ليز',
                                price: 2,
                                rate: '4.8',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  const Text(
                    'الوجبات',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OldHomeCard(
                          cal: 30,
                          imagePath: 'assets/image/lez.png',
                          itemName: 'ليز',
                          price: 2,
                          rate: '4.8',
                        ),
                        OldHomeCard(
                          cal: 30,
                          imagePath: 'assets/image/lez.png',
                          itemName: 'ليز',
                          price: 2,
                          rate: '4.8',
                        ),
                        OldHomeCard(
                          cal: 30,
                          imagePath: 'assets/image/lez.png',
                          itemName: 'ليز',
                          price: 2,
                          rate: '4.8',
                        ),
                        OldHomeCard(
                          cal: 30,
                          imagePath: 'assets/image/lez.png',
                          itemName: 'ليز',
                          price: 2,
                          rate: '4.8',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.w,
      width: 35.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 35.w,
            height: 35.w,
            padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 1.w),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(15),
                boxShadow: kElevationToShadow[8]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Text(
                  'لوزين',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 1.w,),
                Text(
                  '18 رس',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    Text(
                      '30',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0x50000000)),
                    ),
                    Icon(LineAwesome.fire_alt_solid,
                        color: Color(0xffEC8743))
                  ],
                )
              ],
            ),
          ),
          Positioned(
              left: 12.w,
              bottom: 32.w,
              child: Image.asset(
                  'assets/image/lez.png')),
          Positioned(
              left: 27.w,
              bottom: 32.w,
              child: InkWell(
                onTap: () {},
                child: const Icon(
                    Icons.no_food_outlined,
                    color: Colors.red),
              )),
          Positioned(
            left: 3.w,
            bottom: 8.w,
            child: InkWell(
              onTap: () {
                log('add');
              },
              child: Container(
                width: 8.w,
                height: 7.w,
                decoration: BoxDecoration(
                    color: Color(0xffC9E7E7),
                    borderRadius:
                        BorderRadius.circular(6)),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
