package com.coway.trust.biz.eAccounting.pettyCash.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("pettyCashMapper")
public interface PettyCashMapper {
  
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
  
  void insertRqstApproveItems(Map<String, Object> params);
  
  void updateRqstAppvPrcssNo(Map<String, Object> params);
  
  String selectNextIfKey();
  
  int selectNextSeq(String ifKey);
  
  void insertPettyCashReqstInterface(Map<String, Object> params);
  
  List<EgovMap> selectExpenseList(Map<String, Object> params);
  
  List<EgovMap> selectTaxCodePettyCashFlag();
  
  String selectNextExpClmNo();
  
  void insertPettyCashExp(Map<String, Object> params);
  
  int selectNextExpClmSeq(String clmNo);
  
  void insertPettyCashExpItem(Map<String, Object> params);
  
  void updatePettyCashExpTotAmt(Map<String, Object> params);
  
  List<EgovMap> selectExpenseItems(String clmNo);
  
  EgovMap selectExpenseInfo(Map<String, Object> params);
  
  EgovMap selectExpenseInfoForAppv(Map<String, Object> params);
  
  List<EgovMap> selectAttachList(String atchFileGrpId);
  
  void updatePettyCashExp(Map<String, Object> params);
  
  void updatePettyCashExpItem(Map<String, Object> params);
  
  void insertExpApproveItems(Map<String, Object> params);
  
  void updateExpAppvPrcssNo(Map<String, Object> params);
  
  void deletePettyCashExpItem(Map<String, Object> params);
  
  List<EgovMap> selectExpenseItemGrp(Map<String, Object> params);
  
  List<EgovMap> selectExpenseItemGrpForAppv(Map<String, Object> params);
  
  void insertRejectM(Map<String, Object> params);
  
  void insertRejectD(Map<String, Object> params);
  
  List<EgovMap> getOldDisClamUn(Map<String, Object> params);
  
  void updateExistingClamUn(Map<String, Object> params);
  
  String checkCustodian(String memAccId);
}
