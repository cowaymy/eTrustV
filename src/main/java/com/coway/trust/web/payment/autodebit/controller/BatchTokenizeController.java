package com.coway.trust.web.payment.autodebit.controller;

import java.io.IOException;

import com.coway.trust.biz.common.LargeExcelService;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.config.csv.CsvReadComponent;

import com.coway.trust.biz.payment.batchtokenize.service.BatchTokenizeService;
import com.coway.trust.biz.sales.customer.impl.CustomerServiceImpl;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.SFTPUtil;
import com.coway.trust.web.common.claim.ClaimFileCrcCIMBHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class BatchTokenizeController {

	//TING GEN LIANG Enhancement Batch paymode conversion TO Auto Debit
	private static final Logger LOGGER = LoggerFactory.getLogger(CustomerServiceImpl.class);
	@Value("${web.resource.upload.file}"+"/MCPayment")
	private String filePath;
	@Resource(name = "batchTokenizeService")
	private BatchTokenizeService batchTokenizeService;

	@Value("${tokenization.mcp.sftp.host}")
	  private String host;

	  @Value("${tokenization.mcp.sftp.port}")
	  private int port;

	  @Value("${tokenization.mcp.sftp.userid}")
	  private String userName;

	  @Value("${tokenization.mcp.sftp.userpw}")
	  private String password;

	  @Value("${tokenization.mcp.sftp.path}")
	  private String sftpDir;

	@RequestMapping(value = "/paymodeConversionToADList.do")
	public String paymodeConversionToADList(@RequestParam Map<String, Object>params, ModelMap model) {
		return "sales/order/payModeConversionToADList";
	}


	@RequestMapping(value = "/BatchConvertChecking.do")
	public ResponseEntity<List<EgovMap>> BatchConvertChecking (@RequestBody Map<String, Object> params, ModelMap model) throws IOException, InvalidFormatException {
		System.out.print(params);

		ReturnMessage message = new ReturnMessage();


	    List<EgovMap> result = batchTokenizeService.verifyRecord(params);

    	return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/paymodeConvertViewItmJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> paymodeConvertViewItmJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> cnvrItmList = batchTokenizeService.selectBatchTokenizeRecord(params);


		return ResponseEntity.ok(cnvrItmList);
	}

	@RequestMapping(value = "/searchBatchTokenizeList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> searchBatchTokenizeList (@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> cnvrItmList = batchTokenizeService.selectBatchTokenizeRecord(params);


		return ResponseEntity.ok(cnvrItmList);
	}

	@RequestMapping(value = "/batchTokenizeDetailPop.do")
	public String paymodeConversionDetailPop(@RequestParam Map<String, Object>params, ModelMap model) {

		EgovMap cnvrInfo = batchTokenizeService.batchTokenizeDetail(params);
		System.out.println(cnvrInfo);
		model.addAttribute("cnvrInfo", cnvrInfo);
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
	  public ResponseEntity<String> submitBatchTokenize(SessionVO sessionVO) throws Exception {

		    ClaimFileCrcCIMBHandler downloadHandler = null;
		    String sFile;
		    String todayDate;
		    EgovMap batchID = batchTokenizeService.processBatchTokenizeRecord(sessionVO.getUserId());
		    System.out.println("over csv data");
		    System.out.println(batchID);
		    todayDate = CommonUtils.getNowDate();
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

	                String lineDtl = "\""+refNo + "\",\"" + crcNo + "\",\"" + crcExpr+"\"";
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

	        SFTPUtil util = new SFTPUtil();
	        util.init(host, userName, password, port);

	        LOGGER.error("createBatchCSV :: " + file.getAbsolutePath());

	        boolean b1 = util.upload(sftpDir, file);

	        LOGGER.error(Boolean.toString(b1));
	        if(!b1) {
	            LOGGER.error("createBatchCSV :: SFTP Failed :: " + sFile);
	        }
	        util.disconnection();
	        file.delete();
		    return ResponseEntity.ok("ok");
	        // ================
	        // SFTP File :: End
	        // ================
		  }
}
