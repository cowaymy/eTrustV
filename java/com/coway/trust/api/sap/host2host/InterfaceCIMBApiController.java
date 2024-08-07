package com.coway.trust.api.sap.host2host;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.coway.trust.AppConstants;
import com.coway.trust.util.SFTPUtil;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "interfaceCIMB", description = "interfaceCIMB")
@RestController
@RequestMapping(AppConstants.API_BASE_URI + "/cimb")
public class InterfaceCIMBApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(InterfaceCIMBApiController.class);

	@Value("${host2host.sap.ftp.host}")
    private String SAP_IF_FTP_HOST;	// 10.101.3.40

	@Value("${host2host.sap.ftp.port}")
	public int SAP_IF_FTP_PORT;	// = 22;

	@Value("${host2host.sap.ftp.userid}")
	public String SAP_IF_FTP_USERID;	// = "etrustftp4";

	@Value("${host2host.sap.ftp.userpw}")
	public String SAP_IF_FTP_USERPW;	// = "akffus#20!(";

	@Value("${host2host.sap.ftp.rootpath}")
	public String SAP_IF_FTP_ROOTPATH;	// = "/home/etrustftp4/data/sap2etrust/DEV";

	@Value("${host2host.sap.ftp.rootpath_decrypt}")
	public String SAP_IF_FTP_ROOTPATH_DECRYPT;	// = "/home/etrustftp4/data/etrust2sap/DEV";


	@Value("${host2host.was.encrypt.temp.rootpath}")
	public String WAS_ENCRYPT_TEMP_ROOTPATH;	// = "/was/gnupg/cimb/encrypt/";	 // WAS_ENCRYPT_TEMP_ROOTPATH + "YYYYMMDD" = "/was/gnupg/cimb/encrypt/20191222/"

	@Value("${host2host.was.encrypt.rootpath}")
	public String WAS_ENCRYPT_ROOTPATH;	// = "/was/gnupg/cimb/encrypt/";	// WAS_ENCRYPT_ROOTPATH + "YYYYMMDD" = "/was/gnupg/cimb/encrypt/20191222/"

	@Value("${host2host.was.decrypt.temp.rootpath}")
	public String WAS_DECRYPT_TEMP_ROOTPATH;	// = "/was/gnupg/cimb/decrypt/";

	@Value("${host2host.was.decrypt.rootpath}")
	public String WAS_DECRYPT_ROOTPATH;	// = "/was/gnupg/cimb/decrypt/";


	@Value("${host2host.cimb.ftp.host}")
	public String CIMB_FTP_HOST;	// = "203.115.237.33";	// 127.0.0.1

	@Value("${host2host.cimb.ftp.port}")
	public int CIMB_FTP_PORT;	// = 6039;    // 22;

	@Value("${host2host.cimb.ftp.userid}")
	public String CIMB_FTP_USERID;	// = "COWAY_AutoPay";

	@Value("${host2host.cimb.ftp.userpw}")
	public String CIMB_FTP_USERPW;	// = "password";    //"1234";

	@Value("${host2host.cimb.ftp.rootpath}")
	public String CIMB_FTP_ROOTPATH;	// = "/COWAY/Inbound/";

	@Value("${host2host.cimb.ftp.rootpath_decrypt}")
	public String CIMB_FTP_ROOTPATH_DECRYPT;	// = "/COWAY/Outbound/";


	@Value("${host2host.pgp.passphrase}")
	public String PGP_PASSPHRASE;	// = "TEST";

	@Value("${host2host.cimb.keyname}")
	public String CIMB_KEYNAME; // cimbsfguat

	/*
	public String SAP_IF_FTP_HOST = "10.101.3.40";
	public int SAP_IF_FTP_PORT = 22;
	public String SAP_IF_FTP_USERID = "etrustftp4";
	public String SAP_IF_FTP_USERPW = "akffus#20!(";
	public String SAP_IF_FTP_ROOTPATH = "/home/etrustftp4/data/sap2etrust/DEV";
	public String SAP_IF_FTP_ROOTPATH_DECRYPT = "/home/etrustftp4/data/etrust2sap/DEV";

	public String WAS_ENCRYPT_TEMP_ROOTPATH = "/was/gnupg/cimb/encrypt/";	 // WAS_ENCRYPT_TEMP_ROOTPATH + "YYYYMMDD" = "/was/gnupg/cimb/encrypt/20191222/"
	public String WAS_ENCRYPT_ROOTPATH = "/was/gnupg/cimb/encrypt/";	// WAS_ENCRYPT_ROOTPATH + "YYYYMMDD" = "/was/gnupg/cimb/encrypt/20191222/"

	public String WAS_DECRYPT_TEMP_ROOTPATH = "/was/gnupg/cimb/decrypt/";
	public String WAS_DECRYPT_ROOTPATH = "/was/gnupg/cimb/decrypt/";


	public String CIMB_FTP_HOST = "203.115.237.33";	// 127.0.0.1
	public int CIMB_FTP_PORT = 6039;    // 22;
	public String CIMB_FTP_USERID = "COWAY_AutoPay";
	public String CIMB_FTP_USERPW = "password";    //"1234";
	public String CIMB_FTP_ROOTPATH = "/COWAY/Inbound/";
	public String CIMB_FTP_ROOTPATH_DECRYPT = "/COWAY/Outbound/";

	public String PGP_PASSPHRASE = "TEST";
	*/


	// *** SAP I/F FTP -> PGP Encrypt -> CIMB FTP  *** //

	 /**
	 * TO-DO Description
	 * @Author KR-MIN
	 * @Date 2019. 11. 29.
	 * @param interfaceCIMBForm
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "send", produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/send", method = RequestMethod.GET)
	public ResponseEntity<InterfaceCIMBDto> send(@ModelAttribute InterfaceCIMBForm interfaceCIMBForm, ModelMap model) throws Exception {

		EgovMap egvoMap = new EgovMap();

		InterfaceCIMBDto dto = InterfaceCIMBDto.create(egvoMap);

		Map<String, Object> params = interfaceCIMBForm.createMap(interfaceCIMBForm);

		if(params == null){
			dto.setCode("1001");
			dto.setMessage("params is null");
			return ResponseEntity.ok(dto);
		}

		Date today = new Date();
		SimpleDateFormat format1 = new SimpleDateFormat("yyyyMMdd");
		String dt = format1.format(today);

		String temRootPath =  WAS_ENCRYPT_TEMP_ROOTPATH + dt + "/";
		String encryptRootPath =  WAS_ENCRYPT_ROOTPATH + dt + "/";
//		String temRootPath = "C:/Users/HQIT-HUIDING/Desktop/CIMBTEST/" + dt + "/";
//		String encryptRootPath = "C:/Users/HQIT-HUIDING/Desktop/CIMBTEST/" + dt + "/";

		String pFileName = (String)params.get("fileName");

		if(pFileName == null || "".equals(pFileName)){
			dto.setCode("10");
			dto.setMessage("params(fileName) is null");
			return ResponseEntity.ok(dto);
		}

		// make folder
		LOGGER.debug("1-1. Make root folder Start");
		File desti = new File(temRootPath);
		if (!desti.exists()) {
		    desti.mkdirs();
		}

		File desti2 = new File(encryptRootPath);
		if (!desti2.exists()) {
		    desti2.mkdirs();
		}
		LOGGER.debug("1-2. Make root folder End");

		String[] fileNameList = new String[]{pFileName};

		LOGGER.debug("2-1. Get fpt file from sap I/F fpt Start.");

		// 1. Get fpt file from sap I/F fpt
		try {
    		boolean bl = getFileFromSAPFtps(fileNameList);
    		if(!bl){
    			// fail code, message
    			dto.setCode("2000");
    			dto.setMessage("Error get file from SAP FTP.");
    			return ResponseEntity.ok(dto);
    		}
		}catch(Exception e) {
			dto.setCode("2001");
			dto.setMessage("Unexpected Error:" + e.getMessage());
			LOGGER.error("Unexpected Error:" + e.getMessage());
			return ResponseEntity.ok(dto);
		}

		LOGGER.debug("2-2. Get fpt file from sap I/F fpt End.");


		LOGGER.debug("3. PGP encryption/send Start.");
		// 2. PGP encryption

		String cmd = "";
		String str = null;
		StringBuffer sb = null;

		String encryptFilePath = "";

		for(String fileName:fileNameList){
			try {

				LOGGER.debug("3-1. PGP encryption Start.");

				LOGGER.debug("fileName:" + fileName);

				String[] arr = fileName.split("\\.");
				encryptFilePath = encryptRootPath + arr[0] + ".GPG";

				// encrypt file exist -> delete
				File fileEncryptDel = new File(encryptFilePath);
				fileEncryptDel.delete();

				cmd = "gpg --output " + encryptFilePath + " --encrypt --recipient " + CIMB_KEYNAME  + " "+ temRootPath + fileName ;

				LOGGER.debug(">>>>>>>>>encrypt cmd: " + cmd);

				// 명령행 출력 라인 캡쳐를 위한 StringBuffer 설정
			    sb = new StringBuffer();
			    // 명령 실행
			    Process proc = Runtime.getRuntime().exec(cmd);
			    // 명령행의 출력 스트림을 얻고, 그 내용을 buffered reader input stream에 입력한다.
			    BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
			    // 명령행에서의 출력 라인 읽음
			    while ((str = br.readLine()) != null){
			        sb.append(str).append("\n");
			        LOGGER.debug(">>>>>>>>>" + str);
			    }

			    // 명령행이 종결되길 기다린다
			    int rtn = -9999;
			    try {
			        proc.waitFor();
			        // 종료값 체크
			        rtn = proc.exitValue();
			        LOGGER.debug( ">>>>>>>>>>>>rtn:" + rtn);

			    }catch(InterruptedException e) {
			    	LOGGER.error("e", e);

			    	dto.setCode("3001");
					dto.setMessage("Error encrypt file." + e.getMessage());
					return ResponseEntity.ok(dto);
			    }finally{
			        //stream을 닫는다
			        br.close();
			   }

			    LOGGER.debug("3-2. PGP encryption End.");

			    if(rtn == 0){	// success encrypt
    			    LOGGER.debug("4-1. Send file to cimb ftp Start.");
    			    //LOGGER.debug("4-1(TEMP). Skip send file to cimb (UAT).");
    				// 3. Send file to cimb ftp
    			    File fileEncrypt = new File(encryptFilePath);
    			    LOGGER.debug(">>>fileEncrypt.getPath : " + fileEncrypt.getPath());
    				boolean bl3 = sendFileToCIMBFtps(new File[]{fileEncrypt});
    				if(!bl3){
    					// fail code, message

    					LOGGER.error("e", ">>>> Error : Send file to cimb ftp - " + encryptFilePath);

    					dto.setCode("4001");
    					dto.setMessage("Error send file to CIMB.");
    					return ResponseEntity.ok(dto);
    				}
    				LOGGER.debug("4-2. Send file to cimb ftp End.");
			    } else{
		    		dto.setCode("4002");
					dto.setMessage("Encrypt file rtn is not 0.[" + rtn + "]");
					return ResponseEntity.ok(dto);

			    }
			}catch(Exception e) {
				dto.setCode("9000");
				dto.setMessage("Unexpected Error:" + e.getMessage());
				return ResponseEntity.ok(dto);
			}
		}

		LOGGER.debug("3. PGP encryption/send End.");

		//String[] fileList = new String[]{"test_20191129_001.txt.GPG", "test_20191129_002.txt.GPG", "test_20191129_003.txt.GPG"};
		/*
		String rootPath = WAS_ENCRYPT_TEMP_ROOTPATH; 	// from dir
		File dirFile=new File(rootPath);
		File[] fileList = dirFile.listFiles();

		LOGGER.debug("3-1. Send file to cimb ftp Start.");
		// 3. Send file to cimb ftp
		boolean bl3 = sendFileToCIMBFtps(fileList);
		if(!bl3){
			// fail code, message

			return ResponseEntity.ok(dto);
		}
		LOGGER.debug("3-2. Send file to cimb ftp End.");
		*/

		dto.setCode("0");
		dto.setMessage("success");

		return ResponseEntity.ok(dto);
	}


	// 1. File download from SAP I/F ftp to etrust was temp
	private boolean getFileFromSAPFtps(String[] fileNameList){

		String host = SAP_IF_FTP_HOST;
		int port = SAP_IF_FTP_PORT;
		String userName = SAP_IF_FTP_USERID;
		String password = SAP_IF_FTP_USERPW;
		String dir = SAP_IF_FTP_ROOTPATH;		// from dir
		String rootPath = WAS_ENCRYPT_TEMP_ROOTPATH; 	// to dir
		//String rootPath = "C:/Users/HQIT-HUIDING/Desktop/CIMBTEST/";

		Date today = new Date();
		SimpleDateFormat format1 = new SimpleDateFormat("yyyyMMdd");
		String dt = format1.format(today);

		rootPath +=  dt + "/";

		// connect sftp
		SFTPUtil util = new SFTPUtil();
		util.init(host, userName, password, port);


		// download
		for (String downloadFileName : fileNameList) {

			LOGGER.debug(">>> downloadFileName :" + dir + downloadFileName);

			String path = rootPath + downloadFileName;
			boolean bl = util.download(dir, downloadFileName, path);
			if(!bl){
				LOGGER.debug("Error file download : " + path);
				return false;
			}

		}

		// disconnection
		util.disconnection();

		return true;
	}

	// 3. File upload from etrust was temp to CIMB ftp
	private boolean sendFileToCIMBFtps(File[] fileList){

		String host = CIMB_FTP_HOST;		// CIMB ip
		int port = CIMB_FTP_PORT;
		String userName = CIMB_FTP_USERID;
		String password = CIMB_FTP_USERPW;
		String dir = CIMB_FTP_ROOTPATH; // to dir : CIMB ftp dir

		// connect sftp
		LOGGER.debug(">>> sendFileToCIMBFtps > sftp init");
		SFTPUtil util = new SFTPUtil();
		util.init(host, userName, password, port);

		// upload
		for (File file : fileList) {
			LOGGER.debug(">>> sendFileToCIMBFtps > sftp file upload");
			boolean bl = util.upload(dir, file);
			if(!bl){
				LOGGER.debug("파일 upload 오류 : " + file.getName());
				return false;
			}

			LOGGER.debug(">>> sendFileToCIMBFtps > bl : " + bl);

		}
		//LOGGER.debug("파일 업로드를 완료하였습니다.");


		// disconnection
		LOGGER.debug(">>> sendFileToCIMBFtps > sftp disconnection");
		util.disconnection();

		return true;
	}


	// *** CIMB FTP -> PGP Decrypt -> SAP I/F FTP  *** //

	@ApiOperation(value = "receive", produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/receive", method = RequestMethod.GET)
	public ResponseEntity<InterfaceCIMBDto> receive(@ModelAttribute InterfaceCIMBForm interfaceCIMBForm, ModelMap model) throws Exception {

		EgovMap egvoMap = new EgovMap();

		InterfaceCIMBDto dto = InterfaceCIMBDto.create(egvoMap);

		Map<String, Object> params = interfaceCIMBForm.createMap(interfaceCIMBForm);

		if(params == null){
			dto.setCode("1001");
			dto.setMessage("params is null");
			return ResponseEntity.ok(dto);
		}

		Date today = new Date();
		SimpleDateFormat format1 = new SimpleDateFormat("yyyyMMdd");
		String dt = format1.format(today);

		String temRootPath =  WAS_DECRYPT_TEMP_ROOTPATH + dt + "/";
		String decryptRootPath =  WAS_DECRYPT_ROOTPATH + dt + "/";

		String pFileName = (String)params.get("fileName");

		if(pFileName == null || "".equals(pFileName)){
			dto.setCode("10");
			dto.setMessage("params(fileName) is null");
			return ResponseEntity.ok(dto);
		}

		// make folder
		LOGGER.debug("1-1. Make root folder Start");
		File desti = new File(temRootPath);
		if (!desti.exists()) {
		    desti.mkdirs();
		}

		File desti2 = new File(decryptRootPath);
		if (!desti2.exists()) {
		    desti2.mkdirs();
		}
		LOGGER.debug("1-2. Make root folder End");

		String[] fileNameList = new String[]{pFileName};

		LOGGER.debug("2-1. Get fpt file from CIMB sftp Start.");

		// 1. File download from CIMB ftp to etrust was temp
		try {
    		boolean bl = getFileFromCIMBFtps(fileNameList);
    		if(!bl){
    			// fail code, message
    			dto.setCode("2000");
    			dto.setMessage("Error get file from CIMB SFTP.");
    			return ResponseEntity.ok(dto);
    		}
		}catch(Exception e) {
			dto.setCode("2100");
			dto.setMessage("Error get file from CIMB SFTP Error:" + e.getMessage());
			return ResponseEntity.ok(dto);
		}

		LOGGER.debug("2-2. Get fpt file from CIMB sftp End.");



		LOGGER.debug("3. PGP decryption/send Start.");
		// 3. PGP decryption
		String cmd = "";
		String str = null;
		StringBuffer sb = null;

		String decryptFilePath = "";

		for(String fileName:fileNameList){
			try {

    			LOGGER.debug("3-1. PGP decryption Start.");

    			LOGGER.debug("fileName:" + fileName);

    			String[] arr = fileName.split("\\.");
    			decryptFilePath = decryptRootPath + arr[0] + ".TXT";

    			// decrypt file exist -> delete
    			File fileEncryptDel = new File(decryptFilePath);
    			fileEncryptDel.delete();

    			//cmd = "gpg --no-tty --homedir /was/gnupg/gnupg-1.4.22 --output " + decryptFilePath  + " --passphrase " + PGP_PASSPHRASE + " --decrypt " + temRootPath + fileName;
    			//cmd = "echo " + PGP_PASSPHRASE + " | gpg --no-tty --homedir /home/weblogic/.gnupg --output " + decryptFilePath  + " --passphrase-fd 0 --decrypt " + temRootPath + fileName;
    			//cmd = "gpg --no-tty --homedir /home/weblogic/.gnupg --passphrase TEST --output " + decryptFilePath  + " --decrypt " + temRootPath + fileName;

    			//cmd = "echo " + PGP_PASSPHRASE + " | gpg --passphrase-fd 0 --output " + decryptFilePath  + " --decrypt " + temRootPath + fileName;

    			//cmd = "gpg -q --no-tty --homedir /home/weblogic/.gnupg --passphrase-fd TEST --output " + decryptFilePath  + " --decrypt " + temRootPath + fileName;
    			cmd = "gpg  --passphrase TEST --batch --yes --output " + decryptFilePath  + " --decrypt " + temRootPath + fileName;


    			LOGGER.debug(">>>>>>>>>decrypt cmd: " + cmd);

    			// 명령행 출력 라인 캡쳐를 위한 StringBuffer 설정
			    sb = new StringBuffer();
			    // 명령 실행
			    Process proc = Runtime.getRuntime().exec(cmd);
			    // 명령행의 출력 스트림을 얻고, 그 내용을 buffered reader input stream에 입력한다.
			    BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
			    // 명령행에서의 출력 라인 읽음
			    while ((str = br.readLine()) != null){
			        sb.append(str).append("\n");
			        LOGGER.debug(">>>>>>>>>" + str);
			    }

			    BufferedReader brError = new BufferedReader(new InputStreamReader(proc.getErrorStream()));
			    // 명령행에서의 출력 라인 읽음
			    while ((str = brError.readLine()) != null){
			        sb.append(str).append("\n");
			        LOGGER.debug(">>>>>>>>>error>>" + str);
			    }

    		    // 명령행이 종결되길 기다린다
    		    int rtn = -9999;
    		    try {
    		        proc.waitFor();
    		        // 종료값 체크
    		        rtn = proc.exitValue();
    		        LOGGER.debug( ">>>>>>>>>>>>rtn:" + rtn);

    		    }catch(InterruptedException e) {
    		    	LOGGER.error("e", e);

    		    	dto.setCode("3001");
    				dto.setMessage("Error encrypt file." + e.getMessage());
    				return ResponseEntity.ok(dto);
    		    }finally{
    		        //stream을 닫는다
    		        if(br != null){
    		        	br.close();
    		        }
    		        if(brError != null){
    		        	brError.close();
    		        }
    		   }

    		    LOGGER.debug("3-2. PGP decryption End.");

    		    if(rtn == 0){	// success encrypt
    			    LOGGER.debug("4-1. Send file to SAP I/F ftp Start.");
    				// 3. Send file to sap i/f ftp
    			    File fileDecrypt = new File(decryptFilePath);
    			    LOGGER.debug(">>>fileDecrypt.getPath : " + fileDecrypt.getPath());

    			    if(!fileDecrypt.exists()){
    			    	LOGGER.error("e", ">>>> Error : Decrypt file not exist - " + decryptFilePath);

    					dto.setCode("4001");
    					dto.setMessage("Error: Decrypt file not exist.");
    					return ResponseEntity.ok(dto);

    			    }

    				boolean bl3 = sendFileToSAPFtps(new File[]{fileDecrypt});
    				if(!bl3){
    					// fail code, message

    					LOGGER.error("e", ">>>> Error : Send file to SAP I/F ftp - " + decryptFilePath);

    					dto.setCode("4002");
    					dto.setMessage("Error send file to SAP I/F ftp.");
    					return ResponseEntity.ok(dto);
    				}
    				LOGGER.debug("4-2. Send file to SAP I/F ftp End.");
    		    } else{
    	    		dto.setCode("4003");
    				dto.setMessage("Decrypt file rtn is not 0.[" + rtn + "]");
    				return ResponseEntity.ok(dto);

    		    }
    		}catch(Exception e) {
    			dto.setCode("9000");
    			dto.setMessage("Unexpected Error:" + e.getMessage());
    			return ResponseEntity.ok(dto);
    		}
    	}

		LOGGER.debug("3. PGP encryption/send End.");

		dto.setCode("0");
		dto.setMessage("success");

		return ResponseEntity.ok(dto);
	}

	// 1. File download from CIMB ftp to etrust was temp
	private boolean getFileFromCIMBFtps(String[] fileNameList){

		String host = CIMB_FTP_HOST;
		int port = CIMB_FTP_PORT;
		String userName = CIMB_FTP_USERID;
		String password = CIMB_FTP_USERPW;
		String dir = CIMB_FTP_ROOTPATH_DECRYPT;		// from dir
		String rootPath = WAS_DECRYPT_TEMP_ROOTPATH; 	// to dir

		Date today = new Date();
		SimpleDateFormat format1 = new SimpleDateFormat("yyyyMMdd");
		String dt = format1.format(today);

		rootPath +=  dt + "/";

		// connect sftp
		SFTPUtil util = new SFTPUtil();
		util.init(host, userName, password, port);

		// make folder
		File desti = new File(rootPath);
		if (!desti.exists()) {
		    desti.mkdirs();
		}

		// download
		for (String downloadFileName : fileNameList) {

			String path = rootPath + downloadFileName;
			boolean bl = util.download(dir, downloadFileName, path);
			if(!bl){
				LOGGER.debug("파일 다운로드 오류 : " + path);
				return false;
			}

		}
		LOGGER.debug("파일 다운로드를 완료하였습니다.");


		// disconnection
		util.disconnection();

		return true;
	}

	// 3. File upload from etrust was temp to SAP I/F ftp
	private boolean sendFileToSAPFtps(File[] fileList){

		String host = SAP_IF_FTP_HOST;		// CIMB ip
		int port = SAP_IF_FTP_PORT;
		String userName = SAP_IF_FTP_USERID;
		String password = SAP_IF_FTP_USERPW;
		String dir = SAP_IF_FTP_ROOTPATH_DECRYPT; // to dir : SAP I/F ftp dir

		// connect sftp
		SFTPUtil util = new SFTPUtil();
		util.init(host, userName, password, port);

		// upload
		for (File file : fileList) {

			boolean bl = util.upload(dir, file);
			if(!bl){
				LOGGER.debug("파일 upload 오류 : " + file.getName());
				return false;
			}

		}
		LOGGER.debug("파일 업로드를 완료하였습니다.");


		// disconnection
		util.disconnection();

		return true;
	}



	public static void main(String[] args) {
		System.out.println(">>>>>>>>>start");
/*
		 String hostName = "203.115.237.33:6039";
	        String userame = "COWAY_AutoPay";
	        String password = "password";
	        String localFilePath = "C:/test/test_20191129_001.txt.GPG";
	        String remoteFilePath = "/COWAY/Inbound/test_20191129_001.txt.GPG";
	        //SftpUtils.upload(hostName, userame, password, localFilePath, remoteFilePath);
	        File f = new File(localFilePath);
	        if (!f.exists())
	            throw new RuntimeException("Error. Local file not found");
	        FileInputStream fileInputStream = null;
			try {
				fileInputStream = new FileInputStream(f);
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	        SFTPUtil2.upload(hostName, userame, password, fileInputStream, "test.txt", remoteFilePath);
*/

/*

		String rootPath = WAS_ENCRYPT_TEMP_ROOTPATH; 	// from dir
		rootPath = "C:\\test\\20191203\\";

		File dirFile=new File(rootPath);
		File[] fileList = dirFile.listFiles();

		LOGGER.debug("3-1. Send file to cimb ftp Start.");
		// 3. Send file to cimb ftp
		boolean bl3 = sendFileToCIMBFtps(fileList);


		System.out.println(">>>>>>>>>bl3: " + bl3);

		LOGGER.debug("3-2. Send file to cimb ftp End.");

*/

		/*boolean bl = getFileFromSAPFtps(new String[]{"test1.txt","test2.txt"});
		if(!bl){
			System.out.println(">>>>>>>>>bl: " + bl);
		}*/


/*
		String[] fileNameList = new String[]{"test.txt","test2.txt"};
		// 2. PGP encryption
		String rootPath = WAS_ENCRYPT_TEMP_ROOTPATH; 	// from dir
		String encryptRootPath = WAS_ENCRYPT_ROOTPATH; 	// to dir
		File dirFile=new File(rootPath);
		File[] fileList = dirFile.listFiles();

		for(String fileName:fileNameList){
			String[] cmd = new String[]{"gpg --output " + encryptRootPath + fileName + " --encrypt --recipient 'TEST1' " + rootPath + fileName};

		    Process process = null;
			try {
				process = Runtime.getRuntime().exec(cmd);
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

		    BufferedWriter out = new BufferedWriter(new OutputStreamWriter(process.getOutputStream()));

		    try {
		        out.close();
		    } catch (IOException e) {
		        e.printStackTrace();
		    }
		}*/

		/*String cmds = "sh /Users/Kyeongrok/hello.sh";
        String[] callCmd = {"/bin/bash", "-c", cmds};
        Map map = shRunner.execCommand(callCmd);

        System.out.println(map);*/

		// 3. Send file to cimb ftp
		/*
		boolean bl3 = sendFileToCIMBFtps(fileList);
		if(!bl3){
			System.out.println(">>>>>>>>>bl3: " + bl3);
		}*/
	}

	@ApiOperation(value = "test", produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/test", method = RequestMethod.GET)
	public ResponseEntity<InterfaceCIMBDto> test(@ModelAttribute InterfaceCIMBForm interfaceCIMBForm, ModelMap model) throws Exception {

		EgovMap egvoMap = new EgovMap();

		InterfaceCIMBDto dto = InterfaceCIMBDto.create(egvoMap);

		Map<String, Object> params = interfaceCIMBForm.createMap(interfaceCIMBForm);


		String cmd = "";
		String str = null;
		String result = "";
		StringBuffer sb = null;

		//cmd = "ls -al /home/etrust_user/test/20191220";

		cmd = "gpg --output /was/gnupg/cimb/20191222/H2HAPS6087723102019006_3.TXT.GPG --encrypt --recipient TEST2 /was/gnupg/cimb/20191222/H2HAPS6087723102019006.TXT";

		// 명령행 출력 라인 캡쳐를 위한 StringBuffer 설정
	    sb = new StringBuffer();
	    // 명령 실행
	    Process proc = Runtime.getRuntime().exec(cmd);
	    // 명령행의 출력 스트림을 얻고, 그 내용을 buffered reader input stream에 입력한다.
	    BufferedReader br = new BufferedReader(new InputStreamReader(proc.getInputStream()));
	    // 명령행에서의 출력 라인 읽음
	    while ((str = br.readLine()) != null){
	        sb.append(str).append("</br>");
	        System.out.println(">>>>>>>>>" + str);
	    }

	    // 명령행이 종결되길 기다린다
	    try {
	        proc.waitFor();
	        // 종료값 체크
	        int rtn = proc.exitValue();
	        if (rtn != 0) {
	            result = "exit value was non-zero " + rtn;
	        }
	    }catch(InterruptedException e) {
	        result = "process was interrupted";
	    }finally{
	        //stream을 닫는다
	        br.close();
	   }

		return ResponseEntity.ok(dto);

	}

}
