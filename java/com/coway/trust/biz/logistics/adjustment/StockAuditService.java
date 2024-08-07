package com.coway.trust.biz.logistics.adjustment;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : StockAuditService.java
 * @Description : Stock Audit Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 07.   KR-OHK        First creation
 * </pre>
 */
public interface StockAuditService {

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

	List<EgovMap> selectOtherGIGRItemList(Map<String, Object> params);

	String createStockAuditDoc(Map<String, Object> params);

	EgovMap startStockAudit(Map<String, Object> params);

	String saveOtherGiGr(Map<String, Object> params);

	EgovMap selectStockAuditDocDtTime(Map<String, Object> params);

	void saveDocAppvInfo(Map<String, Object> params);

	void saveAppv2Info(Map<String, Object> params);

	void updateStockAuditAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
}
