/**
 *
 */
package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.AccOrderBillVO;
import com.coway.trust.biz.sales.order.vo.AccTaxInvoiceOutrightVO;
import com.coway.trust.biz.sales.order.vo.AccTaxInvoiceOutright_SubVO;
import com.coway.trust.biz.sales.order.vo.AccTradeLedgerVO;
import com.coway.trust.biz.sales.order.vo.CallEntryVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterHistoryVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterVO;
import com.coway.trust.biz.sales.order.vo.DiscountEntryVO;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.GSTEURCertificateVO;
import com.coway.trust.biz.sales.order.vo.InstallationVO;
import com.coway.trust.biz.sales.order.vo.InvStkMovementVO;
import com.coway.trust.biz.sales.order.vo.ReferralVO;
import com.coway.trust.biz.sales.order.vo.RentPaySetVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderDVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvConfigVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvFilterVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvPeriodVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeBUSrvSettingVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderExchangeVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderSchemeConversionVO;
import com.coway.trust.biz.sales.order.vo.SalesReqCancelVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigFilterVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigPeriodVO;
import com.coway.trust.biz.sales.order.vo.SrvMembershipSalesVO;
import com.coway.trust.biz.sales.order.vo.StkReturnEntryVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Mapper("orderRequestMapper")
public interface OrderRequestMapper {

	List<EgovMap> selectResnCodeList(Map<String, Object> params);

	EgovMap selectOrderLastRentalBillLedger1(Map<String, Object> params);

	void insertSalesReqCancel(SalesReqCancelVO salesReqCancelVO);

	EgovMap selectSalesOrderD(Map<String, Object> params);

	EgovMap selectInstallEntry(Map<String, Object> params);

	EgovMap selectCallEntry(Map<String, Object> params);

	EgovMap selectCallEntryByEntryId(Map<String, Object> params);

	void updateCallEntry(CallEntryVO callEntryVO);

	void updateCallEntry2(Map<String, Object> params);

	void updateRentalScheme(Map<String, Object> params);

	EgovMap selectCompleteASIDByOrderIDSolutionReason(Map<String, Object> params);

	void insertSalesOrderExchange(SalesOrderExchangeVO salesOrderExchangeVO);

	void updateSalesOrderExchangeNwCall(SalesOrderExchangeVO salesOrderExchangeVO);

	void updateSoExchgStkRetMovId(SalesOrderExchangeVO salesOrderExchangeVO);

	void updateSalesOrderM(SalesOrderMVO salesOrderMVO);

	void updateSalesOrderMSchem(SalesOrderMVO salesOrderMVO);

	void updateSalesOrderMOtran(SalesOrderMVO salesOrderMVO);

	void updateSalesOrderD(SalesOrderDVO salesOrderDVO);

	void updateSalesOrderDAexc(SalesOrderDVO salesOrderDVO);

	EgovMap selecLastInstall(Map<String, Object> params);

	EgovMap selectSrvConfiguration(Map<String, Object> params);

	EgovMap selectSrvConfiguration2(Map<String, Object> params);

	void insertInvStkMovement(InvStkMovementVO invStkMovementVO);

	void insertStkReturnEntry(StkReturnEntryVO stkReturnEntryVO);

	List<EgovMap> selectSrvConfigPeriod(Map<String, Object> params);

	List<EgovMap> selectSrvConfigSetting(Map<String, Object> params);

	List<EgovMap> selectSrvConfigFilter(Map<String, Object> params);

	List<EgovMap> selectSrvConfigFilterList(Map<String, Object> params);

	void insertSalesOrderExchangeBUSrvConfig(SalesOrderExchangeBUSrvConfigVO salesOrderExchangeBUSrvConfigVO);

	void insertSalesOrderExchangeBUSrvPeriod(SalesOrderExchangeBUSrvPeriodVO salesOrderExchangeBUSrvPeriodVO);

	void insertSalesOrderExchangeBUSrvSetting(SalesOrderExchangeBUSrvSettingVO salesOrderExchangeBUSrvSettingVO);

