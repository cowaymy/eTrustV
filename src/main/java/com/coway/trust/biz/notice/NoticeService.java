package com.coway.trust.biz.notice;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface NoticeService {

	List<EgovMap> selectCodeList(Map<String, Object> params);

	List<EgovMap> getNoticeList(Map<String, Object> params);

	int getNtceNOSeq();

	void insertNotice(Map<String, Object> params);

	EgovMap getNoticeInfo(Map<String, Object> params);

	boolean checkPassword(Map<String, Object> params);

	void deleteNotice(Map<String, Object> params);

	void updateNotice(Map<String, Object> params);

	void updateViewCnt(Map<String, Object> params);

	List<EgovMap> getAttachmentFileInfo(Map<String, Object> params);

    List<EgovMap> selectNtfList(Map<String, Object> params);

    void updateNtfStus(Map<String, Object> params);
}
