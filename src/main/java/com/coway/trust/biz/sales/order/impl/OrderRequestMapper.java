/**
 * 
 */
package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.CallEntryVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterHistoryVO;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.GSTEURCertificateVO;
import com.coway.trust.biz.sales.order.vo.ReferralVO;
import com.coway.trust.biz.sales.order.vo.RentPaySetVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.biz.sales.order.vo.SalesReqCancelVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Mapper("orderRequestMapper")
public interface OrderRequestMapper {

	List<EgovMap> selectResnCodeList();
	
	EgovMap selectOrderLastRentalBillLedger1(Map<String, Object> params);
	
	void insertSalesReqCancel(SalesReqCancelVO salesReqCancelVO);
	
	EgovMap selectSalesOrderD(Map<String, Object> params);
	
	EgovMap selectInstallEntry(Map<String, Object> params);
	
	EgovMap selectCallEntry(Map<String, Object> params);

	EgovMap selectCallEntryByEntryId(Map<String, Object> params);

	void updateCallEntry(CallEntryVO callEntryVO);
	
	void updateCallEntry2(Map<String, Object> params);
	
	void updateRentalScheme(Map<String, Object> params);
	
}
