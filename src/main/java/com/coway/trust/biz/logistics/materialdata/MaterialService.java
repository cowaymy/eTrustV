/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.materialdata;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MaterialService {
	
	List<EgovMap>selectStockMstList(Map<String, Object> params);
	
	List<EgovMap>selectMaterialMstItemList(Map<String, Object> params);
	
	EgovMap selectMaterialMstItemTypeList();
	
	void updateMaterialItemType(List<Object> updateList);
	void insertMaterialItemType(Map<String, Object> params);
	void deleteMaterialItemType(Map<String, Object> params);
	
	
}