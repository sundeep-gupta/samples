package com.example.skgupta.memorygame;

import android.app.Activity;
import android.content.SharedPreferences;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import java.io.IOException;
import java.util.Random;

public class GameActivity extends Activity implements View.OnClickListener {

    //phase 5 - our animation object
    Animation wobble;

    int sample1, sample2, sample3, sample4;
    int[] sequenceToCopy;
    TextView txtScore, txtDifficulty, txtWatchGo;
    SoundPool soundPool;
    Button button1, button2, button3, button4, btnReplay;
    int difficultyLevel;
    private Handler myHandler;
    //Are we playing a sequence at the moment?
    boolean playSequence = false;
    //And which element of the sequence are we on
    int elementToPlay = 0;

    //For checking the players answer
    int playerResponses;
    int playerScore;
    boolean isResponding;

    //for our hiscore (phase 4)
    SharedPreferences prefs;
    SharedPreferences.Editor editor;
    String dataName = "MyData";
    String intName = "MyInt";
    int defaultInt = 0;
    int hiScore;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_game);
        //phase 4
//initialize our two SharedPreferences objects
        prefs = getSharedPreferences(dataName,MODE_PRIVATE);
        editor = prefs.edit();
        hiScore = prefs.getInt(intName, defaultInt);

        init();

        //phase5 - animation
        wobble = AnimationUtils.loadAnimation(this, R.anim.wobble);

        myHandler.sendEmptyMessageDelayed(0, 900);

    }

    private void init() {
        soundPool = new SoundPool(10, AudioManager.STREAM_MUSIC,0);
        try{
            //Create objects of the 2 required classes
            AssetManager assetManager = getAssets();
            AssetFileDescriptor descriptor;

            //create our three fx in memory ready for use
            descriptor = assetManager.openFd("sample1.ogg");
            sample1 = soundPool.load(descriptor, 0);

            descriptor = assetManager.openFd("sample2.ogg");
            sample2 = soundPool.load(descriptor, 0);


            descriptor = assetManager.openFd("sample3.ogg");
            sample3 = soundPool.load(descriptor, 0);

            descriptor = assetManager.openFd("sample4.ogg");
            sample4 = soundPool.load(descriptor, 0);


        }catch(IOException e){
            Toast.makeText(getApplicationContext(),"No Sound!", Toast.LENGTH_LONG).show();
        }
        txtScore = (TextView)findViewById(R.id.txtScore);
        txtDifficulty = (TextView)findViewById(R.id.txtDifficulty);
        txtWatchGo = (TextView) findViewById(R.id.txtWatchGo);

        button1 = (Button) findViewById(R.id.button1);
        button2 = (Button) findViewById(R.id.button2);
        button3 = (Button) findViewById(R.id.button3);
        button4 = (Button) findViewById(R.id.button4);
        btnReplay = (Button) findViewById(R.id.btnReplay);
        button1.setOnClickListener(this);
        button2.setOnClickListener(this);
        button3.setOnClickListener(this);
        button4.setOnClickListener(this);
        btnReplay.setOnClickListener(this);
        difficultyLevel = 4;

        sequenceToCopy = new int[100];
        playerScore = 0;

        txtScore.setText("Score: " + playerScore);
        txtDifficulty.setText("Difficulty: " + difficultyLevel);

        myHandler = new Handler() {
            public void handleMessage(Message msg) {
                super.handleMessage(msg);
                if (playSequence) {
                    //All the thread action will go here
                    //All the thread action will go here
                    //make sure all the buttons are made visible
                    //button1.setVisibility(View.VISIBLE);
                    //button2.setVisibility(View.VISIBLE);
                    //button3.setVisibility(View.VISIBLE);
                    //button4.setVisibility(View.VISIBLE);

                    switch (sequenceToCopy[elementToPlay]){
                        case 1:
                            //hide a button
                            //button1.setVisibility(View.INVISIBLE);
                            //play a sound
                            soundPool.play(sample1, 1, 1, 0, 0, 1);
                            break;

                        case 2:
                            //hide a button
                            //button2.setVisibility(View.INVISIBLE);
                            //play a sound
                            soundPool.play(sample2, 1, 1, 0, 0, 1);
                            break;

                        case 3:
                            //hide a button button3.setVisibility(View.INVISIBLE);
                            //play a sound
                            soundPool.play(sample3, 1, 1, 0, 0, 1);
                            break;

                        case 4:
                            //hide a button
                            //button4.setVisibility(View.INVISIBLE);
                            //play a sound
                            soundPool.play(sample4, 1, 1, 0, 0, 1);
                            break;
                    }

                    elementToPlay++;
                    if(elementToPlay == difficultyLevel){
                        sequenceFinished();
                    }
                }
                myHandler.sendEmptyMessageDelayed(0, 900);
            }
        };
    }

    public void onClick(View view) {
        if(!playSequence) {
            switch (view.getId()) {
                case R.id.button1:
                    //play a sound
                    soundPool.play(sample1, 1, 1, 0, 0, 1);
                    checkElement(1);
                    break;
                case R.id.button2:
                    //play a sound
                    soundPool.play(sample2, 1, 1, 0, 0, 1);
                    checkElement(2);
                    break;
                case R.id.button3:
                    //play a sound
                    soundPool.play(sample3, 1, 1, 0, 0, 1);
                    checkElement(3);
                    break;
                case R.id.button4:
                    //play a sound
                    soundPool.play(sample4, 1, 1, 0, 0, 1);
                    checkElement(4);
                    break;
                case R.id.btnReplay:
                    difficultyLevel = 3;
                    playerScore = 0;
                    txtScore.setText("Score: " + playerScore);
                    playASequence();
                    break;
            }
        }
    }
    public void checkElement(int thisElement) {
        if (isResponding) {
            playerResponses++;
            if (sequenceToCopy[playerResponses - 1] == thisElement) { //Correct
                playerScore = playerScore + ((thisElement + 1) * 2);
                txtScore.setText("Score: " + playerScore);
                if (playerResponses == difficultyLevel) {//got the whole sequence
                    //don't checkElement anymore
                    isResponding = false;
                    //now raise the difficulty
                    difficultyLevel++;
                    //and play another sequence
                    playASequence();
                }

            } else {//wrong answer
                txtWatchGo.setText("FAILED!");
                //don't checkElement anymore
                isResponding = false;
                //for our high score (phase 4)
                if (playerScore > hiScore) {
                    hiScore = playerScore;
                    editor.putInt(intName, hiScore);
                    editor.commit();
                    Toast.makeText(getApplicationContext(), "New Hi-score", Toast.LENGTH_LONG).show();
                }
            }
        }
    }
    public void createSequence(){
        //For choosing a random button
        Random randInt = new Random();
        int ourRandom;
        for(int i = 0; i < difficultyLevel; i++){
            //get a random number between 1 and 4
            ourRandom = randInt.nextInt(4);
            ourRandom ++;//make sure it is not zero
            //Save that number to our array
            sequenceToCopy[i] = ourRandom;
        }

    }
    public void playASequence(){
        createSequence();
        isResponding = false;
        elementToPlay = 0;
        playerResponses = 0;
        txtWatchGo.setText("WATCH!");
        playSequence = true;
    }
    public void sequenceFinished(){
        playSequence = false;
        //make sure all the buttons are made visible
        //button1.setVisibility(View.VISIBLE);
        //button2.setVisibility(View.VISIBLE);
        //button3.setVisibility(View.VISIBLE);
        //button4.setVisibility(View.VISIBLE);
        txtWatchGo.setText("GO!");
        isResponding = true;
    }
}
