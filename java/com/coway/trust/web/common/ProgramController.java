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
import org.springframework.ui.ModelMap;
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
@RequestMapping(value = "/program")
public class ProgramController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ProgramController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "commonService")
	private CommonService commonService;

	@RequestMapping(value = "/pgmManagement.do")
	public String programList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "common/programManagement";
	}

	// POPUP 화면 호출.

	@RequestMapping(value = "/pgmManagentEditPop.do")
	public String pgmManagentUpdPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// popup 화면으로 넘길 데이터.
		model.addAttribute("inputParams", params);

		// 호출될 화면
		return "common/programManagementPop";
	}

	@RequestMapping(value = "/pgmManagentAddPop.do")
	public String pgmManagentAddPop(@RequestParam Map<String, Object> params) {
		// 호출될 화면
		return "common/programManagementPop";
	}

	// search
	@RequestMapping(value = "/selectProgramList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectProgramList(@RequestParam Map<String, Object> params) {
		List<EgovMap> statusCategoryList = commonService.selectProgramList(params);

		return ResponseEntity.ok(statusCategoryList);
	}

	@RequestMapping(value = "/selectPgmTranList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectPgmTranList(@RequestParam Map<String, Object> params) {
		List<EgovMap> statusCategoryList = commonService.selectPgmTranList(params);

		return ResponseEntity.ok(statusCategoryList);
	}

	// save pgmId
	@RequestMapping(value = "/saveProgramId.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveProgramId(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) {
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList

		/*
		int tmpCnt = 0;
		int totCnt = 0;
		if (addList.size() > 0) {
			tmpCnt = commonService.insertPgmId(addList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		if (udtList.size() > 0) {
			tmpCnt = commonService.updatePgmId(udtList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		if (delList.size() > 0) {
			tmpCnt = commonService.deletePgmId(delList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}*/

		// 20190910 KR-OHK : insertPgmId+updatePgmId+deletePgmId => Change One Transaction
		int totCnt = commonService.savePgmId(addList, udtList, delList, sessionVO.getUserId());

		// 콘솔로 찍어보기
		LOGGER.info("PgmId_수정 : {}", udtList.toString());
		LOGGER.info("PgmId_추가 : {}", addList.toString());
		LOGGER.info("PgmId_삭제 : {}", delList.toString());
		LOGGER.info("PgmId_카운트 : {}", totCnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	// update transaction.
	@RequestMapping(value = "/updateTrans.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateTrans(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) {
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList

		/*
		int tmpCnt = 0;
		int totCnt = 0;

		if (addList.size() > 0) {
			tmpCnt = commonService.updPgmIdTrans(addList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		if (udtList.size() > 0) {
			tmpCnt = commonService.updPgmIdTrans(udtList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}*/

		// 20190910 KR-OHK : updPgmIdTrans => Change One Transaction
		int totCnt = commonService.savePgmIdTrans(addList, udtList, sessionVO.getUserId());

		// 콘솔로 찍어보기
		LOGGER.info("PgmId_수정 : {}", udtList.toString());
		LOGGER.info("PgmId_추가 : {}", addList.toString());
		LOGGER.info("PgmId_카운트 : {}", totCnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
}
