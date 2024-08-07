package com.coway.trust.biz.sales.ccp;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CcpExpB2BService {

	List<EgovMap> selectEXPERIANB2BList(Map<String, Object> params)throws Exception;

	List<EgovMap> getExpDetailList(Map<String, Object> params)throws Exception;

	Map<String, Object> getResultRowForExpDisplay(Map<String, Object> params)throws Exception;

	int  saveExpPromoB2BUpdate(Map<String, Object> params);
}
