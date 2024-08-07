package com.coway.trust.biz.eAccounting.webInvoice.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("webInvoiceMapper")
public interface WebInvoiceMapper {

  List<EgovMap> selectWebInvoiceList(Map<String, Object> params);

  List<EgovMap> selectSupplier(Map<String, Object> params);

  List<EgovMap> selectCostCenter(Map<String, Object> params);

  List<EgovMap> selectTaxCodeWebInvoiceFlag();

  String selectNextClmNo();

  void insertWebInvoiceInfo(Map<String, Object> params);

  int selectNextClmSeq(String clmNo);

  void insertWebInvoiceDetail(Map<String, Object> params);

  EgovMap selectWebInvoiceInfo(String clmNo);

  EgovMap selectWebInvoiceInfoForAppv(String clmNo);

  List<EgovMap> selectWebInvoiceItems(String clmNo);

  List<EgovMap> selectWebInvoiceItemsForAppv(String clmNo);

  List<EgovMap> selectAttachListOfAppvPrcssNo(String appvPrcssNo);

  List<EgovMap> selectAttachList(String atchFileGrpId);

  EgovMap selectAttachmentInfo(Map<String, Object> params);

  void updateWebInvoiceInfo(Map<String, Object> params);

  void updateWebInvoiceDetail(Map<String, Object> params);

  void deleteWebInvoiceDetail(Map<String, Object> params);

  String budgetCheck(Map<String, Object> params);

  String selectNextAppvPrcssNo();

  void insertApproveManagement(Map<String, Object> params);

  void insertApproveLineDetail(Map<String, Object> params);

  int selectNextAppvItmSeq(String appvPrcssNo);

  void insertApproveItems(Map<String, Object> params);

  void updateAppvPrcssNo(Map<String, Object> params);

  List<EgovMap> selectApproveList(Map<String, Object> params);

  List<EgovMap> selectVendorApproveList(Map<String, Object> params);

  List<EgovMap> selectAppvLineInfo(Map<String, Object> params);

  List<EgovMap> selectAppvInfo(Map<String, Object> params);

  String selectRejectOfAppvPrcssNo(Map<String, Object> params);

  List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params);

  List<EgovMap> selectAdvInfoAndItems(Map<String, Object> params);

  int selectAppvLineCnt(String appvPrcssNo);

  int selectAppvLinePrcssCnt(String appvPrcssNo);

  void updateAppvInfo(Map<String, Object> params);

  void updateAppvLine(Map<String, Object> params);

  void updateLastAppvLine(Map<String, Object> params);

  String selectNextAppvIfKey();

  String selectNextAdvAppvIfKey();

  int selectNextAppvSeq(String ifKey);

  void insertAppvInterface(Map<String, Object> params);

  void insertAdvInterface(Map<String, Object> params);

  String selectNextReqstIfKey();

  int selectNextReqstSeq(String ifKey);

  void insertReqstInterface(Map<String, Object> params);

  void updateWebInvoiceInfoTotAmt(Map<String, Object> params);

  List<EgovMap> selectBudgetCodeList(Map<String, Object> params);

  List<EgovMap> selectGlCodeList(Map<String, Object> params);

  EgovMap selectTaxRate(Map<String, Object> params);

  EgovMap selectClamUn(Map<String, Object> params);

  void updateClamUn(Map<String, Object> params);

  String selectSameVender(Map<String, Object> params);

  List<EgovMap> getAppvExcelInfo(Map<String, Object> params);

  String selectHrCodeOfUserId(String userId);

  int selectAppvStus(Map<String, Object> param);

  void insertRejectM(Map<String, Object> params);

  void insertRejectD(Map<String, Object> params);

  EgovMap getDtls(Map<String, Object> params);

  void insertNotification(Map<String, Object> params);

  EgovMap getCostCenterName(Map<String, Object> params);

  EgovMap getClmDesc(Map<String, Object> params);

  EgovMap getNtfUser(Map<String, Object> params);

  EgovMap getApprGrp(Map<String, Object> params);

  EgovMap getFinalApprAct(Map<String, Object> params);

  EgovMap getFinApprover(Map<String, Object> params);

  void insMissAppr(Map<String, Object> params);

  int checkExistClmNo(String clmNo);

  List<EgovMap> selectAtchFileData(Map<String, Object> params);

  String selectFCM12Data(Map<String, Object> params);

  EgovMap selectUserDetail(Map<String, Object> params);
}
