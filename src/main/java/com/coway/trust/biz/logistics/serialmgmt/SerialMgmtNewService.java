/**
 * @author KR-JIN.
 **/
package com.coway.trust.biz.logistics.serialmgmt;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

public interface SerialMgmtNewService{

	// homecare serial save
	public List<Object> saveHPSerialCheck(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	// homecare serial cancel
	public void deleteHPSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception;
	public void allDeleteHPSerial(Map<String, ArrayList<Map<String, Object>>> params, SessionVO sessionVO) throws Exception;

}
