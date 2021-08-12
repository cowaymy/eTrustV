/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.organization;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MaintainMovementService {
	List<EgovMap>selectMaintainMovementList(Map<String, Object> params);
	void insMaintainMovement(Map<String, Object> params);
}