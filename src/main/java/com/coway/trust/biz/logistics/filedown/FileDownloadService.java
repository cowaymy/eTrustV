package com.coway.trust.biz.logistics.filedown;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface FileDownloadService {

	List<EgovMap> fileDownloadList(Map<String, Object> params);

	List<EgovMap> selectLabelList(Map<String, Object> params);

	void insertFileSpace(Map<String, Object> params);

}
