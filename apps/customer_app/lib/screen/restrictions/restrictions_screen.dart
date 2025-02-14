import 'package:customer_app/screen/restrictions/cubit/restrictions_cubit.dart';
import 'package:customer_app/widget/container/restriction_card.dart';
import 'package:customer_app/widget/coulmn/empty_space_column.dart';
import 'package:flutter/material.dart';
import 'package:get_all_pkg/get_all_pkg.dart';

class RestrictionsScreen extends StatelessWidget {
  final String childId;
  const RestrictionsScreen({super.key, required this.childId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestrictionsCubit(),
      child: Builder(builder: (context) {
        final cubit = context.read<RestrictionsCubit>();
        cubit.getRestrictionFoodList(childId: childId);
        return BlocListener<RestrictionsCubit, RestrictionsState>(
          listener: (context, state) {
            if (state is LoadingState) {
              showLoadingDialog(context: context);
            }
            if (state is SuccessDeleteState) {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.msg),
                backgroundColor: Colors.green,
              ));
            }
            if (state is ErrorState) {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.msg),
                backgroundColor: Colors.red,
              ));
            }
          },
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
                title: Text(
                  'الوجبات المحظورة',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                centerTitle: true,
                flexibleSpace: Container(
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
              body: Column(
                children: [
                  SizedBox(
                    height: 77.h,
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                      child: BlocBuilder<RestrictionsCubit, RestrictionsState>(
                        builder: (context, state) {
                          return cubit.restrictionsFood.isNotEmpty
                              ? Column(
                                  children: List.generate(
                                  cubit.restrictionsFood.length,
                                  (index) => RestrictionCard(
                                    productName:
                                        cubit.foodMenuModelList[index].foodName,
                                    cal: cubit.foodMenuModelList[index].cal
                                        .toString(),
                                    imagePath: 'assets/image/boxImage.png',
                                    price: cubit.foodMenuModelList[index].price
                                        .toString(),
                                    onDelete: () {
                                      QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.confirm,
                                          text: 'هل انت متأكد',
                                          confirmBtnText: 'نعم',
                                          cancelBtnText: 'لا',
                                          confirmBtnColor: Colors.green,
                                          onCancelBtnTap: () =>
                                              Navigator.pop(context),
                                          onConfirmBtnTap: () {
                                            cubit.deleteRestrictionFood(
                                                productId: cubit
                                                    .restrictionsFood[index]
                                                    .menuItemId);
                                            cubit.getRestrictionFoodList(
                                                childId: childId);
                                          });
                                    },
                                  ),
                                ))
                              : const Center(
                                  child: EmptySpaceColumn(
                                      msg: 'ليس هناك اي وجبات محظورة'));
                        },
                      ),
                    ),
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
