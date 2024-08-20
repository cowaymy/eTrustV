package com.coway.trust.biz.services.installation.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 31/01/2019    ONGHC      1.0.1       - Restructure File
 * 06/03/2019    ONGHC      1.0.2       - Create getSalStat
 * 18/03/2019    ONGHC      1.0.3       - Create getINSNo
 * 27/03/2019    ONGHC      1.0.4       - Create insertExchangeResult and updateExchangeEntry_2
 * 29/04/2019    ONGHC      1.0.5       - Create chkExgRsnCde
 * 18/07/2019    ONGHC      1.0.6       - Create updateExchangeEntryCt
 * 01/07/2020    ONGHC      1.0.7       - Create checkRcdTms, updRcdTms, insertTransLog
 *
 *********************************************************************************************/

@Mapper("installationResultListMapper")
public interface InstallationResultListMapper {
  List<EgovMap> selectInstallationType();

  List<EgovMap> selectApplicationType();

  List<EgovMap> selectInstallStatus();

  /* KV- DSC Code */
  List<EgovMap> selectDscCode();

  List<EgovMap> installationResultList(Map<String, Object> params);

  List<EgovMap> installationResultList2(Map<String, Object> params);

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

  EgovMap getPromoPriceAndPV(Map<String, Object> params);

  EgovMap selectInstallation(Map<String, Object> params);

  EgovMap selectAssignCt(Map<String, Object> params);

  EgovMap selectDoComplete(Map<String, Object> params);

  EgovMap selectExchangeInfo(Map<String, Object> params);

  EgovMap selectBasicInfo(Map<String, Object> params);

  EgovMap selectinstallationInfo(Map<String, Object> params);

  EgovMap selectProgressInfo(Map<String, Object> params);

  EgovMap selectMailingInfo(Map<String, Object> params);

  EgovMap selectEntry(Map<String, Object> params);

  EgovMap selectEntry_2(Map<String, Object> params);

  EgovMap selectExchange(Map<String, Object> params);

  EgovMap selectSalesOrderM(Map<String, Object> params);

  void insertInstallResult(Map<String, Object> params);

  void insertExchangeResult(Map<String, Object> params);

  String selectMaxId(Map<String, Object> params);

  String selectMaxId_2(Map<String, Object> params);

  void updateInstallEntry(Map<String, Object> params);

  void updatePEXTestResultStatus(Map<String, Object> params);

  void updateInstallEntry_2(Map<String, Object> params);

  void updateExchangeEntry_2(Map<String, Object> params);

  void updateExchangeEntryCt(Map<String, Object> params);

  void insertSirim(Map<String, Object> params);

  EgovMap selectPac(Map<String, Object> params);

  void insertMemberShip(Map<String, Object> params);

  EgovMap selectList(Map<String, Object> params);

  List<EgovMap> selectOutRightPreBill(Map<String, Object> params);

  List<EgovMap> selectZRLocation(Map<String, Object> params);

  List<EgovMap> selectRSCertificateID(Map<String, Object> params);

  void insertAccOrderBill(Map<String, Object> params);

  void updateBillRem(Map<String, Object> params);

  void insertTaxInvocieOutright(Map<String, Object> params);

  void insertTaxInvocieOutrightD(Map<String, Object> params);

  void insertTradeLedger(Map<String, Object> params);

  void insertConfig(Map<String, Object> params);

  void insertConfigSet(Map<String, Object> params);

  void insertConfigPeriod(Map<String, Object> params);

  List<EgovMap> selectFilter(Map<String, Object> params);

  void insertConfigFilter(Map<String, Object> params);

  EgovMap selectSalesDet(Map<String, Object> params);

  void updateSalesDet(Map<String, Object> params);

  void updateSalesOrderM(Map<String, Object> params);

  void updateExchange(Map<String, Object> params);

  void insertHappyCall(Map<String, Object> params);

  EgovMap selectMobWh(Map<String, Object> params);

  void insertRecordCard(Map<String, Object> params);

  void insertOrderLog(Map<String, Object> params);

  void insertCallEntry(Map<String, Object> params);

  void insertCallResult(Map<String, Object> params);

  Map getTradeAmount(Map<String, Object> params);

  void updateCallEntry(Map<String, Object> params);

  void insertTaxInvoiceCompany(Map<String, Object> params);

  void insertAccTradeLedger(Map<String, Object> params);

  void insertAccorderBill(Map<String, Object> params);

  void updateSalesOrderMStatus(Map<String, Object> params);

  void insertTaxInvoiceCompanySub(Map<String, Object> params);

