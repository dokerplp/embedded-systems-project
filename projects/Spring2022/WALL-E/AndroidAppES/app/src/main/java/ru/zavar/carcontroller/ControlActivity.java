package ru.zavar.carcontroller;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.HapticFeedbackConstants;
import android.view.MotionEvent;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ControlActivity extends Activity {

    private RemoteCarTcpClient tcpClient;
    private Handler handler = new Handler(Looper.getMainLooper());

    private String getCameraData(String host, String port) {
        return "<style>img{display: block; background-color: hsl(0, 0%, 25%); height: auto; max-width: 65%;margin-left: auto;margin-right: auto}</style>" + "<img src=\"http://" + host + ":" + port + "/\" width=\"1024\" height=\"720\">";
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_control);
        String[] address = getIntent().getStringExtra("address").split(":");
        String cameraHost = getIntent().getStringExtra("camera");
        String cameraFrontPort = getIntent().getStringExtra("front");
        String cameraBackPort = getIntent().getStringExtra("back");
        tcpClient = new RemoteCarTcpClient(address[0], Integer.parseInt(address[1]));
        WebView webFrontView = findViewById(R.id.camera_front_view);
        webFrontView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
        webFrontView.setBackgroundColor(Color.BLACK);
        webFrontView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        webFrontView.setOnTouchListener((v, event) -> (event.getAction() == MotionEvent.ACTION_MOVE));
        webFrontView.setVisibility(View.INVISIBLE);
        webFrontView.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                webFrontView.setVisibility(View.VISIBLE);
            }
        });
        webFrontView.loadDataWithBaseURL(null, getCameraData(cameraHost, cameraFrontPort), "text/html", "UTF-8", null);

        WebView webBackView = findViewById(R.id.camera_back_view);
        webBackView.setWebChromeClient(new WebChromeClient());
        webBackView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
        webBackView.setBackgroundColor(Color.BLACK);
        webBackView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        webBackView.setOnTouchListener((v, event) -> (event.getAction() == MotionEvent.ACTION_MOVE));
        webBackView.loadDataWithBaseURL(null, getCameraData(cameraHost, cameraBackPort), "text/html", "UTF-8", null);
        webBackView.setVisibility(View.INVISIBLE);


        Button camera = findViewById(R.id.camera_button);
        camera.setOnClickListener(v -> {
            camera.performHapticFeedback(HapticFeedbackConstants.CONTEXT_CLICK);
            if(webBackView.getVisibility() == View.VISIBLE) {
                webFrontView.setVisibility(View.VISIBLE);
                webBackView.setVisibility(View.INVISIBLE);
            } else {
                webFrontView.setVisibility(View.INVISIBLE);
                webBackView.setVisibility(View.VISIBLE);
            }
        });

        Button transmission = findViewById(R.id.transmission);
        tcpClient.setTransmissionMode(TransmissionMode.PARK);
        transmission.setBackgroundColor(Color.CYAN);
        transmission.setText("P");

        transmission.setOnClickListener(v -> {
            transmission.performHapticFeedback(HapticFeedbackConstants.VIRTUAL_KEY);
            tcpClient.nextTransmissionMode();
            switch (tcpClient.getTransmissionMode()) {
                case PARK:
                    webFrontView.setVisibility(View.VISIBLE);
                    webBackView.setVisibility(View.INVISIBLE);
                    transmission.setBackgroundColor(Color.CYAN);
                    tcpClient.setTransmissionMode(TransmissionMode.PARK);
                    transmission.setText("P");
                    break;
                case DRIVE:
                    webFrontView.setVisibility(View.VISIBLE);
                    webBackView.setVisibility(View.INVISIBLE);
                    transmission.setBackgroundColor(Color.GREEN);
                    tcpClient.setTransmissionMode(TransmissionMode.DRIVE);
                    transmission.setText("D");
                    break;
                case REVERSE:
                    webFrontView.setVisibility(View.INVISIBLE);
                    webBackView.setVisibility(View.VISIBLE);
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
                gas.performHapticFeedback(HapticFeedbackConstants.CLOCK_TICK);
            }
        });

        ToggleButton nitro = findViewById(R.id.toggleNitro);
        nitro.setOnCheckedChangeListener((buttonView, isChecked) -> {
            if(isChecked) {
                nitro.performHapticFeedback(HapticFeedbackConstants.REJECT);
                gas.setMax(100);
            }
            else
                gas.setMax(80);
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
                rotation.performHapticFeedback(HapticFeedbackConstants.CLOCK_TICK);
            }
        });

        ProgressBar engineBattery = findViewById(R.id.engineBattery);
        ProgressBar rpiBattery = findViewById(R.id.rpiBattery);
        TextView engineBatteryText = findViewById(R.id.engineBatteryText);
        TextView rpiBatteryText = findViewById(R.id.rpiBatteryText);

        tcpClient.setEngineBatteryListener(value -> {
            handler.post(() -> {
                engineBattery.setProgress(value);
                engineBatteryText.setText(String.valueOf(value));
            });
        });
        tcpClient.setRpiBatteryListener(value -> {
            handler.post(() -> {
                rpiBattery.setProgress(value);
                rpiBatteryText.setText(String.valueOf(value));
            });
        });

        tcpClient.setStopListener((String message) -> {
            handler.post(() -> {
                finish();
                if(!message.isEmpty())
                    Toast.makeText(getApplicationContext(), message, Toast.LENGTH_LONG).show();
            });
        });

        tcpClient.start();
    }

    @Override
    protected void onPause() {
        super.onPause();
        tcpClient.stop("Connection reset");
        finish();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        tcpClient.stop();
        finish();
    }

}