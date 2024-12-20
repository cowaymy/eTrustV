/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.login.impl;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.login.LoginHistory;
import com.coway.trust.biz.login.LoginService;
import com.coway.trust.biz.login.SsoLoginService;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.cmmn.model.LoginSubAuthVO;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("loginService")
public class LoginServiceImpl implements LoginService {
  private static final Logger LOGGER = LoggerFactory.getLogger( LoginServiceImpl.class );

  @Autowired
  private LoginMapper loginMapper;

  @Autowired
  private AdaptorService adaptorService;

  @Autowired
  private FileService fileService;

  @Autowired
  private FileMapper fileMapper;

  @Resource(name = "ssoLoginService")
  private SsoLoginService ssoLoginService;

  @Value("${sso.use.flag}")
  private int ssoLoginFlag;

  @Override
  public LoginVO getLoginInfo( Map<String, Object> params ) {
    LOGGER.debug( "loginInfo" );
    LoginVO loginVO = loginMapper.selectLoginInfo( params );
    if ( loginVO != null ) {
      addSubAuthToLoginVO( params, loginVO );
    }
    return loginVO;
  }

  @Override
  public LoginVO selectFindUserIdPop( Map<String, Object> params ) {
    LOGGER.debug( "findLoginInfo" );
    LoginVO loginVO = loginMapper.selectFindUserIdPop( params );
    return loginVO;
  }

  @Override
  public LoginVO loginByMobile( Map<String, Object> params ) {
    LOGGER.debug( "loginByMobile" );
    // TODO : deviceImei 체크 필요.
    LoginVO loginVO = getLoginInfo( params );
    return loginVO;
  }

  @Override
  public LoginVO loginByCallcenter( Map<String, Object> params ) {
    LOGGER.debug( "loginByCallcenter" );
    LoginVO loginVO = loginMapper.selectLoginInfoById( params );
    if ( loginVO != null ) {
      addSubAuthToLoginVO( params, loginVO );
    }
    return loginVO;
  }

  private void addSubAuthToLoginVO( Map<String, Object> params, LoginVO loginVO ) {
    params.put( "userId", loginVO.getUserId() );
    List<LoginSubAuthVO> loginSubAuthVOList = loginMapper.selectSubAuthInfo( params );
    loginVO.setLoginSubAuthVOList( loginSubAuthVOList );
  }

  @Override
  public void logoutByMobile( Map<String, Object> params ) {
    // TODO mobile 로그 아웃시 처리사항....
    logout( params );
  }

  @Override
  public void logout( Map<String, Object> params ) {
    // TODO 로그 아웃시 처리사항....
  }

  @Override
  public List<EgovMap> getLanguages() {
    return loginMapper.selectLanguages();
  }

  @Override
  public int updatePassWord( Map<String, Object> params, Integer crtUserId ) {
    int saveCnt = 0;
    // for (Object obj : addList)
    // {
    params.put( "crtUserId", crtUserId );
    params.put( "updUserId", crtUserId );
    LOGGER.debug( " >>>>> insertUserExceptAuthMapping " );
    LOGGER.debug( " Login_UserId : {}", params.get( "newUserIdTxt" ) );
    // String tmpStr = (String) ((Map<String, Object>) obj).get("hidden");
    // ((Map<String, Object>) obj).put("userId", ((Map<String, Object>) obj).get("userId") );
    saveCnt++;
    loginMapper.updatePassWord( params );
    // }
    // ssoLogin
    if ( ssoLoginFlag > 0 ) {
      try {
        if ( params.get( "userTypeId" ).toString().equals( "1" ) || params.get( "userTypeId" ).toString().equals( "2" )
          || params.get( "userTypeId" ).toString().equals( "3" ) || params.get( "userTypeId" ).toString().equals( "7" )
          || params.get( "userTypeId" ).toString().equals( "5" )
          || params.get( "userTypeId" ).toString().equals( "6672" ) ) {
          // update password in keycloak
          Map<String, Object> ssoParamsOldMem = new HashMap<String, Object>();
          ssoParamsOldMem.put( "memCode", params.get( "userName" ) );
          ssoParamsOldMem.put( "password", params.get( "newPasswordConfirmTxt" ) );
          ssoLoginService.ssoUpdateUserPassword( ssoParamsOldMem );
        }
      }
      catch ( Exception ex ) {
        throw ex;
      }
    }
    return saveCnt;
  }