  void insertTaxInvoiceOutright(Map<String, Object> params);

  void insertTaxInvoiceOutrightSub(Map<String, Object> params);

  EgovMap selectDO(Map<String, Object> params);

  void insertMovement(Map<String, Object> params);

  void updateSalesOrderExchange(Map<String, Object> params);

  int updateAssignCT(Map<String, Object> params);

  List<EgovMap> assignCtOrderList(Map<String, Object> params);

  List<EgovMap> assignCtList(Map<String, Object> params);

  List<EgovMap> selectInstallationNoteListing(Map<String, Object> params);

  String getInvoiceNum(Map<String, Object> params);

  String getSalStat(Map<String, Object> params);

  int chkExgRsnCde(Map<String, Object> params);

  EgovMap selectInstallInfo(Map<String, Object> params);

  int updateInstallResultEdit(Map<String, Object> params);

  int updateInstallFileKey(Map<String, Object> params);

  int updateInstallResultFail(Map<String, Object> params);

  String getPAY0033D_SEQ(Map<String, Object> params);

  EgovMap getOutrightPreBill(Map<String, Object> params);

  EgovMap getOrderByInstallEntryID(Map<String, Object> params);

  // add by hgham mobile 중복 처리
  int isInstallAlreadyResult(Map<String, Object> params);

  EgovMap validationInstallationResult(Map<String, Object> params);

  // add by jgkim
  EgovMap getUsePAY0033D_addr(Map<String, Object> params);

  EgovMap getUsePAY0034D_addr(Map<String, Object> params);

  EgovMap getLocInfo(Map<String, Object> params);

  // get bill custname info
  EgovMap getCustInfo(Map<String, Object> params);

  // get bill address info
  EgovMap getMAddressInfo(Map<String, Object> params);

  EgovMap getInstallationResultInfo(Map<String, Object> params);

  List<EgovMap> viewInstallationResult(Map<String, Object> params);

  void updateInstallEntryEdit(Map<String, Object> params);

  void updateRentalStatus(Map<String, Object> params);

  void updateSal0004d(Map<String, Object> orderLog);

  void updateSal0004d_2(Map<String, Object> orderLog);

  void updateLog0038d_2(Map<String, Object> orderLog);

  EgovMap checkOrderID (Object object);

  EgovMap checkExchangeCollLog(Map<String, Object> orderLog);

  EgovMap checkExchangeCollLog_2(Map<String, Object> orderLog);

  EgovMap getCheckMonthInstallDt(Map<String, Object> params);

  String selectPrevAssignCt(Map<String, Object> updateMap);

  int insResultSync(Map<String, Object> params);



  List<EgovMap> getProductList(Map<String, Object> params);

  List<EgovMap> getProductList2(Map<String, Object> params);

  EgovMap getExchangeInfo(Map<String, Object> params);

  int updateOrderInfoExchgM(Map<String, Object> params);

  int updateOrderInfoExchgS(Map<String, Object> params);

  int chkRcdTms(Map<String, Object> params);

  int selRcdTms(Map<String, Object> params);

  String getINSNo(Map<String, Object> params);

  List<EgovMap> selectCtSerialNoList(Map<String, Object> params);

  String selectDelvryGrCmpltYn(Map<String, Object> params);

  void insertSVC0113D(Map<String, Object> params);

  int checkRcdTms(Map<String, Object> params);

  void updRcdTms(Map<String, Object> params);

  void insertTransLog(Map<String, Object> params);

  List<EgovMap> adapterUsed();

 List<EgovMap> boosterUsed();

  List<EgovMap> viewChkLst();

  List<EgovMap> failParent();

  List<EgovMap> instChkLst();

  List<EgovMap> selectFailChild(Map<String, Object> params);

  List<EgovMap> waterEnvironmentList(Map<String, Object> params);

  List<EgovMap> getProductListwithCategory(Map<String, Object> params);

  List<EgovMap> selectFilterSparePartList(Map<String, Object> params);

  void insertFilterChargeOut (Map<String, Object> params);

  EgovMap selectUserByMemId (Map<String, Object> params);

 List<EgovMap> selectWaterSrcType();

 List<EgovMap> getInstallDtPairByCtCode(Map<String, Object> params);

 void updateEmailSentCount(Map<String, Object> params);

 void insertInstallationAccessories(Map<String, Object> params);

 List<EgovMap> selectInstallAccWithInstallEntryId(Map<String, Object> params);

 void disbleInstallAccWithInstallEntryId(Map<String, Object> params);

 List<EgovMap> selectCompetitorBrand();

}
