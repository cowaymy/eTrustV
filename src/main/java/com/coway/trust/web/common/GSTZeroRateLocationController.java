package com.coway.trust.web.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.GSTZeroRateLocationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.Precondition;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class GSTZeroRateLocationController {

	private static final Logger LOGGER = LoggerFactory.getLogger(GSTZeroRateLocationController.class);

	@Autowired
	private GSTZeroRateLocationService gstZeroRateLocationService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	//GST Zero Rate Exportation
	@RequestMapping(value = "/gstZeroRateExporation.do")
	public String gstZeroRateExporationList(@RequestParam Map<String, Object> params, ModelMap model)
	{
		return "/common/gstZeroRateExportation";
	}

	@RequestMapping(value = "/selectGSTExportationList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectGSTExportationList(@RequestParam Map<String, Object> params)
	{
		LOGGER.debug("zreExptId : {}", params.get("zreExptId"));

		List<EgovMap> selectGSTExportationList = gstZeroRateLocationService.selectGSTExportationList(params);
		return ResponseEntity.ok(selectGSTExportationList);
	}

	@RequestMapping(value = "/selectGSTExportDealerList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectGSTExportDealerList(@RequestParam Map<String, Object> params)
	{
		LOGGER.debug("params : {}", params.toString());

		List<EgovMap> selectGSTExportDealerList = gstZeroRateLocationService.selectGSTExportDealerList(params);
		return ResponseEntity.ok(selectGSTExportDealerList);
	}

	// save UserExptAuth
	@RequestMapping(value = "/saveGSTExportation.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveUserExceptAuthMapping(@RequestBody Map<String, ArrayList<Object>> params,	SessionVO sessionVO)
	{
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList

		/*
		int tmpCnt = 0;
		int totCnt = 0;

		if (addList.size() > 0) {
			tmpCnt = gstZeroRateLocationService.insertGSTExportation(addList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		if (udtList.size() > 0) {
			tmpCnt = gstZeroRateLocationService.updateGSTExportation(udtList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		if (delList.size() > 0) {
			tmpCnt = gstZeroRateLocationService.deleteGSTExportation(delList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}
		*/

		// 20190910 KR-OHK : insertGSTExportation+updateGSTExportation+deleteGSTExportation => Change One Transaction
		int totCnt = gstZeroRateLocationService.saveGSTExportation(addList, udtList, delList, sessionVO.getUserId());

		// 콘솔로 찍어보기
		LOGGER.info("GSTExportation_수정 : {}", udtList.toString());
		LOGGER.info("GSTExportation_추가 : {}", addList.toString());
		LOGGER.info("GSTExportation_삭제 : {}", delList.toString());
		LOGGER.info("GSTExportation_카운트 : {}", totCnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	//GST Zero Rate Location
	@RequestMapping(value = "/gstZeroRateLocation.do")
	public String gstZeroRateLocation(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		params.put("stusCodeId", 1);
		List<EgovMap> stateCodeList = gstZeroRateLocationService.getStateCodeList(params);
		model.addAttribute("stateCodeList", new Gson().toJson(stateCodeList));
		return "/common/gstZeroRateLocation";
	}

	@RequestMapping(value = "/getStateCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getStateCodeList(@RequestParam Map<String, Object> params) {
		Precondition.checkNotNull(params.get("stusCodeId"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "stusCodeId" }));

		LOGGER.debug("stusCodeId : {}", params.get("stusCodeId"));

		List<EgovMap> stateCodeList = gstZeroRateLocationService.getStateCodeList(params);
		return ResponseEntity.ok(stateCodeList);
	}

	@RequestMapping(value = "/getSubAreaList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getSubAreaList(@RequestParam Map<String, Object> params) {
		Precondition.checkNotNull(params.get("areaStusId"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "areaStusId" }));
		Precondition.checkNotNull(params.get("areaStateId"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "areaStateId" }));

		LOGGER.debug("areaStusId : {}", params.get("areaStusId"));
		LOGGER.debug("areaStateId : {}", params.get("areaStateId"));

		List<EgovMap> subAreaList = gstZeroRateLocationService.getSubAreaList(params);
		return ResponseEntity.ok(subAreaList);
	}

	@RequestMapping(value = "/getPostCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getPostCodeList(@RequestParam Map<String, Object> params) {
		Precondition.checkNotNull(params.get("areaId"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "areaId" }));

		LOGGER.debug("areaId : {}", params.get("areaId"));

		List<EgovMap> subAreaList = gstZeroRateLocationService.getPostCodeList(params);
		return ResponseEntity.ok(subAreaList);
	}

	@RequestMapping(value = "/getZRLocationList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getZRLocationList(@RequestParam Map<String, Object> params,
			@RequestParam(value = "zrLocStusId", required = false) Integer[] zrLocStusIds) {

		LOGGER.debug("zrLocId : {}", params.get("zrLocId"));
		LOGGER.debug("zrLocStateId : {}", params.get("zrLocStateId"));
		LOGGER.debug("areaId : {}", params.get("areaId"));
		LOGGER.debug("postCode : {}", params.get("postCode"));

		if (zrLocStusIds != null) {
			for (Integer id : zrLocStusIds) {
				LOGGER.debug("zrLocStusId : {}", id);
			}

			params.put("zrLocStusIds", zrLocStusIds);
		}

		List<EgovMap> zrLocationList = gstZeroRateLocationService.getZRLocationList(params);
		return ResponseEntity.ok(zrLocationList);
	}

	@RequestMapping(value = "/saveZRLocation.do", method = RequestMethod.POST)
	public ResponseEntity saveZRLocation(@RequestBody Map<String, ArrayList<Object>> params, Model model,
			SessionVO sessionVO) {
		gstZeroRateLocationService.saveZRLocation(params, sessionVO.getUserId());
		return ResponseEntity.ok(HttpStatus.OK);
	}

}
