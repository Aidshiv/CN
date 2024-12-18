import java.math.BigInteger;
import java.util.Random;

public class RSA {

    private BigInteger n, d, e;
    private int bitlength = 1024;
    private Random rand;

    public RSA() {
        rand = new Random();
        
        // Generate two large primes, p and q
        BigInteger p = BigInteger.probablePrime(bitlength / 2, rand);
        BigInteger q = BigInteger.probablePrime(bitlength / 2, rand);
        
        // Calculate n = p * q
        n = p.multiply(q);
        
        // Calculate Euler's Totient function, phi(n) = (p-1)*(q-1)
        BigInteger phi = (p.subtract(BigInteger.ONE)).multiply(q.subtract(BigInteger.ONE));
        
        // Set public exponent e to a common value of 65537
        e = BigInteger.valueOf(65537);
        
        // Calculate private exponent d such that d * e ≡ 1 (mod phi(n))
        d = e.modInverse(phi);
    }

    // Encrypt the plaintext
    public BigInteger encrypt(BigInteger plaintext) {
        return plaintext.modPow(e, n);
    }

    // Decrypt the ciphertext
    public BigInteger decrypt(BigInteger ciphertext) {
        return ciphertext.modPow(d, n);
    }

    // Getter for public exponent e
    public BigInteger getPublicKey() {
        return e;
    }

    // Getter for modulus n
    public BigInteger getModulus() {
        return n;
    }

    public static void main(String[] args) {
        // Initialize RSA object
        RSA rsa = new RSA();

        // Display the public key (e, n)
        System.out.println("Public Key: ");
        System.out.println("e: " + rsa.getPublicKey());
        System.out.println("n: " + rsa.getModulus());

        // Original message to be encrypted
        String message = "Hello RSA!";
        System.out.println("\nOriginal Message: " + message);

        // Convert the message into BigInteger (representing byte array)
        BigInteger plaintext = new BigInteger(message.getBytes());
        System.out.println("\nPlaintext as BigInteger: " + plaintext);

        // Encrypt the plaintext
        BigInteger ciphertext = rsa.encrypt(plaintext);
        System.out.println("\nCiphertext: " + ciphertext);

        // Decrypt the ciphertext
        BigInteger decryptedText = rsa.decrypt(ciphertext);
        
        // Convert the decrypted BigInteger back into a string
        String decryptedMessage = new String(decryptedText.toByteArray());
        System.out.println("\nDecrypted Message: " + decryptedMessage);
    }
}
