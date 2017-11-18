int base = 10;
int max_num = 100;

for (int i = 1; i <= 100; i++) {
    printlabel(i);
}

void printlabel(int i) {
def map = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    String s = "";
    while (i > 0) {
        int mod = i % 26;
        int d = i/26;
        s = map[mod] + s;
        i = d;
    }
    println s;
}
