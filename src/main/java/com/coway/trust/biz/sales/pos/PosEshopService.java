package com.coway.trust.biz.sales.pos;

import java.text.ParseException;


import java.util.List;
import java.util.Map;


import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PosEshopService {

	EgovMap  selectItemPrice(Map<String, Object> params)throws Exception;

	Map<String, Object> insertPosEshopItemList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectItemList(Map<String, Object> params);

	Map<String, Object> removeEshopItemList(Map<String, Object> params) throws Exception;

	Map<String, Object> updatePosEshopItemList(Map<String, Object> params) throws Exception;

	void insUpdPosEshopShipping(Map<String, Object> params) throws Exception;

	List<EgovMap> selectShippingList(Map<String, Object> params);

	Map<String, Object> updatePosEshopShipping(Map<String, Object> params) throws Exception;

	List<EgovMap> selectItemImageList(Map<String, Object> params);

	List<EgovMap> selectCatalogList(Map<String, Object> params);

}
