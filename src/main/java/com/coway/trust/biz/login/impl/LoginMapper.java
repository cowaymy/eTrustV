package com.coway.trust.biz.login.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.login.LoginHistory;
import com.coway.trust.cmmn.model.LoginSubAuthVO;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("loginMapper")
public interface LoginMapper {
  LoginVO selectLoginInfo(Map<String, Object> params);

  /**
   * [WARNNING] : use only callcenter ........
   *
   * @param params
   * @return
   */
  LoginVO selectLoginInfoById(Map<String, Object> params);

  List<LoginSubAuthVO> selectSubAuthInfo(Map<String, Object> params);

  LoginVO selectFindUserIdPop(Map<String, Object> params);

  int updatePassWord(Map<String, Object> params);

  int updateUserSetting(Map<String, Object> params);

  void insertLoginHistory(LoginHistory loginHistory);

  List<EgovMap> selectLanguages();

  List<EgovMap> selectSecureResnList(Map<String, Object> params);

  EgovMap selectUserByUserName(String userName);

  EgovMap selectOrgUserByUserName(String userName);

  EgovMap checkByPass(Map<String, Object> params);

  LoginVO getAplcntInfo(Map<String, Object> params);

  EgovMap getDtls(Map<String, Object> params);

  EgovMap getPopDtls(Map<String, Object> params);

  EgovMap getCowayNoticePopDtls(Map<String, Object> params);

  int checkNotice();

  int checkMobileNumber(Map<String, Object> params);

  EgovMap getConfig(Map<String, Object> params);

  int getSmsReqCnt(Map<String, Object> params);

  int getReqId();

  void logRequest(Map<String, Object> params);

  void updateSYS47M_req(Map<String, Object> params);

  void updateRequest(Map<String, Object> params);

  int checkConsent();

  EgovMap getConsentDtls(Map<String, Object> params);

  int loginPopAccept(Map<String, Object> params);

  int selectNextFileId();

  void insertFileDetail(Map<String, Object> flInfo);

  int insertVacInfo(Map<String, Object> params);

  EgovMap getVaccineInfo(Map<String, Object> params);

  LoginVO getVaccineDeclarationAplcntInfo(Map<String, Object> params);

  // Added for blocking login access after N times of failed attempt
  int checkUserAndPass(Map<String, Object> params);

  void updateLoginFailAttempt(Map<String, Object> params);

  void resetLoginFailAttempt(int userId);

  int getLoginFailedMaxAttempt();

  int checkSecurityAnswer(Map<String, Object> params);

  void updateCheckMfaFlag(Map<String, Object> params);

  int checkResetMFAEmail(Map<String, Object> params);

  void updateResetMFA(Map<String, Object> params);

}