  @Override
  public int updateUserSetting( Map<String, Object> params, Integer crtUserId ) {
    int saveCnt = 0;
    params.put( "crtUserId", crtUserId );
    params.put( "updUserId", crtUserId );
    LOGGER.debug( " >>>>> updateUserSetting " );
    LOGGER.debug( " Login_UserId : {}", params.get( "newUserIdTxt" ) );
    saveCnt = loginMapper.updateUserSetting( params );
    return saveCnt;
  }

  @Override
  public List<EgovMap> selectSecureResnList( Map<String, Object> params ) {
    return loginMapper.selectSecureResnList( params );
  }

  @Override
  @CacheEvict(value = {
    AppConstants.LEFT_MENU_CACHE,
    AppConstants.LEFT_MY_MENU_CACHE }, key = "#loginHistory.getUserId()")
  public void saveLoginHistory( LoginHistory loginHistory ) {
    loginMapper.insertLoginHistory( loginHistory );
  }

  @Override
  public EgovMap checkByPass( Map<String, Object> params ) {
    return loginMapper.checkByPass( params );
  }

  @Override
  public LoginVO getAplcntInfo( Map<String, Object> params ) {
    LOGGER.debug( "applicantInfo" );
    LoginVO loginVO = loginMapper.getAplcntInfo( params );
    return loginVO;
  }

  @Override
  public EgovMap getDtls( Map<String, Object> params ) {
    return loginMapper.getDtls( params );
  }

  @Override
  public EgovMap getConsentDtls2( Map<String, Object> params ) {
    return loginMapper.getConsentDtls2( params );
  }

  @Override
  public EgovMap getPopDtls( Map<String, Object> params ) {
    return loginMapper.getPopDtls( params );
  }

  @Override
  public EgovMap getCowayNoticePopDtls( Map<String, Object> params ) {
    return loginMapper.getCowayNoticePopDtls( params );
  }

  @Override
  public int checkNotice() {
    return loginMapper.checkNotice();
  }

  @Override
  public Map<String, Object> tempPwProcess( Map<String, Object> params ) {
    LOGGER.debug( "LoginServiceImpl :: tempPwProcess" );
    LOGGER.debug( "params : {}", params );
    Map<String, Object> result = new HashMap<String, Object>();
    String msg = "";
    int cnt = loginMapper.checkMobileNumber( params );
    int userTypeId = loginMapper.selectFindUserIdPop( params ).getUserTypeId();
    if ( cnt < 1 ) {
      if ( userTypeId == 1 ) {
        msg = "Dear HP, please enter the correct HP code or update your mobile number at nearest sales office.";
      }
      else if ( userTypeId == 2 ) {
        msg = "Dear Cody/ST, please enter the correct Cody/ST code or update your mobile number at nearest sales office.";
      }
      else {
        msg = "Dear user, please enter the correct username or update your mobile number at nearest sales office.";
      }
      // Mobile number does not exist
      result.put( "flg", "fail" );
    }
    else {
      // Mobile number exist
      // TODO
      // Create checking point if SMS password request reached 7 days limit (querying from SYS0098M)
      //
      params.put( "module", "LOGIN" );
      params.put( "subModule", "PW_RESET" );
      params.put( "paramCode", "SMS_REQ_LIMIT" );
      EgovMap cpMap = null;
      cpMap = loginMapper.getConfig( params );
      int smsLimit = Integer.valueOf( cpMap.get( "paramVal" ).toString() );
      params.put( "paramCode", "SMS_DAY_CNT" );
      cpMap = loginMapper.getConfig( params );
      params.put( "dayCnt", cpMap.get( "paramVal" ) );
      int smsReqCnt = loginMapper.getSmsReqCnt( params );
      if ( smsReqCnt >= smsLimit ) {
        if ( userTypeId == 1 ) {
          msg = "Dear HP, request limit reached, kindly email to hpresetpassword@coway.com.my for further assistance";
        }
        else if ( userTypeId == 2 ) {
          msg = "Dear Cody / ST, request limit reached, kindly refer to your manager to email to Cody Operation Department";
        }
        else {
          msg = "Request limit reached";
        }
        result.put( "flg", "fail" );
      }
      else {
        // Generate temporary password
        Random random = new Random();
        char[] chars = "abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();
        StringBuilder sb = new StringBuilder();
        int charsLen = chars.length;
        for ( int i = 0; i < 6; i++ ) {
          int num = random.nextInt( charsLen );
          sb.append( chars[num] );
        }
        params.put( "tempPw", sb.toString() );
        int reqId = loginMapper.getReqId();
        params.put( "reqId", reqId );
        /*
         * Insert SMS request log (ORG0033D) Update User table with temporary password and expired
         * user password last update date (-3 months)
         */
        loginMapper.logRequest( params );
        loginMapper.updateSYS47M_req( params );
        String message = " COWAY:Confidential! Never share your temporary password.Password: " + sb
          + ". Kindly login to update your password.";
        int smsType = 6209;
        if ( userTypeId == 2 ) {
          smsType = 6416;
        }
        // Send SMS
        SmsVO sms = new SmsVO( Integer.valueOf( params.get( "userId" ).toString() ), smsType );
        sms.setMessage( message );
        sms.setMobiles( CommonUtils.nvl( params.get( "mobileNo" ) ) );
        SmsResult smsResult = adaptorService.sendSMS2( sms );
        LOGGER.debug( "LoginServiceImpl :: tempPwProcess :: {}", smsResult.toString() );
        params.put( "smsId", smsResult.getSmsId() );
        loginMapper.updateRequest( params );
        result.put( "flg", "success" );
      }
    }
    result.put( "message", msg );
    return result;
  }

