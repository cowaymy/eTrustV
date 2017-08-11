package com.coway.trust.web.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/status")
public class StatusCodeController {

	private static final Logger LOGGER = LoggerFactory.getLogger(StatusCodeController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "commonService")
	private CommonService commonService;

	// TODO : 임시 유저. 차후 삭제 필요.
	private int getUserId = 9999;

	@RequestMapping(value = "/statusCode.do")
	public String listStatusCode(Model model, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return "common/statusCodeManagement";
	}

	@RequestMapping(value = "/selectStatusCategoryList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectStatusCategoryList(@RequestParam Map<String, Object> params) {
		List<EgovMap> statusCategoryList = commonService.selectStatusCategoryList(params);

		return ResponseEntity.ok(statusCategoryList);
	}

	@RequestMapping(value = "/selectStatusCategoryCdList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectStatusCategoryCdList(@RequestParam Map<String, Object> params) {
		List<EgovMap> statusCategoryCdList = commonService.selectStatusCategoryCodeList(params);

		return ResponseEntity.ok(statusCategoryCdList);

	}

	@RequestMapping(value = "/selectStatusCdIdList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectStatusCdIdList(@RequestParam Map<String, Object> params) {
		List<EgovMap> statusCdIdList = commonService.selectStatusCodeList(params);

		return ResponseEntity.ok(statusCdIdList);
	}

	@RequestMapping(value = "/saveStatusCategory.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveStatusCategory(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) {
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList

		int cnt = 0;
		if (addList.size() > 0) {
			cnt = commonService.insertStatusCategory(addList, getUserId);
		}

		if (udtList.size() > 0) {
			cnt = commonService.updateStatusCategory(udtList, getUserId);
		}

		// 콘솔로 찍어보기
		LOGGER.info("StatusCategory_수정 : {}", udtList.toString());
		LOGGER.info("StatusCategory_추가 : {}", addList.toString());
		LOGGER.info("StatusCategory_카운트 : {}", cnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(cnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/insertStatusCatalogDetail.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveStatusCatalogCode(@RequestBody CommStatusVO params, SessionVO sessionVO) {

		/*
		 * try { sessionVO.getUserId(); } catch (Exception e) { sessionVO.setUserId(7777); }
		 */

		LOGGER.debug("insertStatusCatalogCode: " + params.getGridDataSet());

		int cnt = commonService.insertStatusCategoryCode(params, getUserId);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(cnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/saveStatusCode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveStatusCode(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) {
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList

		int cnt = 0;
		if (addList.size() > 0) {
			cnt = commonService.insertStatusCode(addList, getUserId);
		}

		if (udtList.size() > 0) {
			cnt = commonService.updateStatusCode(udtList, getUserId);
		}

		// 콘솔로 찍어보기
		LOGGER.info("StatusCode_수정 : {}", udtList.toString());
		LOGGER.info("StatusCode_추가 : {}", addList.toString());
		LOGGER.info("StatusCode_카운트 : {}", cnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(cnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	// Category Code Disabled Update
	@RequestMapping(value = "/UpdCategoryCdYN.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> UpdCategoryCdYN(@RequestBody CommStatusVO params, SessionVO sessionVO) {
		int cnt = 0;

		cnt = commonService.updateCategoryCodeYN(params, getUserId);

		// 콘솔로 찍어보기
		LOGGER.info("disabledYn : {}", cnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(cnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
}
