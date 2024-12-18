package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("ccpApprovalControlMapper")
public interface CcpApprovalControlMapper {


	List<EgovMap> selectProductControlList(Map<String, Object> params);

	void updateProductControl(Map<String, Object> params);

	List<EgovMap> selectChsControlList(Map<String, Object> params);

	void updateChsControl(Map<String, Object> params);

	List<EgovMap> selectScoreRangeControlList(Map<String, Object> params);

	 void updateScoreRangeControl(Map<String, Object> params);

	 EgovMap getScoreRangeControl(Map<String, Object> params);

	 void updateScoreRange(Map<String, Object> params);

	 void insertScoreRange(Map<String, Object> params);

	 List<EgovMap> selectUnitEntitleControlList(Map<String, Object> params);

	 void updateUnitEntitle(Map<String, Object> params);

	 void insertUnitEntitle(Map<String, Object> params);

	 List<EgovMap> selectProdEntitleControlList(Map<String, Object> params);

	 int getActiveProdEntitle(Map<String, Object> params);

	 void updateProdEntitle(Map<String, Object> params);

	 void insertProdEntitle(Map<String, Object> params);
}
