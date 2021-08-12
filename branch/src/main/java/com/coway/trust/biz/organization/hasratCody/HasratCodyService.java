/**
 *
 */
package com.coway.trust.biz.organization.hasratCody;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.type.EmailTemplateType;
import com.coway.trust.cmmn.model.EmailVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author HQIT-HUIDING
 * @date Oct 12, 2020
 *
 */
public interface HasratCodyService {
	public List<EgovMap> selectHasratCodyList(Map<String, Object> params);
	public void insertHasratCody(Map<String, Object> params);
	public List<EgovMap> selectCodyBranchList(Map<String, Object> params);
	public EgovMap selectUserInfo (Map<String, Object> params);
	public boolean sendContentEmail(Map<String, Object> params) throws Exception;

}
