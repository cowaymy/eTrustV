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

	List<EgovMap> selectDepartmentList(Map<String, Object> params);

	void insertMasterAsset(Map<String, Object> params);

	void insertAssetMng(Map<String, Object> params);

	void insertDetailAsset(Map<String, Object> params);

	void motifyAssetMng(Map<String, Object> params);

	void deleteAssetMng(Map<String, Object> params);

	void addAssetItm(Map<String, Object> params);

	void RemoveAssetDetail(Map<String, Object> params);

	void RemoveAssetItem(Map<String, Object> params);

	void updateItm(Map<String, Object> params);

	void updateAssetDetail(Map<String, Object> params);

	int AssetCreateSeq();

	int AssetdetailCreateSeq();

	int AssetItemCreateSeq();

	int AssetCardIdSeq();

	List<EgovMap> selectAssetM(int assetid);

	List<EgovMap> selectAssetD(int assetid);

	List<EgovMap> selectAssetDItem(int assetid);

	void insertCopyAssetM(Map<String, Object> params);

	void insertCopyAssetCard(Map<String, Object> params);

	void insertCopyAssetD(Map<String, Object> params2);

	void insertCopyAssetDItmId(Map<String, Object> params3);

	List<EgovMap> assetCardList(Map<String, Object> params);

	void insertAssetCardFrom(Map<String, Object> params);

	void insertAssetCardTo(Map<String, Object> params);

	void updateAssetCard(Map<String, Object> params);

}
