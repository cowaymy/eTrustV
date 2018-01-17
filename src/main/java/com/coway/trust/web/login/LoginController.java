package com.coway.trust.web.login;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.coway.trust.util.CommonUtils;
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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.login.LoginHistory;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/login")
public class LoginController {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoginController.class);

	@Autowired
	private LoginService loginService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/login.do")
	public String login(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		model.addAttribute("languages", loginService.getLanguages());
		model.addAttribute("exception", params.get("exception"));
		return "login/login";
	}

	@RequestMapping(value = "/getLoginInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> getLoginInfo(HttpServletRequest request,
			@RequestBody Map<String, Object> params, ModelMap model) {

		Precondition.checkNotNull(params.get("userId"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "ID" }));
		Precondition.checkNotNull(params.get("password"),
				messageAccessor.getMessage(AppConstants.MSG_NECESSARY, new Object[] { "PASSWORD" }));

		LOGGER.debug("userID : {}", params.get("userId"));

		LoginVO loginVO = loginService.getLoginInfo(params);
		ReturnMessage message = new ReturnMessage();

		if (loginVO == null || loginVO.getUserId() == 0) {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_INVALID, new Object[] { "ID/Password" }));
		} else {

			String clientIp = CommonUtils.getClientIp(request);

			LoginHistory loginHistory = new LoginHistory();
			loginHistory.setSystemId(AppConstants.LOGIN_WEB);
			loginHistory.setUserId(loginVO.getUserId());
			loginHistory.setUserNm(loginVO.getUserName());
			loginHistory.setIpAddr(clientIp);
			loginHistory.setOs((String) params.get("os"));
			loginHistory.setBrowser((String) params.get("browser"));

			loginHistory.setLoginType(AppConstants.LOGIN_WEB);

			loginService.saveLoginHistory(loginHistory);

			HttpSession session = sessionHandler.getCurrentSession();
			session.setAttribute(AppConstants.SESSION_INFO, SessionVO.create(loginVO));
			message.setData(loginVO);
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/logout.do")
	public String logout(HttpServletRequest req, HttpServletResponse res, ModelMap modelMap,
			@RequestParam Map<String, Object> params) {
		loginService.logout(params);
		sessionHandler.clearSessionInfo();
		return AppConstants.REDIRECT_LOGIN;
	}

	// program search popup
	@RequestMapping(value = "/resetPassWordPop.do")
	public String resetPassWordPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// model.addAttribute("url", params);
		LOGGER.debug("passwordReset!!!!");
		return "/login/resetPassWordPop";
	}

	// program search UserID popup
	@RequestMapping(value = "/findIdPop.do")
	public String findIdPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("excuteFlag", "findID");
		LOGGER.debug("findIdPop: {} ", params.toString());
		return "/login/findIdPop";
	}
	
	// UserSetting Popup
	@RequestMapping(value = "/userSettingPop.do")
	public String userSettingPop(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		model.addAttribute("userSettingFlag", sessionVO);
		LOGGER.debug("userSettingPop: {} ,getUserId: {}", params.toString(),sessionVO.getUserId());
		return "/login/userSettingPop";
	}

	// program search UserID popup
	@RequestMapping(value = "/findIdRestPassPop.do")
	public String findIdRestPassPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("excuteFlag", "resetPass");
		LOGGER.debug("findIdRestPassPop: {} ", params.toString());
		return "/login/findIdPop";
	}

	@RequestMapping(value = "/selectFindUserIdPop.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectFindUserIdPop(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("SearchUserID : {}", params.get("userIdFindPopTxt"));

		LoginVO loginVO = loginService.selectFindUserIdPop(params);

		ReturnMessage message = new ReturnMessage();

		if (loginVO == null || loginVO.getUserId() == 0) {
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_NOT_EXIST, new Object[] { "ID" }));
		} else {
			message.setData(loginVO);
		}

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/savePassWordReset.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveStatusCatalogCode(@RequestBody Map<String, Object> params,
			SessionVO sessionVO) {
		LOGGER.debug("savePassWordReset: " + params.toString());

		int cnt = loginService.updatePassWord(params, sessionVO.getUserId());

		// 결과 만들기 
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(cnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}
	
	@RequestMapping(value = "/udateUserInfoSetting.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateUserSetting(@RequestBody Map<String, Object> params,	SessionVO sessionVO) 
	{
		LOGGER.debug("udateUserInfoSetting: " + params.toString());
		
		int cnt = loginService.updateUserSetting(params, sessionVO.getUserId());
		
		// 결과 만들기 
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(cnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
		
	}
	
	@RequestMapping(value = "/selectSecureResnList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectSecureResnList(@RequestParam Map<String, Object> params, ModelMap model) 
	{
		LOGGER.debug("selectSecureResnList : {}", params.toString());
		
		List<EgovMap> selectSecureResnList = loginService.selectSecureResnList(params);
		return ResponseEntity.ok(selectSecureResnList);
	}
	
	@RequestMapping(value="/myInfo.do", method = RequestMethod.GET)
	public String myInfo(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO){
		model.addAttribute("userSettingFlag", sessionVO);
		LOGGER.debug("userSettingPop: {} ,getUserId: {}", params.toString(),sessionVO.getUserId());
		return "/login/myInfo";
		
		
	}
	
}
