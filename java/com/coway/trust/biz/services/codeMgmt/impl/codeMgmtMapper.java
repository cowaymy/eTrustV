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

	List<EgovMap> chkProductAvail(String string);

	List<EgovMap> chkDupReasons(Map<String, Object> params);

	List<EgovMap> chkDupDefectCode(Map<String, Object> params);

	void addDefectCodes(Map<String, Object> params);

	EgovMap selectSvcCodeInfo(Map<String, Object> params);

	List<EgovMap> selectCodeMgmtList(Map<String, Object> params);

	void updateCodeStusSYS32(Map<String, Object> params);

	void updateCodeStusSYS100(Map<String, Object> params);

	EgovMap selectCodeMgmtInfo(Map<String, Object> params);

	void updateASReasons(Map<String, Object> params);

	void updateDefectCodes(Map<String, Object> params);

	void addDefectCodesSmall(Map<String, Object> params);

	EgovMap getDefectId();

	EgovMap getDefectIdParent(Map<String, Object> saveParam);

	List<EgovMap> selectCodeCatList(Map<String, Object> params);

	void updateCodeStusSVC142(Map<String, Object> params);

	void updateSVC0142D(Map<String, Object> params);

	void addSVC0142D(Map<String, Object> params);


}
