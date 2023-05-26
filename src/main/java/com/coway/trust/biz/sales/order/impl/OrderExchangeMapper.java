package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("orderExchangeMapper")
public interface OrderExchangeMapper {

	/**
	 * 글 목록을 조회한다.
	 *
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> orderExchangeList(Map<String, Object> params);


	/**
	 * Exchange Information.
	 *
	 * @param REQ_ID
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap exchangeInfoProduct(Map<String, Object> params);


	/**
	 * Exchange Information. - Customer (From)
	 *
	 * @param REQ_ID
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap exchangeInfoOwnershipFr(Map<String, Object> params);


	/**
	 * Exchange Information. - Customer (To)
	 *
	 * @param REQ_ID
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap exchangeInfoOwnershipTo(Map<String, Object> params);


	/************************** Cancel Request ****************************/
	EgovMap firstSearchForCancel(Map<String, Object> params);
	EgovMap secondSearchForCancel(Map<String, Object> params);
	void updateStusSAL0004D(Map<String, Object> params);
	EgovMap thirdSearchForCancel(Map<String, Object> params);
	int getCallResultIdMaxSeq();
	int insertCCR0007D(Map<String, Object> params);
	int updateCCR0006D(Map<String, Object> params);
	EgovMap fourthSearchForCancel(Map<String, Object> params);
	int getCallEntryIdMaxSeq();
	int insertCCR0006D(Map<String, Object> params);
	int updateResultIdCCR0006D(Map<String, Object> params);
	int getLogIdMaxSeq();
	int insertLogSAL0009D(Map<String, Object> params);
	EgovMap invStkMovLOG0013D(Map<String, Object> params);
	EgovMap exchangeLOG0038D(Map<String, Object> params);
	void updateExchangeLOG0038D(Map<String, Object> params);
	void updateExchgLOG0013D(Map<String, Object> params);

	void updateEmailSentCount(Map<String, Object> params);

}
