package ru.zavar.carcontroller;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.HapticFeedbackConstants;
import android.view.MotionEvent;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

import androidx.constraintlayout.widget.ConstraintLayout;

public class ControlActivity extends Activity {

    private RemoteCarTcpClient tcpClient;
    private boolean frontCameraLoaded = true;
    private boolean backCameraLoaded = true;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private WebView webBackView;
    private WebView webFrontView;
    private ImageView cameraFailImage;
    private ConstraintLayout mainLayout;

    private String getCameraData(String host, String port) {
        return "<style>img{display: block; background-color: hsl(0, 0%, 25%); height: auto; max-width: 65%;margin-left: auto;margin-right: auto}</style>" + "<img src=\"http://" + host + ":" + port + "/\" width=\"1024\" height=\"720\">";
    }

    @SuppressLint("ClickableViewAccessibility")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_control);
        mainLayout = findViewById(R.id.main_layout);
        mainLayout.setAlpha(0.0f);
        String[] address = getIntent().getStringExtra("address").split(":");
        String cameraHost = getIntent().getStringExtra("camera");
        String cameraFrontPort = getIntent().getStringExtra("front");
        String cameraBackPort = getIntent().getStringExtra("back");
        tcpClient = new RemoteCarTcpClient(address[0], Integer.parseInt(address[1]));

        cameraFailImage = findViewById(R.id.camera_fail);

        webFrontView = findViewById(R.id.camera_front_view);
        webFrontView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
        webFrontView.setBackgroundColor(Color.BLACK);
        webFrontView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        webFrontView.setOnTouchListener((v, event) -> (event.getAction() == MotionEvent.ACTION_MOVE));
        webFrontView.setVisibility(View.VISIBLE);
        webFrontView.setWebViewClient(new WebViewClient() {
            @Override
            public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
                super.onReceivedError(view, request, error);
                webFrontView.setVisibility(View.INVISIBLE);
                cameraFailImage.setVisibility(View.VISIBLE);
                frontCameraLoaded = false;
            }
        });
        webFrontView.loadDataWithBaseURL(null, getCameraData(cameraHost, cameraFrontPort), "text/html", "UTF-8", null);

        webBackView = findViewById(R.id.camera_back_view);
        webBackView.setWebChromeClient(new WebChromeClient());
        webBackView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
        webBackView.setBackgroundColor(Color.BLACK);
        webBackView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        webBackView.setOnTouchListener((v, event) -> (event.getAction() == MotionEvent.ACTION_MOVE));
        webBackView.setVisibility(View.INVISIBLE);
        webBackView.setWebViewClient(new WebViewClient() {
            @Override
            public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
                super.onReceivedError(view, request, error);
                webBackView.setVisibility(View.INVISIBLE);
                backCameraLoaded = false;
            }
        });
        webBackView.loadDataWithBaseURL(null, getCameraData(cameraHost, cameraBackPort), "text/html", "UTF-8", null);

        Button camera = findViewById(R.id.camera_button);
        camera.setOnClickListener(v -> {
            camera.performHapticFeedback(HapticFeedbackConstants.CONTEXT_CLICK);
            if(webBackView.getVisibility() == View.VISIBLE)
                switchToFrontCamera();
            else
                switchToBackCamera();
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
                    switchToFrontCamera();
                    transmission.setBackgroundColor(Color.CYAN);
                    tcpClient.setTransmissionMode(TransmissionMode.PARK);
                    transmission.setText("P");
                    break;
                case DRIVE:
                    switchToFrontCamera();
                    transmission.setBackgroundColor(Color.GREEN);
                    tcpClient.setTransmissionMode(TransmissionMode.DRIVE);
                    transmission.setText("D");
                    break;
                case REVERSE:
                    switchToBackCamera();
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

        ToggleButton nitro = findViewById(R.id.toggle_nitro);
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

        ProgressBar engineBattery = findViewById(R.id.engine_battery);
        ProgressBar rpiBattery = findViewById(R.id.rpi_battery);
        TextView engineBatteryText = findViewById(R.id.engine_battery_text);
        TextView rpiBatteryText = findViewById(R.id.rpi_battery_text);

        tcpClient.setOnEngineBatteryChange(value -> handler.post(() -> {
            engineBattery.setProgress(value);
            engineBatteryText.setText(String.valueOf(value));
        }));
        tcpClient.setOnRpiBatteryChange(value -> handler.post(() -> {
            rpiBattery.setProgress(value);
            rpiBatteryText.setText(String.valueOf(value));
        }));

        tcpClient.setOnStop(message -> handler.post(() -> {
            mainLayout.animate().translationY(mainLayout.getHeight()).alpha(0.0f).setDuration(1000).scaleX(-20);
            finish();
            if(!message.isEmpty())
                Toast.makeText(getApplicationContext(), message, Toast.LENGTH_SHORT).show();
        }));

        tcpClient.setOnConnect(() -> {
            mainLayout.animate().translationY(0).alpha(1.0f).setDuration(1000);
        });

        tcpClient.start();
    }

    @Override
    protected void onPause() {
        super.onPause();
        tcpClient.stop();
        finish();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        tcpClient.stop();
        finish();
    }

    private void switchToFrontCamera() {
        if(frontCameraLoaded) {
            webFrontView.setVisibility(View.VISIBLE);
            webBackView.setVisibility(View.INVISIBLE);
            cameraFailImage.setVisibility(View.INVISIBLE);
        } else {
            webFrontView.setVisibility(View.INVISIBLE);
            cameraFailImage.setVisibility(View.VISIBLE);
        }
    }

    private void switchToBackCamera() {
        if(backCameraLoaded) {
            webFrontView.setVisibility(View.INVISIBLE);
            webBackView.setVisibility(View.VISIBLE);
            cameraFailImage.setVisibility(View.INVISIBLE);
        } else {
            webBackView.setVisibility(View.INVISIBLE);
            cameraFailImage.setVisibility(View.VISIBLE);
        }
    }

}