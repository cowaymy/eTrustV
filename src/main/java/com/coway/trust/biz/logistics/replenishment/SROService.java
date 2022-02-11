/**
 * @author LEO
 */
package com.coway.trust.biz.logistics.replenishment;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SROService {

	List<EgovMap> sroItemMgntList(Map<String, Object> params);
	void  saveSroItemMgnt(Map<String, ArrayList<Object>> params, SessionVO sessionVO);
	void  deleteUpdateLOG0112D(List <EgovMap>params, SessionVO sessionVO);
	List<EgovMap> selectSroCodeList(Map<String, Object> params);
	List<EgovMap> sroMgmtList(Map<String, Object> params);
	List<EgovMap> sroMgmtDetailList(Map<String, Object> params);
	List<EgovMap> sroMgmtDetailListPopUp(Map<String, Object> params);
	String  saveSroMgmt(Map<String,Object > params, SessionVO sessionVO);


}
