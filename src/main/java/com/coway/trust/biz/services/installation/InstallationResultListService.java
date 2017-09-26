package com.coway.trust.biz.services.installation;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface InstallationResultListService {

	List<EgovMap> selectApplicationType();
	
	List<EgovMap> selectInstallStatus();
	
	List<EgovMap>  installationResultList(Map<String, Object> params);
	
	EgovMap getInstallResultByInstallEntryID(Map<String, Object> params);
	
	EgovMap getOrderInfo(Map<String, Object> params);

	EgovMap getcustomerInfo(Object cust_id);
	
	EgovMap getCustomerAddressInfo(Map<String, Object> params);
	
	EgovMap getCustomerContractInfo(Map<String, Object> params);
	
	EgovMap getInstallationBySalesOrderID(Map<String, Object> params);
	
	EgovMap getInstallContactByContactID(Map<String, Object> params);
	
	EgovMap getSalesOrderMBySalesOrderID(Map<String, Object> params);
	
	EgovMap getMemberFullDetailsByMemberIDCode(Map<String, Object> params);
	
	List<EgovMap>selectViewInstallation(Map<String, Object> params);
	
	EgovMap selectCallType(Map<String, Object> params);
	
	EgovMap getOrderExchangeTypeByInstallEntryID(Map<String, Object> params);
	
	List<EgovMap> selectFailReason(Map<String, Object> params);
	
	EgovMap getStockInCTIDByInstallEntryIDForInstallationView(Map<String, Object> params);
	
	EgovMap getSirimLocByInstallEntryID(Map<String, Object> params);
	
	List<EgovMap> checkCurrentPromoIsSwapPromoIDByPromoID(int promotionId);
	
	List<EgovMap> selectSalesPromoMs(int promotionId);
	
	//EgovMap getPromoPriceAndPV(int promotionId, int productId);
	
	EgovMap getAssignPromoIDByCurrentPromoIDAndProductID(int promotionId,int productId,boolean flag);
	
	EgovMap selectViewDetail(Map<String, Object> params);
	
	boolean insertInstallationProductExchange(Map<String, Object> params,SessionVO sessionVO) throws ParseException;
	
	boolean insertInstallationResult(Map<String, Object> params,SessionVO sessionVO) throws ParseException;
}
