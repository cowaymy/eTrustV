package com.coway.trust.biz.services.installation;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE PIC VERSION COMMENT -------------------------------------------------------------------------------------------- 31/01/2019 ONGHC 1.0.1 - Restructure File 06/03/2019 ONGHC 1.0.2 - Create getSalStat 29/04/2019 ONGHC 1.0.3 - Create chkExgRsnCde
 *
 *********************************************************************************************/

public interface InstallationResultListService {

  List<EgovMap> selectInstallationType();

  List<EgovMap> selectApplicationType();

  List<EgovMap> selectInstallStatus();

  List<EgovMap> adapterUsed();

  List<EgovMap> boosterUsed();

  List<EgovMap> instChkLst();

  List<EgovMap> failParent();

  List<EgovMap> selectDscCode();

  List<EgovMap> installationResultList(Map<String, Object> params);

  EgovMap getInstallResultByInstallEntryID(Map<String, Object> params);

  EgovMap getFileID(Map<String, Object> params); ///FileXXX

  EgovMap getOrderInfo(Map<String, Object> params);

  // EgovMap getcustomerInfo(Object cust_id);

  EgovMap getcustomerInfo(Map<String, Object> params);

  EgovMap getCustomerAddressInfo(Map<String, Object> params);

  EgovMap getCustomerContractInfo(Map<String, Object> params);

  EgovMap getInstallationBySalesOrderID(Map<String, Object> params);

  EgovMap getInstallContactByContactID(Map<String, Object> params);

  EgovMap getSalesOrderMBySalesOrderID(Map<String, Object> params);

  EgovMap getMemberFullDetailsByMemberIDCode(Map<String, Object> params);

  List<EgovMap> selectViewInstallation(Map<String, Object> params);

  EgovMap selectCallType(Map<String, Object> params);

  EgovMap getOrderExchangeTypeByInstallEntryID(Map<String, Object> params);

  List<EgovMap> selectFailReason(Map<String, Object> params);

  EgovMap getStockInCTIDByInstallEntryIDForInstallationView(Map<String, Object> params);

  EgovMap getSirimLocByInstallEntryID(Map<String, Object> params);

  List<EgovMap> checkCurrentPromoIsSwapPromoIDByPromoID(int promotionId);

  List<EgovMap> selectSalesPromoMs(int promotionId);

  // EgovMap getPromoPriceAndPV(int promotionId, int productId);

  EgovMap getAssignPromoIDByCurrentPromoIDAndProductID(int promotionId, int productId, boolean flag);

  EgovMap selectViewDetail(Map<String, Object> params);

  boolean insertInstallationProductExchange(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

  Map<String, Object> insertInstallationResult(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

  Map<String, Object> insertInstallationResult_2(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

  Map<String, Object> runInstSp(Map<String, Object> params, SessionVO sessionVO, String no) throws ParseException;

  Map<String, Object> updateAssignCT(Map<String, Object> params);

  List<EgovMap> assignCtOrderList(Map<String, Object> params);

  List<EgovMap> assignCtList(Map<String, Object> params);

  List<EgovMap> selectInstallationNoteListing(Map<String, Object> params) throws ParseException;

  EgovMap selectInstallInfo(Map<String, Object> params);

  int editInstallationResult(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

  int updateInstallFileKey(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

  int failInstallationResult(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

  int isInstallAlreadyResult(Map<String, Object> params);

  int insResultSync(Map<String, Object> params);

  EgovMap validationInstallationResult(Map<String, Object> params);

  EgovMap getLocInfo(Map<String, Object> params);

  EgovMap getInstallationResultInfo(Map<String, Object> params);

  List<EgovMap> viewInstallationResult(Map<String, Object> params);

  EgovMap checkMonthInstallDate(Map<String, Object> params);

  List<EgovMap> getProductList(Map<String, Object> params);

  List<EgovMap> getProductList2(Map<String, Object> params);

  int chkRcdTms(Map<String, Object> params);

  int selRcdTms(Map<String, Object> params);

  String getSalStat(Map<String, Object> params);

  int chkExgRsnCde(Map<String, Object> params);

  List<EgovMap> selectCtSerialNoList(Map<String, Object> params);

  List<EgovMap> selectFailChild(Map<String, Object> params);

  ReturnMessage insertInstallationResultSerial(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

  int editInstallationResultSerial(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

  Map<String, Object> updateAssignCTSerial(Map<String, Object> params);

  List<EgovMap> waterEnvironmentList(Map<String, Object> params);

  List<EgovMap> getProductListwithCategory(Map<String, Object> params);

  EgovMap saveInsAsEntry(List<Map<String, Object>> add, Map<String, Object> params, EgovMap installResult, int userId);

  List<EgovMap> selectFilterSparePartList(Map<String, Object> params);

  EgovMap selectStkCatType (Map<String, Object> params);

  void sendSms(Map<String, Object> smsList);

  //void sendEmail();

  Map<String, Object> installationSendSMS(String ApptypeID, Map<String, Object> installResult);

  List<EgovMap> selectWaterSrcType();

  List<EgovMap> getInstallDtPairByCtCode(Map<String, Object> params);

  ReturnMessage installationSendEmail(Map<String, Object> params);

  void insertInstallationAccessories(List<String> installAccList , EgovMap installResult, int userId);

  List<EgovMap> selectInstallAccWithInstallEntryId(Map<String, Object> params);

  List<EgovMap> selectCompetitorBrand();

}
