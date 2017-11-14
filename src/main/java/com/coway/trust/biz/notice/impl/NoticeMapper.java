package com.coway.trust.biz.notice.impl;

import java.util.List;
import java.util.Map;


import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("noticeMapper")
public interface NoticeMapper {

	List<EgovMap> noticeList(Map<String, Object> params) throws Exception;
	
	void insertNotice(Map<String, Object> params) throws Exception; 
	
	List<EgovMap> selectCodeList(Map<String, Object> params) throws Exception;
	
	int getNtceNOSeq() throws Exception;
	
	EgovMap noticeInfo(Map<String, Object> params) throws Exception; 
	
	int checkPassword(Map<String, Object> params) throws Exception;
	
	void updateNotice(Map<String, Object> params) throws Exception;
	
	void upViewCnt(Map<String, Object> params) throws Exception;
	
	void deleteNotice(Map<String, Object> params) throws Exception;
	
//	EgovMap getAttachmentFileInfo(Map<String, Object> params) throws Exception;
	
}
