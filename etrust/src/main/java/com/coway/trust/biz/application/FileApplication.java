package com.coway.trust.biz.application;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface FileApplication {
	void businessAttach(FileType type, List<FileVO> list, Map<String, Object> params);

	int commonAttach(FileType type, List<FileVO> list, Map<String, Object> params);
}
