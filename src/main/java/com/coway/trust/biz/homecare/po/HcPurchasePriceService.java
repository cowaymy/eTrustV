package com.coway.trust.biz.homecare.po;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HcPurchasePriceService {

	// 공통코드 조회
	public List<EgovMap> selectComonCodeList(String params) throws Exception;
	public List<EgovMap> selectVendorList(Map<String, Object> params) throws Exception;

	// Purchase Price(HC) 메인 조회
	public int selectHcPurchasePriceListCnt(Map<String, Object> params) throws Exception;
	public List<EgovMap> selectHcPurchasePriceList(Map<String, Object> params) throws Exception;

	// Purchase Price(HC) History 조회
	public List<EgovMap> selectHcPurchasePriceHstList(Map<String, Object> params) throws Exception;

	// SAVE
	public int multiHcPurchasePrice(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

}
