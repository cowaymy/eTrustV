package com.coway.trust.biz.logistics.stocks.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("stockMapper")
public interface StockMapper {
	List<EgovMap> selectStockList(Map<String, Object> params);

	List<EgovMap> selectStockInfo(Map<String, Object> params);

	List<EgovMap> selectPriceInfo(Map<String, Object> params);

	List<EgovMap> selectFilterInfo(Map<String, Object> params);

	List<EgovMap> selectServiceInfo(Map<String, Object> params);

	List<EgovMap> selectStockImgList(Map<String, Object> params);

	void updateStockInfo(Map<String, Object> params);

	void updateStockPriceInfo(Map<String, Object> params);

	void modifyServicePoint(Map<String, Object> params);

	void updateSalePriceUOM(Map<String, Object> params);

	void updateSalePriceInfo(Map<String, Object> params);

	void insertSalePriceInfo(Map<String, Object> params);
	List<EgovMap> srvMembershipList();

	int addServiceInfoGrid(Map<String, Object> param);

	int selectPacId();

	int selectExistPacId(Map<String, Object> param);

	int chcekCountPacId(Map<String, Object> param);

	int removeServiceInfoGrid(Map<String, Object> param);

	int selectBomId();

	int stockSTKIDsearch();

	int addFilterInfoGrid(Map<String, Object> param);

	int removeFilterInfoGrid(Map<String, Object> param);

	void insertSalePriceInfoHistory(Map<String, Object> smap);

	List<EgovMap> selectPriceHistoryInfo(Map<String, Object> param);

	List<EgovMap> selectStockCommisionSetting(Map<String, Object> param);

	void updateStockCommision(Map<String, Object> params);

	void nonvalueStockIns(Map<String, Object> params);

	void nonvalueItemPriceins(Map<String, Object> params);

	String nonvaluedItemCodeChk(Map<String, Object> params);

	List<EgovMap> selectCodeList();

	List<EgovMap> selectCodeList2();

	List<EgovMap> selectPriceInfo2(Map<String, Object> params);

	List<EgovMap> selectPriceHistoryInfo2(Map<String, Object> param);

	// Added by Hui Ding, 2020-06-22
	EgovMap selectStkCatType(Map<String, Object> params);

	List<EgovMap> getEosEomInfo(Map<String, Object> params);

	void modifyEosEomInfo(Map<String, Object> params);

	void insertSalePriceReqst(Map<String, Object> params);

	int countInPrgrsPrcApproval(Map<String, Object> params);

	void updatePriceReqstApproval(Map<String, Object> params);

	// to select stock code by stock id, Hui Ding. 02/10/2024
	String selectStkCodeById(Map<String, Object> params);


	/*//bom manual execution
	List<EgovMap> selectITF180Data();
	void insertBomMaster43M(Map<String, Object> map);
	void insertBomDetail44D(Map<String, Object> map);
	void updateITF180Status(Map<String, Object> map);
	List<EgovMap> selectRmvITF180Data();
	void updateDelete44D(Map<String, Object> map);

	// material
	List<EgovMap> selectITF140Data();
	List<EgovMap> selectCdcCode();
	void insertMaterialCall(Map<String, Object> map);
	void insertSCM08Record(Map<String, Object> map);
	void insertSCM17Record(Map<String, Object> map);
	void updateITF140Status(Map<String, Object> map);

	//FOB
	List<EgovMap> selectITF141Data();
	void deletePurchasePriceCall(Map<String, Object> map);
	void insertPurchasePriceCall(Map<String, Object> map);
	void updateITF141Status(Map<String, Object> map);

	// BL INFO
	List<EgovMap> selectITF160Data();
	void insertBLMaster83M(Map<String, Object> map);
	void insertBLMaster84D(Map<String, Object> map);
	void updateITF160Status(Map<String, Object> map);*/

}
