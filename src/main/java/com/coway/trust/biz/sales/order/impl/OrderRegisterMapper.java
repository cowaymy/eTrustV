/**
 *
 */
package com.coway.trust.biz.sales.order.impl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.ASEntryVO;
import com.coway.trust.biz.sales.order.vo.AccClaimAdtVO;
import com.coway.trust.biz.sales.order.vo.CallEntryVO;
import com.coway.trust.biz.sales.order.vo.CallResultVO;
import com.coway.trust.biz.sales.order.vo.CcpDecisionMVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterVO;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.EStatementReqVO;
import com.coway.trust.biz.sales.order.vo.GSTEURCertificateVO;
import com.coway.trust.biz.sales.order.vo.InstallEntryVO;
import com.coway.trust.biz.sales.order.vo.InstallResultVO;
import com.coway.trust.biz.sales.order.vo.InstallationVO;
import com.coway.trust.biz.sales.order.vo.RentPaySetVO;
import com.coway.trust.biz.sales.order.vo.RentalSchemeVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderContractVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderDVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderLogVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigFilterVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigPeriodVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigSettingVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigurationVO;
import com.coway.trust.biz.sales.order.vo.SrvMembershipSalesVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */

/******************************************************************
 * DATE              PIC            VERSION        COMMENT
 *--------------------------------------------------------------------------------------------
 * 23/04/2020    ONGHC          1.0.1           - Add insertPexDefectEntry
 ******************************************************************/

@Mapper("orderRegisterMapper")
public interface OrderRegisterMapper {

  String selectDocNo(int docNoId);

  String selectDocNoS(Map<String, Object> params);

  EgovMap selectSrvCntcInfo(Map<String, Object> params);

  EgovMap selectStockPrice(Map<String, Object> params);

  List<EgovMap> selectDocSubmissionList(Map<String, Object> params);

  List<EgovMap> selectPromotionByAppTypeStock(Map<String, Object> params);

  List<EgovMap> selectPromotionByAppTypeStock2(Map<String, Object> params);

  List<EgovMap> selectPromotionByAppTypeStockESales(Map<String, Object> params);

  EgovMap selectProductPromotionPriceByPromoStockID(Map<String, Object> params);

  EgovMap selectProductPromotionPriceByPromoStockIDNew(Map<String, Object> params);

  EgovMap selectProductPromotionPriceByPromoAnoStockIDNew(Map<String, Object> params);

  EgovMap selectProductPromotionPriceByPromoStockIDNewCorp(Map<String, Object> params);

  EgovMap selectTrialNo(Map<String, Object> params);

  EgovMap selectMemberByMemberIDCode(Map<String, Object> paraselectVerifyOldSalesOrderNoValidityICarems);

  EgovMap checkRC(Map<String, Object> params);

  List<EgovMap> selectMemberList(Map<String, Object> params);

  EgovMap selectBankById(Map<String, Object> params);

  List<EgovMap> selectBOMList(Map<String, Object> params);

  EgovMap selectOldOrderId(String salesOrdNo);

  EgovMap selectSvcExpire(int srvSoId);

  EgovMap selectVerifyOldSalesOrderNoValidity(int salesOrdIdOld);

  EgovMap selectVerifyOldSalesOrderNoValidityICare(int salesOrdIdOld);

  EgovMap selectSalesOrderM(Map<String, Object> params);

  EgovMap selectSalesOrderRentalScheme(Map<String, Object> params);

  EgovMap selectAccRentLedgers(int salesOrdId);

  EgovMap selectRentalInstNo(int salesOrdId);

  BigDecimal selectRentAmt(int salesOrdId);

  EgovMap selectPromoDesc(int promoId);

  void insertSalesOrderM(SalesOrderMVO salesOrderMVO);

  void insertSalesOrderD(SalesOrderDVO salesOrderDVO);

  void insertInstallation(InstallationVO installationVO);

  void insertRentPaySet(RentPaySetVO rentPaySetVO);

  void insertCustBillMaster(CustBillMasterVO custBillMasterVO);

  void insertEStatementReq(EStatementReqVO eStatementReqVO);

  void insertAccClaimAdt(AccClaimAdtVO accClaimAdtVO);

  void insertRentalScheme(RentalSchemeVO rentalSchemeVO);

  void insertCcpDecisionM(CcpDecisionMVO ccpDecisionMVO);

  void updatePreccpScore(CcpDecisionMVO ccpDecisionMVO);

  void insertDocSubmission(DocSubmissionVO docSubmissionVO);

