/**
 *
 */
package com.coway.trust.biz.homecare.sales.impl;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.homecare.sales.vo.HTOrderVO;
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
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Tommy
 *
 */
@Mapper("htOrderRegisterMapper")
public interface htOrderRegisterMapper {

	String selectDocNo(int docNoId);

	String selectDocNoS(Map<String, Object> params);

	EgovMap selectSrvCntcInfo(Map<String, Object> params);

	EgovMap selectStockPrice(Map<String, Object> params);

	List<EgovMap> selectDocSubmissionList(Map<String, Object> params);

	List<EgovMap> selectPromotionByAppTypeStock(Map<String, Object> params);

	List<EgovMap> selectPromotionByAppTypeStock2(Map<String, Object> params);

	EgovMap selectProductPromotionPercentByPromoID(Map<String, Object> params);

	EgovMap selectProductPromotionPriceByPromoStockIDNew(Map<String, Object> params);

	EgovMap selectProductPromotionPriceByPromoStockIDNewCorp(Map<String, Object> params);

	EgovMap selectTrialNo(Map<String, Object> params);

	EgovMap selectMemberByMemberIDCode(Map<String, Object> paraselectVerifyOldSalesOrderNoValidityICarems);

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

	void insertSalesOrderM(HTOrderVO orderVO);

	void insertSalesOrderD(SalesOrderDVO salesOrderDVO);

	void insertInstallation(InstallationVO orderVO);

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

	List<EgovMap> selectProductComponent(Map<String, Object> params);

	EgovMap selectProductComponentDefaultKey(Map<String, Object> params);

	void insertASEntry(ASEntryVO asEntryVo);

	EgovMap selectOutstandingAmt(int salesOrdId);

	EgovMap selectOutrightPlusOutstandingAmt(int salesOrdId);

	EgovMap selectTaxInvoice(Map<String, Object> params);

	int insert_Pay0031d(Map<String, Object> param);

	int getSeqPay0031D();

	void insert_Pay0032d(Map<String, Object> param);

	void insert_Pay0016d(Map<String, Object> param);

	EgovMap getCSEntryDocNo(Map<String, Object> params);

    void insertAccSrvMemLedger(Map<String, Object> params);

    EgovMap selectMembershipPackageInfo(Map<String, Object> params);

    void updateMembershipSales(Map<String, Object> params);

    void updateSrvConfigPeriod(Map<String, Object> params);

	EgovMap selectHTCovergPostCode(Map<String, Object> params);

	void insert_Pay0007d(Map<String, Object> param5);

}
