package com.example.time_is_money

import android.os.Build
import androidx.fragment.app.FragmentActivity
import com.hhlr.biometrics.BiometricsApi
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class BiometricChannelUtil {
  companion object {

    private const val CHANNEL = "simpleBiometricAPI:1.0.1"

    fun registerChannel(
      context: FragmentActivity,
      flutterEngine: FlutterEngine
    ) {

      MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        .setMethodCallHandler { call, result ->

          when (call.method) {

            "showBiometricPromptForEncryption" -> {
              showBiometricPromptForEncryption(context, call, result)
            }

            "canAuthenticate" -> {
              result.success(BiometricsApi().canAuthenticate(context))
            }

            "showBiometricPromptForDecryption" -> {
              showBiometricPromptForDecryption(context, call, result)
            }

            else -> {
              result.notImplemented()
            }
          }
        }
    }

    private fun showBiometricPromptForEncryption(context: FragmentActivity, call: MethodCall, result: MethodChannel.Result) {
      val title = call.argument<String>("title").toString()
      val subtitle = call.argument<String>("subtitle").toString()
      val negativeButtonText = call.argument<String>("negativeButtonText").toString()
      val token = call.argument<String>("token").toString()


      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        BiometricsApi().showBiometricPromptForEncryption(
          activityContext = context,
          title = title,
          subtitle = subtitle,
          negativeButtonText = negativeButtonText,
          token = token,
          onAuthenticationSucceeded = {
            result.success("AuthenticationSucceeded")
          },
          onAuthenticationError = {
            result.error("AuthenticationError",
              "Authentication Error", null)
          },
          onAuthenticationFailed = {
            result.error("AuthenticationError",
              "Authentication Error: " + it?.message, null)
          }
        )
      }
    }

    private fun showBiometricPromptForDecryption(context: FragmentActivity, call: MethodCall, result: MethodChannel.Result) {
      val title = call.argument<String>("title").toString()
      val subtitle = call.argument<String>("subtitle").toString()
      val negativeButtonText = call.argument<String>("negativeButtonText").toString()

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        BiometricsApi().showBiometricPromptForDecryption(
          context = context,
          title = title,
          subtitle = subtitle,
          negativeButtonText = negativeButtonText,
          onAuthenticationSucceeded = { plainTextToken ->
            if (plainTextToken != null) {
              result.success(plainTextToken)
            } else {
              result.error("AuthenticationError",
                "No token to parse", null)
            }
          },
          onAuthenticationError = {
            result.error("AuthenticationError",
              "No token to parse", null)
          },
          onAuthenticationFailed = {
            result.error("AuthenticationError",
              "No token to parse", null)
          }
        )
      }
    }
  }
}