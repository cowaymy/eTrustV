package com.coway.trust.biz.logistics.helpdesk;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HelpDeskService {
	
	List<EgovMap> selectReasonList(Map<String, Object> params);
	
	List<EgovMap> selectDataChangeList(Map<String, Object> params);
	
	List<EgovMap> detailDataChangeList(Map<String, Object> params);
	
	List<EgovMap> CompulsoryList(Map<String, Object> params);
	
	List<EgovMap> ChangeItemList(Map<String, Object> params);
	
	List<EgovMap> RespondList(Map<String, Object> params);
	
	Map<String, Object> insertDataChangeList(Map<String, Object> params, int loginId,String today);
	
	void sendEmailList(Map<String, Object> params,String today);
	
}
