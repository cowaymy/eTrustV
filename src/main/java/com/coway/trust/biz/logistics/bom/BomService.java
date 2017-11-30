package com.coway.trust.biz.logistics.bom;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface BomService {

	List<EgovMap> selectCdcList(Map<String, Object> params);

	List<EgovMap> selectBomList(Map<String, Object> params);

	List<EgovMap> materialInfo(Map<String, Object> params);

	List<EgovMap> filterInfo(Map<String, Object> params);

	List<EgovMap> spareInfo(Map<String, Object> params);

	List<EgovMap> selectCodeList(Map<String, Object> params);
	
	void modifyLeadTmOffset(Map<String, Object> params);

}
