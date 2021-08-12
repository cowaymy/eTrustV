package com.coway.trust.biz.application;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.util.EgovFormBasedFileVo;

public interface FileApplication {
	int businessAttach(FileType type, List<FileVO> list, Map<String, Object> params);

	int commonAttachByUserId(FileType type, List<FileVO> list, Map<String, Object> params);

	int commonAttachByUserName(FileType type, List<FileVO> list, Map<String, Object> params);

	void noticeAttach(FileType type, List<FileVO> list, Map<String, Object> params);

	void updateNoticeAttach(List<FileVO> fileVOS, Map<String, Object> params);
	
	void updateBusinessAttach(List<FileVO> fileVOS, Map<String, Object> params);
}
