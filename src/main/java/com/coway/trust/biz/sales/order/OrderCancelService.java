package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderCancelService {

	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> orderCancellationList(Map<String, Object> params);
	
	
	/**
	 * DSC BRANCH
	 * 
	 * @param 
	 *            - 
	 * @return combo box
	 * @exception Exception
	 */
	List<EgovMap> dscBranch(Map<String, Object> params);

	
	/**
	 * Cancellation Request Information.
	 * 
	 * @param REQ_ID
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap cancelReqInfo(Map<String, Object> params); 
	
	
	/**
	 * Cancellation Log Transaction
	 * 
	 * @param 
	 * @return 글 상세
	 * @exception Exception
	 */
	List<EgovMap> cancelLogTransctionList(Map<String, Object> params);
	
	
	/**
	 * Product Return Transaction
	 * 
	 * @param 
	 * @return 글 상세
	 * @exception Exception
	 */
	List<EgovMap> productReturnTransctionList(Map<String, Object> params);
	
	
	/**
	 * CT Assignment Information.
	 * 
	 * @param REF_ID, TYPE_ID
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap ctAssignmentInfo(Map<String, Object> params); 
	
	
	/**
	 * Assign CT  - New Cancellation Log Result
	 * 
	 * @param 
	 *            - 
	 * @return combo box
	 * @exception Exception
	 */
	List<EgovMap> selectAssignCT(Map<String, Object> params);
}
