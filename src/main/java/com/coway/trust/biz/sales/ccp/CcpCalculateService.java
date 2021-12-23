package com.coway.trust.biz.sales.ccp;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CcpCalculateService {

	List<EgovMap> getRegionCodeList(Map<String, Object> params) throws Exception;

	List<EgovMap> selectDscCodeList() throws Exception;

	List<EgovMap> selectReasonCodeFbList() throws Exception;

	List<EgovMap> selectCalCcpListAjax(Map<String, Object> params) throws Exception;

	EgovMap getLatestOrderLogByOrderID(Map<String, Object> params) throws Exception;

	List<EgovMap> getOrderUnitList (Map<String, Object> params) throws Exception;

	EgovMap getCalViewEditField(Map<String, Object> params) throws Exception;

	List<EgovMap> getCcpStusCodeList() throws Exception;

	List<EgovMap> getLoadIncomeRange(Map<String, Object> params) throws Exception;

	Map<String, Object> selectLoadIncomeRange(Map<String, Object> params) throws Exception;

	EgovMap selectCcpInfoByCcpId(Map<String, Object> params) throws Exception;

	EgovMap selectSalesManViewByOrdId(Map<String, Object> params) throws Exception;

	List<EgovMap> getCcpRejectCodeList() throws Exception;

	EgovMap countCallEntry(Map<String, Object> params) throws Exception;

	void calSave (Map<String, Object> params) throws Exception;

	Map<String, Object> getResultRowForCTOSDisplayForCCPCalculation(Map<String, Object> params) throws Exception;

	List<EgovMap> getCcpInstallationList(Map<String, Object> params)throws Exception;

	EgovMap getAux(Map<String, Object> params);

	EgovMap selectCcpInfoByOrderId(Map<String, Object> params) throws Exception;

	List<EgovMap> ccpEresubmitNewConfirm(Map<String, Object> params);

	List<EgovMap> ccpEresubmitList(Map<String, Object> params) throws Exception;

	void ccpEresubmitNewSave(Map<String, Object> params) throws Exception;

	void insertPreOrderAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs);

	void updatePreOrderAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params,List<String> seqs);

	void updateCcpEresubmitAttach(Map<String, Object> params) throws Exception;

	EgovMap selectCcpEresubmit(Map<String, Object> params) throws Exception;

	int getMemberID(Map<String, Object> params);

}
