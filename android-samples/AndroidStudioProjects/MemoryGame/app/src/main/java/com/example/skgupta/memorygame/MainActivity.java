package com.example.skgupta.memorygame;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class MainActivity extends Activity implements View.OnClickListener{
    //for our hiscore (phase 4)
    SharedPreferences prefs;
    String dataName = "MyData";
    String intName = "MyString";
    int defaultInt = 0;
    //both activities can see this
    public static int hiScore;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Button btnPlay = (Button) findViewById(R.id.btnPlay);
        btnPlay.setOnClickListener(this);
    }

    public void onClick(View view) {
        Intent i = new Intent(this, GameActivity.class);
        startActivity(i);
        //for our high score (phase 4)
        //initialize our two SharedPreferences objects
        prefs = getSharedPreferences(dataName,MODE_PRIVATE);

        //Either load our High score or
        //if not available our default of 0
        hiScore = prefs.getInt(intName, defaultInt);

        //Make a reference to the Hiscore textview in our layout
        TextView textHiScore =(TextView) findViewById(R.id.txtHiScore);
        //Display the hi score
        textHiScore.setText("Highest Score: "+ hiScore);
    }
}
