package com.github.NateWright.log_it

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone

class MainActivity: FlutterActivity() {
  private val CHANNEL = "log_it.NateWright.github.com/flutter_local_notification"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      if(call.method == "getTimeZoneName") {
        result.success(TimeZone.getDefault().id);
      }
//      if ("drawableToUri".equals(call.method)) {
//        int resourceId = MainActivity.this.getResources().getIdentifier((String) call.arguments, "drawable", MainActivity.this.getPackageName());
//        result.success(resourceToUriString(MainActivity.this.getApplicationContext(), resourceId));
//    }
//    if("getAlarmUri".equals(call.method)) {
//        result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM).toString());
//    }
//    if("getTimeZoneName".equals(call.method)) {
//        result.success(TimeZone.getDefault().getID());
//    }
    }
  }
}
