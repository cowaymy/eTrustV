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
import com.coway.trust.biz.common.mobileAuthorization.MobileAuthMenuService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobileAuthMenuController.java
 * @Description : MobileAuthMenuController
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 27.   KR-HAN        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/mobileAuthMenu")
public class MobileAuthMenuController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MobileAuthMenuController.class);

	@Autowired
	private MobileAuthMenuService mobileAuthMenuService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	 /**
	 * MobileAuthMenuMapping
	 * @Author KR-HAN
	 * @Date 2019. 11. 27.
	 * @param model
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mobileAuthMenuMapping.do")
	public String MobileAuthMenuMapping(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "common/mobileAuthorization/mobileAuthMenuMapping";
	}

	 /**
	 * selectMobileRoleAuthMappingAdjustList
	 * @Author KR-HAN
	 * @Date 2019. 12. 14.
	 * @param params
	 * @return
	 */
	@RequestMapping(value = "/selectMobileRoleAuthMappingAdjustList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMobileRoleAuthMappingAdjustList(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> selectRoleAuthMappingAdjustList = mobileAuthMenuService.selectMobileRoleAuthMappingAdjustList(params);

		return ResponseEntity.ok(selectRoleAuthMappingAdjustList);
	}

	 /**
	 * searchUpperMobileMenuPop
	 * @Author KR-HAN
	 * @Date 2019. 11. 27.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/searchMobileAuthMenuPop.do")
	public String searchUpperMobileMenuPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.addAttribute("authCode", params.get("authCode") );

		// 호출될 화면
		return "common/mobileAuthorization/searchMobileAuthMenuPop";
	}


	 /**
	 * saveMobileMenuAuthRoleMapping
	 * @Author KR-HAN
	 * @Date 2019. 11. 27.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	@RequestMapping(value = "/saveMobileMenuAuthRoleMapping.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveMobileMenuAuthRoleMapping(@RequestBody Map<String, ArrayList<Object>> params,
			SessionVO sessionVO) {
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList

		int totCnt = mobileAuthMenuService.saveMobileMenuAuthRoleMapping(addList, udtList, delList, sessionVO.getUserId());

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

	 /**
	 * saveMobileMenuAuthAllRoleMapping
	 * @Author KR-HAN
	 * @Date 2019. 11. 27.
	 * @param params
	 * @param sessionVO
	 * @return
	 */
	@RequestMapping(value = "/saveMobileMenuAuthAllRoleMapping.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveMobileMenuAuthAllRoleMapping(@RequestBody Map<String, Object> params,
			SessionVO sessionVO) {

		int totCnt = mobileAuthMenuService.saveMobileMenuAuthAllRoleMapping(params, sessionVO.getUserId());

		// 콘솔로 찍어보기
		LOGGER.info("MenuCd_카운트 : {}", totCnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	@RequestMapping(value = "/selectMobileMenuAuthMenuList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMobileMenuAuthMenuList(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> selectMobileMenuAuthMenuList = mobileAuthMenuService.selectMobileMenuAuthMenuList(params);

		return ResponseEntity.ok(selectMobileMenuAuthMenuList);
	}

}
