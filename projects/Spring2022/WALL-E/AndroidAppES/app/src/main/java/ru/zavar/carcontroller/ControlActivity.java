package ru.zavar.carcontroller;

import androidx.appcompat.app.AppCompatActivity;

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

public class ControlActivity extends Activity {

    private Button button;
    private RemoteCarTcpClient tcpClient;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_control);
        String[] address = getIntent().getStringExtra("address").split(":");
        String cameraHost = getIntent().getStringExtra("camera");
        tcpClient = new RemoteCarTcpClient(address[0], Integer.parseInt(address[1]));
        WebView webView = findViewById(R.id.camera_view);
        webView.setWebChromeClient(new WebChromeClient());
        webView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
        webView.setBackgroundColor(Color.BLACK);
        webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        webView.setOnTouchListener((v, event) -> (event.getAction() == MotionEvent.ACTION_MOVE));
        webView.loadDataWithBaseURL(null, "<style>img{display: block; background-color: hsl(0, 0%, 25%); height: auto; max-width: 65%; margin-bottom: -10;margin-left: auto;margin-right: auto}</style>" + "<img src=\"http://" + cameraHost + "/\" width=\"1024\" height=\"720\">", "text/html", "UTF-8", null);

        tcpClient.start();

        Button transmission = findViewById(R.id.transmission);

        tcpClient.setTransmissionMode(TransmissionMode.PARK);
        transmission.setBackgroundColor(Color.CYAN);
        transmission.setText("P");

        transmission.setOnClickListener(v -> {
            tcpClient.nextTransmissionMode();
            switch (tcpClient.getTransmissionMode()) {
                case PARK:
                    transmission.setBackgroundColor(Color.CYAN);
                    tcpClient.setTransmissionMode(TransmissionMode.PARK);
                    transmission.setText("P");
                    break;
                case DRIVE:
                    transmission.setBackgroundColor(Color.GREEN);
                    tcpClient.setTransmissionMode(TransmissionMode.DRIVE);
                    transmission.setText("D");
                    break;
                case REVERSE:
                    transmission.setBackgroundColor(Color.RED);
                    tcpClient.setTransmissionMode(TransmissionMode.REVERSE);
                    transmission.setText("R");
                    break;
            }
        });

        SeekBar gas = findViewById(R.id.gas);
        gas.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                tcpClient.setGas(progress);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                gas.setProgress(0);
                tcpClient.setGas(0);
            }
        });

        SeekBar rotation = findViewById(R.id.rotation);
        rotation.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                tcpClient.setRotation(progress);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                rotation.setProgress(50);
                tcpClient.setRotation(50);
            }
        });
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        tcpClient.stop();
        finish();
    }
}