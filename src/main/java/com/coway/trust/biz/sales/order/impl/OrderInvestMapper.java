package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("orderInvestMapper")
public interface OrderInvestMapper {
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> orderInvestigationList(Map<String, Object> params);
	
	
	/**
	 * Investigation View Info mapper
	 * 
	 * @param params
	 * @return EgovMap
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap orderInvestInfo(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Investigation View customer Info mapper
	 * 
	 * @param params
	 * @return EgovMap
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap orderCustomerInfo(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Investigation View Info Grid
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> orderInvestInfoGrid(Map<String, Object> params);
	
	
	/**
	 * Investigation Reject Reason Combo Box
	 * 
	 * @param
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> cmbRejReasonList(Map<String, Object> params);
	
	
	/**
	 * Investigation inchargeL Combo Box
	 * 
	 * @param
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> inchargeList(Map<String, Object> params);

	
	/**
	 * Investigation inchargeL Combo Box
	 * 
	 * @param
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	int orderInvestClosedDateChk();
	
	
	/**
	 * Single Investigation Request mapper
	 * 
	 * @param params
	 * @return EgovMap
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap orderNoChk(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Single Investigation Request mapper
	 * 
	 * @param params
	 * @return EgovMap
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap orderNoInfo(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Single Investigation Request mapper
	 * 
	 * @param params
	 * @return EgovMap
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap singleInvestView(Map<String, Object> params) throws Exception;
	
	
	/************************** Order Investigation save ****************************/
	int searchBSScheduleM(Map<String, Object> params);
	EgovMap searchInvestigateReqM(Map<String, Object> params) throws Exception;
	int updateInvestReqM(Map<String, Object> params);
	int insertInvestigateReqD(Map<String, Object> params);
	
	
	/************************** Order Investigation Request ****************************/
	String getDocNo(Map<String, Object> params)throws Exception;
	int insertInvestReqM(Map<String, Object> params);
	int insertSalesOrdLog(Map<String, Object> params);
	
	
	/**
	 * Investigation Investigation Call/Result Search
	 * 
	 * @param
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> orderInvestCallRecallList(Map<String, Object> params);
	
	
	/**
	 * Single Investigation Request mapper
	 * 
	 * @param params
	 * @return EgovMap
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap investCallResultInfo(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Single Investigation Request mapper
	 * 
	 * @param params
	 * @return EgovMap
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap investCallResultCust(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Investigation Investigation Call/Result Search
	 * 
	 * @param
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> investCallResultLog(Map<String, Object> params);
	
}
