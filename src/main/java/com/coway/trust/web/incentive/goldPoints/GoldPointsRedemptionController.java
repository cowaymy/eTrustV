package com.coway.trust.web.incentive.goldPoints;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.incentive.goldPoints.GoldPointsService;
import com.coway.trust.biz.incentive.goldPoints.RedemptionItemVO;
import com.coway.trust.biz.organization.organization.MemberListService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/incentive/goldPoints")
public class GoldPointsRedemptionController {

	private static final Logger LOGGER = LoggerFactory.getLogger(GoldPointsRedemptionController.class);

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "memberListService")
	private MemberListService memberListService;

	@Resource(name = "goldPointsService")
	private GoldPointsService goldPointsService;

	@Autowired
	private CsvReadComponent csvReadComponent;

	@RequestMapping(value = "/redemptionList.do")
	public String redemptionList(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.info("===== redemptionList.do =====");

		params.put("groupCode",1);

		List<EgovMap> memberType = commonService.selectCodeList(params);
		List<EgovMap> status = memberListService.selectStatus();

		model.addAttribute("memberType", memberType);
		model.addAttribute("status", status);

		return "incentive/goldPoints/redemptionList";
	}

	@RequestMapping(value = "/searchRedemptionList.do")
	public ResponseEntity<List<EgovMap>> searchRedemptionList(@RequestParam Map<String, Object> params){

		List<EgovMap> result = goldPointsService.selectRedemptionList(params);

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/uploadRedemptionItemsPop.do")
	public String uploadRedemptionItemsPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "incentive/goldPoints/uploadRedemptionItemsPop";
	}

	@RequestMapping(value = "/csvUploadRedemptionItems.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> csvUploadRedemptionItems(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");
		List<RedemptionItemVO> vos = csvReadComponent.readCsvToList(multipartFile, true, RedemptionItemVO::create);

		List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();

		for (RedemptionItemVO vo : vos) {

			HashMap<String, Object> hm = new HashMap<String, Object>();

	        hm.put("itmCode", vo.getItemCode());
	        hm.put("itmCat", vo.getItemCategory());
	        hm.put("itmDesc", vo.getItemDesc());
	        hm.put("gpPerUnit", vo.getGoldPtsPerUnit());
	        hm.put("startDt", vo.getStartDate());
	        hm.put("endDt", vo.getEndDate());
			hm.put("crtUserId", sessionVO.getUserId());
			hm.put("updUserId", sessionVO.getUserId());

			detailList.add(hm);
		}

		Map<String, Object> master = new HashMap<String, Object>();

	    master.put("crtUserId", sessionVO.getUserId());
	    master.put("updUserId", sessionVO.getUserId());

	    int result = goldPointsService.saveCsvRedemptionItems(master, detailList);

		ReturnMessage message = new ReturnMessage();

	    if (result > 0) {
	    	message.setMessage("Redemption items successfully uploaded.");
	        message.setCode(AppConstants.SUCCESS);
	    } else {
	    	message.setMessage("Failed to upload Redemption items. Please try again later.");
	        message.setCode(AppConstants.FAIL);
	    }

	    return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/newRedemptionPop.do")
	public String newRedemptionPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		//params.put("userId", sessionVO.getUserId());  	//temporarily comment out for testing
		params.put("userId", 89940);		//temporarily set for testing

		String memCode = goldPointsService.getOrgDtls(params);
		params.put("memCode", memCode);

		EgovMap rBasicInfo = goldPointsService.selectRedemptionBasicInfo(params);
		List<EgovMap> ptsExpiryList = goldPointsService.selectPointsExpiryList(params);

		model.put("rBasicInfo", rBasicInfo);
		model.put("ptsExpiryList", new Gson().toJson(ptsExpiryList));

		return "incentive/goldPoints/newRedemptionPop";
	}

	@RequestMapping(value = "/searchItemCategoryList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> searchItemCategoryList(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> result = goldPointsService.searchItemCategoryList(params);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/searchRedemptionItemList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> searchRedemptionItemList(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> result = goldPointsService.searchRedemptionItemList(params);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/createNewRedemption.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> createNewRedemption(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		params.put("userId", sessionVO.getUserId());

		LOGGER.debug("===== createNewRedemption.do =====");
		LOGGER.debug("params : {}", params);

		Map<String, Object> resultValue = goldPointsService.createNewRedemption(params);

	    LOGGER.debug("resultValue : " + resultValue);

	    return ResponseEntity.ok(resultValue);
	}

	@RequestMapping(value = "/sendNotification.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> sendNotification(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		int result = goldPointsService.sendNotification(params);

		ReturnMessage message = new ReturnMessage();

	    if (result > 0) {
	    	message.setMessage("Redemption notification successful.");
	        message.setCode(AppConstants.SUCCESS);
	    } else {
	    	message.setMessage("Redemption notification failed.");
	        message.setCode(AppConstants.FAIL);
	    }

	    return ResponseEntity.ok(message);

	}

}
