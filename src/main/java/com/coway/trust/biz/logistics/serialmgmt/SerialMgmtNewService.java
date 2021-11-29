/**
 * @author KR-JIN.
 **/
package com.coway.trust.biz.logistics.serialmgmt;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SerialMgmtNewService{

	// homecare serial save
	public List<Object> saveHPSerialCheck(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	// homecare serial cancel
	public void deleteHPSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception;
	public void allDeleteHPSerial(Map<String, ArrayList<Map<String, Object>>> params, SessionVO sessionVO) throws Exception;


	// Logistic serial save
	public List<Object> saveLogisticBarcode(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	// Logistic serial cancel
	public void deleteSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception;
	// Logistic Grid All Delete
	public void deleteGridSerial(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	// Logistic serial save
	public void saveSerialCode(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	public void reverseSerialCode(Map<String, Object> params) throws Exception;

	// Stock Audit serial delete
	public void deleteAdSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	// item check
	public EgovMap selectItemSerch(Map<String, Object> params) throws Exception;

	// Other GI/GR serial delete
	public void deleteOgOiSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	// box serial barcode
	public String selectBoxSerialBarcode(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	// Logistic save serial
	public void saveSerialNo(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	// Logistic clear serial
	public int clearSerialNo(Map<String, Object> params, SessionVO sessionVO) throws Exception;
}
