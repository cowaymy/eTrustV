package com.coway.trust.biz.homecare.report;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HcPoResultService {

	public int selecthcPoResultGropListCnt(Map<String, Object> params) throws Exception;
	public List<EgovMap> selecthcPoResultGropList(Map<String, Object> params) throws Exception;

	// Po List 조회
	public int selecthcPoResultMainListCnt(Map<String, Object> params) throws Exception;
	public List<EgovMap> selecthcPoResultMainList(Map<String, Object> params) throws Exception;

	// Po List Detail 조회
	public List<EgovMap> selecthcPoResultSubList(Map<String, Object> params) throws Exception;


}