  @Override
  public int checkConsent() {
    return loginMapper.checkConsent();
  }

  @Override
  public EgovMap getConsentDtls( Map<String, Object> params ) {
    return loginMapper.getConsentDtls( params );
  }

  @Override
  public int loginPopAccept( Map<String, Object> params ) {
    return loginMapper.loginPopAccept( params );
  }

  /**
   * upload vaccination doc
   *
   * @Date Sep 12, 2021
   * @Author HQIT-HUIDING
   * @param list
   * @param type
   * @param params
   * @param seqs
   */
  @Override
  public void insertAttachDoc( List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs ) {
    // TODO Auto-generated method stub
    int fileGroupKey = fileMapper.selectFileGroupKey();
    AtomicInteger i = new AtomicInteger( 0 ); // get seq key.
    list.forEach( r -> {
      this.insertFile( fileGroupKey, r, type, params, seqs.get( i.getAndIncrement() ) );
    } );
    params.put( "fileGroupKey", fileGroupKey );
  }

  private void insertFile( int fileGroupKey, FileVO flVO, FileType flType, Map<String, Object> params, String seq ) {
    LOGGER.debug( "login insertFile :: Start" );
    int atchFlId = loginMapper.selectNextFileId();
    FileGroupVO fileGroupVO = new FileGroupVO();
    Map<String, Object> flInfo = new HashMap<String, Object>();
    flInfo.put( "atchFileId", atchFlId );
    flInfo.put( "atchFileName", flVO.getAtchFileName() );
    flInfo.put( "fileSubPath", flVO.getFileSubPath() );
    flInfo.put( "physiclFileName", flVO.getPhysiclFileName() );
    flInfo.put( "fileExtsn", flVO.getFileExtsn() );
    flInfo.put( "fileSize", flVO.getFileSize() );
    flInfo.put( "filePassword", flVO.getFilePassword() );
    flInfo.put( "fileUnqKey", params.get( "claimUn" ) );
    flInfo.put( "fileKeySeq", seq );
    loginMapper.insertFileDetail( flInfo );
    fileGroupVO.setAtchFileGrpId( fileGroupKey );
    fileGroupVO.setAtchFileId( atchFlId );
    fileGroupVO.setChenalType( flType.getCode() );
    fileGroupVO.setCrtUserId( Integer.parseInt( params.get( "userId" ).toString() ) );
    fileGroupVO.setUpdUserId( Integer.parseInt( params.get( "userId" ).toString() ) );
    fileMapper.insertFileGroup( fileGroupVO );
    LOGGER.debug( "login insertFile :: End" );
  }

