package com.coway.trust.web.common.mobileAuthorization;

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
import com.coway.trust.biz.common.mobileAuthorization.MobileMenuService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobileMenuController.java
 * @Description : MobileMenuController
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 30.   KR-HAN        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/mobileMenu")
public class MobileMenuController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MobileMenuController.class);

	@Autowired
	private MobileMenuService mobileMenuService;

	@Autowired
	private MessageSourceAccessor messageAccessor;


	 /**
	 * 모바일 메뉴 등록 화면 이동
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mobileMenuManagement.do")
	public String mobileMenuManagement(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "common/mobileAuthorization/mobileMenuManagement";
	}

	 /**
	 * 모바일 메뉴 조회
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectMobileMenuList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMenuList(@RequestParam Map<String, Object> params) {
		List<EgovMap> selectMenuList = mobileMenuService.selectMobileMenuList(params);

		return ResponseEntity.ok(selectMenuList);
	}


	 /**
	 * 모바일 메뉴 조회 팝업 화면 이동
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/searchMobileMenuPop.do")
	public String searchUpperMobileMenuPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.addAttribute("menuLvl", params.get("menuLvl") );

		// 호출될 화면
		return "common/mobileAuthorization/searchMobileMenuPop";
	}

	 /**
	 * 모바일 메뉴 팝업 조회
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectMobileMenuPopList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectUpperMobileMenuList(@RequestParam Map<String, Object> params, SessionVO sessionVO) {

		params.put("userId", sessionVO.getUserId());

		List<EgovMap> selectMobileMenuPopList = mobileMenuService.selectMobileMenuPopList(params);

		return ResponseEntity.ok(selectMobileMenuPopList);
	}

	 /**
	 * 모바일 메뉴 저장
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	@RequestMapping(value = "/saveMobileMenuId.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveMenuId(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) {
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList

		int totCnt = mobileMenuService.saveMobileMenu(addList, udtList, delList, sessionVO.getUserId());

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
