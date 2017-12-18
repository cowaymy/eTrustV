package com.coway.trust.biz.services.installation.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.installation.InstallationReversalService;
import com.coway.trust.web.services.installation.InstallationReversalController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("installationReversalService")
public class InstallationReversalServiceImpl extends EgovAbstractServiceImpl implements InstallationReversalService{
	private static final Logger logger = LoggerFactory.getLogger(InstallationReversalController.class);
	
	@Resource(name = "installationReversalMapper")
	private InstallationReversalMapper installationReversalMapper;
	
	public List<EgovMap> selectOrderList(Map<String, Object> params) {
		return installationReversalMapper.selectOrderList(params);
	}
	
	@Override
	public EgovMap installationReversalSearchDetail1(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail1(params);
	}
	@Override
	public EgovMap installationReversalSearchDetail2(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail2(params);
	}
	@Override
	public EgovMap installationReversalSearchDetail3(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail3(params);
	}
	@Override
	public EgovMap installationReversalSearchDetail4(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail4(params);
	}
	@Override
	public EgovMap installationReversalSearchDetail5(Map<String, Object> params) {
		return installationReversalMapper.selectOrderListDetail5(params);
	}
	
	@Override
	public List<EgovMap> selectReverseReason() {
		return installationReversalMapper.selectReverseReason();
	}
	
	@Override
	public List<EgovMap> selectFailReason() {
		return installationReversalMapper.selectFailReason();
	}
	
	@Override
	public  int    saveReverseNewInstallationResult(Map<String, Object> params) {
		return installationReversalMapper.saveReverseNewInstallationResult(params);
	}
	
	@Override
	public  String    getMemIDBySalesOrderIDAndPacID(Map<String, Object> params) {
		return installationReversalMapper.getMemIDBySalesOrderIDAndPacID(params);
	}
	
	@Override
	public  String    getLatestConfigIDBySalesOrderID(Map<String, Object> params) {
		return installationReversalMapper.getLatestConfigIDBySalesOrderID(params);
	}
	
	@Override
	public  String    getHCIDBySalesOrderID(Map<String, Object> params) {
		return installationReversalMapper.getHCIDBySalesOrderID(params);
	}
	
	@Override
	public EgovMap getRequiredView(Map<String, Object> params) {
		return installationReversalMapper.getRequiredView(params);
	}
	
	@Override
	public  String    getDOCNumber(Map<String, Object> params) {
		return installationReversalMapper.getDOCNumber(params);
	}
	
	@Override
	public  void    updateDOCNumber(Map<String, Object> params) {
		installationReversalMapper.updateDOCNumber(params);
	}
	
	@Override
	public  void    addAccAdjTransEntry(Map<String, Object> params) {
		installationReversalMapper.addAccAdjTransEntry(params);
	}
	
	@Override
	public  int    selectLastadjEntryId() {
		return installationReversalMapper.selectLastadjEntryId();
	}
	
	@Override
	public  void    addAccAdjTransResult(Map<String, Object> params) {
		installationReversalMapper.addAccAdjTransResult(params);
	}
	
	@Override
	public  String    getDOCNumberOnlyNumber() {
		return installationReversalMapper.getDOCNumberOnlyNumber();
	}
	
	@Override
	public EgovMap getQryPreBill(Map<String, Object> params) {
		return installationReversalMapper.getQryPreBill(params);
	}
	
	@Override
	public  void    addAccOrderVoid_Invoice(Map<String, Object> params) {
		installationReversalMapper.addAccOrderVoid_Invoice(params);
	}
	
	@Override
	public  void    addAccOrderVoid_Invoice_Sub(Map<String, Object> params) {
		installationReversalMapper.addAccOrderVoid_Invoice_Sub(params);
	}
	
	@Override
	public  void    updateAccOrderBill(Map<String, Object> params) {
		installationReversalMapper.updateAccOrderBill(params);
	}
	
	@Override
	public  void    addAccTradeLedger(Map<String, Object> params) {
		installationReversalMapper.addAccTradeLedger(params);
	}
	
	@Override
	public  void    updateRentalScheme(Map<String, Object> params) {
		installationReversalMapper.updateRentalScheme(params);
	}
	
	@Override
	public EgovMap getQryPreBill_out(Map<String, Object> params) {
		return installationReversalMapper.getQryPreBill_out(params);
	}
	
	@Override
	public List<EgovMap> getQryOutS(Map<String, Object> params) {
		installationReversalMapper.getQryOutS(params);
				
		//return (List<EgovMap>) params.get("p1");
		return (List<EgovMap>) params;
	}
	
	@Override
	public EgovMap getQryAccBill(Map<String, Object> params) {
		return installationReversalMapper.getQryAccBill(params);
	}
	
	@Override
	public  void    updateAccOrderBill2(Map<String, Object> params) {
		installationReversalMapper.updateAccOrderBill2(params);
	}
	
	@Override
	public  void    updateDOCNumber_8Digit(Map<String, Object> params) {
		installationReversalMapper.updateDOCNumber_8Digit(params);
	}
	
