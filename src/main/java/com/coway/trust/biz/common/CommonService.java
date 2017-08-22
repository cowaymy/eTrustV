package com.coway.trust.biz.common;

import java.util.List;
import java.util.Map;

import com.coway.trust.web.common.CommStatusVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@SuppressWarnings("unused")
public interface CommonService {

	List<EgovMap> selectCodeList(Map<String, Object> params);
	List<EgovMap> getCommonCodes(Map<String, Object> params);
	List<EgovMap> getAllCommonCodes(Map<String, Object> params);
	List<EgovMap> getCommonCodesPage(Map<String, Object> params);
	int getCommonCodeTotalCount(Map<String, Object> params);
	List<EgovMap> selectI18NList();


	/************************** Role Auth Mapping ****************************/
	List<EgovMap> selectRoleAuthMappingList(Map<String, Object> params);

	List<EgovMap> selectRoleAuthMappingBtn(Map<String, Object> params);
	
	List<EgovMap> selectRoleAuthMappingAdjustList(Map<String, Object> params);
	
	List<EgovMap> selectRoleAuthMappingPopUpList(Map<String, Object> params);
	
	int insertRoleAuthMapping(List<Object> addList, Integer updUserId);
	
	int updateRoleAuthMapping(List<Object> addList, Integer updUserId);
	
	int deleteRoleAuthMapping(List<Object> addList, Integer updUserId);
	
	/************************** Role Management ****************************/
	List<EgovMap> selectRoleList(Map<String, Object> params);

	/************************** Auth Management ****************************/
	List<EgovMap> selectAuthList(Map<String, Object> params);

	int deleteAuth(List<Object> addList, Integer updUserId);

	int insertAuth(List<Object> addList, Integer updUserId);

	int updateAuth(List<Object> addList, Integer updUserId);

	/************************** Menu Management ****************************/
	List<EgovMap> selectMenuList(Map<String, Object> params);
	List<EgovMap> selectUpperMenuList(Map<String, Object> params);

	int deleteMenuId(List<Object> addList, Integer updUserId);

	int insertMenuCode(List<Object> addList, Integer updUserId);

	int updateMenuCode(List<Object> addList, Integer updUserId);

	/************************** Program Management ****************************/
	List<EgovMap> selectProgramList(Map<String, Object> params);
	List<EgovMap> selectPgmTranList(Map<String, Object> params);

	int insertPgmId(List<Object> addList, Integer crtUserId);

	int updatePgmId(List<Object> addList, Integer crtUserId);

	int updPgmIdTrans(List<Object> addList, Integer updUserId);

	int deletePgmId(List<Object> addList, Integer updUserId);


	/************************** Status Code ****************************/
	// StatusCategory
	List<EgovMap> selectStatusCategoryList(Map<String, Object> params);

	// StatusCategory Code
	List<EgovMap> selectStatusCategoryCodeList(Map<String, Object> params);

	// StatusCode
	List<EgovMap> selectStatusCodeList(Map<String, Object> params);

	// insert StatusCategory
	int  insertStatusCategory(List<Object> addList, Integer crtUserId);
	// update StatusCategory
	int  updateStatusCategory(List<Object> addList, Integer crtUserId);

	// insert StatusCode
	int  insertStatusCode(List<Object> addList, Integer crtUserId);
	// update StatusCode
	int  updateStatusCode(List<Object> addList, Integer crtUserId);

	// insert Status Category Code
	int insertStatusCategoryCode(CommStatusVO formDataParameters, Integer crtUserId);
	// update Status Category Code
	int updateCategoryCodeYN(CommStatusVO formDataParameters, Integer crtUserId);

	/************************** Account Code ****************************/
	// Account Code
	int mergeAccountCode(Map<String, Object> params);

	int getAccCodeCount(Map<String, Object> params);

	List<EgovMap> getAccountCodeList(Map<String, Object> params);

	// Common Master Code
	List<EgovMap> getMstCommonCodeList(Map<String, Object> params);

	// Common Detail Code
	List<EgovMap> getDetailCommonCodeList(Map<String, Object> params);

	//void saveCodes(Map<String, Object> params);

    /**
     * add Organization Detail Data
     * @param addList
     * @return
     */
    int addCommCodeGrid(List<Object> addList, Integer crtUserId);

    /**
     * update Organization Detail Data
     * @param updateList
     * @return
     */
    int udtCommCodeGrid(List<Object> updateList, Integer updUserId);

    /**
     * add Organization Detail Data
     * @param addList
     * @return
     */
    int addDetailCommCodeGrid(List<Object> addList, Integer crtUserId);

    /**
     * update Organization Detail Data
     * @param updateList
     * @return
     */
    int udtDetailCommCodeGrid(List<Object> updateList, Integer updUserId);


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

	List<EgovMap> selectProductCodeList(Map<String, Object> params);

	List<EgovMap> selectInStckSelCodeList(Map<String, Object> params);

	List<EgovMap> selectStockLocationList(Map<String, Object> params);

	/**
	*  IssuedBankList 조회
	 * @param
	 * @return
	 */
	List<EgovMap> selectBankList();

	EgovMap selectBrnchIdByPostCode(Map<String, Object> params);


	List<EgovMap> selectProductList();


}
