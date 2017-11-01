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
import com.coway.trust.biz.sales.order.vo.SalesReqCancelVO;
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
	
	void updateSoExchgStkRetMovId(SalesOrderExchangeVO salesOrderExchangeVO);
	
	void updateSalesOrderM(SalesOrderMVO salesOrderMVO);
	
	void updateSalesOrderD(SalesOrderDVO salesOrderDVO);
	
	EgovMap selecLastInstall(Map<String, Object> params);

	EgovMap selectSrvConfiguration(Map<String, Object> params);

	void insertInvStkMovement(InvStkMovementVO invStkMovementVO);
	
	void insertStkReturnEntry(StkReturnEntryVO stkReturnEntryVO);
	
	List<EgovMap> selectSrvConfigPeriod(Map<String, Object> params);
	
	List<EgovMap> selectSrvConfigSetting(Map<String, Object> params);
	
	List<EgovMap> selectSrvConfigFilter(Map<String, Object> params);
	
	void insertSalesOrderExchangeBUSrvConfig(SalesOrderExchangeBUSrvConfigVO salesOrderExchangeBUSrvConfigVO);
	
	void insertSalesOrderExchangeBUSrvPeriod(SalesOrderExchangeBUSrvPeriodVO salesOrderExchangeBUSrvPeriodVO);
	
	void insertSalesOrderExchangeBUSrvSetting(SalesOrderExchangeBUSrvSettingVO salesOrderExchangeBUSrvSettingVO);
	
	void insertSalesOrderExchangeBUSrvFilter(SalesOrderExchangeBUSrvFilterVO salesOrderExchangeBUSrvFilterVO);
	
}
