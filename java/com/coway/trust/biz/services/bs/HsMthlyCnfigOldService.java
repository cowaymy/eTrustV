package com.coway.trust.biz.services.bs;

import java.text.ParseException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HsMthlyCnfigOldService {

	List<EgovMap> selectHsMnthlyMaintainOldList(Map<String, Object> params);

	EgovMap selectHsMnthlyMaintainOldDetail(Map<String, Object> params);

	public EgovMap selectBSSettingOld(Map<String, Object> params);

	int updateCurrentMonthSettingCody(Map<String, Object> params);

	String selectHSCodyByCode(Map<String, Object> params);

}
