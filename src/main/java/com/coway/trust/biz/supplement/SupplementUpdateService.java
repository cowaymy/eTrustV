package com.coway.trust.biz.supplement;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.pos.vo.PosGridVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SupplementUpdateService {

	List<EgovMap> selectSupplementList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectSupRefStus();

	List<EgovMap> selectSupRefStg();

	List<EgovMap> selectSubmBrch();

	List<EgovMap> selectWhBrnchList() throws Exception;

	List<EgovMap> getSupplementDetailList(Map<String, Object> params)throws Exception;

	List<EgovMap> selectPosJsonList(Map<String, Object> params) throws Exception;

	List<EgovMap> checkDuplicatedTrackNo(Map<String, Object> params);

	//public EgovMap selectOrderBasicInfo(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	EgovMap selectOrderBasicInfo(Map<String, Object> params) throws Exception;

	//void updateRefStgStatus(Map<String, Object> transactionId);

	int updateRefStgStatus(Map<String, Object> params) throws Exception;




/*	List<EgovMap> selectPosModuleCodeList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectStatusCodeList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectPosJsonList(Map<String, Object> params) throws Exception;*/




}
