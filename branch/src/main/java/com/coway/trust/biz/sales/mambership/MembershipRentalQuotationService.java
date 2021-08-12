/**
 * 
 */
package com.coway.trust.biz.sales.mambership;

import java.util.List;



import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author goo
 *
 */
public interface MembershipRentalQuotationService {
	
	
	List<EgovMap>   quotationList(Map<String, Object> params);
	List<EgovMap>   newConfirm(Map<String, Object> params);
	List<EgovMap>   selCheckExpService(Map<String, Object> params);
	
	List<EgovMap>   newOListuotationList(Map<String, Object> params);
	
	EgovMap		newGetExpDate(Map<String, Object> params);
	
	List<EgovMap>   getSrvMemCode(Map<String, Object> params);
	
	EgovMap		mPackageInfo(Map<String, Object> params);
	
	List<EgovMap>   getPromotionCode(Map<String, Object> params); 
	
	EgovMap	    	getFilterCharge(Map<String, Object> params);
	
	List<EgovMap>   getFilterPromotionCode(Map<String, Object> params); 
	
	List<EgovMap>   getPromoPricePercent(Map<String, Object> params); 
	
	List<EgovMap>   getOrderCurrentBillMonth(Map<String, Object> params); 
	
	EgovMap	    	getOderOutsInfo(Map<String, Object> params);
	
	EgovMap 	insertQuotationInfo(Map<String, Object> params) ;
	
	EgovMap	   getMembershipFilterChargeList(Map<String, Object> params);
	
	
	List<EgovMap>   getFilterChargeList(Map<String, Object> params);
	double   getFilterChargeListSum(Map<String, Object> params);
	
	EgovMap		getFilterPromotionAmt(Map<String, Object> params);
	
	void 	insertSrvMembershipQuot_Filter(Map<String, Object> params) ;
	
	EgovMap   getSAL0083D_SEQ(Map<String, Object> params);
	
	
	List<EgovMap>   mActiveQuoOrder(Map<String, Object> params);
	
	List<EgovMap>   selectSrchMembershipQuotationPop(Map<String, Object> params);
	
	EgovMap cnvrToSalesOrderInfo(Map<String, Object> params);
	
	EgovMap cnvrToSalesAddrInfo(Map<String, Object> params);
	
	EgovMap cnvrToSalesCntcInfo(Map<String, Object> params);
	
	List<EgovMap> cnvrToSalesfilterChgList(Map<String, Object> params);
	
	EgovMap cnvrToSalesPackageInfo(Map<String, Object> params);
	
	EgovMap cnvrToSalesOrderInfo2nd(Map<String, Object> params);
	
	EgovMap cnvrToSalesThrdParty(Map<String, Object> params);

	EgovMap insertCnvrToSale(Map<String, Object> params) ;
	void updateStus(Map<String, Object> params);

	
}
   