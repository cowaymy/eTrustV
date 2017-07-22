package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.payment.reconciliation.service.CRCStatementVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommonService {

	List<EgovMap> selectCodeList(Map<String, Object> params);

	List<EgovMap> selectI18NList();
	
	// Account Code
	int mergeAccountCode(Map<String, Object> params);
	
	int getAccCodeCount(Map<String, Object> params);
	
	List<EgovMap> getAccountCodeList(Map<String, Object> params);
	
	// Common Master Code
	List<EgovMap> getMstCommonCodeList(Map<String, Object> params);
	
	// Common Detail Code
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

    
    /**
     * BranchCodeList
     * @param params
     * @return
     */
    List<EgovMap> selectBranchList(Map<String, Object> params);

    
    /**
	 * Account 정보 조회 (크레딧 카드 리스트 / 은행 계좌 리스트)
	 * @param params
	 * @return
	 */
	List<EgovMap> getAccountList(Map<String, Object> params);
	
	 /**
	 * Branch ID로 User 정보 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> getUsersByBranch(Map<String, Object> params);
	
	List<EgovMap> selectAddrSelCode(Map<String, Object> params);
	
	List<EgovMap> selectProductCodeList();
	
}