	@Override
	public  void    addAccInvAdjr(Map<String, Object> params) {
		installationReversalMapper.addAccInvAdjr(params);
	}
	
	@Override
	public  String    getAccBillTaxCodeID(Map<String, Object> params) {
		return installationReversalMapper.getAccBillTaxCodeID(params);
	}
	
	@Override
	public  void    addAccInvoiceAdjustment_Sub(Map<String, Object> params) {
		installationReversalMapper.addAccInvoiceAdjustment_Sub(params);
	}
	
	@Override
	public  void    addAccTaxDebitCreditNote(Map<String, Object> params) {
		installationReversalMapper.addAccTaxDebitCreditNote(params);
	}
	
	@Override
	public  void    addAccTaxDebitCreditNote_Sub(Map<String, Object> params) {
		installationReversalMapper.addAccTaxDebitCreditNote_Sub(params);
	}
	
	@Override
	public  int    getMemoAdjustID() {
		return installationReversalMapper.getMemoAdjustID();
	}
	
	@Override
	public  int  getNoteID() {
		return installationReversalMapper.getNoteID();
	}
	
	@Override
	public  int    getAccInvVoidID() {
		return installationReversalMapper.getAccInvVoidID();
	}
	
	@Override
	public  void    updateInstallresult(Map<String, Object> params) {
		installationReversalMapper.updateInstallresult(params);
	}
	
	@Override
	public EgovMap getInstallResults(Map<String, Object> params) {
		return installationReversalMapper.getInstallResults(params);
	}
	
	@Override
	public  void    addInstallresultReverse(Map<String, Object> params) {
		installationReversalMapper.addInstallresultReverse(params);
	}
	
	@Override
	public  void    updateInstallEntry(Map<String, Object> params) {
		installationReversalMapper.updateInstallEntry(params);
	}
	
	@Override
	public  void    updateSrvMembershipSale(Map<String, Object> params) {
		installationReversalMapper.updateSrvMembershipSale(params);
	}
	
	@Override
	public  void    updateSrvConfiguration(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfiguration(params);
	}
	
	@Override
	public  void    updateSrvConfigSetting(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigSetting(params);
	}
	
	@Override
	public  void    updateSrvConfigPeriod(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigPeriod(params);
	}
	
	@Override
	public  void    updateSrvConfigFilter(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigFilter(params);
	}
	
	@Override
	public  void    updateHappyCallM(Map<String, Object> params) {
		installationReversalMapper.updateHappyCallM(params);
	}
	
	@Override
	public  void    updateSalesOrderM(Map<String, Object> params) {
		installationReversalMapper.updateSalesOrderM(params);
	}
	
	@Override
	public  void    updateInstallation(Map<String, Object> params) {
		installationReversalMapper.updateInstallation(params);
	}
	
	@Override
	public  void    addCallEntry(Map<String, Object> params) {
		installationReversalMapper.addCallEntry(params);
	}
	
	@Override
	public int getCallEntry(Map<String, Object> params) {
		return installationReversalMapper.getCallEntry(params);
	}
	
	@Override
	public  void    addCallResult(Map<String, Object> params) {
		installationReversalMapper.addCallResult(params);
	}
	
	@Override
	public  void    addSalesorderLog(Map<String, Object> params) {
		installationReversalMapper.addSalesorderLog(params);
	}
	
	@Override
	public EgovMap GetOrderExchangeTypeByInstallEntryID(Map<String, Object> params) {
		return installationReversalMapper.GetOrderExchangeTypeByInstallEntryID(params);
	}
	
	@Override
	public  void    updateSalesOrderExchange(Map<String, Object> params) {
		installationReversalMapper.updateSalesOrderExchange(params);
	}
	
	@Override
	public  void    updateSrvConfigurations(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigurations(params);
	}
	
	@Override
	public  void    updateSrvConfigSetting2(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigSetting2(params);
	}
	
	@Override
	public  void    updateSrvConfigPeriod2(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigPeriod2(params);
	}
	
	@Override
	public  void    updateSrvConfigFilter2(Map<String, Object> params) {
		installationReversalMapper.updateSrvConfigFilter2(params);
	}
	
	@Override
	public EgovMap getRequiredView2(Map<String, Object> params) {
		return installationReversalMapper.getRequiredView2(params);
	}
	
	public  void    updateSalesOrderM2(Map<String, Object> params) {
		installationReversalMapper.updateSalesOrderM2(params);
	}
	
	public  void    updateSalesOrderD2(Map<String, Object> params) {
		installationReversalMapper.updateSalesOrderD2(params);
	}
	
	@Override
	public  void    addAccTRXes(Map<String, Object> params) {
		installationReversalMapper.addAccTRXes(params);
	}
	
	@Override
	public  void    updateSrvMembershipSale2(Map<String, Object> params) {
		installationReversalMapper.updateSrvMembershipSale2(params);
	}
	
	@Override
	public  void    addAccRentLedger(Map<String, Object> params) {
		installationReversalMapper.addAccRentLedger(params);
	}
	

}