  void insertSrvMembershipSales(SrvMembershipSalesVO srvMembershipSalesVO);

  void insertSrvConfiguration(SrvConfigurationVO srvConfigurationVO);

  void insertSrvConfigSetting(SrvConfigSettingVO srvConfigSettingVO);

  void insertSrvConfigPeriod(SrvConfigPeriodVO srvConfigPeriodVO);

  void insertSrvConfigFilter(SrvConfigFilterVO srvConfigFilterVO);

  void insertCallEntry(CallEntryVO callEntryVO);

  void insertCallResult(CallResultVO callResultVO);

  void insertInstallEntry(InstallEntryVO installEntryVO);

  void insertInstallResult(InstallResultVO installResultVO);

  void insertSalesOrderLog(SalesOrderLogVO salesOrderLogVO);

  void insertGSTEURCertificate(GSTEURCertificateVO gstEURCertificateVO);

  void insertSalesOrderContract(SalesOrderContractVO salesOrderContractVO);

  void updateCustBillId(SalesOrderMVO salesOrderMVO);

  EgovMap selectLoginInfo(Map<String, Object> params);

  EgovMap selectCheckAccessRight(Map<String, Object> params);

  List<EgovMap> selectProductCodeList(Map<String, Object> params);

  List<EgovMap> selectServicePackageList(Map<String, Object> params);

  List<EgovMap> selectServicePackageList2(Map<String, Object> params);

  EgovMap selectServiceContractPackage(Map<String, Object> params);

  List<EgovMap> selectPrevOrderNoList(Map<String, Object> params);

  List<EgovMap> selectProductComponent(Map<String, Object> params);

  List<EgovMap> selectPromoBsdCpnt(Map<String, Object> params);

  List<EgovMap> selectPromoBsdCpntESales(Map<String, Object> params);

  EgovMap selectProductComponentDefaultKey(Map<String, Object> params);

  void insertASEntry(ASEntryVO asEntryVo);

  EgovMap selectOutstandingAmt(int salesOrdId);

  EgovMap selectOutrightPlusOutstandingAmt(int salesOrdId);

  int chkCrtAS(SalesOrderDVO salesOrderDVO);

  EgovMap selectEKeyinSofCheck(Map<String, Object> params);

  List<EgovMap> mailAddrViewHistoryAjax(Map<String, Object> params);

  List<EgovMap> instAddrViewHistoryAjax(Map<String, Object> params);

  int chkPromoCboCan(Map<String, Object> params);

  int chkPromoCboMst(Map<String, Object> params);

  int chkPromoCboSub(Map<String, Object> params);

  int chkCanMapCnt(Map<String, Object> params);

  int chkCboBindOrdNo(Map<String, Object> params);

  List<EgovMap> selectComboOrderJsonList(Map<String, Object> params);

  List<EgovMap> selectComboOrderJsonList_2(Map<String, Object> params);

  String chkPromoCboByOrd(Map<String, Object> params);

  int chkOrdLink(Map<String, Object> params);

  EgovMap getOrdInfo(Map<String, Object> params);

  public int insert_SAL0225D(SalesOrderMVO salesOrderMVO);

  public EgovMap getCtgryId(int ordId);

  public EgovMap getCtgryCode(int ordId);

  List<EgovMap> selectPrevMatOrderNoList(Map<String, Object> params);

  String selectPrevMatOrderAppTypeId(Map<String, Object> params);

  void insertPexDefectEntry(Map<String, Object> params);

  int updateMarketingMessageStatus(Map<String, Object> params);

  EgovMap selectShiIndexInfo(String custNric);

  EgovMap getExTradeConfig();

  EgovMap getRentalPeriod(int salesOrdIdOld);

  void insert_SAL0349D(Map<String, Object> params);

  int chkCanExtradeWoutPR(int ordId);
 //int chkIsAcMainOrd(String salesOrdId);

  Map<String, Object> automatedCcpProcess(Map<String, Object> params);

  EgovMap checkPreCcp(Map<String, Object> params);

  void insertSalesSpecialPromotion(Map<String, Object> params);

  EgovMap selectPreBookSalesPerson(Map<String, Object> params);

  EgovMap selectPreBookConfigurationPerson(Map<String, Object> params);

  EgovMap rentalExtradeEligibility(Map<String, Object> params);
  EgovMap getPromotionInfoExtradeAppType(Map<String, Object> params);

  BigDecimal selectOutrightAmt(int salesOrdId);

  BigDecimal selectASAmt(int salesOrdId);
}
