package com.coway.trust.biz.sales.ccp;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CcpRentMemShipService {

	List<EgovMap> getBranchCodeList() throws Exception;
	
	List<EgovMap> getReasonCodeList() throws Exception;
	
	List<EgovMap> selectCcpRentListSearchList(Map<String, Object> params) throws Exception;
}
