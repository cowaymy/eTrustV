package com.coway.trust.biz.services.installation.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("installationReversalMapper")
public interface InstallationReversalMapper {

	List<EgovMap> selectOrderList(Map<String, Object> params);

	EgovMap selectOrderListDetail1(Map<String, Object> params);
	EgovMap selectOrderListDetail2(Map<String, Object> params);
	EgovMap selectOrderListDetail3(Map<String, Object> params);
	EgovMap selectOrderListDetail4(Map<String, Object> params);
	EgovMap selectOrderListDetail5(Map<String, Object> params);

	List<EgovMap> selectReverseReason();
	List<EgovMap> selectFailReason();

	Map<String, Object>   SP_LOGISTIC_REQUEST(Map<String, Object> param);

	int saveReverseNewInstallationResult(Map<String, Object> params);

	String getMemIDBySalesOrderIDAndPacID(Map<String, Object> params);

	String getLatestConfigIDBySalesOrderID(Map<String, Object> params);

	String getHCIDBySalesOrderID(Map<String, Object> params);

	EgovMap getRequiredView(Map<String, Object> params);

	String getDOCNumber(Map<String, Object> params);

	void updateDOCNumber(Map<String, Object> params);

	void addAccAdjTransEntry(Map<String, Object> params);

	int selectLastadjEntryId();

	void addAccAdjTransResult(Map<String, Object> params);

	String getDOCNumberOnlyNumber();

	EgovMap getQryPreBill(Map<String, Object> params);

	void addAccOrderVoid_Invoice(Map<String, Object> params);

	void addAccOrderVoid_Invoice_Sub(Map<String, Object> params);

	void updateAccOrderBill(Map<String, Object> params);

	void addAccTradeLedger(Map<String, Object> params);

	void updateRentalScheme(Map<String, Object> params);

	EgovMap getQryPreBill_out(Map<String, Object> params);

	List<EgovMap> getQryOutS(Map<String, Object> params);

	EgovMap getQryAccBill(Map<String, Object> params);

	void updateAccOrderBill2(Map<String, Object> params);

	void updateDOCNumber_8Digit(Map<String, Object> params);

	void addAccInvAdjr(Map<String, Object> params);

	String getAccBillTaxCodeID(Map<String, Object> params);

	void addAccInvoiceAdjustment_Sub(Map<String, Object> params);

	void addAccTaxDebitCreditNote(Map<String, Object> params);

	void addAccTaxDebitCreditNote_Sub(Map<String, Object> params);

	int getMemoAdjustID();

	int getNoteID();

	int getAccInvVoidID();

	void updateInstallresult(Map<String, Object> params);

	EgovMap getInstallResults(Map<String, Object> params);

	void addInstallresultReverse(Map<String, Object> params);

	void updateInstallEntry(Map<String, Object> params);

	void updateSrvMembershipSale(Map<String, Object> params);

	void updateSrvConfiguration(Map<String, Object> params);

	void updateSrvConfigSetting(Map<String, Object> params);

	void updateSrvConfigPeriod(Map<String, Object> params);

	void updateSrvConfigFilter(Map<String, Object> params);

	void updateHappyCallM(Map<String, Object> params);

	void updateSalesOrderM(Map<String, Object> params);

	void updateInstallation(Map<String, Object> params);

	void addCallEntry(Map<String, Object> params);

	int getCallEntry(Map<String, Object> params);

	void addCallResult(Map<String, Object> params);

	void addSalesorderLog(Map<String, Object> params);

	EgovMap GetOrderExchangeTypeByInstallEntryID(Map<String, Object> params);

	void updateSalesOrderExchange(Map<String, Object> params);

	void updateSrvConfigurations(Map<String, Object> params);

	void updateSrvConfigSetting2(Map<String, Object> params);

	void updateSrvConfigPeriod2(Map<String, Object> params);

	void updateSrvConfigFilter2(Map<String, Object> params);

	EgovMap getRequiredView2(Map<String, Object> params);

	void updateSalesOrderM2(Map<String, Object> params);

	void updateSalesOrderD2(Map<String, Object> params);

	void addAccTRXes(Map<String, Object> params);

	void updateSrvMembershipSale2(Map<String, Object> params);

	void addAccRentLedger(Map<String, Object> params);
}
