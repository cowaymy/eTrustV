package com.coway.trust.web.login;

import java.io.File;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import javax.annotation.Resource;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;

import org.apache.commons.codec.binary.Base32;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.login.LoginHistory;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.biz.login.SsoLoginService;
import com.coway.trust.biz.logistics.survey.SurveyService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.Precondition;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.util.Calendar;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/login")
public class LoginController {

	private static final Logger LOGGER = LoggerFactory.getLogger(LoginController.class);

	@Autowired
	private LoginService loginService;

	@Autowired
	private SurveyService surveyService;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Resource(name = "ssoLoginService")
	private SsoLoginService ssoLoginService;

	@Value("${sso.use.flag}")
	private int ssoLoginFlag;

	@RequestMapping(value = "/checkMFA.do")
	public String checkMFA(@RequestParam Map<String, Object> params, RedirectAttributes redirectAttributes, HttpServletRequest request,ModelMap model)  throws  Exception {

		LOGGER.debug("params{}", params);
	    Base32 codec =  new  Base32();
	    //Generate authentication key
	    //String  encodedKey =  new  String (codec.encode("leo.ham@coway.com.my".getBytes()));

	    String email = (String) params.get("email");
	    String memCode = (String) params.get("memCode");
	    String userName = (String) params.get("userName");
	    String isHideQR = (String) params.get("isCheckMfa");
	    String userId = (String) params.get("userId");
	    byte [] secretKey =  Arrays.copyOf(email.getBytes(),  10 );
	  	    byte []bEncodedKey =  codec.encode(secretKey);
	    String  encodedKey =  new  String (bEncodedKey);
	    //Generate barcode address
	    String  QrUrl =  getQRBarcodeURL( memCode, email, encodedKey);

	    model.addAttribute( "encodedKey" , encodedKey);
	    model.addAttribute( "QrUrl" , QrUrl);
	    model.addAttribute( "userName" , userName);
	    model.addAttribute( "memCode" , memCode);
	    model.addAttribute( "isHideQR" , isHideQR);
	    model.addAttribute( "userId" , userId);

	    LOGGER.debug("encodedKey : {}", encodedKey);
	    LOGGER.debug("QrUrl : {}", QrUrl);

	    return  "/login/checkMFAPop" ;
	}


	//Barcode creation function
	public static String getQRBarcodeURL(String user, String host, String secret) {
		// QR코드 주소 생성
/*		String format2 = "http://chart.apis.google.com/chart?cht=qr&chs=200x200&chl=otpauth://totp/%s@%s%%3Fsecret%%3D%s&chld=H|0";
*/
		String format2 = "https://qrcode.tec-it.com/API/QRCode?size=small&dpi=150&data=otpauth://totp/%s@%s%%3Fsecret%%3D%s&chld=H|0";

		return String.format(format2, user, host, secret);
	}

