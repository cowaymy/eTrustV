package com.coway.trust.biz.eAccounting.pettyCash;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PettyCashService {
  
  List<EgovMap> selectCustodianList(Map<String, Object> params);
  
  String selectUserNric(String memAccId);
  
  void insertCustodian(Map<String, Object> params);
  
  EgovMap selectCustodianInfo(Map<String, Object> params);
  
  void updateCustodian(Map<String, Object> params);
  
  void deleteCustodian(Map<String, Object> params);
  
  List<EgovMap> selectRequestList(Map<String, Object> params);
  
  String selectNextRqstClmNo();
  
  void insertPettyCashReqst(Map<String, Object> params);
  
  EgovMap selectRequestInfo(Map<String, Object> params);
  
  void updatePettyCashReqst(Map<String, Object> params);
  
  void insertRqstApproveManagement(Map<String, Object> params);
  
  String selectNextIfKey();
  
  int selectNextSeq(String ifKey);
  
  void insertPettyCashReqstInterface(Map<String, Object> params);
  
  List<EgovMap> selectExpenseList(Map<String, Object> params);
  
  List<EgovMap> selectTaxCodePettyCashFlag();
  
  void insertPettyCashExp(Map<String, Object> params);
  
  List<EgovMap> selectExpenseItems(String clmNo);
  
  EgovMap selectExpenseInfo(Map<String, Object> params);
  
  EgovMap selectExpenseInfoForAppv(Map<String, Object> params);
  
  List<EgovMap> selectAttachList(String atchFileGrpId);
  
  void updatePettyCashExp(Map<String, Object> params);
  
  void insertExpApproveManagement(Map<String, Object> params);
  
  void deletePettyCashExpItem(Map<String, Object> params);
  
  void updatePettyCashExpTotAmt(Map<String, Object> params);
  
  List<EgovMap> selectExpenseItemGrp(Map<String, Object> params);
  
  List<EgovMap> selectExpenseItemGrpForAppv(Map<String, Object> params);
  
  String selectNextExpClmNo();
  
  void editRejected(Map<String, Object> params);
  
  String checkCustodian(String memAccId);
}
