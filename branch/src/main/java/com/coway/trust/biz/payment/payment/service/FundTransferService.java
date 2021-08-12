package com.coway.trust.biz.payment.payment.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface FundTransferService
{

	
	 /**
	 * Fund Transfer Item List 조회
	 * 
	 * @param 
	 * @return 
	 * @exception Exception
	 */
    List<EgovMap> selectFundTransferItemList(Map<String, Object> params);
    

}
