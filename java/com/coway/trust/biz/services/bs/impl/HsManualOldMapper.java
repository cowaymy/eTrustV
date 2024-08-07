package com.coway.trust.biz.services.bs.impl;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("hsManualOldMapper")
public interface HsManualOldMapper {

	List<EgovMap> selectHsOldConfigList(Map<String, Object> params);

	List<EgovMap> selectStateList(Map<String, Object> params);

	List<EgovMap> selectAreaList(Map<String, Object> params);

	List<EgovMap> selectHSCodyOldList(Map<String, Object> params);

	EgovMap selectOrderInstallationInfoByOrdID(Map<String, Object> params);

	EgovMap selectBSOrderServiceSetting(Map<String, Object> params);

}
