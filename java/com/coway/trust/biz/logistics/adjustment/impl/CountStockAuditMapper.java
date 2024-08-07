package com.coway.trust.biz.logistics.adjustment.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CountStockAuditMapper.java
 * @Description : Count-Stock Audit Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 07.   KR-OHK        First creation
 * </pre>
 */
@Mapper("countStockAuditMapper")
public interface CountStockAuditMapper {

	int selectCountStockAuditListCnt(Map<String, Object> params);

	List<EgovMap> selectCountStockAuditList(Map<String, Object> params);

	List<EgovMap> selectCountStockAuditListExcel(Map<String, Object> params);

	EgovMap selectStockAuditDocInfo(Map<String, Object> params);

	List<EgovMap> selectStockAuditItemList(Map<String, Object> params);

	List<EgovMap> selectMobileNo(Map<String, Object> params);

	EgovMap selectStockAuditLocStatus(Map<String, Object> params);

	List<EgovMap> selectOtherReasonCodeList(Map<String, Object> params);

	EgovMap selectStockAuditLocDtTime(Map<String, Object> params);

	List<EgovMap> selectAttachmentFileInfo(Map<String, Object> params);

	int selectStockAuditProcCnt(Map<String, Object> params);

	String checkRejetCountStockAudit(Map<String, Object> params);

	int updateCountStockAuditLoc(Map<String, Object> params);

	int updateCountStockAuditItem(Map<String, Object> params);

	int updateCountStockAuditApprItem(Map<String, Object> params);

	int saveAppvInfo(Map<String, Object> params);

	int insertStockAuditLocHistory(Map<String, Object> params);

	int insertStockAuditItemHistory(Map<String, Object> params);

	int clear1stApprovalDoc(Map<String, Object> params);

	int clear1stApprovalLoc(Map<String, Object> params);

	int clear1stApprovalItem(Map<String, Object> params);

}
