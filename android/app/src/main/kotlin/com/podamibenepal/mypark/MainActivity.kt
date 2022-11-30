package com.podamibenepal.mypark

import android.content.Intent
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.view.KeyEvent
import android.widget.TextView
import android.widget.Toast
import com.google.zxing.integration.android.IntentIntegrator

class MainActivity: FlutterActivity() {
    private val CHANNEL = "volumeButton";
    private var scannedCode = "1234"
    lateinit var textView: TextView

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        val intentIntegrator = IntentIntegrator(this@MainActivity)

        when (keyCode) {
            KeyEvent.KEYCODE_VOLUME_UP -> intentIntegrator.initiateScan()
            KeyEvent.KEYCODE_VOLUME_DOWN -> Toast.makeText(applicationContext, "Wrong Volume button Pressed", Toast.LENGTH_SHORT).show()
        }
        return true
    }

    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?
    ) {
        val result = IntentIntegrator.parseActivityResult(requestCode, resultCode, data)
        if (result != null) {
            if (result.contents == null) {
                Toast.makeText(this, "cancelled", Toast.LENGTH_SHORT).show()
            } else {
                Log.d("MainActivity", "Scanned")
                Toast.makeText(this, "Scanned -> " + result.contents, Toast.LENGTH_SHORT)
                    .show()
                textView.text = String.format("Scanned Result: %s", result)
            }
        } else {
            super.onActivityResult(requestCode, resultCode, data)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if(call.method == "randomTextTest"){
                val xv = textView.text
//                result.success(xv)
                result.success(xv)
            }
        }

    }

    fun randomTextTest(): String {
        return "Native code message"
    }

}
