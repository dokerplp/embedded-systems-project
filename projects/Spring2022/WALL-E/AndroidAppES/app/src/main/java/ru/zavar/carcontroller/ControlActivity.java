package ru.zavar.carcontroller;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.graphics.Color;
import android.os.Build;
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

import androidx.annotation.RequiresApi;
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

        SeekBar transmission = findViewById(R.id.transmission);
        TextView textD3 = findViewById(R.id.textD3);
        TextView textD2 = findViewById(R.id.textD2);
        TextView textD1 = findViewById(R.id.textD1);
        TextView textR = findViewById(R.id.textR);
        TextView textP = findViewById(R.id.textP);
        tcpClient.setTransmissionMode(TransmissionMode.PARK);
        textP.setBackgroundColor(Color.CYAN);
        textR.setBackgroundColor(Color.GRAY);
        textD1.setBackgroundColor(Color.GRAY);
        textD2.setBackgroundColor(Color.GRAY);
        textD3.setBackgroundColor(Color.GRAY);
        transmission.setProgress(0);
        transmission.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                switch (progress) {
                    case 0:
                        gas.setMax(100);
                        tcpClient.setTransmissionMode(TransmissionMode.PARK);
                        textP.setBackgroundColor(Color.CYAN);
                        textR.setBackgroundColor(Color.GRAY);
                        textD1.setBackgroundColor(Color.GRAY);
                        textD2.setBackgroundColor(Color.GRAY);
                        textD3.setBackgroundColor(Color.GRAY);
                        switchToFrontCamera();
                        seekBar.performHapticFeedback(HapticFeedbackConstants.CONTEXT_CLICK);
                        break;
                    case 1:
                        gas.setMax(100);
                        tcpClient.setTransmissionMode(TransmissionMode.REVERSE);
                        textP.setBackgroundColor(Color.GRAY);
                        textR.setBackgroundColor(Color.RED);
                        textD1.setBackgroundColor(Color.GRAY);
                        textD2.setBackgroundColor(Color.GRAY);
                        textD3.setBackgroundColor(Color.GRAY);
                        switchToBackCamera();
                        seekBar.performHapticFeedback(HapticFeedbackConstants.CONTEXT_CLICK);
                        break;
                    case 2:
                        gas.setMax(50);
                        tcpClient.setTransmissionMode(TransmissionMode.DRIVE);
                        textP.setBackgroundColor(Color.GRAY);
                        textR.setBackgroundColor(Color.GRAY);
                        textD1.setBackgroundColor(Color.GREEN);
                        textD2.setBackgroundColor(Color.GRAY);
                        textD3.setBackgroundColor(Color.GRAY);
                        switchToFrontCamera();
                        seekBar.performHapticFeedback(HapticFeedbackConstants.CONTEXT_CLICK);
                        break;
                    case 3:
                        gas.setMax(70);
                        tcpClient.setTransmissionMode(TransmissionMode.DRIVE);
                        textP.setBackgroundColor(Color.GRAY);
                        textR.setBackgroundColor(Color.GRAY);
                        textD1.setBackgroundColor(Color.GRAY);
                        textD2.setBackgroundColor(Color.YELLOW);
                        textD3.setBackgroundColor(Color.GRAY);
                        switchToFrontCamera();
                        seekBar.performHapticFeedback(HapticFeedbackConstants.CONTEXT_CLICK);
                        break;
                    case 4:
                        gas.setMax(100);
                        tcpClient.setTransmissionMode(TransmissionMode.DRIVE);
                        textP.setBackgroundColor(Color.GRAY);
                        textR.setBackgroundColor(Color.GRAY);
                        textD1.setBackgroundColor(Color.GRAY);
                        textD2.setBackgroundColor(Color.GRAY);
                        textD3.setBackgroundColor(Color.parseColor("#FF9800"));
                        switchToFrontCamera();
                        seekBar.performHapticFeedback(HapticFeedbackConstants.CONTEXT_CLICK);
                        break;
                }
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }


            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

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