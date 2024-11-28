package com.coway.trust.biz.login;

import java.security.NoSuchAlgorithmException;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface LoginService {
  LoginVO getLoginInfo( Map<String, Object> params );

  LoginVO selectFindUserIdPop( Map<String, Object> params );

  void logout( Map<String, Object> params );

  LoginVO loginByMobile( Map<String, Object> params );

  LoginVO loginByCallcenter( Map<String, Object> params );

  void logoutByMobile( Map<String, Object> params );

  List<EgovMap> getLanguages();

  int updatePassWord( Map<String, Object> params, Integer crtUserId );

  int updateUserSetting( Map<String, Object> params, Integer crtUserId );

  void saveLoginHistory( LoginHistory loginHistory );

  List<EgovMap> selectSecureResnList( Map<String, Object> params );

  EgovMap checkByPass( Map<String, Object> params );

  LoginVO getAplcntInfo( Map<String, Object> params );

  EgovMap getDtls( Map<String, Object> params );

  EgovMap getPopDtls( Map<String, Object> params );

  EgovMap getCowayNoticePopDtls( Map<String, Object> params );

  int checkNotice();

  //	int passwordRequest(Map<String, Object> params);
  Map<String, Object> tempPwProcess( Map<String, Object> params );

  int checkConsent();

  EgovMap getConsentDtls( Map<String, Object> params );

  int loginPopAccept( Map<String, Object> params );

  public void insertAttachDoc( List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs );

  public int insertVaccineInfo( Map<String, Object> params, int userId, String memId );

  public EgovMap getVaccineInfo( String memId );

  LoginVO getVaccineDeclarationAplcntInfo( Map<String, Object> params );

  public int checkNewPassword( Map<String, Object> params );

  public void updateLoginFailAttempt( Map<String, Object> params );

  public void resetLoginFailAttempt( int userId );

  public int getLoginFailedMaxAttempt();

  public EgovMap selectUserByUserName( String username );

  public int checkSecurityAnswer( Map<String, Object> params );

  public void updateCheckMfaFlag( Map<String, Object> params );

  public int checkResetMFAEmail( Map<String, Object> params );

  public void updateResetMFA( Map<String, Object> params );

  boolean sendResetMFAEmail(Map<String, Object> params);


}
