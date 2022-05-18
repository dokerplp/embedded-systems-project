package ru.zavar.carcontroller;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button button = findViewById(R.id.button);

        button.setOnClickListener(v -> {
            Intent myIntent = new Intent(this, ControlActivity.class);
            myIntent.putExtra("address", ((EditText)findViewById(R.id.car_host_text)).getText().toString());
            myIntent.putExtra("camera", ((EditText)findViewById(R.id.camera_host_text)).getText().toString());
            myIntent.putExtra("front", ((EditText)findViewById(R.id.camera_front)).getText().toString());
            myIntent.putExtra("back", ((EditText)findViewById(R.id.camera_back)).getText().toString());
            startActivity(myIntent);
        });

    }
}