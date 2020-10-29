package com.example.live_chat
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    // add onCreate method (if not exists)
    override fun onCreate(savedInstanceState: Bundle?) {
        // add this line to "onCreate" method
        this.getIntent().putExtra("enable-software-rendering", true)
        // don't forget to call "super"
        super.onCreate(savedInstanceState)
    }

}