	@RequestMapping(value = "/otpMFASubmit.do" , method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> otpMFASubmit(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model)  throws  Exception {

	ReturnMessage message = new ReturnMessage();

	LOGGER.info("code{}", params.get("code"));
	LOGGER.info("encodedKey{}",  params.get("encodedKey"));
	LOGGER.info("params{}",  params);

	try {

	int userId = Integer. parseInt((String) params.get("userId"));
	String  code =  (String) params.get("code");
	long codeCheck  =  Integer. parseInt (code);
	String  encodedKey =  (String) params.get("encodedKey");
	long  l =  new Date().getTime();
	long  ll =   l /  30000 ;
	LOGGER.info("code{}", code);
	LOGGER.info("codeCheck{}", codeCheck);
	LOGGER.info("encodedKey{}", encodedKey);
	boolean  check_code =  false ;
	check_code =  check_code(encodedKey, codeCheck, ll);

	if (! check_code) {
	    LOGGER.debug("back to OTP!!!!");
		message.setCode(AppConstants.FAIL);
		message.setData("");
		message.setMessage("OTP code does not match.");
	}

	else {

		LOGGER.info("uuuserrr{}", userId);
		loginService.updateCheckMfaFlag(userId);
		message.setCode(AppConstants.SUCCESS);
		message.setData("");
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	}


	} catch (Exception e){
	LOGGER.error(e.toString());
	}

	return ResponseEntity.ok(message);
	}


	//code check function
	private  static  boolean  check_code( String  secret,  long  code,  long  t)  throws  InvalidKeyException, NoSuchAlgorithmException {
	  Base32 codec =  new  Base32();
	  byte [] decodedKey =  codec.decode(secret);

	  LOGGER.debug("CHECK SCRT", secret);

	  int  window =  3 ;
	  for  ( int  i = - window; i <=  window; ++ i) {
	      long  hash =  verify_code(decodedKey, t +  i);

	      if  (hash ==  code) {
	          return  true ;
	      }
	  }

	  return  false ;
	}

	//code check function
	private  static  int  verify_code( byte [] key,  long  t)  throws  NoSuchAlgorithmException, InvalidKeyException{
	  byte [] data =  new  byte [ 8 ];
	  long  value =  t;
	  for  ( int  i =  8 ; i-- >  0 ; value >>>=  8 ) {
	      data[i] =  ( byte ) value;
	  }

	  SecretKeySpec signKey =  new  SecretKeySpec(key,  "HmacSHA1" );
	  Mac mac =  Mac.getInstance( "HmacSHA1" );
	  mac.init(signKey);
	  byte [] hash =  mac.doFinal(data);

	  LOGGER.debug("CHECK hash", hash);

	  int  offset =  hash[ 20 -  1 ] &  0xF ;

	  long  truncatedHash =  0 ;
	  for  ( int  i =  0 ; i <  4 ; ++ i) {
	      truncatedHash <<=  8 ;
	      truncatedHash |=  (hash[offset +  i] &  0xFF );
	  }

	  truncatedHash &=  0x7FFFFFFF ;
	  truncatedHash %=  1000000 ;

	  return  ( int ) truncatedHash;
	}


	@RequestMapping(value = "/login.do")
	public String loginEtrust(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
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
		LOGGER.debug("isCheckedMfa : {}", params.get("isCheckedMfa"));

		LoginVO loginVO = loginService.getLoginInfo(params);
		//LOGGER.info("###loginVO: " + loginVO.toString());
		ReturnMessage message = new ReturnMessage();

		int maxAttempt = loginService.getLoginFailedMaxAttempt();
		int attemptLeft = 0;

		if (loginVO == null || loginVO.getUserId() == 0) {

			if (loginVO == null && params.get("userId") != null) {

				EgovMap userMap = loginService.selectUserByUserName(params.get("userId").toString());

				if (userMap != null){

					if (maxAttempt > 0 ) {
						if (Integer.valueOf(userMap.get("loginFailAttempt").toString()) >= maxAttempt) {
							message.setCode(AppConstants.FAIL);
							message.setMessage("You have reached the maximum login attempts (" + maxAttempt + " attempts). <br/>Please contact administrator. ");
						} else {
							// update login fail attempt. Hui Ding, 18/03/2022
							loginService.updateLoginFailAttempt(params);

							EgovMap failedLogin = loginService.selectUserByUserName(params.get("userId").toString());
							attemptLeft = 5 - Integer.parseInt(failedLogin.get("loginFailAttempt").toString());

							message.setCode(AppConstants.FAIL);
							message.setMessage(messageAccessor.getMessage(AppConstants.MSG_INVALID, new Object[] { "ID/Password <br/>You have "+ attemptLeft + " login attempts left."}));
						}
					}
				}
			}

		} else {

			EgovMap userMap2 = loginService.selectUserByUserName(loginVO.getUserName().toString());

			if (userMap2 != null){
				if (maxAttempt > 0 ) {
					if (Integer.valueOf(userMap2.get("loginFailAttempt").toString()) >= maxAttempt) {
						message.setCode(AppConstants.FAIL);
						message.setMessage("You have reached the maximum login attempts (" + maxAttempt + " attempts). <br/>Please contact administrator. ");

						return ResponseEntity.ok(message);
					}
				}
			}

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

			if(params.get("isCheckedMfa").equals("Y") || loginVO.getCheckMfaFlag() == 2){
				HttpSession session = sessionHandler.getCurrentSession();
				session.setAttribute(AppConstants.SESSION_INFO, SessionVO.create(loginVO));
			}

			message.setData(loginVO);

			// set vaccination checking
			/*if (loginVO.getMemId() != null && (loginVO.getUserTypeId() == 1 || loginVO.getUserTypeId() == 2 || loginVO.getUserTypeId() == 3 || loginVO.getUserTypeId() == 7)){
				EgovMap vacInfo = loginService.getVaccineInfo(loginVO.getMemId());
				if (vacInfo != null){
					if (CommonUtils.getDiffDate(vacInfo.get("nextPopDt").toString()) == 0){
						session.setAttribute("vaccinationPop", "Y");
						session.setAttribute("vacInfo", vacInfo);

						if (vacInfo.get("VACCINE_STATUS").toString().equalsIgnoreCase("D")){
							model.addAttribute("vaccinationPop", "Y");
						} else if (vacInfo.get("VACCINE_STATUS").toString().equalsIgnoreCase("P")){
							model.addAttribute("vaccinationPop", "Y");
							model.addAttribute("vac2ndDosePop", "Y");
						}
					}
				} else {
					session.setAttribute("vaccinationPop", "Y");
				}
			}*/

			// Added for resetting login attempt limit after successfully logged in. Hui Ding, 18/03/2022.
			loginService.resetLoginFailAttempt(loginVO.getUserId());
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
	public String userSettingPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		model.addAttribute("userSettingFlag", sessionVO);
		LOGGER.debug("userSettingPop: {} ,getUserId: {}", params.toString(), sessionVO.getUserId());
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

		params.put("userTypeId",sessionVO.getUserTypeId());
		params.put("userName",sessionVO.getUserName());
		int cnt = loginService.updatePassWord(params, sessionVO.getUserId());

		params.put("userId", sessionVO.getUserName());
		params.put("password", params.get("newPasswordConfirmTxt"));

		// Reset session info to get latest password
		LoginVO loginVO = loginService.getLoginInfo(params);
		HttpSession session = sessionHandler.getCurrentSession();
		session.setAttribute(AppConstants.SESSION_INFO, SessionVO.create(loginVO));

		if(ssoLoginFlag > 0){
    		if(loginVO.getUserTypeId() == 1 || loginVO.getUserTypeId() == 2 || loginVO.getUserTypeId() == 3 || loginVO.getUserTypeId() == 7
    				|| loginVO.getUserTypeId() == 5){
    			//update password in keycloak
    			Map<String,Object> ssoParamsOldMem = new HashMap<String, Object>();
    			ssoParamsOldMem.put("memCode", sessionVO.getUserName());
    			ssoParamsOldMem.put("password", params.get("newPasswordConfirmTxt"));
    			ssoLoginService.ssoUpdateUserPassword(ssoParamsOldMem);
    		}
		}

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(cnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/updateUserInfoSetting.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateUserSetting(@RequestBody Map<String, Object> params,
			SessionVO sessionVO) {
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
	public ResponseEntity<List<EgovMap>> selectSecureResnList(@RequestParam Map<String, Object> params,
			ModelMap model) {
		LOGGER.debug("selectSecureResnList : {}", params.toString());

		List<EgovMap> selectSecureResnList = loginService.selectSecureResnList(params);
		return ResponseEntity.ok(selectSecureResnList);
	}

	@RequestMapping(value = "/myInfo.do", method = RequestMethod.GET)
	public String myInfo(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		model.addAttribute("userSettingFlag", sessionVO);
		LOGGER.debug("userSettingPop: {} ,getUserId: {}", params.toString(), sessionVO.getUserId());
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
		model.put("popId", params.get("popId"));
		model.put("pdfNm", params.get("loginPdf"));
		model.put("popType", params.get("popType"));
		model.put("popAck1", params.get("popAck1"));
		model.put("popAck2", params.get("popAck2"));
		model.put("popAck3", params.get("popAck3"));
		model.put("popRejectFlg", params.get("popRejectFlg"));
		model.put("verName", params.get("verName"));
		model.put("verNRIC", params.get("verNRIC"));
		model.put("verBankAccNo", params.get("verBankAccNo"));
		model.put("verBankName", params.get("verBankName"));

		if(params.containsKey("consentFlg")) {
		    model.put("consentFlg", params.get("consentFlg"));
		}

		return "/login/loginPop";
	}

	@RequestMapping(value = "/getLoginDtls.do", method = RequestMethod.GET)
	public ResponseEntity<Map> getLoginDtls(@RequestParam Map<String, Object> params, HttpServletRequest request,
			ModelMap model, SessionVO sessionVO) {

		LOGGER.debug("==================== getLoginDtls ====================");

		// Map<String, Object> popInfo = new HashMap();

		params.put("userTypeId", sessionVO.getUserTypeId());
		params.put("userId", sessionVO.getUserId());

		EgovMap item1 = new EgovMap();
		item1 = (EgovMap) loginService.getDtls(params);
		params.put("roleType", item1.get("roleType"));

		return ResponseEntity.ok(params);
	}

	@RequestMapping(value = "/loginPopCheck", method = RequestMethod.GET)
	public ResponseEntity<Map> cdEagmt1(@RequestParam Map<String, Object> params, HttpServletRequest request,
			ModelMap model, SessionVO sessionVO) throws ParseException {

		LOGGER.debug("==================== loginPopCheck ====================");

		LOGGER.debug("params : {}", params);
		model.put("loginUserId", (String) params.get("loginUserId"));
		model.put("os", (String) params.get("os"));
		model.put("browser", (String) params.get("browser"));
		model.put("userId", (String) params.get("userId"));
		model.put("password", (String) params.get("password"));
		model.put("userType", (String) params.get("loginUserType"));

		params.put("userId", sessionVO.getUserId());

		int noticeExist = loginService.checkNotice();

		// check consent letter exist
		int consentExist = loginService.checkConsent();
		EgovMap itemConsent = null;
		if(consentExist > 0) {
		    itemConsent = loginService.getConsentDtls(params);
		}

		// Get User type, role/contract type, agreement status (if applicable)
		EgovMap item1 = new EgovMap();
		item1 = (EgovMap) loginService.getDtls(params);

		LOGGER.debug("============ ITEMS1 =============" + item1);

		Map<String, Object> popInfo = new HashMap();

		String userTypeId = params.get("userTypeId").toString();
		while (userTypeId.length() < 4) {
			userTypeId = "0" + userTypeId;
			LOGGER.debug("userTypeId :: " + userTypeId);
		}

		params.put("userTypeId", userTypeId);
		params.put("roleType", item1.get("roleType"));
		params.put("roleId", item1.get("roleType"));

		LOGGER.debug("============roleType=============" + item1.get("roleType"));
		String retMsg = "";

		// If ORG0003D not empty/null = agreement exist
		if (item1 != null) {
			LOGGER.debug("============ AGREEMENT EXIST =============");
			if (item1.containsKey("stusId")) {
				String stusId = item1.get("stusId").toString();
				String cnfm = item1.get("cnfm").toString();
				String cnfmDt = item1.get("cnfmDt").toString().substring(0, 10);

				popInfo.put("verName", item1.get("name"));
				popInfo.put("verNRIC", item1.get("nric"));
				popInfo.put("verBankAccNo", item1.get("bankAccNo"));
				popInfo.put("verBankName", item1.get("bankName"));

				// Pending Agreement (New Members)
				if ("44".equals(stusId) && "0".equals(cnfm) && "1900-01-01".equals(cnfmDt)) {
					LOGGER.debug("============ PENDING =============");
					params.put("roleId", item1.get("roleType"));
					params.put("popType", "A");

					if(consentExist > 0 && ("115".equals(item1.get("roleType")) ||
					   "121".equals(item1.get("roleType")) ||
					   "352".equals(item1.get("roleType")) || "351".equals(item1.get("roleType")))
					  ) {
					    params.put("consentFlg", "Y");
					}
				}
				// Accepted (Existing Members)
				else if ("5".equals(stusId) && "1".equals(cnfm) && !"1900-01-01".equals(cnfmDt)) {

					LOGGER.debug("============ ACCEPTED =============");
					// HM, SM, GM Renewal
					if ("0001".equals(userTypeId) && !"115".equals(item1.get("roleType"))) {

						params.put("popType", "M");
//						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//
//						Date currDate = new Date(); // Current Date
//						Date janRe = null; // January Renewal
//						Date julRe = null; // July Renewal
//						Date cnfmDate = null; // Agreement Confirmation Date
//
//						Calendar cal = Calendar.getInstance();
//
//						cal.setTime(currDate);
//						int cYear = cal.get(Calendar.YEAR);
//						int cMth = cal.get(Calendar.MONTH);
//						if (cMth < 7) {
//							cMth = 1;
//						} else {
//							cMth = 2;
//						}
//
//						//popType B - Short Term Extension Agreement for HM, SM and GM
//						try {
//							janRe = sdf.parse(Integer.toString(cYear) + "-01-01");
//							julRe = sdf.parse(Integer.toString(cYear) + "-07-01");
//							cnfmDate = sdf.parse(cnfmDt);
//
//							switch (cMth) {
//							case 1:
//								if (cnfmDate.compareTo(janRe) < 0) {
//									params.put("roleId", item1.get("roleType"));
//									params.put("popType", "B");
//								} else {
//									params.put("popType", "M");
//								}
//								break;
//							case 2:
//								if (cnfmDate.compareTo(julRe) < 0) {
//									params.put("roleId", item1.get("roleType"));
//									params.put("popType", "B");
//								} else {
//									params.put("popType", "M");
//								}
//								break;
//							default:
//								params.put("popType", "M");
//								break;
//							}
//						} catch (Exception e) {
//							LOGGER.error(e.toString());
//						}
					}
					// Cody agreement renewal
					else if ("0002".equals(userTypeId) && "121".equals(item1.get("roleType"))) {
						params.put("roleId", "121");
						try {
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

							Date currRenewalDt = null;
							Date joinDt = sdf.parse(item1.get("joinDt").toString().substring(0, 10));
							Date cnfmDate = sdf.parse(cnfmDt);

							Date currDate = new Date(); // Current Date
							Calendar cal = Calendar.getInstance();
							cal.setTime(currDate);

							currRenewalDt = sdf.parse(Integer.toString(cal.get(Calendar.YEAR)) + "-04-01");

							// if(currDate.compareTo(currRenewalDt) < 0 )
							if (cnfmDate.compareTo(currRenewalDt) < 0 && joinDt.compareTo(currRenewalDt) < 0
									&& currDate.compareTo(currRenewalDt) >= 0) {
								params.put("popType", "A");
							} else if (cnfmDate.compareTo(currRenewalDt) < 0 && joinDt.compareTo(currRenewalDt) >= 0) {
								params.put("popType", "M");
							} else {
								params.put("popType", "-");
							}
						} catch (Exception e) {
							LOGGER.error(e.toString());
						}
					}
					// HT agreement renewal
					else if ("0007".equals(userTypeId)
					        /*("0007".equals(userTypeId) && (("348".equals(item1.get("roleType")))
							|| ("349".equals(item1.get("roleType"))) || ("350".equals(item1.get("roleType")))
							|| ("351".equals(item1.get("roleType"))) || ("352".equals(item1.get("roleType")))))
							*/
					) {
						// 0007=HT, roletype121=level of position
						LOGGER.debug("===========HT agreement renewal============");
						LOGGER.debug("===========roleType============" + item1.get("roleType"));

						LOGGER.debug("============ ACCEPTED =============");
						params.put("popType", "A");
						params.put("roleId", item1.get("roleType"));
						EgovMap aggrementCrtDt = new EgovMap();
						aggrementCrtDt = (EgovMap) loginService.getPopDtls(params);
						LOGGER.debug("============ aggrementCrtDt =============" + aggrementCrtDt);
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
						Date agreeCrtDt = sdf.parse(aggrementCrtDt.get("crtDt").toString().substring(0, 10));
						LOGGER.debug("============ agreeCrtDt =============" + agreeCrtDt);

						// here start the validation
						params.put("roleId", "356");
						try {
							Date joinDt = sdf.parse(item1.get("joinDt").toString().substring(0, 10));
							LOGGER.debug("===========joinDT============" + joinDt);
							Date cnfmDate = sdf.parse(cnfmDt);
							LOGGER.debug("===========cnfmDate data type============" + cnfmDate.getClass().getName());

							Date currDate = new Date(); // Current Date
							Calendar cal = Calendar.getInstance();
							cal.setTime(currDate);

							Calendar c = Calendar.getInstance();
							c.setTime(joinDt);
							c.add(Calendar.YEAR, 1);
							Date currRenewalDt = new Date();
							currRenewalDt = c.getTime();

							if (cnfmDate.compareTo(agreeCrtDt) < 0 && joinDt.compareTo(agreeCrtDt) < 0
									&& currDate.compareTo(agreeCrtDt) >= 0) {
								LOGGER.debug("===========AAAAAAAAAAAAAA============");
								params.put("popType", "A");
							}

							// if(currDate.compareTo(currRenewalDt) < 0 )
							else if (cnfmDate.compareTo(currRenewalDt) < 0 && joinDt.compareTo(currRenewalDt) < 0
									&& currDate.compareTo(currRenewalDt) >= 0) {
								LOGGER.debug("===========BBBBBBBBBBBBBBBBBB============");
								params.put("popType", "A");
							} else if (cnfmDate.compareTo(currRenewalDt) < 0 && joinDt.compareTo(currRenewalDt) >= 0) {
								params.put("popType", "M");
							} else {
								params.put("popType", "-");
							}
						} catch (Exception e) {
							LOGGER.error(e.toString());
						}
					}
					// HP, CD, HT
                    else if(consentExist > 0 &&
                            itemConsent == null &&
                            "4".equals(item1.get("memLvl").toString()) &&
                            ("0001".equals(userTypeId) || "0002".equals(userTypeId) || "0007".equals(userTypeId))) {
                        LOGGER.info("HP :: ORG0036D empty");
                        params.put("popType", "C");
                    }
					// Other than HP user type (Staff, Admin)
					else {
						params.put("popType", "M");
					}
				}
				// Rejected
				else if ("6".equals(stusId) && "0".equals(cnfm) && !"1900-01-01".equals(cnfmDt)) {
					params.put("popType", "-");
					retMsg = "Application has been rejected.";
				} else {
					params.put("popType", "-");
				}
			}
		}

		// Get pop up file name, pop exception members/roles
		int memLvl = 0;
		if(item1.containsKey("memLvl")) {
		    memLvl = Integer.parseInt(item1.get("memLvl").toString());
		}

		String popType = "";
		if(params.containsKey("popType")) {
		    popType = params.get("popType").toString();
		}
		int userType = Integer.parseInt(item1.get("userTypeId").toString());

		/*
		 * For Organization ::
		 * Agreement :: highest precedence
		 * Memo :: 2nd
		 * Notice :: Lowest (Generally configured for all type users inclusive staff)
		 */
		if(!"A".equals(popType) && !"M".equals(popType) && noticeExist > 0) {
		    switch(userType) {
	        case 1:
	            if("".equals(popType)) params.put("popType", "N");
	            //params.put("popType", "N");
	            break;
	        case 2:
	            if(memLvl < 4) {
	                // CM, SCM, GCM
	                // Default Notice view as there's no contract renewal applicable
	                params.put("popType", "N");
	            } else if(memLvl == 4) {
	                if("-".equals(popType) || "".equals(popType)) {
	                    if(consentExist > 0 && itemConsent == null) {
	                        params.put("popType", "C");
	                    } else {
	                        params.put("popType", "N");
	                    }
	                }
	            }
	            break;
	        case 7:
	            /*
	             * HT has no memo applied as of 2021-02-04
	             * Subject to change if required
	             */
	            if(!"A".equals(popType)) {
	                if(consentExist > 0 && itemConsent == null) {
	                    params.put("popType", "C");
	                } else {
	                    params.put("popType", "N");
	                }
	            }
	            break;
	        default:
	            params.put("popType", "N");
	        }
		}

		/*
		if("1".equals(item1.get("userTypeId").toString()) || "2".equals(item1.get("userTypeId").toString()) || "7".equals(item1.get("userTypeId").toString())) {
		    if((!"A".equals(params.get("popType").toString()) && noticeExist != 0) || ("2".equals(item1.get("userTypeId").toString()) && memLvl < 4)) {
	            params.put("popType", "N");
	        }
		} else {
		    params.put("popType", "N");
		}
		*/

 		EgovMap item2 = new EgovMap();
		item2 = (EgovMap) loginService.getPopDtls(params);

		// Get Pop up configuration
		if (item2 != null) {
			// Pop up configuration exist - get configurations
			if (item2.containsKey("popNewFlNm")) {
			    popInfo.put("popId", item2.get("popId"));
				popInfo.put("popFlName", item2.get("popNewFlNm"));
				popInfo.put("popExceptionMemroleCnt", item2.get("popExceptionMemroleCnt"));
				popInfo.put("popExceptionUserCnt", item2.get("popExceptionUserCnt"));
				popInfo.put("popType", item2.get("popType"));
				popInfo.put("popRejectFlg", item2.get("popRejectFlg"));
				popInfo.put("popAck1", item2.get("popAck1"));
				popInfo.put("popAck2", item2.get("popAck2"));
				popInfo.put("popAck3", item2.get("popAck3"));
				LOGGER.debug("============ popInfo =============" + popInfo);
			} else {
				popInfo.put("popFlName", "-");
				popInfo.put("popExceptionMemroleCnt", "0");
				popInfo.put("popExceptionUserCnt", "0");
			}
		} else {
			// Pop up configuration does not exist > Exception default to 1 to by pass pop up window
			popInfo.put("popExceptionMemroleCnt", "1");
		}

		params.put("inWeb", "0");
		int surveyTypeId = surveyService.isSurveyRequired(params, sessionVO);
		if (surveyTypeId != 0) {
			params.put("surveyTypeId", surveyTypeId);
		}
		int verifySurveyStus = surveyService.verifyStatus(params, sessionVO);

		if(params.containsKey("consentFlg")) {
		    popInfo.put("consentFlg", params.get("consentFlg"));
		}

		popInfo.put("surveyTypeId", surveyTypeId);
		popInfo.put("verifySurveyStus", verifySurveyStus);
		popInfo.put("retMsg", retMsg);

		return ResponseEntity.ok(popInfo);
	}

	@RequestMapping(value = "/loginNoticePopCheck", method = RequestMethod.GET)
	public ResponseEntity<Map> loginNoticePopCheck(@RequestParam Map<String, Object> params, HttpServletRequest request,
			ModelMap model, SessionVO sessionVO) throws ParseException {

		Map<String, Object> popNoticeInfo = new HashMap();

		params.put("userTypeId", "0000"); // universal member type

		EgovMap noticePopItem = new EgovMap();
		noticePopItem = loginService.getCowayNoticePopDtls(params);

		if (noticePopItem != null && !noticePopItem.isEmpty()){

    		if (noticePopItem.containsKey("popNewFlNm")) {
    			popNoticeInfo.put("retMsg", "");
    			popNoticeInfo.put("popFlName", noticePopItem.get("popNewFlNm"));
    		} else {
    			popNoticeInfo.put("retMsg", "No Notice.");
    			popNoticeInfo.put("popFlName", "-");
    		}
		} else {
			popNoticeInfo.put("retMsg", "No Notice.");
		}

		return ResponseEntity.ok(popNoticeInfo);
	}

	@RequestMapping(value = "/loginNoticePop.do")
	public String loginNoticePop(@RequestParam Map<String, Object> params, ModelMap model) {

		LOGGER.debug("params : {}", params);
		model.put("loginUserId", (String) params.get("loginUserId"));
		model.put("os", (String) params.get("os"));
		model.put("browser", (String) params.get("browser"));
		model.put("userId", (String) params.get("userId"));
		model.put("password", (String) params.get("password"));
		model.put("userType", (String) params.get("loginUserType"));
		model.put("pdfNm", params.get("loginPdf"));
		model.put("popType", params.get("popType"));

		model.put("inQueue", params.get("inQueue"));

		return "/login/loginNoticePop";
	}

	@RequestMapping(value = "/tempPwProcess.do")
	public ResponseEntity<ReturnMessage> tempPwProcess(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO session) {
	    LOGGER.debug("loginController :: tempPwProcess");
	    LOGGER.debug("params : {}", params);

	    Map<String, Object> tempPwProcess = new HashMap<String, Object>();
	    tempPwProcess = loginService.tempPwProcess(params);

	    ReturnMessage message = new ReturnMessage();
	    if("fail".equals(tempPwProcess.get("flg").toString())) {
            message.setCode(AppConstants.FAIL);
            message.setMessage(tempPwProcess.get("message").toString());
        } else {
            message.setCode(AppConstants.SUCCESS);
            message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        }

        return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/popAccept.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> popAccept(@RequestParam Map<String, Object> params, ModelMap model) {
	    LOGGER.debug("========== popAccent.do ==========");
	    LOGGER.debug("params : {}", params);

	    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
        params.put("userId", sessionVO.getUserId());
	    int acceptPop = loginService.loginPopAccept(params);

	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

	    return ResponseEntity.ok(message);
	}

	/**
	 * Added for Vaccination document upload
	 *
	 * @Date Sep 12, 2021
	 * @Author HQIT-HUIDING
	 * @param request
	 * @param params
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/attachFileUpload.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> attachFileUpload(MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, Model model, SessionVO sessionVO) throws Exception {

		String err = "";
		String code = "";
		List<String> seqs = new ArrayList<>();

		//LocalDate date = LocalDate.now();
		//String year    = String.valueOf(date.getYear());
		//String month   = String.format("%02d",date.getMonthValue());

		String subPath = File.separator + "login"
		               + File.separator + "vaccination";
		               //+ File.separator + CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT3);

		try{
			 Set set = request.getFileMap().entrySet();
			 Iterator i = set.iterator();

			 while(i.hasNext()) {
			     Map.Entry me = (Map.Entry)i.next();
			     String key = (String)me.getKey();
			     seqs.add(key);
			 }

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadImageFilesWithCompress(request, uploadDir, subPath , AppConstants.UPLOAD_MIN_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		params.put(CommonConstants.USER_ID, sessionVO.getUserId());

		loginService.insertAttachDoc(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  params, seqs);

		params.put("attachFiles", list);
		code = AppConstants.SUCCESS;
		}catch(ApplicationException e){
			err = e.getMessage();
			code = AppConstants.FAIL;
		}

		ReturnMessage message = new ReturnMessage();
		message.setCode(code);
		message.setData(params);
		message.setMessage(err);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/vaccineInfoPop.do")
	public String vaccineInfoPop (@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		EgovMap vacInfo = loginService.getVaccineInfo(sessionVO.getMemId());

		model.addAttribute("vacInfo", vacInfo);

		return "/login/vaccineInfoPop";
	}

	@RequestMapping(value = "/vaccineInfoSave.do", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> vaccineInfoSave(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO)
	          throws Exception {

		LOGGER.info("####params: " + params.toString());
		String memId = sessionVO.getMemId();
		int userId = sessionVO.getUserId();

		LOGGER.info("########memId: " + memId);
		LOGGER.info("########userId: " + userId);

		int result = loginService.insertVaccineInfo(params, userId, memId);


		ReturnMessage message = new ReturnMessage();
		if (result > 0){
    	    message.setCode(AppConstants.SUCCESS);
    	    message.setMessage("Successful");
		} else {
			message.setCode(AppConstants.FAIL);
    	    message.setMessage("Failed");
		}

	    return ResponseEntity.ok(message);

	}

	/**
	 * To validate password
	 *
	 * @Date Mar 17, 2022
	 * @Author HQIT-HUIDING
	 * @param params
	 * @param request
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/checkPassword.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> checkPassword(@RequestParam Map<String, Object> params, ModelMap model) throws ParseException {

		LOGGER.info("###params: " + params.toString());
		params.put("password", params.get("newPassword"));

		// to check if new password same like previous password
		int result =  loginService.checkNewPassword(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(result);

		return ResponseEntity.ok(message);

	}

	/**
	 * To validate security answer
	 *
	 * @Date Mar 29, 2022
	 * @Author HQIT-HLTANG
	 * @param params
	 * @param request
	 * @param model
	 * @param sessionVO
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/checkSecAns.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> checkSecAns(@RequestBody Map<String, Object> params, ModelMap model) {

		int result = loginService.checkSecurityAnswer(params);

		ReturnMessage message = new ReturnMessage();

		if (result == 0) {
			message.setCode(AppConstants.FAIL);
		} else {
			message.setCode(AppConstants.SUCCESS);
		}

		return ResponseEntity.ok(message);
	}
}
