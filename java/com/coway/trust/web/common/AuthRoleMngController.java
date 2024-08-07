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
import org.springframework.cache.annotation.CacheEvict;
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
@RequestMapping(value = "/authorization")
public class AuthRoleMngController
{

	private static final Logger LOGGER = LoggerFactory.getLogger(AuthRoleMngController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "commonService")
	private CommonService commonService;


	/************************ UserExptAuthMapping ****************************/

	@RequestMapping(value = "/userExceptAuthMapping.do")
	public String userExceptAuthMapping(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		return "common/userExceptAuthMapping";
	}

	@RequestMapping(value = "/searchAuthUserExceptMappingPop.do")
	public String searchAuthUserExceptMappingPop(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		return "common/searchAuthUserExceptMappingPop";
	}

	// user Info Select
	@RequestMapping(value = "/selectUserInfoList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectUserInfoList(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> selectUserExceptionInfoList = commonService.selectUserExceptionInfoList(params);

		return ResponseEntity.ok(selectUserExceptionInfoList);
	}

	// userExceptional Mapping with AuthUserId
	@RequestMapping(value = "/selectUserExceptAdjustList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectUserExceptAdjustList(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> selectUserExceptAdjustList = commonService.selectUserExceptAdjustList(params);

		return ResponseEntity.ok(selectUserExceptAdjustList);
	}

	// save UserExptAuth
		@RequestMapping(value = "/saveUserExceptAuthMapping.do", method = RequestMethod.POST)
		@CacheEvict(value = AppConstants.LEFT_MENU_CACHE, allEntries = true)
		public ResponseEntity<ReturnMessage> saveUserExceptAuthMapping(@RequestBody Map<String, ArrayList<Object>> params,	SessionVO sessionVO)
		{
			List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
			List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
			List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList

			/*
			int tmpCnt = 0;
			int totCnt = 0;

			if (addList.size() > 0) {
				tmpCnt = commonService.insertUserExceptAuthMapping(addList, sessionVO.getUserId());
				totCnt = totCnt + tmpCnt;
			}

			if (udtList.size() > 0) {
				tmpCnt = commonService.updateUserExceptAuthMapping(udtList, sessionVO.getUserId());
				totCnt = totCnt + tmpCnt;
			}

			if (delList.size() > 0) {
				tmpCnt = commonService.deleteUserExceptAuthMapping(delList, sessionVO.getUserId());
				totCnt = totCnt + tmpCnt;
			}
			*/

			// 20190910 KR-OHK : insertUserExceptAuthMapping+updateUserExceptAuthMapping+deleteUserExceptAuthMapping => Change One Transaction
			int totCnt = commonService.saveUserExceptAuthMapping(addList, udtList, delList, sessionVO.getUserId());

			// 콘솔로 찍어보기
			LOGGER.info("UserExcept_수정 : {}", udtList.toString());
			LOGGER.info("UserExcept_추가 : {}", addList.toString());
			LOGGER.info("UserExcept_삭제 : {}", delList.toString());
			LOGGER.info("UserExcept_카운트 : {}", totCnt);

			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setData(totCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);
		}

	/************************ auth role mapping ****************************/

