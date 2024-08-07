package com.coway.trust.web.organization.organization;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
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
import com.coway.trust.biz.organization.organization.LoyaltyHPUploadService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping("/organization")
public class LoyaltyHPUploadController {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoyaltyHPUploadController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;


	@Autowired
	private SessionHandler sessionHandler;


	@Autowired
	private CsvReadComponent csvReadComponent;



	@Resource(name = "loyaltyHPUploadService")
	private LoyaltyHPUploadService loyaltyHPUploadService;



	@RequestMapping(value = "/loyaltyHPUpload.do")
	public String loyaltyActiveHPList(@RequestParam Map<String, Object> params, ModelMap model) {
		return "organization/organization/loyaltyHPUploadStatus";
	}


	@RequestMapping(value = "/loyaltyHPUploadNewPop.do")
	public String loyaltyHPUploadNewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "organization/organization/loyaltyHPUploadNewPop";
	}


	@RequestMapping(value = "/loyaltyHPUploadDetailPop.do")
	public String loyaltyHPUploadDetailPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.addAttribute("uploadId", params.get("uploadId"));
		return "organization/organization/loyaltyHPUploadDetailPop";
	}



	@RequestMapping(value = "/loyaltyHPUploadDetailViewPop.do")
	public String loyaltyHPUploadDetailViewPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.addAttribute("uploadId", params.get("uploadId"));
		return "organization/organization/loyaltyHPUploadDetailViewPop";
	}


	@RequestMapping(value = "/loyaltyHPUploadAddItemPop.do")
	public String loyaltyHPUploadAddItemPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.addAttribute("uploadId", params.get("uploadId"));
		return "organization/organization/loyaltyHPUploadAddItemPop";
	}


	@RequestMapping(value = "/selectLoyaltyHPUploadMemberStatusPop.do")
	public String selectLoyaltyHPUploadMemberStatusPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.addAttribute("uploadId", params.get("uploadId"));
		return "organization/organization/selectLoyaltyHPUploadMemberStatusPop";
	}




	@RequestMapping(value = "/selectLoyaltyHPUpload.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLoyaltyActiveHPList(@RequestParam Map<String, Object> params , HttpServletRequest request, ModelMap model) {

		LOGGER.debug("selectLoyaltyActiveHPList.do");
		LOGGER.debug("params :: " + params);

		String[] statusList = request.getParameterValues("statusList");
		params.put("statusList", statusList);

		List<EgovMap> loyaltyActiveHPList = null;
		loyaltyActiveHPList = loyaltyHPUploadService.selectLoyaltyHPUploadList(params);

		return ResponseEntity.ok(loyaltyActiveHPList);
	}




	@RequestMapping(value = "/selectLoyaltyHPUploadMemberStatusList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLoyaltyHPUploadMemberStatusList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		LOGGER.debug("selectLoyaltyActiveHPList.do");
		LOGGER.debug("params :: " + params);

		List<EgovMap> loyaltyActiveHPList = null;
		loyaltyActiveHPList = loyaltyHPUploadService.selectLoyaltyHPUploadMemberStatusList(params);

		return ResponseEntity.ok(loyaltyActiveHPList);
	}






	@RequestMapping(value = "/selectLoyaltyHPUploadDetailListForMember", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectLoyaltyHPUploadDetailListForMember(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {

		LOGGER.debug("selectLoyaltyHPUploadDetailListForMember.do");
		LOGGER.debug("params :: " + params);

		List<EgovMap> loyaltyActiveHPList = null;
		loyaltyActiveHPList = loyaltyHPUploadService.selectLoyaltyHPUploadDetailListForMember(params);

		return ResponseEntity.ok(loyaltyActiveHPList);
	}




	@RequestMapping(value = "/loyaltyHpUpload", method = RequestMethod.POST)
	public ResponseEntity<String> loyaltyHpUpload(MultipartHttpServletRequest request) throws IOException, InvalidFormatException {


		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = String.valueOf(sessionVO.getUserId());


		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");

		List<LoyaltyHPUploadDataVO> vos = csvReadComponent.readCsvToList(multipartFile, true, LoyaltyHPUploadDataVO::create);
		String uploadId= loyaltyHPUploadService.insertUploadData(vos ,loginId);


		return ResponseEntity.ok(uploadId);
	}



	@RequestMapping(value = "/addLoyaltyHpUpload", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage>  addLoyaltyHpUpload(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws IOException, InvalidFormatException {



	    	LOGGER.debug(params.toString());
			SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
			String loginId = String.valueOf(sessionVO.getUserId());

			params.put("userId", loginId);
			loyaltyHPUploadService.addLoyaltyHpUpload(params);


	    	// 결과 만들기
	 		ReturnMessage message = new ReturnMessage();
	 		message.setCode(AppConstants.SUCCESS);
	 		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));


			return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/removeLoyaltyHpUpload", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage>  removeLoyaltyHpUpload(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws IOException, InvalidFormatException {

	    	LOGGER.debug(params.toString());
			SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
			String loginId = String.valueOf(sessionVO.getUserId());

			params.put("userId", loginId);
			loyaltyHPUploadService.removeItem(params);


	    	// 결과 만들기
	 		ReturnMessage message = new ReturnMessage();
	 		message.setCode(AppConstants.SUCCESS);
	 		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));


			return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/deActiveteItem", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage>  deActiveteItem(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws IOException, InvalidFormatException {

	    	LOGGER.debug(params.toString());
			SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
			String loginId = String.valueOf(sessionVO.getUserId());

			params.put("userId", loginId);
			loyaltyHPUploadService.deActiveteItem(params);


	    	// 결과 만들기
	 		ReturnMessage message = new ReturnMessage();
	 		message.setCode(AppConstants.SUCCESS);
	 		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));


			return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/confrimItemLoyaltyHpUpload", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage>  confrimItemLoyaltyHpUpload(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws IOException, InvalidFormatException {

	    	LOGGER.debug(params.toString());
			SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
			String loginId = String.valueOf(sessionVO.getUserId());

			params.put("userId", loginId);
			loyaltyHPUploadService.confrimItem(params);


	    	// 결과 만들기
	 		ReturnMessage message = new ReturnMessage();
	 		message.setCode(AppConstants.SUCCESS);
	 		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));


			return ResponseEntity.ok(message);
	}




	@RequestMapping(value = "/selectToyaltyHpUploadDetailList", method = RequestMethod.GET)
	public  ResponseEntity<EgovMap>  selectToyaltyHpUploadDetailList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws IOException, InvalidFormatException {

        EgovMap rtnMap  = new EgovMap();
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = String.valueOf(sessionVO.getUserId());

		List<EgovMap> list = loyaltyHPUploadService.selectLoyaltyHPUploadDetailList(params);
		Map<String, Object> info = loyaltyHPUploadService.selectLoyaltyHPUploadDetailInfo(params);


		rtnMap.put("dataList", list);
		rtnMap.put("info", info);

		return ResponseEntity.ok(rtnMap);
	}
}
