package com.coway.trust.biz.sales.pos.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("posEshopMapper")
public interface PosEshopMapper {


	EgovMap  selectItemPrice(Map<String, Object> params);

	int getSeqSAL0321D();

	void insertEshopItemList(Map<String, Object> params);

	List<EgovMap> selectItemList(Map<String, Object> params);

	void removeEshopItemList(Map<String, Object> params);

	void updateEshopItemList(Map<String, Object> params);

	int getSeqSAL0322D();

	List<EgovMap> selectShippingList(Map<String, Object> params);

	void insertEshopShippingList(Map<String, Object> params);

	void removeEshopShippingList(Map<String, Object> params);

	void updatePosEshopShipping(Map<String, Object> params);

	List<EgovMap> selectItemImageList(Map<String, Object> params);

	List<EgovMap> selectCatalogList(Map<String, Object> params);



}
