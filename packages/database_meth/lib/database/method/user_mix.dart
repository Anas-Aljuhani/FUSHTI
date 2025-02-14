import 'package:database_meth/database/super_main.dart';
import 'package:get_all_pkg/data/model/app_model.dart';
import 'package:get_all_pkg/data/model/child_model.dart';
import 'package:get_all_pkg/data/model/user_model.dart';
import 'package:get_all_pkg/data/setup.dart';

mixin UserMix {
  updateChildOpenDay(
      {required double limtFunds,
      required ChildModel childModel,
      required isOpen}) async {
    try {
      await SuperMain().supabase.from("followers").update({
        "daily_limit": limtFunds,
        "is_open_day": isOpen,
      }).eq("id", childModel.id);
    } catch (er) {}
  }

  addfundsChild({required double funds, required ChildModel childModel}) async {
    try {
      AppModel appModel = getIt.get<AppModel>();
      await SuperMain().supabase.rpc("decrement_funds",
          params: {"user_id": appModel.userModel!.id, "amount": funds});

      await SuperMain().supabase.rpc("child_incrment_funds",
          params: {"p_user_id": childModel.id, "p_amount": funds});
    } catch (er) {
      rethrow;
    }
  }

  updateUserProfile(
      {required String name, required String phone, required String id}) async {
    try {
      await SuperMain()
          .supabase
          .from('users')
          .update({'name': name, 'phone': phone})
          .eq('id', id)
          .select();
    } catch (e) {}
  }

  updateUserProfileImage({required String id, required String imageUrl}) async {
    try {
      final test = await SuperMain()
          .supabase
          .from('users')
          .update({
            'image_url': imageUrl,
          })
          .eq('id', id)
          .select();
    } catch (e) {}
  }

  getUser({required String id}) async {
    try {
      final response = await SuperMain()
          .supabase
          .from('users')
          .select()
          .eq('id', id)
          .single();
      UserModel user = UserModel.fromJson(response);
      return user;
    } catch (e) {}
  }

  updateFunds(
      {required String userId,
      required double funds,
      required double oldFund}) async {
    try {
      final res = await SuperMain()
          .supabase
          .from('users')
          .update({'funds': funds + oldFund})
          .eq('id', userId)
          .select();
    } catch (e) {}
  }

  sendSuggestion(
      {required String senderName,
      required String content,
      required String schoolId}) async {
    try {
      final res = await SuperMain().supabase.from('help_center').insert({
        'sender_name': senderName,
        'school_id': schoolId,
        'message': content
      }).select();
    } catch (e) {}
  }

  getSuggestion({required String schoolId}) async {
    try {
      final res = await SuperMain()
          .supabase
          .from('help_center')
          .select()
          .eq('school_id', schoolId);

      return res;
    } catch (e) {}
  }

  getBestThreeProduct() async {
    try {
      final res =
          await SuperMain().supabase.rpc('get_top_three_products').select();
      return res;
    } catch (e) {}
  }
}
