public class StaticExample {
    static {
         System.out.println("In Outer class static");
    }

    public static class InnerClass {
        static {
            System.out.println("In Inner class static");
        }
    }
    public static void main(String[] args){}
}