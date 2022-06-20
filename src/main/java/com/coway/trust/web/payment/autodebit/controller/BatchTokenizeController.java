package com.coway.trust.web.payment.autodebit.controller;

import java.io.IOException;
import java.io.InputStream;

import com.coway.trust.biz.common.LargeExcelService;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.nio.file.Files;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import com.coway.trust.config.csv.CsvReadComponent;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.autodebit.service.ClaimService;
import com.coway.trust.biz.payment.autodebit.service.M2UploadVO;
import com.coway.trust.biz.payment.batchtokenize.service.BatchTokenizeService;
import com.coway.trust.biz.sales.customer.CustomerVO;
import com.coway.trust.biz.sales.customer.impl.CustomerServiceImpl;
import com.coway.trust.biz.sales.order.OrderConversionService;
import com.coway.trust.biz.sales.pst.PSTRequestDOVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.SFTPUtil;
import com.coway.trust.web.common.claim.ClaimFileCrcCIMBHandler;
import com.coway.trust.web.common.claim.FileInfoVO;
import com.coway.trust.web.common.claim.FormDef;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BatchTokenizeController {

	//TING GEN LIANG Enhancement Batch paymode conversion TO Auto Debit
/*	@RequestMapping(value = "/paymodeConversionToADList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> paymodeConversionToADList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		String[] convStusFrList = request.getParameterValues("cmbStatusFr");
		String[] convStusToList = request.getParameterValues("cmbStatusTo");
		params.put("convStusFrList", convStusFrList);
		params.put("convStusToList", convStusToList);

		List<EgovMap> conversionList = orderConversionService.paymodeConversionList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(conversionList);
	}*/
	private static final Logger LOGGER = LoggerFactory.getLogger(CustomerServiceImpl.class);
	@Value("C:/Users/HQ-GENLIANG/Desktop")
	private String filePath;
	@Autowired
	 private LargeExcelService largeExcelService;
	@Autowired
	private CsvReadComponent csvReadComponent;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "batchTokenizeService")
	private BatchTokenizeService batchTokenizeService;

	private String[] claimFileColumns = new String[] { "refno", "bankDtlCtrlId", "salesOrdId" };

	@RequestMapping(value = "/paymodeConversionToADList.do")
	public String paymodeConversionToADList(@RequestParam Map<String, Object>params, ModelMap model) {
		System.out.print("here");
		return "sales/order/payModeConversionToADList";
	}


	@RequestMapping(value = "/BatchConvertChecking.do")
	public ResponseEntity<List<EgovMap>> BatchConvertChecking (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws IOException, InvalidFormatException {

		System.out.print("herezxc");
		System.out.print(params);

		ReturnMessage message = new ReturnMessage();
	    params.put("userId", sessionVO.getUserId());

	    List<EgovMap> result = batchTokenizeService.verifyRecord(params);

    	return ResponseEntity.ok(result);
	}
/*
	@RequestMapping(value = "/paymodeConversionDetailToADPop.do")
	public String paymodeConversionDetailToADPop(@RequestParam Map<String, Object>params, ModelMap model) {
		EgovMap cnvrInfo = orderConversionService.paymodeConversionView(params);

		//List<EgovMap> orderCnvrInvalidItmList = orderConversionService.orderCnvrInvalidItmList(params);
		//List<EgovMap> orderCnvrValidItmList = orderConversionService.orderCnvrValidItmList(params);
		//List<EgovMap> conversionItmList = orderConversionService.orderConversionViewItmList(params);

		//int invalidRows = orderCnvrInvalidItmList.size();
		//int validRows = orderCnvrValidItmList.size();
		//int allRows = conversionItmList.size();

		//logger.info("##### invalidRows #####" +invalidRows);
		//logger.info("##### validRows #####" +validRows);

		model.addAttribute("cnvrInfo", cnvrInfo);
		//model.addAttribute("invalidRows", invalidRows);
		//model.addAttribute("validRows", validRows);
		//model.addAttribute("allRows", allRows);

		return "sales/order/paymodeConversionDetailToADPop";
	}*/

	@RequestMapping(value = "/paymodeConvertViewItmJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> paymodeConvertViewItmJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> cnvrItmList = batchTokenizeService.selectBatchTokenizeRecord(params);

		// 데이터 리턴.
		return ResponseEntity.ok(cnvrItmList);
	}

	@RequestMapping(value = "/searchBatchTokenizeList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> searchBatchTokenizeList (@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> cnvrItmList = batchTokenizeService.selectBatchTokenizeRecord(params);

		// 데이터 리턴.
		return ResponseEntity.ok(cnvrItmList);
	}

	@RequestMapping(value = "/batchTokenizeDetailPop.do")
	public String paymodeConversionDetailPop(@RequestParam Map<String, Object>params, ModelMap model) {

		EgovMap cnvrInfo = batchTokenizeService.batchTokenizeDetail(params);
		System.out.println(cnvrInfo);
		//List<EgovMap> orderCnvrInvalidItmList = orderConversionService.orderCnvrInvalidItmList(params);
		//List<EgovMap> orderCnvrValidItmList = orderConversionService.orderCnvrValidItmList(params);
		//List<EgovMap> conversionItmList = orderConversionService.orderConversionViewItmList(params);

		//int invalidRows = orderCnvrInvalidItmList.size();
		//int validRows = orderCnvrValidItmList.size();
		//int allRows = conversionItmList.size();

		//logger.info("##### invalidRows #####" +invalidRows);
		//logger.info("##### validRows #####" +validRows);

		model.addAttribute("cnvrInfo", cnvrInfo);
		//model.addAttribute("invalidRows", invalidRows);
		//model.addAttribute("validRows", validRows);
		//model.addAttribute("allRows", allRows);
		return "sales/order/paymodeConversionToADDetailPop";
	}

	@RequestMapping(value = "/batchTokenizeViewItmJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> orderConversionViewItmList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> cnvrItmList = batchTokenizeService.batchTokenizeViewItmJsonList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(cnvrItmList);
	}


	@RequestMapping(value = "/paymodeConversionToAD.do")
	public String paymodeConversionToAD(@RequestParam Map<String, Object>params, ModelMap model) {
		//logger.info("###################### New ###############");
		return "sales/order/paymodeConvertToADNewPop";
	}
	@RequestMapping(value = "/submitBatchTokenize.do")
	  public ResponseEntity<String> submitBatchTokenize() throws Exception {

		    ClaimFileCrcCIMBHandler downloadHandler = null;
		    String sFile;
		    String todayDate;
		    EgovMap batchID = batchTokenizeService.processBatchTokenizeRecord();
		    System.out.println("over csv data");
		    System.out.println(batchID);
		    todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "ddMMyyyy");
		    sFile = "[MCP] Batch Tokenize_" + todayDate + "_" + String.valueOf(batchID.get("batchid")) + ".csv";
		    BufferedWriter fileWriter = null;
		    File file = new File(filePath + "/" + sFile);
            System.out.println(filePath);
            if (!file.getParentFile().exists()) {
                file.getParentFile().mkdirs();
            }
		    try {


	            fileWriter = new BufferedWriter(new FileWriter(file));

	            List<EgovMap> cardDetailsList = batchTokenizeService.getCardDetails(batchID);
	            System.out.println(cardDetailsList);
	            Map<String, Object> cardDetailsMap = new HashMap<String, Object>();
	            for(Map<String, Object> cardObject : cardDetailsList) {
	                cardDetailsMap.putAll(cardObject);

	                String refNo = cardDetailsMap.get("refno").toString();
	                String crcNo = cardDetailsMap.get("custcrcno").toString();
	                String crcExpr = cardDetailsMap.get("custcrcexpr").toString();

	                String lineDtl = refNo + "," + crcNo + "," + crcExpr;
	                fileWriter.write(lineDtl);
	                fileWriter.newLine();
	                fileWriter.flush();

	            }

	        } catch(Exception ex) {
	            LOGGER.error(ex.toString());
	        } finally {
	            if(fileWriter != null) {
	                try {
	                    fileWriter.close();
	                } catch (IOException ex) {
	                    LOGGER.error(ex.toString());
	                }
	            }
	        }
		    System.out.println("end mid");
		    String host, port, userName, password, sftpDir;

	        host = "coway.services.mcpayment.net";
	        port = "22";
	        userName = "coway-user";
	        password = "o!VBeIg*RLv3";
	        sftpDir = "/uploads/TOKEN/Response";

	        SFTPUtil util = new SFTPUtil();
	        util.init(host, userName, password, Integer.parseInt(port));


//	        util.download(sftpDir, "[MCP] Batch Tokenize_16062022_113.csv", filePath+"/[MCP] Batch Tokenize_16062022_113.csv");




	        Scanner sc = new Scanner(new File(filePath+"/RES_[MCP] Data Migration_20220512-1.csv"));
	        //parsing a CSV file into the constructor of Scanner class
	        sc.useDelimiter(",");
	        //setting comma as delimiter pattern
	        while (sc.hasNext()) {
	          System.out.println(sc.next());
	        }
/*	        LOGGER.error("createBatchCSV :: " + file.getAbsolutePath());

	        boolean b1 = util.upload(sftpDir, file);

	        LOGGER.error(Boolean.toString(b1));
	        if(!b1) {
	            LOGGER.error("createBatchCSV :: SFTP Failed :: " + sFile);
	        }
]
*/        util.disconnection();
	        file.delete();
		    return ResponseEntity.ok("ok");
	        // ================
	        // SFTP File :: End
	        // ================
		  }


    	  private Boolean saveTokenizeRecord(){
			return null;
    	  }

}
