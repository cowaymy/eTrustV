package com.coway.trust.biz.logistics.asset.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("AssetMngMapper")
public interface AssetMngMapper {
	List<EgovMap> selectAssetList(Map<String, Object> params);
	List<EgovMap> selectDetailList(Map<String, Object> params);
	List<EgovMap> selectDealerList(Map<String, Object> params);
	List<EgovMap> selectBrandList(Map<String, Object> params);
	List<EgovMap> selectTypeList(Map<String, Object> params);
	void insertAssetMng(Map<String, Object> params);
	void insertDetailAsset(Map<String, Object> params);
	void motifyAssetMng(Map<String, Object> params);
	void deleteAssetMng(Map<String, Object> params);
	int AssetCreateSeq();
	int AssetdetailCreateSeq();
}
