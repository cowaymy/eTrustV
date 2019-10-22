package com.coway.trust.web.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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
import com.coway.trust.biz.common.MenuService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/menu")
public class MenuController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MenuController.class);

	@Autowired
	private MenuService menuService;

	@Autowired
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/getMenuList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getMenuList(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {
		LOGGER.debug("/getMenuList.do...........");
		return ResponseEntity.ok(menuService.getMenuList(sessionVO));
	}

	@RequestMapping(value = "/menuManagement.do")
	public String menuList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "/common/menuManagement";
	}

	// search
	@RequestMapping(value = "/selectMenuList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMenuList(@RequestParam Map<String, Object> params) {
		List<EgovMap> selectMenuList = commonService.selectMenuList(params);

		return ResponseEntity.ok(selectMenuList);
	}

	// search upperMenu popup
	@RequestMapping(value = "/selectUpperMenuList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectUpperMenuList(@RequestParam Map<String, Object> params) {
		List<EgovMap> selectUpperMenuList = commonService.selectUpperMenuList(params);

		return ResponseEntity.ok(selectUpperMenuList);
	}

	// program search popup
	@RequestMapping(value = "/searchProgramPop.do")
	public String searchPopProgramList(@RequestParam Map<String, Object> params, ModelMap model) {
		// model.addAttribute("url", params);
		// 호출될 화면
		return "/common/searchProgramPop";
	}

	// uppermenu search popup
	@RequestMapping(value = "/searchUpperMenuPop.do")
	public String searchPopUpperMenuList(@RequestParam Map<String, Object> params, ModelMap model) {
		// model.addAttribute("url", params);
		// 호출될 화면
		return "/common/searchUpperMenuPop";
	}

	// save menuId
	@RequestMapping(value = "/saveMenuId.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveMenuId(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) {
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList

		/*
		int tmpCnt = 0;
		int totCnt = 0;
		if (addList.size() > 0) {
			tmpCnt = commonService.insertMenuCode(addList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		if (udtList.size() > 0) {
			tmpCnt = commonService.updateMenuCode(udtList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		if (delList.size() > 0) {
			tmpCnt = commonService.deleteMenuId(delList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}
		*/

		// 20190910 KR-OHK : insertMenuCode+updateMenuCode+deleteMenuId => Change One Transaction
		int totCnt = commonService.saveMenuId(addList, udtList, delList, sessionVO.getUserId());

		// 콘솔로 찍어보기
		LOGGER.info("MenuCd_수정 : {}", udtList.toString());
		LOGGER.info("MenuCd_추가 : {}", addList.toString());
		LOGGER.info("MenuCd_삭제 : {}", delList.toString());
		LOGGER.info("MenuCd_카운트 : {}", totCnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

}