  @Override
  public int insertVaccineInfo( Map<String, Object> params, int userId, String memId ) {
    Map<String, Object> updParams = new HashMap<String, Object>();
    String nextPopDt = CommonUtils.getCalDate( 7 ); // defaultly set 21days later to pop again
    // String secondNextPopDt = CommonUtils.getCalDate(7); // 2nd dose next pop date set to every 7 days
    int update = 0;
    updParams.put( "userId", userId );
    updParams.put( "memId", memId );
    if ( params.get( "currVacStatus" ) == null || params.get( "currVacStatus" ) == ""
      || ( params.get( "currVacStatus" ) != "" && params.get( "currVacStatus" ).toString().equalsIgnoreCase( "D" ) ) ) {
      if ( params.get( "firstDoseChk" ) != "" ) {
        if ( params.get( "firstDoseChk" ).toString().equalsIgnoreCase( "yes" ) ) {
          // insert org0040D
          updParams.put( "firstDoseChk", "Y" ); // completed 1st dose
          updParams.put( "firstDoseDt", params.get( "1stDoseDt" ) );
          updParams.put( "typeOfVaccine", params.get( "typeOfVaccine" ) );
          updParams.put( "otherVacType", params.get( "otherVacType" ) );
          if ( params.get( "2ndDoseNo" ) != null && params.get( "2ndDoseNo" ) != ""
            && params.get( "2ndDoseNo" ).toString().equalsIgnoreCase( "on" ) ) {
            // set next pop date for 2nd dose info collection
            updParams.put( "nextPopDt", nextPopDt );
            updParams.put( "vaccineStatus", "P" ); // P = Partial | C = Completed | D = Did not take vaccine
          }
          else {
            updParams.put( "vaccineStatus", "C" ); // P = Partial | C = Completed | D = Did not take vaccine
            if ( !params.get( "typeOfVaccine" ).toString().equals( "6500" )
              && !params.get( "typeOfVaccine" ).toString().equals( "6511" ) ) { // johnson & johnson ||
              // CanSino only take 1 dose
              updParams.put( "secondDoseChk", "Y" ); // completed 2nd dose
              updParams.put( "secondDoseDt", params.get( "2ndDoseDt" ) );
            }
          }
          updParams.put( "yesAtchGrpId", params.get( "atchFileGrpId" ) );
          // update = loginMapper.insertVacInfo(updParams);
        }
        else {
          updParams.put( "reasonId", params.get( "reason" ) );
          updParams.put( "vaccineStatus", "D" ); // P = Partial | C = Completed | D = Did not take vaccine
          if ( params.get( "reason" ).equals( "6501" ) ) // pregnancy
            updParams.put( "reasonDtl", params.get( "pregnancyWeek" ) );
          else if ( params.get( "reason" ).equals( "6502" ) ) // allergic
            updParams.put( "reasonDtl", params.get( "allergicType" ) );
          else
            updParams.put( "reasonDtl", params.get( "reasonDtl" ) );
          updParams.put( "nextPopDt", nextPopDt );
          updParams.put( "noAtchGrpId", params.get( "atchFileGrpId" ) );
        }
      }
    }
    else {
      if ( params.get( "currVacStatus" ).toString().equalsIgnoreCase( "P" ) ) { // update 2nd dose info only
        if ( params.get( "2ndDoseNo" ) != null && params.get( "2ndDoseNo" ) != ""
          && params.get( "2ndDoseNo" ).toString().equalsIgnoreCase( "on" ) ) {
          // set next pop date for 2nd dose info collection
          updParams.put( "nextPopDt", nextPopDt );
        }
        else {
          updParams.put( "vaccineStatus", "C" ); // P = Partial | C = Completed | D = Did not take vaccine
          updParams.put( "secondDoseChk", "Y" ); // completed 2nd dose
          updParams.put( "secondDoseDt", params.get( "2ndDoseDt" ) );
        }
        if ( params.get( "typeOfVaccine" ) != null ) {
          updParams.put( "typeOfVaccine", params.get( "typeOfVaccine" ) );
        }
      }
    }
    if ( params.get( "declareChk" ).toString().equalsIgnoreCase( "on" ) ) {
      updParams.put( "declareChk", "Y" );
    }
    update = loginMapper.insertVacInfo( updParams );
    return update;
  }

  @Override
  public EgovMap getVaccineInfo( String memId ) {
    EgovMap vacInfo = null;
    if ( memId != null ) {
      Map<String, Object> params = new HashMap<String, Object>();
      params.put( "memId", memId );
      vacInfo = loginMapper.getVaccineInfo( params );
    }
    return vacInfo;
  }

  @Override
  public LoginVO getVaccineDeclarationAplcntInfo( Map<String, Object> params ) {
    LOGGER.debug( "getVaccineDeclarationAplcntInfo" );
    LoginVO loginVO = loginMapper.getVaccineDeclarationAplcntInfo( params );
    return loginVO;
  }

  @Override
  public int checkNewPassword( Map<String, Object> params ) {
    return loginMapper.checkUserAndPass( params );
  }

  @Override
  public void updateLoginFailAttempt( Map<String, Object> params ) {
    loginMapper.updateLoginFailAttempt( params );
  }

  @Override
  public void resetLoginFailAttempt( int userId ) {
    loginMapper.resetLoginFailAttempt( userId );
  }

  @Override
  public int getLoginFailedMaxAttempt() {
    return loginMapper.getLoginFailedMaxAttempt();
  }

  @Override
  public EgovMap selectUserByUserName( String username ) {
    return loginMapper.selectUserByUserName( username );
  }

  @Override
  public int checkSecurityAnswer( Map<String, Object> params ) {
    return loginMapper.checkSecurityAnswer( params );
  }

  @Override
  public void updateCheckMfaFlag( Map<String, Object> params ) {
    loginMapper.updateCheckMfaFlag(params);
  }

