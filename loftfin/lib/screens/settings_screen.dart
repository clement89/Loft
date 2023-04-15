import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loftfin/providers/settings_provider.dart';
import 'package:loftfin/services/log_service.dart';
import 'package:loftfin/strings.dart';
import 'package:loftfin/style/app_theme.dart';
import 'package:loftfin/widgets/custom_appbar.dart';
import 'package:loftfin/widgets/custom_button.dart';
import 'package:loftfin/widgets/outline_textdield.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static String routeName = "/settings_perk";

  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode? signPerk;
  FocusNode? referee;
  FocusNode? focusNode1;
  FocusNode? focusNode2;
  @override
  void initState() {
    // TODO: implement initState
    context.read<SettingsProvider>().getAllSettings();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          // LoftMenu(),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                key: _scaffoldKey,
                //drawer: LoftMenu(),
                bottomNavigationBar: SizedBox(
                  height: size.height * AppTheme.footerHeight,
                  child: _footerWidget(),
                ),
                backgroundColor: Colors.white,
                appBar: _appBar(),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _buildBody(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        dPrint('updating...');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                Text(
                  'Enable Waitlist',
                  style: TextStyle(fontSize: 16.0),
                ), //Text
                SizedBox(width: 10), //SizedBox
                /** Checkbox Widget **/
                Checkbox(
                  value: settings.byPassWaitList,
                  onChanged: (bool? value) {
                    settings.updateByPassWaitList();
                  },
                ), //Checkbox
              ], //<Widget>[]
            ), //Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: OutlineTextField(
                title: 'Referral Rewards',
                isError: settings.refError,
                keyboardType: TextInputType.name,
                controller: settings.refPerkController,
                // defaultValue: settings.refPerk,
                nextFocusNode: referee,
                type: TextType.text,
                validator: isNumeric,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: OutlineTextField(
                title: 'Referee Perks',
                isError: settings.refereeError,
                keyboardType: TextInputType.name,
                controller: settings.refereeController,
                // defaultValue: settings.referee,
                focusNode: referee,
                nextFocusNode: signPerk,
                type: TextType.text,
                validator: isNumeric,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: OutlineTextField(
                title: 'Signup Perk Count',
                isError: settings.signError,
                keyboardType: TextInputType.name,
                controller: settings.signupPerk,
                focusNode: signPerk,
                nextFocusNode: focusNode1,
                // defaultValue: settings.signup,
                type: TextType.text,
                validator: isNumeric,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: OutlineTextField(
                title: 'Referrals For Extra Rewards',
                isError: settings.refForExtraRewardsError,
                keyboardType: TextInputType.name,
                controller: settings.referralsForExtraRewards,
                focusNode: focusNode1,
                nextFocusNode: focusNode2,
                // defaultValue: settings.signup,
                type: TextType.text,
                validator: isNumeric,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: OutlineTextField(
                title: 'Extra Referral Rewards',
                isError: settings.extraRefRewardsError,
                keyboardType: TextInputType.name,
                controller: settings.extraReferralRewards,
                focusNode: focusNode2,
                // defaultValue: settings.signup,
                type: TextType.text,
                validator: isNumeric,
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.only(top: 20),
            //   child: Text(
            //     'WaitList Rules',
            //     style: TextStyle(
            //       fontWeight: FontWeight.w600,
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            // ListView.builder(
            //   padding: EdgeInsets.zero,
            //   shrinkWrap: true,
            //   itemCount:
            //       context.watch<SettingsProvider>().waitList.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     return WaitListWidget(
            //         waitList: context
            //             .read<SettingsProvider>()
            //             .waitList[index]);
            //   },
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: CustomIconButton(
            //     title: 'Add Rule',
            //     width: 100,
            //     backgroundColor: Colors.blue,
            //     onClick: () {
            //       context.read<SettingsProvider>().addToWaitList(
            //             WaitList(start: '', end: '', perkCount: ''),
            //           );
            //     },
            //   ),
            // ),
          ],
        );
      },
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  PreferredSizeWidget _appBar() {
    return CustomAppBar(
      title: 'Settings',
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppTheme.blue,
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _footerWidget() {
    return Container(
      padding: EdgeInsets.all(
        10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: AppTheme.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            // offset: Offset(2, 4),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            title: kStringsSave,
            width: 100,
            backgroundColor: AppTheme.themeColor,
            onClick: () async {
              final provider =
                  Provider.of<SettingsProvider>(context, listen: false);
              if (!provider.checkValidate()) {
                return;
              }

              EasyLoading.show(status: 'Updating Settings');

              if (!context.read<SettingsProvider>().checkValidate()) {
                return;
              }

              await context.read<SettingsProvider>().saveSettings();

              EasyLoading.dismiss();

              EasyLoading.showSuccess('Settings updated.');
            },
          ),
        ],
      ),
    );
  }
}
