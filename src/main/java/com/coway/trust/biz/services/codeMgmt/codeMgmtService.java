package com.coway.trust.biz.services.codeMgmt;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface codeMgmtService {

	ReturnMessage saveNewCode(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

	List<EgovMap> chkProductAvail(Map<String, Object> params);

	List<EgovMap> chkDupReasons(Map<String, Object> params);

	List<EgovMap> chkDupDefectCode(Map<String, Object> params);

	EgovMap selectSvcCodeInfo(Map<String, Object> params);

	List<EgovMap> selectCodeMgmtList(Map<String, Object> params);

	void updateCodeStus(Map<String, Object> params);

	EgovMap selectCodeMgmtInfo(Map<String, Object> params);

	ReturnMessage updateSvcCode(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

	List<EgovMap> selectCodeCatList(Map<String, Object> params);


}
