package com.coway.trust.biz.common.impl;
import com.coway.trust.biz.common.EncryptionDecryptionService;
import com.coway.trust.web.payment.mobileAutoDebit.controller.MobileAutoDebitController;

import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Arrays;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;

@Service("encryptionDecryptionService")
public class EncryptionDecryptionServiceImpl implements EncryptionDecryptionService {
	private static final Logger LOGGER = LoggerFactory.getLogger(EncryptionDecryptionServiceImpl.class);
	private static SecretKeySpec secretKey;
    private static byte[] key;
    private static final String ALGORITHM = "AES";
	static Cipher cipher;

	@Override
	 public String encrypt(String strToEncrypt, String secret) {
	        try {
	            prepareSecreteKey(secret);
	            Cipher cipher = Cipher.getInstance(ALGORITHM);
	            cipher.init(Cipher.ENCRYPT_MODE, secretKey);
	            //DO url encoder
	            return URLEncoder.encode(Base64.getEncoder().encodeToString(cipher.doFinal(strToEncrypt.getBytes("UTF-8"))), StandardCharsets.UTF_8.toString());
	        } catch (Exception e) {
				LOGGER.debug("error: =====================>> " + e.toString());
	        }
	        return null;
	    }

	@Override
	    public String decrypt(String strToDecrypt, String secret) {
	        try {
	            prepareSecreteKey(secret);
	            Cipher cipher = Cipher.getInstance(ALGORITHM);
	            cipher.init(Cipher.DECRYPT_MODE, secretKey);
	            /* URL decode is ignore because http server auto decoded when value passed in */
	            //return new String(cipher.doFinal(Base64.getDecoder().decode(URLDecoder.decode(strToDecrypt, StandardCharsets.UTF_8.toString()))));
	            return new String(cipher.doFinal(Base64.getDecoder().decode(strToDecrypt)));
	        } catch (Exception e) {
	            System.out.println("Error while decrypting: " + e.toString());
	        }
	        return null;
	    }


	private void prepareSecreteKey(String myKey) {
        MessageDigest sha = null;
        try {
            key = myKey.getBytes(StandardCharsets.UTF_8);
            sha = MessageDigest.getInstance("SHA-1");
            key = sha.digest(key);
            key = Arrays.copyOf(key, 16);
            secretKey = new SecretKeySpec(key, ALGORITHM);
        } catch (NoSuchAlgorithmException e) {
			LOGGER.debug("error: =====================>> " + e.toString());
        }
    }
}
