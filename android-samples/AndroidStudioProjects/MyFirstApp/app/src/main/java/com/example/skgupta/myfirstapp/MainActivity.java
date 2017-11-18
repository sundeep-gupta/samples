package com.example.skgupta.myfirstapp;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.google.android.gms.appindexing.Action;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.appindexing.Thing;
import com.google.android.gms.common.api.GoogleApiClient;

public class MainActivity extends Activity implements View.OnClickListener{

    /**
     * ATTENTION: This was auto-generated to implement the App Indexing API.
     * See https://g.co/AppIndexing/AndroidStudio for more information.
     */
    private GoogleApiClient client;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.i("INFO", "Checking if the logging works this way in logcat");
        setContentView(R.layout.activity_main);
        Button btnPlay = (Button)findViewById(R.id.btnPlay);
        btnPlay.setOnClickListener(this);
        findViewById(R.id.btnHighest).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(MainActivity.this.getApplicationContext(), "" + Score.highest, Toast.LENGTH_LONG).show();
            }
        });
    }

    @Override
    public void onClick(View v) {
        Intent i;
        i = new Intent(this, GameActivity.class);
        startActivity(i);
    }
}
