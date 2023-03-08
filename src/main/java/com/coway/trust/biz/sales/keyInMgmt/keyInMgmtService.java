package com.coway.trust.biz.sales.keyInMgmt;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface keyInMgmtService {

	int saveKeyInId(List<Object> udtList, Integer userId);

	List<EgovMap> selectKeyinMgmtList(Map<String, Object> params);

	List<EgovMap> searchKeyinMgmtList(Map<String, Object> params);

	public EgovMap uploadExcel(Map<String, Object> params,SessionVO sessionVO);

	EgovMap getDocNo(String docNoId);

	String getNextDocNo(String prefixNo, String docNo);

}
