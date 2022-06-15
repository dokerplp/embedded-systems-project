package ru.zavar.carcontroller;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import java.io.IOException;
import java.net.Socket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MainActivity extends Activity {

    private final Handler handler = new Handler(Looper.getMainLooper());
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button button = findViewById(R.id.button);

        button.setOnClickListener(v -> {
            button.setEnabled(false);
            Intent myIntent = new Intent(this, ControlActivity.class);
            String address = ((EditText) findViewById(R.id.car_host_text)).getText().toString();
            myIntent.putExtra("address", address);
            myIntent.putExtra("camera", ((EditText) findViewById(R.id.camera_host_text)).getText().toString());
            myIntent.putExtra("front", ((EditText) findViewById(R.id.camera_front)).getText().toString());
            myIntent.putExtra("back", ((EditText) findViewById(R.id.camera_back)).getText().toString());
            Toast.makeText(getApplicationContext(), "Connecting...", Toast.LENGTH_SHORT).show();
            String[] addressSplit = address.split(":");
            executor.execute(() -> {
                if (!checkHost(addressSplit[0], Integer.parseInt(addressSplit[1]))) {
                    handler.post(() -> {
                        Toast.makeText(getApplicationContext(), "Connection failed", Toast.LENGTH_SHORT).show();
                        button.setEnabled(true);
                    });
                } else {
                    handler.post(() -> button.setEnabled(true));
                    startActivity(myIntent);
                }
            });
        });
    }

    private boolean checkHost(String host, int port) {
        try (Socket s = new Socket(host, port)) {
            return true;
        } catch (IOException ignore) {

        }
        return false;
    }

}