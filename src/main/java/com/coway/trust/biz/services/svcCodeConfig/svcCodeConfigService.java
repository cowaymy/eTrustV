package com.coway.trust.biz.services.svcCodeConfig;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface svcCodeConfigService {

	List<EgovMap> selectSvcCodeConfigList(Map<String, Object> params);

	//Product Category
	List<EgovMap> selectProductCategoryList();

	// StatusCategory Code
    List<EgovMap> selectStatusCategoryCodeList();

	EgovMap selectCodeConfigList(Map<String, Object> params);

	void saveNewCode(Map<String, Object> params, SessionVO sessionVO);

	void updateSvcCode(Map<String, Object> params, SessionVO sessionVO);

}
