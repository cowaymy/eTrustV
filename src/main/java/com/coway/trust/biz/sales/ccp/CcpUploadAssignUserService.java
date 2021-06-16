/**
 *
 */
package com.coway.trust.biz.sales.ccp;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author HQIT-HUIDING
 * @date Jun 15, 2021
 *
 */
public interface CcpUploadAssignUserService {

	public int saveCsvUpload(Map<String, Object> master, List<Map<String, Object>> detailList);

	public List<EgovMap> selectCcpAssignUserMstList(Map<String, Object> params);

	public EgovMap selectCcpAssignUserDtlList(Map<String, Object> params);


}
