/**
 * 
 */
package com.coway.trust.biz.sales.pst;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
public interface PSTRequestDOService {

	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> selectPstRequestDOList(Map<String, Object> params);
	
	
	/**
	 * 글 상세조회를 한다. PST Info
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap getPstRequestDODetailPop(Map<String, Object> params);
	
	
	/**
	 * 글 상세조회를 한다. PST Stock List
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 상세
	 * @exception Exception
	 */
	List<EgovMap> getPstRequestDOStockDetailPop(Map<String, Object> params);
	
}
