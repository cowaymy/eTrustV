package com.coway.trust.biz.sales.ccp;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CcpCTOSB2BService {


	List<EgovMap> selectCTOSB2BList(Map<String, Object> params)throws Exception;

	List<EgovMap> getCTOSDetailList(Map<String, Object> params)throws Exception;

	Map<String, Object> getResultRowForCTOSDisplay(Map<String, Object> params)throws Exception;

	int  savePromoB2BUpdate(Map<String, Object> params);

	Map<String, Object> reuploadCTOSB2BList(Map<String, Object> params, SessionVO sessionVO);

	EgovMap getCurrentTower(Map<String, Object> params)throws Exception;

	int  updateCurrentTower(Map<String, Object> params);

	int  updateAgeGroup(Map<String, Object> params);

	List<EgovMap> selectAgeGroupList(Map<String, Object> params);

	EgovMap getCurrentAgeGroup(Map<String, Object> params)throws Exception;
}
