/**
 *
 */
package com.coway.trust.biz.sales.ccp.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author HQIT-HUIDING
 * @date Jun 15, 2021
 *
 *
 */
@Mapper("ccpUploadAssignUserMapper")
public interface CcpUploadAssignUserMapper {

	int selectNextBatchId();
	int selectNextDetId();
	int insertUploadAssignUserMst(Map<String, Object> params);
	int insertUploadAssignUserDtl(Map<String, Object> params);
	List<EgovMap> selectUploadAssignUserList (Map<String, Object> params);
	List<EgovMap> selectUploadCcpUsertList (Map<String, Object> params);
	int updateUploadCcpUsertList (Map<String, Object> params);
	int updateCcpCalculationPageUser (Map<String, Object> params);
	List<EgovMap> selectUploadAssignUserDtlList (Map<String, Object> params);
	List<EgovMap> selectUploadReAssignUserDtlList (Map<String, Object> params);
	EgovMap selectViewHeaderInfo (Map<String, Object> params);
	void callBatchCcpAssignUser(Map<String, Object> params);

}
