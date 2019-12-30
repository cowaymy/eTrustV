package com.coway.trust.biz.logistics.adjustment;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CountStockAuditService.java
 * @Description : Count-Stock Audit Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 07.   KR-OHK        First creation
 * </pre>
 */
public interface CountStockAuditService {

	int selectCountStockAuditListCnt(Map<String, Object> params);

	List<EgovMap> selectCountStockAuditList(Map<String, Object> params);

	List<EgovMap> selectCountStockAuditListExcel(Map<String, Object> params);

	EgovMap selectStockAuditDocInfo(Map<String, Object> params);

	List<EgovMap> selectStockAuditItemList(Map<String, Object> params);

	List<EgovMap> selectOtherReasonCodeList(Map<String, Object> params);

	EgovMap selectStockAuditLocDtTime(Map<String, Object> params);

	List<EgovMap> getAttachmentFileInfo(Map<String, Object> params);

	void saveCountStockAuditNew(Map<String, Object> params);

	void saveAppvInfo(Map<String, Object> params);

	void stockAuditSendSms(Map<String, Object> params);

}