	void insertSalesOrderExchangeBUSrvFilter(SalesOrderExchangeBUSrvFilterVO salesOrderExchangeBUSrvFilterVO);

	List<EgovMap> selectSalesOrderSchemeList(Map<String, Object> params);

	EgovMap selectSchemePriceSettingByPromoCode(Map<String, Object> params);

	List<EgovMap> selectSchemePartSettingBySchemeIDList(Map<String, Object> params);

	EgovMap selectRentalInstStartMonth(Map<String, Object> params);

	List<EgovMap> selectSrvMembershipSaleList(Map<String, Object> params);

//	List<SrvMembershipSalesVO> selectSrvMembershipSaleList(Map<String, Object> params);

	List<EgovMap> selectServiceConfigPeriodEffectiveList(Map<String, Object> params);

	void insertSalesOrderSchemeConversion(SalesOrderSchemeConversionVO salesOrderSchemeConversionVO);

	void updateSrvMembershipSales(Map<String, Object> params);

	void updateSrvMembershipSalesAexc(SrvMembershipSalesVO srvMembershipSalesVO);

	void updateSrvMembershipSalesAexc2(Map<String, Object> params);

	void updateSrvConfigPeriod(Map<String, Object> params);

	void updateSrvConfigPeriodAexc(SrvConfigPeriodVO srvConfigPeriodVO);

	void updateDiscountEntryStatus(Map<String, Object> params);

	void insertDiscountEntry(DiscountEntryVO discountEntryVO);

	void updateSrvConfigFilter(Map<String, Object> params);

	void insertSrvConfigFilter(Map<String, Object> params);

	EgovMap selectOrderSimulatorViewByOrderNo(Map<String, Object> params);

	EgovMap selectRentalInst(Map<String, Object> params);

	EgovMap selectRentalInst2(Map<String, Object> params);

	EgovMap selectInstallResult(Map<String, Object> params);

	EgovMap selectPromoD(Map<String, Object> params);

	EgovMap selectAccRentLedger(Map<String, Object> params);

	EgovMap selectAccRentLedger2(Map<String, Object> params);

	EgovMap selectAccRentLedger3(Map<String, Object> params);

	EgovMap selectTotalDNBill(Map<String, Object> params);

	EgovMap selectTotalDNBill2(Map<String, Object> params);

	EgovMap selectTotalCNBill(Map<String, Object> params);

	EgovMap selectTotalCNBill2(Map<String, Object> params);

	EgovMap selectLastBill(Map<String, Object> params);

	List<EgovMap> selectInstallResultsBySalesOrderID(Map<String, Object> params);

	void updateSalesOrderMAexc(SalesOrderMVO salesOrderMVO);

	void insertSrvMembershipSales(SrvMembershipSalesVO srvMembershipSalesVO);

	List<EgovMap> selectPurchaseMembershipList(Map<String, Object> params);

	void insertAccTradeLedger(AccTradeLedgerVO accTradeLedgerVO);

	void insertAccOrderBill(AccOrderBillVO accOrderBillVO);

	void insertAccTaxInvoiceOutright(AccTaxInvoiceOutrightVO accTaxInvoiceOutrightVO);

	void insertAccTaxInvoiceOutright_Sub(AccTaxInvoiceOutright_SubVO accTaxInvoiceOutright_SubVO);

	EgovMap selectInstallationAddress(Map<String, Object> params);

	void updateInstallationOtran(InstallationVO installationVO);

	void updateRentPaySetOtran(RentPaySetVO rentPaySetVO);

	EgovMap selectSalesOrderMOtran(Map<String, Object> params);

	void updateCustBillMasterOtran(CustBillMasterVO custBillMasterVO);

	EgovMap selectObligtPriod(Map<String, Object> params);

	EgovMap selectPenaltyAmt(Map<String, Object> params);

	int selectCcpDecisionMById(Map<String, Object> params);

	int selectECashDeductionItemById(Map<String, Object> params);

	void updateSalesOrderLog(Map<String, Object> params);

	void updateSalesOrderMCanc(Map<String, Object> params);

	int validOCRStus(Map<String, Object> params);

}
