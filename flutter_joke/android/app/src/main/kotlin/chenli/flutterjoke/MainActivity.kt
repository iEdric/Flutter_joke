package chenli.flutterjoke

import android.content.Intent
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity(): FlutterActivity() {

  private val SHARE_CHANNEL = "channel:Chenli"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(this.flutterView, SHARE_CHANNEL).setMethodCallHandler { methodCall, result ->
      if (methodCall.method == "ChenliShareFile") {
//        print(methodCall.arguments)
        shareFile(methodCall.arguments as String)
      }
    }
  }

  private fun shareFile(path: String) {
    val shareIntent = Intent(Intent.ACTION_SEND)
    shareIntent.type = "text/plain"
    shareIntent.putExtra(Intent.EXTRA_SUBJECT, "每日一笑")//添加分享内容标题
    shareIntent.putExtra(Intent.EXTRA_TEXT,path)//添加分享内容
    this.startActivity(Intent.createChooser(shareIntent, "分享"))
  }
}
