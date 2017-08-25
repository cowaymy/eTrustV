package com.coway.trust.biz.logistics.helpdesk;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HelpDeskService {
	
	List<EgovMap> selectDataChangeList(Map<String, Object> params);
	
	List<EgovMap> detailDataChangeList(Map<String, Object> params);
	
/*	String selectSirimNo(Map<String, Object> params);
	
	void insertSirimList(Map<String, Object> params);
	
	List<EgovMap> selectSirimTransList(Map<String, Object> params);
	
	List<EgovMap> selectSirimToTransit(Map<String, Object> params);*/
}
