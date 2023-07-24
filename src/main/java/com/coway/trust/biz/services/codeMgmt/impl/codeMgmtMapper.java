package com.coway.trust.biz.services.codeMgmt.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("CodeMgmtMapper")
public interface codeMgmtMapper {

	void updateProductSetting(Map<String, Object> params);

	EgovMap getTypeCode(String type);

	void addASReasons(Map<String, Object> params);

	List<EgovMap> chkProductAvail(Map<String, Object> params);

	List<EgovMap> chkDupReasons(Map<String, Object> params);

	List<EgovMap> chkDupDefectCode(Map<String, Object> params);

	void addSYS0013M(Map<String, Object> params);

	void addDefectCodes(Map<String, Object> params);

	EgovMap selectSvcCodeInfo(Map<String, Object> params);

	List<EgovMap> selectCodeMgmtList(Map<String, Object> params);

	void updateCodeStusSYS32(Map<String, Object> params);

	void updateCodeStusSYS100(Map<String, Object> params);

	void updateCodeStusSYS13(Map<String, Object> params);

	EgovMap selectCodeMgmtInfo(Map<String, Object> params);

	void updateASReasons(Map<String, Object> params);

	void updateSYS0013M(Map<String, Object> params);

	void updateDefectCodes(Map<String, Object> params);


}
