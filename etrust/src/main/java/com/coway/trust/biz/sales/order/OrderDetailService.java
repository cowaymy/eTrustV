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

	public EgovMap selectOrderBasicInfo(Map<String, Object> params) throws Exception;

	public List<EgovMap> selectCallLogList(Map<String, Object> params);

	public List<EgovMap> selectSameRentalGrpOrderList(Map<String, Object> params);
	
	public List<EgovMap> selectMembershipInfoList(Map<String, Object> params);
	
	public List<EgovMap> selectDocumentList(Map<String, Object> params);

	List<EgovMap> selectPaymentMasterList(Map<String, Object> params);

	List<EgovMap> selectAutoDebitList(Map<String, Object> params);

	List<EgovMap> selectDiscountList(Map<String, Object> params);

	List<EgovMap> selectLast6MonthTransList(Map<String, Object> params);

	EgovMap selectBasicInfo(Map<String, Object> params) throws Exception;

	EgovMap selectGSTCertInfo(Map<String, Object> params);
}
