package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("CompensationMapper")
public interface CompensationMapper {
	
	List<EgovMap> selCompensationList(Map<String, Object> params);
	 
	EgovMap selectCompenSationView(Map<String, Object> params);
	
	int   insertCompensation(Map<String, Object> params);
	
	int   updateCompensation(Map<String, Object> params);
	 
	List<EgovMap> selectSalesOrdNoInfo(Map<String, Object> params);
	
	List<EgovMap> selectAttachmentFileInfo(Map<String, Object> params);

}
