package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderSuspensionService {

	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> orderSuspensionList(Map<String, Object> params);
	
	
	/**
	 * Cancellation Request Information.
	 * 
	 * @param REQ_ID
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap orderSuspendInfo(Map<String, Object> params); 
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> suspendInchargePerson(Map<String, Object> params);
	
	void saveReAssign(Map<String, Object> params); 
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> suspendCallResult(Map<String, Object> params);
	
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> callResultLog(Map<String, Object> params);
	
	
	void newSuspendResult(Map<String, Object> params);
}
