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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.incentive.goldPoints.GoldPointsService;
import com.coway.trust.biz.incentive.goldPoints.GoldPointsVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.csv.CsvReadComponent;
import com.coway.trust.config.handler.SessionHandler;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/incentive/goldPoints")
public class GoldPointsUploadController {

	private static final Logger LOGGER = LoggerFactory.getLogger(GoldPointsUploadController.class);

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "goldPointsService")
	private GoldPointsService goldPointsService;

	@Autowired
	private CsvReadComponent csvReadComponent;

	@RequestMapping(value = "/pointsUploadList.do")
	public String pointsUploadList(@RequestParam Map<String, Object> params) {
		return "incentive/goldPoints/pointsUploadList";
	}

	@RequestMapping(value = "/selectPointsUploadList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPointsUploadList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) {
	    LOGGER.debug("params =====================================>>  " + params);

		String[] arrBatchStatus = request.getParameterValues("cmbBatchStatus");

		params.put("arrBatchStatus", arrBatchStatus);

	    List<EgovMap> list = goldPointsService.selectPointsUploadList(params);

	    LOGGER.debug("list =====================================>>  " + list.toString());
	    return ResponseEntity.ok(list);
	}

	@RequestMapping(value = "/uploadPointsPop.do")
	public String uploadPointsPop(@RequestParam Map<String, Object> params, ModelMap model) {
		return "incentive/goldPoints/uploadPointsPop";
	}

	@RequestMapping(value = "/csvUploadPoints.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> csvUploadPoints(MultipartHttpServletRequest request, SessionVO sessionVO) throws IOException, InvalidFormatException {

		Map<String, MultipartFile> fileMap = request.getFileMap();
		MultipartFile multipartFile = fileMap.get("csvFile");
		List<GoldPointsVO> vos = csvReadComponent.readCsvToList(multipartFile, true, GoldPointsVO::create);

		List<Map<String, Object>> detailList = new ArrayList<Map<String, Object>>();

		boolean isValidUpload = true;

		for (GoldPointsVO vo : vos) {

			if (vo.getPtsEarned() < 0 ) {		// negative points should not be uploaded
				isValidUpload = false;
				break;
			}

			HashMap<String, Object> hm = new HashMap<String, Object>();

	        hm.put("memCode", vo.getMemCode());
	        hm.put("memName", vo.getMemName());
	        hm.put("ptsDesc", vo.getPtsDesc());
	        hm.put("ptsEarned", vo.getPtsEarned());
	        hm.put("startDate", vo.getStartDate());
	        hm.put("endDate", vo.getEndDate());
			hm.put("crtUserId", sessionVO.getUserId());
			hm.put("updUserId", sessionVO.getUserId());

			detailList.add(hm);
		}

	    ReturnMessage message = new ReturnMessage();

		if (isValidUpload) {
			Map<String, Object> master = new HashMap<String, Object>();

		    master.put("crtUserId", sessionVO.getUserId());
		    master.put("updUserId", sessionVO.getUserId());

		    int result = goldPointsService.saveCsvUpload(master, detailList);

		    if (result > 0) {
		    	message.setMessage("Gold Points successfully uploaded.");
		        message.setCode(AppConstants.SUCCESS);
		    } else {
		    	message.setMessage("Failed to upload Gold Points. Please try again later.");
		        message.setCode(AppConstants.FAIL);
		    }
		} else {
			message.setMessage("Please remove negative values for Earned Points and retry.");
	        message.setCode(AppConstants.FAIL);
		}

	    return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/confirmPointsPop.do")
	public String confirmPointsPop(@RequestParam Map<String, Object> params, ModelMap model) {
	    LOGGER.debug("params =====================>  " + params);

	    EgovMap pointsBatchInfo = goldPointsService.selectPointsBatchInfo(params);

	    model.addAttribute("pointsBatchInfo", pointsBatchInfo);
	    model.addAttribute("pointsBatchDtl", new Gson().toJson(pointsBatchInfo.get("pointsBatchDtl")));
	    return "incentive/goldPoints/confirmPointsPop";
	}

	@RequestMapping(value = "/pointsUploadConfirm")
	public ResponseEntity<ReturnMessage> pointsUploadConfirm(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		params.put("loginId", loginId);

		goldPointsService.callPointsUploadConfirm(params);

		String msg = null;
		if (params.get("v_sqlcode") != null) {
			msg = "("+ params.get("v_sqlcode") +")"+ params.get("v_sqlcont");
		}

		message.setMessage(msg);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/pointsUploadReject")
	public ResponseEntity<ReturnMessage> pointsUploadReject(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId = sessionVO.getUserId();
		params.put("loginId", loginId);

		int result = goldPointsService.updPointsUploadReject(params);

	    if(result > 0) {
	    	message.setMessage("Points Upload successfully rejected.<br />");
		    message.setCode(AppConstants.SUCCESS);
		} else {
			message.setMessage("Failed to reject Points Upload. Please try again later.");
		    message.setCode(AppConstants.FAIL);
		}

		return ResponseEntity.ok(message);
	}

}
