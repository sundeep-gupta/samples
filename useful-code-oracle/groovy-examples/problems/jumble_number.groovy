

int N = 500;

for (int j = 1; j < N; j++) {
    if (isJumbled(j)) {
        print  j + "  " ;
    }
}
boolean isJumbled(int num) {
    boolean jumbled = true
    List<String> tokens = Integer.toString(num).split("(?!^)");
    for(int i = 1; i < tokens.size(); i++) {
        int prevValue = Integer.valueOf(tokens[i - 1])
        int currValue = Integer.valueOf(tokens[i])
        jumbled = (prevValue - currValue) == 1 ?true : 
                (currValue - prevValue) == 1 ? true: false; 
        if(!jumbled) { return false}
    }
    return true
}

