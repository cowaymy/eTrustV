package com.coway.trust.biz.payment.otherpayment.service.impl;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ObjectListing;
import com.coway.trust.biz.api.vo.HcSurveyResultCsvVO;
import com.coway.trust.biz.common.AWSS3Service;
import com.coway.trust.biz.payment.otherpayment.service.EmallPymtService;
import com.coway.trust.biz.payment.payment.service.BatchPaymentService;
import com.coway.trust.biz.payment.payment.service.impl.BatchPaymentMapper;
import com.coway.trust.web.common.CommonController;
import com.coway.trust.web.file.AWSS3Controller;
import com.coway.trust.web.payment.otherpayment.controller.EmallPymtController;
import com.coway.trust.web.payment.payment.controller.BatchPaymentController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.ResponseInputStream;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;

@Service("emallPymtService")
public class EmallPymtServiceImpl extends EgovAbstractServiceImpl implements EmallPymtService {

	private static final Logger logger = LoggerFactory.getLogger(EmallPymtController.class);

	/*
	 * @Autowired private AWSS3Controller aWSS3Controller;
	 */

	@Resource(name = "emallPymtMapper")
	private EmallPymtMapper emallPymtMapper;

	@Resource(name = "batchPaymentService")
	private BatchPaymentService batchPaymentService;

	@Resource(name = "batchPaymentMapper")
	private BatchPaymentMapper batchPaymentMapper;

	@Value("${cloud.aws.s3.bucket}")
	private String bucketName;

	@Value("${cloud.aws.credentials.accessKey}")
	private String bucketAccessKey;

	@Value("${cloud.aws.credentials.secretKey}")
	private String bucketSecretKey;

	@Value("${cloud.aws.region}")
	private String bucketRegion;

	@Value("${com.file.upload.path}")
	private String commonPath;

	@Value("${emall.s3.com.file.upload.path}")
	private String uploadPath;

	@Value("${emall.s3.com.file.directory}")
	private String fileDirectory;

	@Resource(name = "awsService")
	private AWSS3Service awsService;

	private static final Logger LOGGER = LoggerFactory.getLogger(EmallPymtServiceImpl.class);


	@Override
	public List<EgovMap> selectEmallPymtList(Map<String, Object> params) {
		return emallPymtMapper.selectEmallPymtList(params);
	}

	@Override
	public List<EgovMap> selectEmallPymtDetailsList(Map<String, Object> params) {
		return emallPymtMapper.selectEmallPymtDetailsList(params);
	}

	@Override
	public EgovMap executeAdvPymtTesting(Map<String, Object> params, HttpServletResponse response) throws Exception {
		EgovMap result = new EgovMap();
		EgovMap request = new EgovMap();

		LOGGER.debug("listBucketObjects : start\n" );
		String dirName = "";
		dirName = params.get("dirName").toString();
		request.put("directory", dirName);
//		request.put("fileId", fileId);
		request.put("uploadPath", uploadPath);
		request.put("fileType", ".xls");
		awsService.listBucketObjects(request);
		LOGGER.debug("listBucketObjects : done\n" );

		return result;
	}

	@Override
	public EgovMap executeAdvPymt(Map<String, Object> params, HttpServletResponse response) throws Exception {
		EgovMap result = new EgovMap();
		EgovMap fileResultList = new EgovMap();
		EgovMap request = new EgovMap();

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        Date currentDate = new Date();
        String todayFormattedDate = dateFormat.format(currentDate);

        //String fileId = "Sale_CapturePayment_2023101001.xls";
//        String dirName = "PaymentTransaction/" + "20231010";
        String dirName = fileDirectory + todayFormattedDate;
        if(params.get("dirName") != null && !params.get("dirName").toString().isEmpty()){
        	dirName = params.get("dirName").toString();
        }

        request.put("directory", dirName);
//		request.put("fileId", fileId);
		request.put("uploadPath", uploadPath);
		request.put("fileType", ".xls");
		if(params.get("fileId") != null && !params.get("fileId").toString().isEmpty()){
        	List<String> fileList = new ArrayList<String>();
        	String fileId = params.get("fileId").toString();
        	fileList.add(dirName + "/" + fileId);
        	fileResultList.put("files", fileList);
        	fileResultList.put("status", 1);
        }else{
    		fileResultList = awsService.listBucketObjects(request);
        }

		if(fileResultList != null && fileResultList.get("status").toString().equals("1")){
			List<String> fileList = new ArrayList<String>();
			fileList = (List<String>) fileResultList.get("files");

			for (String filePath : fileList) {
				String[] file = filePath.split("/");
				String fileId = file[2];
				if(!fileId.equals("arhive")){
					request.put("fileId", file[2]);
					EgovMap dwldResult = awsService.downloadSingleFile1(request);

					LOGGER.debug("dwldResult : ..........\n" + dwldResult.size());
					if(dwldResult != null){
						if(Integer.parseInt(dwldResult.get("status").toString()) > 0){
							EgovMap returnResult = this.excelFileProcess(request);

							//success and move the file to archieve
							if(Integer.parseInt(returnResult.get("status").toString()) >= 0){
								result = this.moveFileLocal(request);

								request.put("sourceFile", dirName + "/" + fileId);
								request.put("targetFile", dirName + "/arhive/" + fileId);
								awsService.moveFile(request);
							}else{
								result = returnResult;
							}
						}else{
							result = dwldResult;
						}
					}else{
						result.put("status", "-1");
						result.put("message", "dwldResult is null");
						LOGGER.debug("dwldResult : Failed..........\n");
					}
				}
			}

		}else{
			result.put("status", "0");
			result.put("message", fileResultList.get("message").toString());
			LOGGER.debug("listBucketObjects : Failed..........\n");
		}
		return result;
	}

