/**
 *
 */
package com.coway.trust.biz.sales.order.impl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

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
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Mapper("orderRegisterMapper")
public interface OrderRegisterMapper {

	String selectDocNo(int docNoId);

	String selectDocNoS(Map<String, Object> params);

	EgovMap selectSrvCntcInfo(Map<String, Object> params);

	EgovMap selectStockPrice(Map<String, Object> params);

	List<EgovMap> selectDocSubmissionList(Map<String, Object> params);

	List<EgovMap> selectPromotionByAppTypeStock(Map<String, Object> params);

	List<EgovMap> selectPromotionByAppTypeStock2(Map<String, Object> params);

	EgovMap selectProductPromotionPriceByPromoStockID(Map<String, Object> params);

	EgovMap selectProductPromotionPriceByPromoStockIDNew(Map<String, Object> params);

	EgovMap selectTrialNo(Map<String, Object> params);

	EgovMap selectMemberByMemberIDCode(Map<String, Object> params);

	List<EgovMap> selectMemberList(Map<String, Object> params);

	EgovMap selectBankById(Map<String, Object> params);

	List<EgovMap> selectBOMList(Map<String, Object> params);

	EgovMap selectOldOrderId(String salesOrdNo);

	EgovMap selectSvcExpire(int srvSoId);

	EgovMap selectVerifyOldSalesOrderNoValidity(int salesOrdIdOld);

	EgovMap selectSalesOrderM(Map<String, Object> params);

	EgovMap selectSalesOrderRentalScheme(int salesOrdId);

	EgovMap selectAccRentLedgers(int salesOrdId);

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

}
