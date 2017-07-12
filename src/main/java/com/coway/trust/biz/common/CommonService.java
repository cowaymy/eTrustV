package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommonService {

	List<EgovMap> selectCodeList(Map<String, Object> params);

	List<EgovMap> selectI18NList();
	
	List<EgovMap> getMstCommonCodeList(Map<String, Object> params);
	
	List<EgovMap> getDetailCommonCodeList(Map<String, Object> params);
	
	void saveCodes(Map<String, Object> params);
	
    /**
     * add Organization Detail Data
     * @param addList 
     * @return
     */
    int addCommCodeGrid(List<Object> addList );
    
    /**
     * update Organization Detail Data
     * @param updateList
     * @return
     */
    int udtCommCodeGrid(List<Object> updateList);
    
    /**
     * add Organization Detail Data
     * @param addList 
     * @return
     */
    int addDetailCommCodeGrid(List<Object> addList );
    
    /**
     * update Organization Detail Data
     * @param updateList
     * @return
     */
    int udtDetailCommCodeGrid(List<Object> updateList);
	
}