	@Override
	public EgovMap excelFileProcess(Map<String, Object> params) {
		EgovMap result = new EgovMap();

		String fileId = params.get("fileId").toString();

		List<Map<String, Object>> list = new ArrayList<>();

		logger.debug(" ================ excelFileProcess ===================   ");

		try {
			FileInputStream file = new FileInputStream(new File(commonPath + uploadPath + "/" + fileId));

			// Create Workbook instance holding reference to .xlsx file
			XSSFWorkbook workbook = new XSSFWorkbook(file);

			// Get first/desired sheet from the workbook
			XSSFSheet sheet = workbook.getSheetAt(0);

			// Iterate through each rows one by one
			Iterator<Row> rowIterator = sheet.iterator();
			int countrow = sheet.getPhysicalNumberOfRows();
			if (countrow > 1) {
				Row row;
				for (int i = 1; i <= sheet.getLastRowNum(); i++) {
					row = sheet.getRow(i);

					Map<String, Object> map = new HashMap<String, Object>();
					map.put("refNo", row.getCell(0).getStringCellValue());
					map.put("doNo", row.getCell(1).getStringCellValue());
					map.put("cardNo", row.getCell(2).getStringCellValue());
					map.put("apprCd", row.getCell(3).getStringCellValue());
					map.put("trnsDt", row.getCell(4).getStringCellValue());
					map.put("appType", row.getCell(5).getStringCellValue());
					map.put("trnsAmt", row.getCell(6).getNumericCellValue());

					list.add(map);
				}
			} else {
				LOGGER.error("no record.");
				LOGGER.debug("no record...........\n");
			}

			file.close();
		} catch (Exception e) {
			LOGGER.error("Timeout:");
			LOGGER.error("[emall payment] - Caught Exception: " + e);
			// resultValue.put("status", "2001");
			// resultValue.put("message", "Unexpected Error");
			// return resultValue;
		}

		int insertEmall = 0;
		int id= 0;
		try {
//    		if (list.size() > 0) {
    			LOGGER.debug("list.size().........." + list.size() +"\n");

    			String crtUserId = "349";
    	        id = batchPaymentMapper.getPAY0044DSEQ();

    	        params.put("id", id);
    	        params.put("fileName", fileId);
    	        params.put("totalRecord", list.size());
    	        params.put("stus", 1); // Status
    	        params.put("crtUserId", crtUserId); // System Admin

    	        emallPymtMapper.insertPay0356M(params);

    	        int size = 500;
    	        int page = list.size() / size;
    	        int start;
    	        int end;

    	        Map<String, Object> bulkMap = new HashMap<>();
    	        if (list.size() > 0) {
        	        for (int i = 0; i <= page; i++) {
        	          start = i * size;
        	          end = size;

        	          if (i == page)
        	            end = list.size();

        	          bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
        	          bulkMap.put("id", id);
        	          bulkMap.put("crtUserId", crtUserId);
        	          bulkMap.put("stus", 1);
        	          emallPymtMapper.insertPay0357D(bulkMap);

        	        }
    	        }
//    		}
		} catch (Exception e) {
			result.put("status", "0");
			result.put("msg", "Store Procedure Error");
			LOGGER.error("emall excelFileProcess : " + e.toString());
	    }

		int insertResult = 0;
		if (list.size() > 0) {
			LOGGER.debug("list.size().........." + list.size() +"\n");
			String payModeId = "107";
			String cardModeIdEcom = batchPaymentService.selectBatchPayCardModeId("ECOM");
			String cardModeIdPnp = batchPaymentService.selectBatchPayCardModeId("PNPRPS");

			// Map<String, MultipartFile> fileMap = request.getFileMap();
			// MultipartFile multipartFile = fileMap.get("csvFile");
			// List<BatchPaymentVO> vos = csvReadComponent.readCsvToList(multipartFile, true, BatchPaymentVO::create);
			//
			List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();
			for (Map<String, Object> vo : list) {

				HashMap<String, Object> hm = new HashMap<String, Object>();

				EgovMap orderDet = emallPymtMapper.getOrderDetail(vo);

				if(orderDet != null){
					Date date = null;
					String pattern = "M/d/yyyy h:mm:ss a";

					SimpleDateFormat dateFormat = new SimpleDateFormat(pattern);

					SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
					int year = 1990;
					try {
						date = dateFormat.parse(vo.get("trnsDt").toString());
						System.out.println("Parsed Date: " + date);

						String yearString = yearFormat.format(date);
			            year = Integer.parseInt(yearString);
					} catch (Exception e) {
						e.printStackTrace();
					}

					hm.put("disabled", 0);
					hm.put("creator", 349);
					hm.put("updator", 349);
					hm.put("validStatusId", 1);
					hm.put("validRemark", "");
					hm.put("userOrderNo", orderDet.get("salesOrdNo"));
					hm.put("userTrNo", "");
					hm.put("userRefNo", vo.get("doNo").toString().trim());
					hm.put("userAmount", vo.get("trnsAmt").toString().trim());
					hm.put("userBankAcc", "2720/004");
					hm.put("userChqNo", "");
					hm.put("userIssueBank", "");
					hm.put("userRunningNo", "");
					hm.put("userEftNo", "");
					hm.put("userRefDate_Month", date.getMonth()+1);
					hm.put("userRefDate_Day", date.getDate());
					hm.put("userRefDate_Year", year);
					hm.put("userBankChargeAmt", "");
					hm.put("userBankChargeAcc", "");
					hm.put("sysOrderId", 0);
					hm.put("sysAppTypeId", 0);
					hm.put("sysAmount", 0);
					hm.put("sysBankAccId", 0);
					hm.put("sysIssBankId", 0);
					hm.put("sysRefDate", "1900/01/01");
					hm.put("sysBCAmt", 0);
					hm.put("sysBCAccId", 0);
					hm.put("userRemark", vo.get("refNo").toString().trim());
					hm.put("cardNo", vo.get("cardNo").toString());

					hm.put("cardModeId", cardModeIdEcom);
					hm.put("approvalCode", vo.get("apprCd").toString().trim());
					hm.put("userTrDate", "1900/01/01");
					hm.put("userCollectorCode", "");
					hm.put("sysCollectorId", 0);
					hm.put("paymentType", orderDet.get("appCode"));
					hm.put("PaymentTypeId", 0);
					hm.put("advanceMonth", 0);
					hm.put("paymentChnnl", "");

					detailList.add(hm);
					LOGGER.debug(" =========add refno and orderno ========= " +vo.get("doNo").toString() + " : " + orderDet.get("salesOrdNo"));
				}else{
					hm.put("disabled", 0);
					hm.put("creator", 349);
					hm.put("updator", 349);
					hm.put("validStatusId", 8);
					hm.put("validRemark", "No order found. Do No: " + vo.get("doNo").toString().trim());
					hm.put("userOrderNo", "");
					hm.put("userTrNo", "");
					hm.put("userRefNo", vo.get("doNo").toString().trim());
					hm.put("userAmount", vo.get("trnsAmt").toString().trim());
					hm.put("userBankAcc", "");
					hm.put("userChqNo", "");
					hm.put("userIssueBank", "");
					hm.put("userRunningNo", "");
					hm.put("userEftNo", "");
					hm.put("userRefDate_Month", 0);
					hm.put("userRefDate_Day", 0);
					hm.put("userRefDate_Year", 0);
					hm.put("userBankChargeAmt", "");
					hm.put("userBankChargeAcc", "");
					hm.put("sysOrderId", 0);
					hm.put("sysAppTypeId", 0);
					hm.put("sysAmount", 0);
					hm.put("sysBankAccId", 0);
					hm.put("sysIssBankId", 0);
					hm.put("sysRefDate", "1900/01/01");
					hm.put("sysBCAmt", 0);
					hm.put("sysBCAccId", 0);
					hm.put("userRemark", "");
					hm.put("cardNo", "");

					hm.put("cardModeId", cardModeIdEcom);
					hm.put("approvalCode", "");
					hm.put("userTrDate", "1900/01/01");
					hm.put("userCollectorCode", "");
					hm.put("sysCollectorId", 0);
					hm.put("paymentType", "");
					hm.put("PaymentTypeId", 0);
					hm.put("advanceMonth", 0);
					hm.put("paymentChnnl", "");

					detailList.add(hm);
					LOGGER.debug(" =========vo.get(doNo).toString() invalid ref no to find order ========= " +vo.get("doNo").toString() );
				}

			}

			if(detailList.size() > 0){
				Map<String, Object> master = new HashMap<String, Object>();

				master.put("batchId", id);
				master.put("payModeId", payModeId);
				master.put("batchStatusId", 1);
				master.put("confirmStatusId", 44);
				master.put("creator", 349);
				master.put("updator", 349);
				master.put("confirmDate", "1900/01/01");
				master.put("confirmBy", 0);
				master.put("convertDate", "1900/01/01");
				master.put("convertBy", 0);
				master.put("paymentType", 97);
				master.put("paymentRemark", "");
				master.put("paymentCustType", 1368);
				master.put("jomPay", 0);
				master.put("advance", 0);
				master.put("eMandate", 0);
				master.put("isBatch", 1);

				LOGGER.debug(" ================ detailList =================== " +detailList );
				LOGGER.debug(" ================ master =================== " +master );

				 insertResult = batchPaymentService.saveBatchPaymentUpload(master, detailList);

				 emallPymtMapper.updatePay0357dDetail(master);
			}else{
				LOGGER.debug(" =========detailList no records========= ");
			}

		}

		int confirmResult = 0;
		if(insertResult > 0){
			LOGGER.debug("saveBatchPaymentUpload : Sucess..........\n");
			Map<String, Object> saveParams = new HashMap<String, Object>();
			saveParams.put("batchId", insertResult);
			saveParams.put("userId", 349);
			confirmResult = batchPaymentService.saveConfirmBatch(saveParams);

			if(confirmResult > 0){
				Map<String, Object> updateParams = new HashMap<String, Object>();
				updateParams.put("stus", 4);
				updateParams.put("id", id);
				emallPymtMapper.updatePay0356mMaster(updateParams);

				result.put("status", "1");
				LOGGER.debug("saveConfirmBatch : Sucess..........\n");
			}else{
				result.put("status", "0");
				LOGGER.debug("saveConfirmBatch : Failed..........\n");
			}
		}else if(insertResult == 0){
			Map<String, Object> updateParams = new HashMap<String, Object>();
			updateParams.put("stus", 4);
			updateParams.put("id", id);
			emallPymtMapper.updatePay0356mMaster(updateParams);
			result.put("status", "0");
			LOGGER.debug("saveBatchPaymentUpload : not run..........\n");
		}else {
			result.put("status", "-1");
			LOGGER.debug("saveBatchPaymentUpload : Failed..........\n");
		}

		return result;
	}

	@Override
	public EgovMap moveFileLocal(Map<String, Object> params) {
		logger.info("emallPymtService moveFileLocal start");
		EgovMap result = new EgovMap();
		EgovMap arcRequest = new EgovMap();
		String fileId = params.get("fileId").toString();
		try {
			Files.move(Paths.get(commonPath + uploadPath + "/" + fileId), Paths.get(commonPath + uploadPath + "/arhive/" + fileId));

			result.put("status", "1");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			if(e.toString().contains("FileAlreadyExistsException")){
				try {
					SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyyMMddHHmm");
			        Date currentDate1 = new Date();
			        String todayFormattedDate1 = dateFormat1.format(currentDate1);
					Files.move(Paths.get(commonPath + uploadPath + "/" + fileId), Paths.get(commonPath + uploadPath + "/arhive/" + fileId + "_" + todayFormattedDate1));
					result.put("status", "1");
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					result.put("status", "-1");
				}
			}else{
				e.printStackTrace();
				result.put("status", "-1");
			}
		}finally{
			logger.info("emallPymtService moveFileLocal end");
			return result;
		}

	}

}
