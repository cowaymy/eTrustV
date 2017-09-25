/**
 * 
 */
package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.CustBillMasterHistoryVO;
import com.coway.trust.biz.sales.order.vo.RentPaySetVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Mapper("orderModifyMapper")
public interface OrderModifyMapper {

	void updateSalesOrderM(Map<String, Object> params);
	
	void insertCustBillMasterHistory(CustBillMasterHistoryVO custBillMasterHistoryVO);
	
	void updateCustBillMaster(Map<String, Object> params);
	
	void updateCustAddId(Map<String, Object> params);
	
	void updateNric(Map<String, Object> params);
	
	EgovMap selectBillGroupByBillGroupID(Map<String, Object> params); //Bill Group Master
	
	List<EgovMap> selectBillGroupOrder(Map<String, Object> params); //Bill Group Master
	
	int selectNricCheckCnt(Map<String, Object> params);
	
	int selectNricCheckCnt2(Map<String, Object> params);
	
	EgovMap selectCustInfo(Map<String, Object> params); //
	
	EgovMap selectNricExist(Map<String, Object> params); //
	
	EgovMap selectInstRsltCount(Map<String, Object> params);

	EgovMap selectGSTZRLocationCount(Map<String, Object> params);

	EgovMap selectGSTZRLocationByAddrIdCount(Map<String, Object> params);

	void updateInstallInfo(Map<String, Object> params);
	
	void updateInstallUpdateInfo(Map<String, Object> params);
	
	void updatePaymentChannel(RentPaySetVO rentPaySetVO);
	
}
