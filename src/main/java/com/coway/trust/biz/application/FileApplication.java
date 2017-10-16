package com.coway.trust.biz.application;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;

public interface FileApplication {
	void businessAttach(String fileChannel, List<FileVO> list, Map<String, Object> params);

	int commonAttach(String fileChannel, List<FileVO> list, Map<String, Object> params);
}
