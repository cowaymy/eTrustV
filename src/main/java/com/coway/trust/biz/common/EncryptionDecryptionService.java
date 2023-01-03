package com.coway.trust.biz.common;

import javax.crypto.SecretKey;

public interface EncryptionDecryptionService {

	String encrypt(String strToEncrypt, String secret);

	String decrypt(String strToDecrypt, String secret);

}
