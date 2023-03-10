import 'package:flutter/material.dart';
import '../../../layout/homeLayout/homelayout.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../../shared/resources/color_manager.dart';
import '../../../shared/resources/font_manager.dart';
import '../Sign Up Screen/OrDivider.dart';
import '../Sign Up Screen/Social_Icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../Sign Up Screen/register_screen.dart';
import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';

class LoginScreen extends StatelessWidget {

  LoginScreen({super.key});

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginState>(
      listener: (context,state) {
        if(state is LoginSuccessState) {
          if (state.model.id.isNotEmpty) {
            CacheHelper.saveData(
              key: 'token',
              value: state.model.id,
            ).then((value) =>
            {
              navigateFish(context, const HomeLayout()),
            }
            );
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: '   Hey    Mr.$name...........',
                message: '    ${state.model.message}',
                contentType: ContentType.success,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
          else{
           final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: '     Error!',
                message: '    ${state.model.message}',
                contentType: ContentType.failure,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
        }
      },
      builder: (context,state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 10,
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome back!',
                            style: TextStyle(
                              color: ColorManager.black,
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s24,
                              fontWeight: FontWeightManager.bold,
                            ),
                          ),
                          Text('Login to your account',
                            style: TextStyle(
                              color: ColorManager.gery,
                              fontFamily: FontConstants.fontFamily,
                              fontSize: FontSize.s16,
                              fontWeight: FontWeightManager.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 12.5,
                    ),
                    Form(
                        key: formKey,
                        child: Column(
                          children:
                          [
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Login',
                                  prefixIcon: Icon(Icons.person_outlined,color: ColorManager.gery,),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35.0),
                                  )
                              ),
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator:(value){
                                if(value!.isEmpty)
                                  {
                                    return 'please enter your email address';
                                  }
                                return null;
                                },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height/35,
                            ),
                            TextFormField(
                              obscureText: LoginCubit.get(context).isPasswordShown,
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              validator: (value){
                                if(value!.isEmpty)
                                {
                                  return 'password is too short';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value){
                                if(formKey.currentState!.validate())
                                {
                                  LoginCubit.get(context).userLogin(email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock_outline_sharp),
                                  suffixIcon: IconButton(
                                    onPressed: (){
                                      LoginCubit.get(context).changePasswordVisibility() ;
                                    } ,
                                    icon: Icon(LoginCubit.get(context).suffix),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(35.0),
                                  )
                              ),
                            ),
                            Row(
                              children:
                              [
                                TextButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreenScreen()));
                                },
                                  child: Text(' Create Account',
                                    style: TextStyle(
                                      color: ColorManager.brightBlue,
                                      fontWeight: FontWeightManager.semiBold,
                                      fontFamily: FontConstants.fontFamily,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                TextButton(onPressed: (){},
                                    child: Text('Forgot password?',
                                      style: TextStyle(
                                        color: ColorManager.black,
                                        fontWeight: FontWeightManager.semiBold,
                                        fontFamily: FontConstants.fontFamily,
                                      ),
                                    ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height/50,
                            ),
                            Conditional.single(
                              context: context ,
                              conditionBuilder: (BuildContext  context) => state is! LoginLoadingState,
                                widgetBuilder: (context){
                                return Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width/35,
                                  ),
                                  child: TextButton(
                                    onPressed:(){
                                      if(formKey.currentState!.validate()){
                                        LoginCubit.get(context).userLogin(email: emailController.text,
                                            password: passwordController.text);
                                      }

                                  } ,
                                    style: TextButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      backgroundColor: ColorManager.black,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),
                                    child:  Text('Login',
                                      style: TextStyle(
                                        color: ColorManager.white,
                                        fontFamily: FontConstants.fontFamily,
                                        fontSize: FontSize.s22,
                                        fontWeight: FontWeightManager.semiBold,
                                      ),
                                    ),
                                  ),
                                );
                                },
                                fallbackBuilder: (context) {
                                  return const Center(child: CircularProgressIndicator()) ;
                                }
                            ),
                            const OrDivider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SocialIcons(
                                    iconSource: "assets/icons/facebook.svg",
                                    press: (){
                                      print("facebook");
                                    }
                                ),
                                SocialIcons(
                                    iconSource: "assets/icons/twitter.svg",
                                    press: (){
                                      print("twitter");
                                    }
                                ),
                                SocialIcons(
                                    iconSource: "assets/icons/google-plus.svg",
                                    press: (){
                                      print("google");
                                    }
                                )
                              ],
                            ),
                          ],
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      ),
    );
  }
}