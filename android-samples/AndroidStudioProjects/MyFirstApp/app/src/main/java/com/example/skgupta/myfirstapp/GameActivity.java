package com.example.skgupta.myfirstapp;
import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Random;

import static android.widget.Toast.LENGTH_LONG;

public class GameActivity extends Activity implements View.OnClickListener{
    Random random = new Random();
    int partA, partB;
    int correctAnswer;
    TextView textPartA, textPartB, textScore, textLevel;
    Toast toastCorrect, toastWrong;

    int currentScore = 0;
    int currentLevel = 1;
    Button[] choices = new Button[3];
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_game);
        initObjects();
        nextQuestion();



    }
    private void initObjects() {
        textPartA = (TextView) findViewById(R.id.textPartA);
        textPartB = (TextView) findViewById(R.id.textPartB);
        textScore = (TextView) findViewById(R.id.textScore);
        textLevel = (TextView) findViewById(R.id.textLevel);

        choices[0] = (Button)findViewById(R.id.buttonChoice1);
        choices[1] = (Button)findViewById(R.id.buttonChoice2);
        choices[2] = (Button)findViewById(R.id.buttonChoice3);

        choices[0].setOnClickListener(this);
        choices[1].setOnClickListener(this);
        choices[2].setOnClickListener(this);
        findViewById(R.id.btnReset).setOnClickListener(this);
        toastCorrect = Toast.makeText(getApplicationContext(), "Well Done!",Toast.LENGTH_SHORT);
        toastWrong = Toast.makeText(getApplicationContext(), "Hard Luck!", Toast.LENGTH_SHORT);
    }
    private void reset() {
        currentLevel = 1;
        currentScore = 0;
        textScore.setText("Score: " + currentScore);
        textLevel.setText("Level: " + currentLevel);
    }
    @Override
    public void onClick(View v) {
        int givenAnswer;

        switch (v.getId()) {
            case R.id.btnReset:
                reset();
                nextQuestion();
                break;
            case R.id.buttonChoice1:
            case R.id.buttonChoice2:
            case R.id.buttonChoice3:
                givenAnswer = Integer.parseInt(((Button) v).getText().toString());
                updateScore(givenAnswer);
                nextQuestion();
                break;
        }
    }
    private void updateScore(int givenAnswer) {
        if (correctAnswer == givenAnswer) {
            currentScore = currentScore + 10;
            currentLevel++;
            toastWrong.cancel();
            toastCorrect.show();
        }
        else {
            currentLevel = Math.max(1, currentLevel - 1);
            currentScore = Math.max(0, currentScore - 10);
            toastCorrect.cancel();
            toastWrong.show();
        }
        textScore.setText("Score: " + currentScore);
        textLevel.setText("Level: " + currentLevel);
        if (currentScore > Score.highest) {
            Score.highest = currentScore;
        }
    }

    private int getRandomNumber(int level) {
        return random.nextInt((int)Math.pow(10.0, level));
    }

    private void nextQuestion() {
        partA = getRandomNumber(currentLevel);
        Log.i("info", "First Random number is " + partA);
        partB = getRandomNumber(currentLevel);
        Log.i("info", "Second Random number is " + partB);
        correctAnswer = partA + partB;
        textPartA.setText("" + partA);
        textPartB.setText("" + partB);
        int[] answers = getAnswers(correctAnswer);
        for(int i = 0; i < answers.length; i++) {
            choices[i].setText("" + answers[i]);
        }
    }

    int[] getAnswers(int correctAnswer) {
        int[] answers = {-1, -1, -1};
        int whichChoice = random.nextInt(answers.length);
        Log.i("info", "Right answer is in "+ whichChoice);
        answers[whichChoice] = correctAnswer;
        int wrongAnswer = -1;
        do {
            wrongAnswer = getRandomNumber(currentLevel + 1);
            Log.i("info", "Found wrong number - " + wrongAnswer);
        } while(wrongAnswer == correctAnswer);
        Log.i("info", "First wrong answer is " + wrongAnswer);
        int lastCell = -1;
        switch ((whichChoice)) {
            case 0:
                lastCell = 2;
                answers[1] = wrongAnswer;
                break;
            case 1:
                lastCell = 2;
                answers[0] = wrongAnswer;
                break;
            case 2:
                lastCell = 1;
                answers[0] = wrongAnswer;
                break;
        }
        int secondWrong = -1;
        do {
            secondWrong = getRandomNumber(currentLevel + 1);
        } while(secondWrong == wrongAnswer || secondWrong == correctAnswer);
        Log.i("info", "Second wrong answer is " + secondWrong);
        answers[lastCell] = secondWrong;
        return answers;
    }
}
