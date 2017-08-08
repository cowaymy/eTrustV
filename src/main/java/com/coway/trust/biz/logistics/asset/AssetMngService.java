package com.coway.trust.biz.logistics.asset;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;


public interface AssetMngService {
	
	List<EgovMap> selectAssetList(Map<String, Object> params);
	List<EgovMap> selectDetailList(Map<String, Object> params);
	List<EgovMap> selectDealerList(Map<String, Object> params);
	List<EgovMap> selectBrandList(Map<String, Object> params);
	List<EgovMap> selectTypeList(Map<String, Object> params);
	void insertAssetMng(Map<String, Object> params);
	void motifyAssetMng(Map<String, Object> params);
	void deleteAssetMng(Map<String, Object> params);
	
	
	
}
