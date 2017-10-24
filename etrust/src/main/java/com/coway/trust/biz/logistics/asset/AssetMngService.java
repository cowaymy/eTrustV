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

	List<EgovMap> selectDepartmentList(Map<String, Object> params);

	void insertAssetMng(Map<String, Object> params, List<EgovMap> detailAddList, int loginId);

	void addItemAssetMng(List<EgovMap> itemAddList, int loginId);

	void motifyAssetMng(Map<String, Object> params);

	void updateItemAssetMng(Map<String, Object> params, int loginId);

	void RemoveItemAssetMng(Map<String, Object> params);

	void deleteAssetMng(Map<String, Object> params);

	int insertCopyAsset(int assetid, int copyquantity, int loginId);

	List<EgovMap> assetCardList(Map<String, Object> params);

	void saveAssetCard(Map<String, Object> params);

	void updateAssetStatus(Map<String, Object> params);

}
