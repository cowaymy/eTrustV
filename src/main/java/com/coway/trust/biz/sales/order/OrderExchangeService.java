package com.coway.trust.biz.sales.order;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderExchangeService {

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
	 * Exchange Information. - Product Exchange Type
	 *
	 * @param REQ_ID
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap exchangeInfoProduct(Map<String, Object> params);


	/**
	 * Exchange Information. - Product Exchange Type
	 *
	 * @param REQ_ID
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap exchangeInfoOwnershipFr(Map<String, Object> params);


	/**
	 * Exchange Information. - Product Exchange Type
	 *
	 * @param REQ_ID
	 * @return 글 상세
	 * @exception Exception
	 */
	EgovMap exchangeInfoOwnershipTo(Map<String, Object> params);


	void saveCancelReq(Map<String, Object> params);

	ReturnMessage pexSendEmail(Map<String, Object> params);
}
