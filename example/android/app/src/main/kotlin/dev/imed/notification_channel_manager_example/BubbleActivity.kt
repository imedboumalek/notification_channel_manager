package dev.imed.notification_channel_manager_example

import android.app.Activity
import android.os.Bundle
import android.view.Gravity
import android.widget.TextView

// The content shown inside a test bubble. Bubbles need a resizable activity
// to expand into (see the manifest entry).
class BubbleActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(TextView(this).apply {
            text = "Hello from inside a bubble 🫧"
            gravity = Gravity.CENTER
            textSize = 20f
        })
    }
}
