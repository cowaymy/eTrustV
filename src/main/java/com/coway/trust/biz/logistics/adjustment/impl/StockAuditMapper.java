package com.coway.trust.biz.logistics.adjustment.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : StockAuditMapper.java
 * @Description : Stock Audit Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 07.   KR-OHK        First creation
 * </pre>
 */
@Mapper("stockAuditMapper")
public interface StockAuditMapper {

	String getStockAuditNo();

	List<EgovMap> selectLocCodeList(Map<String, Object> params);

	int selectStockAuditListCnt(Map<String, Object> params);

	List<EgovMap> selectStockAuditList(Map<String, Object> params);

	List<EgovMap> selectStockAuditListExcel(Map<String, Object> params);

	List<EgovMap> selectStockAuditLocDetail(Map<String, Object> params);

	List<EgovMap> selectLocationList(Map<String, Object> params);

	List<EgovMap> selectItemList(Map<String, Object> params);

	EgovMap selectStockAuditDocInfo(Map<String, Object> params);

	List<EgovMap> selectStockAuditSelectedLocList(Map<String, Object> params);

	List<EgovMap> selectStockAuditSelectedItemList(Map<String, Object> params);

	List<EgovMap> selectLocInHisList(Map<String, Object> params);

	List<EgovMap> selectItemInHisList(Map<String, Object> params);

	EgovMap getMovQty(Map<String, Object> params);

	List<EgovMap> selectOtherGIGRItemList(Map<String, Object> params);

	List<EgovMap> getOtherGiGrReqstNo(Map<String, Object> params);

	EgovMap getOtherTargetReqstNo(Map<String, Object> params);

	EgovMap selectStockAuditDocStatus(Map<String, Object> params);

	EgovMap selectStockAuditAprvCnt(Map<String, Object> params);

	EgovMap selectStockAuditDocDtTime(Map<String, Object> params);

	EgovMap selectStockAuditProcInfo(Map<String, Object> params);

	int insertStockAuditDoc(Map<String, Object> params);

	int deleteStockAuditLoc(Map<String, Object> params);

	int insertStockAuditLoc(Map<String, Object> params);

	int deleteStockAuditItem(Map<String, Object> params);

	int insertStockAuditItem(Map<String, Object> params);

	int updateStockAuditDoc(Map<String, Object> params);

	int updateDocStusCode(Map<String, Object> params);

	int updateLocStusCode(Map<String, Object> params);

	int saveDocAppvInfo(Map<String, Object> params);

	int updateSysQty(Map<String, Object> params);

	int updateOtherTrnscType(Map<String, Object> params);

	int updateOtherGiGrReqstInfo(Map<String, Object> params);

	int insertLOG0047M(Map<String, Object> params);

	int insertLOG0048D(Map<String, Object> params);

	void SP_LOGISTIC_DELIVERY_SERIAL(Map<String, Object> params);

	void SP_LOGISTIC_BARCODE_SAVE_AD(Map<String, Object> params);
}
