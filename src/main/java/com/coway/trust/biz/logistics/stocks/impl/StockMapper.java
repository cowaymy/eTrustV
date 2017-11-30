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
	
	void modifyServicePoint(Map<String, Object> params);

	void updateSalePriceUOM(Map<String, Object> params);

	void updateSalePriceInfo(Map<String, Object> params);

	List<EgovMap> srvMembershipList();

	int addServiceInfoGrid(Map<String, Object> param);

	int selectPacId();

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
}
