package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ccpExpB2BMapper")
public interface CcpExpB2BMapper {


	List<EgovMap> selectEXPERIANB2BList(Map<String, Object> params);

	List<EgovMap> getExpDetailList(Map<String, Object> params);

	EgovMap getResultRowForExpDisplay(Map<String, Object> params);

	int  savePromoB2BUpdate(Map<String, Object> params);

	int  savePromoB2BUpdate2(Map<String, Object> params);

	int  savePromoCHSUpdate(Map<String, Object> params);

	int  savePromoCHSUpdate2(Map<String, Object> params);

}
