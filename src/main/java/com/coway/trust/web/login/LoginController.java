package com.coway.trust.web.login;

import java.util.HashMap;
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

		params.put("userId", sessionVO.getUserName());
		params.put("password", params.get("newPasswordConfirmTxt"));

		// Reset session info to get latest password
		LoginVO loginVO = loginService.getLoginInfo(params);
		HttpSession session = sessionHandler.getCurrentSession();
		session.setAttribute(AppConstants.SESSION_INFO, SessionVO.create(loginVO));

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(cnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/updateUserInfoSetting.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateUserSetting(@RequestBody Map<String, Object> params,	SessionVO sessionVO)
	{
		LOGGER.debug("updateUserInfoSetting: " + params.toString());

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

    // 2018-07-19 - LaiKW - HP Pop up
    @RequestMapping(value = "/loginPop.do")
    public String loginPop(@RequestParam Map<String, Object> params, ModelMap model) {

    	LOGGER.debug("==================== loginPop.do ====================");

    	LOGGER.debug("params : {}", params);
        model.put("loginUserId", (String) params.get("loginUserId"));
        model.put("os", (String) params.get("os"));
        model.put("browser", (String) params.get("browser"));
        model.put("userId", (String) params.get("userId"));
        model.put("password", (String) params.get("password"));
        model.put("userType", (String) params.get("loginUserType"));
        model.put("pdfNm", params.get("loginPdf"));
        model.put("popType", params.get("popType"));
        model.put("popAck1", params.get("popAck1"));
        model.put("popAck2", params.get("popAck2"));

        return "/login/loginPop";
    }

    @RequestMapping(value = "/loginPopCheck", method = RequestMethod.GET)
    public ResponseEntity<Map> cdEagmt1(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        LOGGER.debug("==================== loginPopCheck ====================");

        LOGGER.debug("params : {}", params);
        model.put("loginUserId", (String) params.get("loginUserId"));
        model.put("os", (String) params.get("os"));
        model.put("browser", (String) params.get("browser"));
        model.put("userId", (String) params.get("userId"));
        model.put("password", (String) params.get("password"));
        model.put("userType", (String) params.get("loginUserType"));

        params.put("userId", sessionVO.getUserId());

        // Get User type, role/contract type, agreement status (if applicable)
        EgovMap item1 = new EgovMap();
        item1 = (EgovMap) loginService.getDtls(params);

        Map<String, Object> popInfo = new HashMap();

        String userTypeId = params.get("userTypeId").toString();
        while(userTypeId.length() < 4) {
            userTypeId = "0" + userTypeId;
            LOGGER.debug("userTypeId :: " + userTypeId);
        }

        params.put("userTypeId", userTypeId);
        params.put("roleType", item1.get("roleType"));

        String retMsg = "";

        // If ORG0003D not empty/null = agreement exist
        if(item1 != null) {
            if(item1.containsKey("stusId")) {
                String stusId = item1.get("stusId").toString();
                String cnfm = item1.get("cnfm").toString();
                String cnfmDt = item1.get("cnfmDt").toString().substring(0, 10);

                // Pending
                if("44".equals(stusId) && "0".equals(cnfm) && "1900-01-01".equals(cnfmDt)) {
                    params.put("roleId", item1.get("roleType"));
                    params.put("popType", "A");
                }
                // Accepted
                else if("5".equals(stusId) && "1".equals(cnfm) && !"1900-01-01".equals(cnfmDt)) {
                    params.put("popType", "M");
                }
                // Rejected
                else if("6".equals(stusId) && "0".equals(cnfm) && !"1900-01-01".equals(cnfmDt)) {
                    params.put("popType", "-");
                    retMsg = "Application has been rejected.";
                }
            }
        }

        // Get pop up file name, pop exception members/roles
        EgovMap item2 = new EgovMap();
        item2 = (EgovMap) loginService.getPopDtls(params);

        // Get Pop up configuration
        if(item2 != null) {
            // Pop up configuration exist - get configurations
            if(item2.containsKey("popNewFlNm")) {
                popInfo.put("popFlName", item2.get("popNewFlNm"));
                popInfo.put("popExceptionMemroleCnt", item2.get("popExceptionMemroleCnt"));
                popInfo.put("popExceptionUserCnt", item2.get("popExceptionUserCnt"));
                popInfo.put("popType", item2.get("popType"));
                popInfo.put("popRejectFlg", item2.get("popRejectFlg"));
                popInfo.put("popAck1", item2.get("popAck1"));
                popInfo.put("popAck2", item2.get("popAck2"));
                popInfo.put("popAck3", item2.get("popAck3"));
            } else {
                popInfo.put("popFlName", "-");
                popInfo.put("popExceptionMemroleCnt", "0");
                popInfo.put("popExceptionUserCnt", "0");
            }
        } else {
            // Pop up configuration does not exist > Exception default to 1 to by pass pop up window
            popInfo.put("popExceptionMemroleCnt", "1");
        }

        popInfo.put("retMsg", retMsg);

        return ResponseEntity.ok(popInfo);
    }

}
