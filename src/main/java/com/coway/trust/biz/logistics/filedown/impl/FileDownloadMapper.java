package com.coway.trust.biz.logistics.filedown.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("FileDownloadMapper")
public interface FileDownloadMapper {
	
	List<EgovMap> fileDownloadList(Map<String, Object> params);
	
	List<EgovMap> selectLabelList(Map<String, Object> params);
	
	void insertFileSpace(Map<String, Object> params);
	
	int fileUpCreateSeq();

}
