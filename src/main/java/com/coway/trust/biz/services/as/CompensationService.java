package com.coway.trust.biz.services.as;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CompensationService {

	List<EgovMap> selCompensationList(Map<String, Object> params);
	
	public EgovMap selectCompenSationView(Map<String, Object> params);
	
	EgovMap insertCompensation(Map<String, Object> params);
	
	EgovMap updateCompensation(Map<String, Object> params);
	
	List<EgovMap> selectSalesOrdNoInfo(Map<String, Object> params);
	
}
