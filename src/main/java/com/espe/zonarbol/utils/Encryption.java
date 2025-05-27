package com.espe.zonarbol.utils;

import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;

public class Encryption {
    private static final String SECRET = "jer787Adji87Tas7y8D";
    
    public static String encrypt(String password) {
      Key  key = new SecretKeySpec(SECRET.getBytes(),  0, 16, "AES");
      byte[] encripted = null;
      Cipher chiper;
      
        try {
            chiper = Cipher.getInstance("AES/ECB/PKCS5Padding");
            chiper.init(Cipher.ENCRYPT_MODE, key);
            encripted = chiper.doFinal(password.getBytes());
        } catch (NoSuchAlgorithmException | NoSuchPaddingException | InvalidKeyException | IllegalBlockSizeException | BadPaddingException ex) {
            System.out.println("Something went wrong when encrypting the password");
            return null;
        }
        
      return Base64.getEncoder().encodeToString(encripted);
    }
    
    
    public static String decrypt(String encriptedPassword) {
        Key key = new SecretKeySpec(SECRET.getBytes(),  0, 16, "AES");
        
        String decryptedBytes = null;
        Cipher chiper;
        
        try {
            chiper = Cipher.getInstance("AES/ECB/PKCS5Padding");
            chiper.init(Cipher.DECRYPT_MODE, key);
            
            byte[] decodedBytes = Base64.getDecoder().decode(encriptedPassword);
            decryptedBytes = new String(chiper.doFinal(decodedBytes));
            
        } catch (NoSuchAlgorithmException | NoSuchPaddingException | InvalidKeyException | IllegalBlockSizeException | BadPaddingException ex ) {
            System.out.println("Something went wrong when decrypting the password"); 
        }
        
        return decryptedBytes;
    }
    
    public static boolean comparePasswords(String passwordToCheck, String passwordBytes){
        String realPassword = decrypt(passwordBytes);
        
        return realPassword.equals(passwordToCheck);
    }
}
