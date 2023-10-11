package com.coway.trust.biz.eAccounting.webInvoice;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface WebInvoiceService {

  List<EgovMap> selectWebInvoiceList(Map<String, Object> params);

  List<EgovMap> selectSupplier(Map<String, Object> params);

  List<EgovMap> selectCostCenter(Map<String, Object> params);

  List<EgovMap> selectTaxCodeWebInvoiceFlag();

  String selectNextClmNo();

  void insertWebInvoiceInfo(Map<String, Object> params);

  EgovMap selectWebInvoiceInfo(String clmNo);

  EgovMap selectWebInvoiceInfoForAppv(String clmNo);

  List<EgovMap> selectWebInvoiceItems(String clmNo);

  List<EgovMap> selectWebInvoiceItemsForAppv(String clmNo);

  List<EgovMap> selectAttachListOfAppvPrcssNo(String appvPrcssNo);

  List<EgovMap> selectAttachList(String atchFileGrpId);

  EgovMap selectAttachmentInfo(Map<String, Object> params);

  void updateWebInvoiceInfo(Map<String, Object> params);

  List<Object> budgetCheck(Map<String, Object> params);

  String selectNextAppvPrcssNo();

  void insertApproveManagement(Map<String, Object> params);

  List<EgovMap> selectApproveList(Map<String, Object> params);

  List<EgovMap> selectVendorApproveList(Map<String, Object> params);

  List<EgovMap> selectAppvLineInfo(Map<String, Object> params);

  List<EgovMap> selectAppvInfo(Map<String, Object> params);

  String selectRejectOfAppvPrcssNo(Map<String, Object> params);

  List<EgovMap> selectAppvInfoAndItems(Map<String, Object> params);

  String getAppvPrcssStus(List<EgovMap> appvLineInfo, List<EgovMap> appvInfoAndItems);

  void updateApprovalInfo(Map<String, Object> params);

  void updateRejectionInfo(Map<String, Object> params);

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

  void editRejected(Map<String, Object> params);

  EgovMap getDtls(Map<String, Object> params);

  EgovMap getCostCenterName(Map<String, Object> params);

  EgovMap getApprGrp(Map<String, Object> params);

  EgovMap getFinalApprAct(Map<String, Object> params);

  EgovMap getFinApprover(Map<String, Object> params);

  String selectNextAppvIfKey();

  int checkExistClmNo(String clmNo);

  List<EgovMap> selectAtchFileData(Map<String, Object> params);

  String selectFCM12Data(Map<String, Object> params);
}
