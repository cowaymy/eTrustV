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

	public EgovMap getOrderBasicInfo(Map<String, Object> params);
	
	public EgovMap getOrderBasicInfoByOrderID(Map<String, Object> params);
	
	public EgovMap getLatestOrderLogByOrderID(Map<String, Object> params);
	
	public EgovMap getOrderAgreementByOrderID(Map<String, Object> params);
	
	public EgovMap getOrderInstallationInfoByOrderID(Map<String, Object> params);
	
	public List<EgovMap> getOrderReferralInfoList(Map<String, Object> params);
	
	public List<EgovMap> getROSCallLogList(Map<String, Object> params);
	
	public List<EgovMap> getPaymentList(Map<String, Object> params);
	
	public List<EgovMap> getAutoDebitResultList(Map<String, Object> params);
	
	public List<EgovMap> getSameRentalGrpOrderList(Map<String, Object> params);
}
