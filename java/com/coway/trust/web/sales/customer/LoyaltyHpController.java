package com.coway.trust.web.sales.customer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.customer.LoyaltyHpService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/customer")
public class LoyaltyHpController {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoyaltyHpController.class);

	@Autowired
	private CsvReadComponent csvReadComponent;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "loyaltyHpService")
	private LoyaltyHpService loyaltyHpService;

	@RequestMapping(value = "/loyaltyHp.do")
	public String loyaltyHpUploadList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		return "sales/customer/loyaltyHpUploadList";
	}

	@RequestMapping(value = "loyaltyHpUploadPop.do")
	public String loyaltyHpFileUploadPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		return "sales/customer/loyaltyHpUploadPop";
	}

	@RequestMapping(value = "/loyaltyHpCsvUpload", method = RequestMethod.POST)
	public ResponseEntity readFile(MultipartHttpServletRequest request,SessionVO sessionVO) throws IOException, InvalidFormatException {
	    ReturnMessage message = new ReturnMessage();
	    Map<String, MultipartFile> fileMap = request.getFileMap();
	    MultipartFile multipartFile = fileMap.get("csvFile");
	    List<LoyaltyHpRawDataVO> vos = csvReadComponent.readCsvToList(multipartFile, true, LoyaltyHpRawDataVO::create);

	    List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();
	    for (LoyaltyHpRawDataVO vo : vos) {

	        HashMap<String, Object> hm = new HashMap<String, Object>();

	        hm.put("salesOrdNo", vo.getSalesOrdNo().trim());
	        hm.put("hpCode", vo.getHpCode().trim());
	        hm.put("startDate", vo.getStartDate().trim());
	        hm.put("endDate", vo.getEndDate().trim());
	        hm.put("crtUserId", sessionVO.getUserId());
	        hm.put("updUserId", sessionVO.getUserId());

	        detailList.add(hm);
	    }

	    Map<String, Object> master = new HashMap<String, Object>();

	    master.put("crtUserId", sessionVO.getUserId());
	    master.put("updUserId", sessionVO.getUserId());
	    master.put("loyaltyHpRem", "Loyalty HP File Upload");
	    master.put("loyaltyHpTotItm", vos.size());
	    master.put("loyaltyHpTotSuccess", 0);
	    master.put("loyaltyHpTotFail", 0);

	    int result = loyaltyHpService.saveCsvUpload(master, detailList);
	    if(result > 0){

	        message.setMessage("Loyalty HP File successfully uploaded.<br />Batch ID : "+result);
	        message.setCode(AppConstants.SUCCESS);
	    }else{
	        message.setMessage("Failed to upload Loyalty HP File. Please try again later.");
	        message.setCode(AppConstants.FAIL);
	    }

	    return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectLoyaltyHpMstList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLoyaltyHpMstList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
	    LOGGER.debug("params =====================================>>  " + params);

	    List<EgovMap> list = loyaltyHpService.selectLoyaltyHpMstList(params);

	    LOGGER.debug("list =====================================>>  " + list.toString());
	    return ResponseEntity.ok(list);
	}


	@RequestMapping(value = "/loyaltyHpDetailViewPop.do")
	public String loyaltyHpDetailViewPop(@RequestParam Map<String, Object> params, ModelMap model) {
	    LOGGER.debug("params =====================================>>  " + params);

	    EgovMap loyaltyHpBatchInfo = loyaltyHpService.selectLoyaltyHpInfo(params);

	    model.addAttribute("loyaltyHpBatchInfo", loyaltyHpBatchInfo);
	    model.addAttribute("loyaltyHpBatchItem", new Gson().toJson(loyaltyHpBatchInfo.get("loyaltyHpBatchItem")));
	    return "sales/customer/loyaltyHpDetailViewPop";
	}

	@RequestMapping(value = "/loyaltyHpConfirm")
	public ResponseEntity<ReturnMessage> loyaltyHpConfirm(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		params.put("loginId", loginId);

		loyaltyHpService.callLoyaltyHpConfirm(params);

		String msg = null;
		if(params.get("v_sqlcode") != null)
			msg = "("+ params.get("v_sqlcode") +")"+ params.get("v_sqlcont");
		System.out.println("##msg : "+msg);

		message.setMessage(msg);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/loyaltyHpReject")
	public ResponseEntity<ReturnMessage> loyaltyHpReject(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		params.put("loginId", loginId);

		int result = loyaltyHpService.updLoyaltyHpReject(params);

	    if(result > 0){

		        message.setMessage("Loyalty HP File successfully rejected.<br />");
		        message.setCode(AppConstants.SUCCESS);
		    }else{
		        message.setMessage("Failed to reject Loyalty HP File. Please try again later.");
		        message.setCode(AppConstants.FAIL);
		    }

		return ResponseEntity.ok(message);
	}



}