	@RequestMapping(value = "/authRoleMapping.do")
	public String authRoleList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		return "common/authRoleMapping";
	}

	// Left SYS0044M_SYSROLE
	@RequestMapping(value = "/selectRoleAuthMappingList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRoleAuthMappingList(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> selectRoleAuthMappingList = commonService.selectRoleAuthMappingList(params);

		return ResponseEntity.ok(selectRoleAuthMappingList);
	}

	// SYS0054M SerchBtn
	@RequestMapping(value = "/selectSearchBtnList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRoleAuthMappingBtn(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> selectRoleAuthMappingBtnList = commonService.selectRoleAuthMappingBtn(params);

		return ResponseEntity.ok(selectRoleAuthMappingBtnList);
	}

	// SYS0054M CellClick
	@RequestMapping(value = "/selectRoleAuthMappingAdjustList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRoleAuthMappingAdjustList(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> selectRoleAuthMappingAdjustList = commonService.selectRoleAuthMappingAdjustList(params);

		return ResponseEntity.ok(selectRoleAuthMappingAdjustList);
	}

	//
	@RequestMapping(value = "/selectRoleAuthMappingPopUpList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRoleAuthMappingPopUpList(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> selectRoleAuthMappingPopUpList = commonService.selectRoleAuthMappingPopUpList(params);

		return ResponseEntity.ok(selectRoleAuthMappingPopUpList);
	}

	// save Auth
	@RequestMapping(value = "/saveAuthRoleMapping.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAuthRoleMapping(@RequestBody Map<String, ArrayList<Object>> params,	SessionVO sessionVO)
	{
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList

		/*
		int tmpCnt = 0;
		int totCnt = 0;

		if (addList.size() > 0) {
			tmpCnt = commonService.insertRoleAuthMapping(addList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		if (udtList.size() > 0) {
			tmpCnt = commonService.updateRoleAuthMapping(udtList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		if (delList.size() > 0) {
			tmpCnt = commonService.deleteRoleAuthMapping(delList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}
		*/

		// 20190910 KR-OHK : insertRoleAuthMapping+updateRoleAuthMapping+deleteRoleAuthMapping => Change One Transaction
		int totCnt = commonService.saveRoleAuthMapping(addList, udtList, delList, sessionVO.getUserId());

		// 콘솔로 찍어보기
		LOGGER.info("AuthCd_수정 : {}", udtList.toString());
		LOGGER.info("AuthCd_추가 : {}", addList.toString());
		LOGGER.info("AuthCd_삭제 : {}", delList.toString());
		LOGGER.info("AuthCd_카운트 : {}", totCnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}


	// uppermenu search popup view
	@RequestMapping(value = "/searchRoleAuthMappingPop.do")
	public String searchRoleAuthMappingPopUp(@RequestParam Map<String, Object> params, ModelMap model) {
		// model.addAttribute("url", params);
		// 호출될 화면
		return "/common/searchRoleAuthMappingPop";
	}

	/*********************** Auth Management ******************************/
	@RequestMapping(value = "/authMngment.do")
	public String authList(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		LOGGER.debug("authList");

		return "common/authorizaManagement";
	}

	// uppermenu search popup
	@RequestMapping(value = "/searchRolePop.do")
	public String searchRolePopUp(@RequestParam Map<String, Object> params, ModelMap model) {
		// model.addAttribute("url", params);
		// 호출될 화면
		return "/common/searchRolePop";
	}


	// search
	@RequestMapping(value = "/selectAuthList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAuthList(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> selectAuthList = commonService.selectAuthList(params);

		return ResponseEntity.ok(selectAuthList);
	}

	// search Role Popup
	@RequestMapping(value = "/selectRoleList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectRoleList(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> selectRoleList = commonService.selectRoleList(params);

		return ResponseEntity.ok(selectRoleList);
	}


	// save Auth
	@RequestMapping(value = "/saveAuth.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAuth(@RequestBody Map<String, ArrayList<Object>> params,	SessionVO sessionVO)
	{
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); // Get grid addList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList

		/*
		int tmpCnt = 0;
		int totCnt = 0;
		if (addList.size() > 0) {
			tmpCnt = commonService.insertAuth(addList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		if (udtList.size() > 0) {
			tmpCnt = commonService.updateAuth(udtList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}

		if (delList.size() > 0) {
			tmpCnt = commonService.deleteAuth(delList, sessionVO.getUserId());
			totCnt = totCnt + tmpCnt;
		}
		*/

		// 20190910 KR-OHK : insertAuth+updateAuth+deleteAuth => Change One Transaction
		int totCnt = commonService.saveAuth(addList, udtList, delList, sessionVO.getUserId());

		// 콘솔로 찍어보기
		LOGGER.info("AuthCd_수정 : {}", udtList.toString());
		LOGGER.info("AuthCd_추가 : {}", addList.toString());
		LOGGER.info("AuthCd_삭제 : {}", delList.toString());
		LOGGER.info("AuthCd_카운트 : {}", totCnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
}
