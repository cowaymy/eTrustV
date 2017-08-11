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
@RequestMapping(value = "/general")
public class GeneralCodeController {

	private static final Logger LOGGER = LoggerFactory.getLogger(GeneralCodeController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "commonService")
	private CommonService commonService;

	// TODO : 임시 유저. 차후 삭제 필요.
	private int getUserId = 9999;

	@RequestMapping(value = "/generalCode.do")
	public String listCommCode(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "common/generalCodeManagement";
	}

	@RequestMapping(value = "/selectMstCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeMstList(@RequestParam Map<String, Object> params) {
		List<EgovMap> mstCommCodeList = commonService.getMstCommonCodeList(params);

		return ResponseEntity.ok(mstCommCodeList);
	}

	@RequestMapping(value = "/selectDetailCodeList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeDetailList(@RequestParam Map<String, Object> params) {
		List<EgovMap> mstCommDetailCodeList = commonService.getDetailCommonCodeList(params);

		return ResponseEntity.ok(mstCommDetailCodeList);
	}

	@RequestMapping(value = "/saveGeneralCode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCommMstGrid(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) {
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList

		// 반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
		int cnt = 0;
		if (addList.size() > 0) {
			cnt = commonService.addCommCodeGrid(addList, getUserId);
		}

		if (udtList.size() > 0) {
			cnt = commonService.udtCommCodeGrid(udtList, getUserId);
		}

		// 콘솔로 찍어보기
		LOGGER.info("CommCd_수정 : {}", udtList.toString());
		LOGGER.info("CommCd_추가 : {}", addList.toString());
		LOGGER.info("CommCd_카운트 : {}", cnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(cnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveDetailCommCode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveCommDetailGrid(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) {
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList

		// 반드시 서비스 호출하여 비지니스 처리. (현재는 샘플이므로 로그만 남김.)
		// 조회.
		int cnt = 0;
		if (addList.size() > 0) {
			cnt = commonService.addDetailCommCodeGrid(addList, getUserId);
		}

		if (udtList.size() > 0) {
			cnt = commonService.udtDetailCommCodeGrid(udtList, getUserId);
		}

		// 콘솔로 찍어보기
		LOGGER.info("DetailCommCd_수정 : {}", udtList.toString());
		LOGGER.info("DetailCommCd_추가 : {}", addList.toString());
		LOGGER.info("DetailCommCd_카운트 : {}", cnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
}
