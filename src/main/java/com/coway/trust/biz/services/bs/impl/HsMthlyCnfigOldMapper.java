package com.coway.trust.biz.services.bs.impl;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("hsMthlyCnfigOldMapper")
public interface HsMthlyCnfigOldMapper {

	List<EgovMap> selectHsMnthlyMaintainOldList(Map<String, Object> params);

	EgovMap selectBSSettingOld(Map<String, Object> params);

	String selectHSCodyByCode(Map<String, Object> params);
}
