package com.coway.trust.web.incentive.goldPoints;

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
	public String redemptionList(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		params.put("groupCode",1);
		List<EgovMap> memberType = commonService.selectCodeList(params);

		List<EgovMap> status = memberListService.selectStatus();

		model.addAttribute("memberType", memberType);
		model.addAttribute("status", status);

        if(sessionVO.getUserTypeId() != 4 && sessionVO.getUserTypeId() != 6) {
            params.put("userId", sessionVO.getUserId());
            EgovMap orgDtls = (EgovMap) goldPointsService.getOrgDtls(params);

            model.addAttribute("memCode", (String) orgDtls.get("memCode"));
            model.addAttribute("orgCode", (String) orgDtls.get("orgCode"));
            model.addAttribute("grpCode", (String) orgDtls.get("grpCode"));
            model.addAttribute("deptCode", (String) orgDtls.get("deptCode"));
        }

		return "incentive/goldPoints/redemptionList";
	}

	@RequestMapping(value = "/searchRedemptionList.do")
	public ResponseEntity<List<EgovMap>> searchRedemptionList(@RequestParam Map<String, Object> params, HttpServletRequest request){

		String[] arrRdmStatus = request.getParameterValues("cmbRdmStatus");
	    String[] arrCollectionBrnch = request.getParameterValues("cmbCollectionBranch");
	    String[] arrRedemptionItem = request.getParameterValues("cmbRedemptionItem");
		params.put("arrRdmStatus", arrRdmStatus);
		params.put("arrCollectionBrnch", arrCollectionBrnch);
		params.put("arrRedemptionItem", arrRedemptionItem);

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

		params.put("userId", sessionVO.getUserId());

		EgovMap orgDtls = (EgovMap) goldPointsService.getOrgDtls(params);
		params.put("memCode", (String) orgDtls.get("memCode"));

		EgovMap rBasicInfo = goldPointsService.selectRedemptionBasicInfo(params);
		List<EgovMap> ptsExpiryList = goldPointsService.selectPointsExpiryList(params);

		model.addAttribute("rBasicInfo", rBasicInfo);
		model.addAttribute("ptsExpiryList", new Gson().toJson(ptsExpiryList));

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

    	Map<String, Object> notificationMap = new HashMap<>();
    	notificationMap.put("mobileNo", params.get("mobileNo"));
    	notificationMap.put("emailAddr", params.get("emailAddr"));
    	notificationMap.put("userId", sessionVO.getUserId());

		Map<String, Object> resultValue = goldPointsService.createNewRedemption(params);
	    LOGGER.debug("resultValue : " + resultValue);

	    if ((int) resultValue.get("p1") == 1) {
			LOGGER.debug("===== sendNotification =====");

	    	notificationMap.put("redemptionNo", resultValue.get("redemptionNo"));

	    	goldPointsService.sendNotification(notificationMap);
	    }

	    return ResponseEntity.ok(resultValue);
	}

	@RequestMapping(value = "/updateRedemptionPop.do")
	public String updateRedemptionPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO){

		  String rdmId = (String) params.get("rdmId");
		  model.put("rdmId", rdmId);
		  String[] rdmIdArray = rdmId.split("∈");
		  params.put("rdmId", rdmIdArray);

		  List<EgovMap> rdmDetail = goldPointsService.selectRedemptionDetails(params);
			LOGGER.debug("===== rdmDetail ====="+rdmDetail);

		model.put("rdmDetail", rdmDetail);


		return "incentive/goldPoints/updateRedemptionPop";
	}


	@RequestMapping(value = "/updateForfeitRedemptionPop.do")
	public String updateForfeitRedemptionPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO){

		LOGGER.debug("===== params ====="+params);

		String rdmId = (String) params.get("rdmId");
		String[] rdmIdArray = rdmId.split("∈");
		params.put("rdmId", rdmIdArray);

		List<EgovMap> rdmDetail2 = goldPointsService.selectRedemptionDetails(params);
		LOGGER.debug("===== rdmDetail2 ====="+rdmDetail2);


			if(rdmDetail2 != null && rdmDetail2.size() > 0){

				for (int idx = 0; idx < rdmDetail2.size(); idx++) {

					Map<String, Object> addMap = (Map<String, Object>)rdmDetail2.get(idx);

					model.put("rdmId", addMap.get("rdmId"));
					model.put("rdmNo", addMap.get("rdmNo"));
					model.put("memCode", addMap.get("memCode"));
					model.put("memName", addMap.get("memName"));
					model.put("nric", addMap.get("nric"));
					model.put("itmCat", addMap.get("itmCat"));
					model.put("itmDisplayName", addMap.get("itmDisplayName"));
					model.put("qty", addMap.get("qty"));
					model.put("totalPts", addMap.get("totalPts"));

				}
			}



		return "incentive/goldPoints/updateForfeitRedemptionPop";
	}

	@RequestMapping(value = "/selectRedemptionDetails", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRedemptionDetails (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		 String rdmId = (String) params.get("rdmId");
		 String[] rdmIdArray = rdmId.split("∈");
		 params.put("rdmId", rdmIdArray);

		List<EgovMap> itemList = null;

		itemList = goldPointsService.selectRedemptionDetails(params);

		return ResponseEntity.ok(itemList);

	}

	@RequestMapping(value = "/updateRedemption.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateRedemption(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO){

		params.put("userId", sessionVO.getUserId());

		String rdmId = (String) params.get("rdmId");
		String[] rdmIdArray = rdmId.split("∈");
		params.put("rdmId", rdmIdArray);

		int result = goldPointsService.updateRedemption(params);

		ReturnMessage message = new ReturnMessage();

	    if (result > 0) {
	    	message.setMessage("Redemption update successful.");
	        message.setCode(AppConstants.SUCCESS);
	    } else {
	    	message.setMessage("Redemption update failed.");
	        message.setCode(AppConstants.FAIL);
	    }

	    return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/cancelRedemption.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> cancelRedemption(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		params.put("userId", sessionVO.getUserId());

		LOGGER.debug("===== cancelRedemption.do =====");
		LOGGER.debug("params : {}", params);

		Map<String, Object> resultValue = goldPointsService.cancelRedemption(params);

	    LOGGER.debug("resultValue : " + resultValue);

	    return ResponseEntity.ok(resultValue);
	}

	@RequestMapping(value = "/adminCancelRedemption.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> adminCancelRedemption(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		params.put("userId", sessionVO.getUserId());

		LOGGER.debug("===== adminCancelRedemption.do =====");
		LOGGER.debug("params : {}", params);

		Map<String, Object> resultValue = goldPointsService.adminCancelRedemption(params);

	    LOGGER.debug("resultValue : " + resultValue);

	    return ResponseEntity.ok(resultValue);
	}

	@RequestMapping(value = "/adminForfeitRedemption.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> adminForfeitRedemption(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		params.put("userId", sessionVO.getUserId());

		LOGGER.debug("===== adminCancelRedemption.do =====");
		LOGGER.debug("params : {}", params);

		Map<String, Object> resultValue = goldPointsService.adminForfeitRedemption(params);

	    LOGGER.debug("resultValue : " + resultValue);

	    return ResponseEntity.ok(resultValue);
	}

	@RequestMapping(value = "/selectRedemptionItemList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRedemptionItemList(@RequestParam Map<String, Object> params) {
		List<EgovMap> redemptionItemList = goldPointsService.selectRedemptionItemList(params);
		return ResponseEntity.ok(redemptionItemList);
	}

}