  @Override
  public int checkResetMFAEmail( Map<String, Object> params ) {
    return loginMapper.checkResetMFAEmail( params );
  }

  @Override
  public void updateResetMFA( Map<String, Object> params ) {
    loginMapper.updateResetMFA(params);
  }

	@Override
	public boolean sendResetMFAEmail(Map<String, Object> params) {

		EmailVO email = new EmailVO();
		List<String> toList = new ArrayList<String>();
		//params

		//subject and contents
		String subject  = "";
		String content = "";
		String memCode = params.get("memCode").toString();  // Example username
		String qrCodeImageUrl = params.get("qrLink").toString(); ;

		toList.add(params.get("email").toString());

		subject = "Action Required: Reset OTP MFA for " + memCode + " eTrust Account";

		content = "<html>" +
			    "<head>" +
			    "<style>" +
			    "body { font-family: 'Arial', sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; color: #333; }" +
			    "h1, h2, h3 { color: #333; }" +
			    "a { text-decoration: none; color: #007BFF; }" +
			    "dl { margin: 0; padding: 0; }" +
			    "dt { font-weight: bold; margin-top: 15px; }" +
			    "dd { margin-bottom: 10px; }" +
			    "p { font-size: 14px; line-height: 1.6; }" +
			    ".email-container { max-width: 600px; margin: 20px auto; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1); }" +
			    ".email-header { background-color: #007BFF; color: #ffffff; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }" +
			    ".email-body { padding: 20px; }" +
			    ".button { background-color: #28a745; color: #fff; padding: 12px 25px; border-radius: 5px; text-align: center; display: inline-block; font-size: 16px; margin-top: 20px; cursor: pointer; }" +
			    ".qr-container { text-align: center; padding: 20px; background-color: #f7f7f7; border-radius: 10px; box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1); margin-top: 20px; }" +
			    ".qr-container img { max-width: 100%; height: auto; border: 3px solid #4CAF50; border-radius: 10px; box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2); }" +
			    ".footer { font-size: 12px; color: #888; text-align: center; margin-top: 30px; }" +
			    "</style>" +
			    "</head>" +
			    "<body>" +
			    "<div class='email-container'>" +
			    "<div class='email-header'>" +
			    "<h1>Action Required: Reset Your OTP MFA</h1>" +
			    "<p>For eTrust Account - " + memCode + "</p>" +
			    "</div>" +
			    "<div class='email-body'>" +
			    "<p>Dear PIC</p>" +
			    "<p>We have received your request to reset the One-Time Password (OTP) for your Multi-Factor Authentication (MFA) via Google Authenticator. To complete the reset process, kindly follow the steps outlined below:</p>" +
			    "<dl>" +
			    "<dt><strong>1. Remove the Old OTP Setup</strong></dt>" +
			    "<dd>Before proceeding, please remove the previously configured OTP from your Google Authenticator app to avoid any conflicts with the new setup.</dd>" +
			    "<dt><strong>2. Scan the New QR Code</strong></dt>" +
			    "<dd>Below is the QR code for your new OTP configuration. To set up the new OTP, open your Google Authenticator app and scan the QR code displayed below:</dd>" +
			    "</dl>" +
			    "<div class='qr-container'>" +
			    "<img src='" + qrCodeImageUrl + "' alt='QR Code for OTP'>" +
			    "<p style='font-size: 14px; color: #333;'>Scan this QR code to complete your OTP setup.</p>" +
			    "</div>" +
			    "<dl>" +
			    "<dt><strong>3. Retry Logging into Your eTrust Account</strong></dt>" +
			    "<dd>Once you have scanned the new QR code, please attempt to log in to your eTrust account again using the updated OTP generated by Google Authenticator.</dd>" +
			    "</dl>" +
			    "<p>If you experience any issues or need further assistance, please contact our support team.</p>" +
			    "<p>Thank you for your prompt attention to this matter and for ensuring the security of your account.</p>" +
			    "<a href='https://trustdesk.coway.com.my' class='button'>Contact Support</a>" +
			    "</div>" +
			    "<div class='footer'>" +
			    "<p>If you did not request this reset, please ignore this email.</p>" +
			    "<p>&copy; Copyrights 2017. Coway Malaysia Sdn. Bhd. All rights reserved.</p>" +
			    "</div>" +
			    "</div>" +
			    "</body>" +
			    "</html>";


		email.setTo(toList);
		email.setHtml(true);
		email.setSubject(subject);
		email.setText(content);

		boolean isSuccess = adaptorService.sendEmail(email, false);

		return isSuccess;
	}
}
