package com.coway.trust.biz.homecare.po;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HcConfirmPoService {
	// supplier id search
	public String selectUserSupplierId(Map<String, Integer> params) throws Exception;

	// Purchase Price(HC) 메인 조회
	public int selectHcConfirmPoMainListCnt(Map<String, Object> params) throws Exception;
	public List<EgovMap> selectHcConfirmPoMainList(Map<String, Object> params) throws Exception;

	// Purchase Price(HC) History 조회
	public List<EgovMap> selectHcConfirmPoSubList(Map<String, Object> params) throws Exception;

	// SAVE
	public int multiConfirmPo(Map<String, Object> params, SessionVO sessionVO) throws Exception;

}
