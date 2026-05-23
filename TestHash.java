import java.security.MessageDigest;

public class TestHash {
    public static void main(String[] args) throws Exception {
        String[] pws = {"Swap@123", "123456", "Shiv"};
        for (String p : pws) {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(p.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder(2 * hash.length);
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if(hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            System.out.println(p + " -> " + hexString.toString());
        }
    }
}
