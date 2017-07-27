/**
 * 
 */
package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
public interface OrderDetailService {

	public EgovMap getOrderBasicInfo(Map<String, Object> params) throws Exception;
	
	public EgovMap getOrderBasicInfoByOrderID(Map<String, Object> params);
	
	public EgovMap getLatestOrderLogByOrderID(Map<String, Object> params);
	
	public EgovMap getOrderAgreementByOrderID(Map<String, Object> params);
	
	public EgovMap getOrderInstallationInfoByOrderID(Map<String, Object> params);
	
	public List<EgovMap> getOrderReferralInfoList(Map<String, Object> params);
	
	public List<EgovMap> getCallLogList(Map<String, Object> params);

	public List<EgovMap> getSameRentalGrpOrderList(Map<String, Object> params);
	
	public List<EgovMap> getMembershipInfoList(Map<String, Object> params);
	
	public List<EgovMap> getDocumentList(Map<String, Object> params);

	List<EgovMap> getPaymentMasterList(Map<String, Object> params);

	List<EgovMap> getAutoDebitList(Map<String, Object> params);

	List<EgovMap> getDiscountList(Map<String, Object> params);
}
