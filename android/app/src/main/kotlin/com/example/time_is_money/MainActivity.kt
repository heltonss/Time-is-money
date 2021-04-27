package com.example.time_is_money

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterFragmentActivity() {

  override fun configureFlutterEngine(@NonNull
                                      flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    BiometricChannelUtil.registerChannel(this, flutterEngine);
  }
}
