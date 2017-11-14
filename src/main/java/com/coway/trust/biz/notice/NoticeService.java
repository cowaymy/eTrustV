package com.coway.trust.biz.notice;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface NoticeService {
	
	List<EgovMap> selectCodeList(Map<String, Object> params) throws Exception;
	
	List<EgovMap> noticeList(Map<String, Object> params) throws Exception;
	
	int getNtceNOSeq() throws Exception;
	
	void insertNotice(Map<String, Object> params) throws Exception;
	
	EgovMap noticeInfo(Map<String, Object> params)throws Exception;
	
	boolean checkPassword(Map<String, Object> params) throws Exception;
	
	void deleteNotice(Map<String, Object> params) throws Exception;
	
	void updateNotice(Map<String, Object> params) throws Exception;
	
	void upViewCnt(Map<String, Object> params) throws Exception;
	
//	EgovMap getAttachmentFileInfo(Map<String, Object> params) throws Exception;
}
