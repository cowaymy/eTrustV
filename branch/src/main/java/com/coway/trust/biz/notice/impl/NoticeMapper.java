package com.coway.trust.biz.notice.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("noticeMapper")
public interface NoticeMapper {

	List<EgovMap> noticeList(Map<String, Object> params);

	void insertNotice(Map<String, Object> params);

	List<EgovMap> selectCodeList(Map<String, Object> params);

	int getNtceNOSeq();

	EgovMap noticeInfo(Map<String, Object> params);

	int checkPassword(Map<String, Object> params);

	void updateNotice(Map<String, Object> params);

	void updateViewCnt(Map<String, Object> params);

	void deleteNotice(Map<String, Object> params);

	List<EgovMap> selectAttachmentFileInfo(Map<String, Object> params);

    List<EgovMap> selectNtfList(Map<String, Object> params);

    void updateNtfStus(Map<String, Object> params);

}
