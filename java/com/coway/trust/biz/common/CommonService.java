package com.coway.trust.biz.common;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.codehaus.jettison.json.JSONException;

import com.businessobjects.report.web.json.b;
import com.coway.trust.web.common.CommStatusVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@SuppressWarnings("unused")
public interface CommonService
{
    List<EgovMap> selectCodeList( Map<String, Object> params );

    List<EgovMap> selectCodeGroup( Map<String, Object> params );

    List<EgovMap> getCommonCodes( Map<String, Object> params );

    List<EgovMap> getAllCommonCodes( Map<String, Object> params );

    List<EgovMap> getCommonCodesPage( Map<String, Object> params );

    List<EgovMap> getBanks( Map<String, Object> params );

    List<EgovMap> getDefectMasters( Map<String, Object> params );

    List<EgovMap> getDefectDetails( Map<String, Object> params );

    List<EgovMap> getMalfunctionReasons( Map<String, Object> params );

    List<EgovMap> getMalfunctionCodes( Map<String, Object> params );

    List<EgovMap> getReasonCodes( Map<String, Object> params );

    List<EgovMap> getProductMasters( Map<String, Object> params );

    List<EgovMap> getProductDetails( Map<String, Object> params );

    int getCommonCodeTotalCount( Map<String, Object> params );

    List<EgovMap> selectI18NList();

    /************************** UserException ****************************/
    List<EgovMap> selectUserExceptionInfoList( Map<String, Object> params );

    List<EgovMap> selectUserExceptAdjustList( Map<String, Object> params );
    // int insertUserExceptAuthMapping(List<Object> addList, Integer updUserId);
    // int updateUserExceptAuthMapping(List<Object> addList, Integer updUserId);

    // int deleteUserExceptAuthMapping(List<Object> addList, Integer updUserId);
    /**
     * Insert, Update, Delete UserExceptional Auth Mapping List
     *
     * @Author KR-OHK
     * @Date 2019. 9. 10.
     * @param addList
     * @param udtList
     * @param delList
     * @param userId
     * @return
     */
    int saveUserExceptAuthMapping( List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId );

    /************************** Role Auth Mapping ****************************/
    List<EgovMap> selectRoleAuthMappingList( Map<String, Object> params );

    List<EgovMap> selectRoleAuthMappingBtn( Map<String, Object> params );

    List<EgovMap> selectRoleAuthMappingAdjustList( Map<String, Object> params );

    List<EgovMap> selectRoleAuthMappingPopUpList( Map<String, Object> params );
    // int insertRoleAuthMapping(List<Object> addList, Integer updUserId);
    // int updateRoleAuthMapping(List<Object> addList, Integer updUserId);

    // int deleteRoleAuthMapping(List<Object> addList, Integer updUserId);
    /**
     * Insert, Update, Delete Role Auth Mapping List
     *
     * @Author KR-OHK
     * @Date 2019. 9. 10.
     * @param addList
     * @param udtList
     * @param delList
     * @param userId
     * @return
     */
    int saveRoleAuthMapping( List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId );

    int deleteMGRRoleAuthMapping( List<Object> addList, Integer updUserId );

    /************************** Role Management ****************************/
    List<EgovMap> selectRoleList( Map<String, Object> params );

    /************************** Auth Management ****************************/
    List<EgovMap> selectAuthList( Map<String, Object> params );
    // int deleteAuth(List<Object> addList, Integer updUserId);
    // int insertAuth(List<Object> addList, Integer updUserId);

    // int updateAuth(List<Object> addList, Integer updUserId);
    /**
     * Insert, Update, Delete Auth Mapping List
     *
     * @Author KR-OHK
     * @Date 2019. 9. 10.
     * @param addList
     * @param udtList
     * @param delList
     * @param userId
     * @return
     */
    int saveAuth( List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId );

    /************************** Menu Management ****************************/
    List<EgovMap> selectMenuList( Map<String, Object> params );

    List<EgovMap> selectUpperMenuList( Map<String, Object> params );
    // int deleteMenuId(List<Object> addList, Integer updUserId);
    // int insertMenuCode(List<Object> addList, Integer updUserId);

    // int updateMenuCode(List<Object> addList, Integer updUserId);
    /**
     * Insert, Update, Delete Menu List
     *
     * @Author KR-OHK
     * @Date 2019. 9. 10.
     * @param addList
     * @param udtList
     * @param delList
     * @param userId
     * @return
     */
    int saveMenuId( List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId );

    /************************** Program Management ****************************/
    List<EgovMap> selectProgramList( Map<String, Object> params );

    List<EgovMap> selectPgmTranList( Map<String, Object> params );
    // int insertPgmId(List<Object> addList, Integer crtUserId);
    // int updatePgmId(List<Object> addList, Integer crtUserId);
    // int deletePgmId(List<Object> addList, Integer updUserId);

    // int updPgmIdTrans(List<Object> addList, Integer updUserId);
    /**
     * Insert, Update, Delete Program List
     *
     * @Author KR-OHK
     * @Date 2019. 9. 10.
     * @param addList
     * @param udtList
     * @param delList
     * @param userId
     * @return
     */
    int savePgmId( List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId );

    /**
     * Update Program Trans List
     *
     * @Author KR-OHK
     * @Date 2019. 9. 10.
     * @param addList
     * @param udtList
     * @param userId
     * @return
     */
    int savePgmIdTrans( List<Object> addList, List<Object> udtList, Integer userId );

    /************************** Status Code ****************************/
    // StatusCategory
    List<EgovMap> selectStatusCategoryList( Map<String, Object> params );

    // StatusCategory Code
    List<EgovMap> selectStatusCategoryCodeList( Map<String, Object> params );

    // StatusCode
    List<EgovMap> selectStatusCodeList( Map<String, Object> params );
    // insert StatusCategory
    // int insertStatusCategory(List<Object> addList, Integer crtUserId);
    // update StatusCategory
    // int updateStatusCategory(List<Object> addList, Integer crtUserId);

    // int deleteStatusCategoryCode(List<Object> addList, Integer crtUserId);
    /**
     * Insert, Update, Delete Status Category List
     *
     * @Author KR-OHK
     * @Date 2019. 9. 10.
     * @param addList
     * @param udtList
     * @param delList
     * @param userId
     * @return
     */
    int saveStatusCategory( List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId );

    int deleteStatusCategoryMst( List<Object> addList, Integer crtUserId );

    // insert StatusCode
    // int insertStatusCode(List<Object> addList, Integer crtUserId);
    // update StatusCode
    // int updateStatusCode(List<Object> addList, Integer crtUserId);
    /**
     * Insert, Update Status Code List
     *
     * @Author KR-OHK
     * @Date 2019. 9. 10.
     * @param addList
     * @param udtList
     * @param userId
     * @return
     */
    int saveStatusCode( List<Object> addList, List<Object> udtList, Integer userId );

    // insert Status Category Code
    int insertStatusCategoryCode( CommStatusVO formDataParameters, Integer crtUserId );

    // update Status Category Code
    int updateCategoryCodeYN( CommStatusVO formDataParameters, Integer crtUserId );
    // delete Status Category Code
    // int deleteCategoryCode(CommStatusVO formDataParameters, Integer crtUserId);

    /************************** Account Code ****************************/
    // Account Code
    int mergeAccountCode( Map<String, Object> params );

    int getAccCodeCount( Map<String, Object> params );

    List<EgovMap> getAccountCodeList( Map<String, Object> params );

    // Common Master Code
    List<EgovMap> getMstCommonCodeList( Map<String, Object> params );

    // Common Detail Code
    List<EgovMap> getDetailCommonCodeList( Map<String, Object> params );

    // void saveCodes(Map<String, Object> params);
    /**
     * Insert, Update Group Code list
     *
     * @Author KR-MIN
     * @Date 2019. 9. 5.
     * @param addList
     * @param crtUserId
     * @param udtList
     * @param updUserId
     * @return
     */
    int saveCommCodeGrid( List<Object> addList, Integer crtUserId, List<Object> udtList, Integer updUserId );
    /**
     * add Organization Detail Data
     *
     * @param addList
     * @return
     */
    // int addCommCodeGrid(List<Object> addList, Integer crtUserId);

    /**
     * update Organization Detail Data
     *
     * @param updateList
     * @return
     */
    // int udtCommCodeGrid(List<Object> updateList, Integer updUserId);
    /**
     * Insert, Update Code list
     *
     * @Author KR-MIN
     * @Date 2019. 9. 5.
     * @param addList
     * @param crtUserId
     * @param updateList
     * @param updUserId
     * @return
     */
    int saveDetailCommCodeGrid( List<Object> addList, Integer crtUserId, List<Object> updateList, Integer updUserId );
    /**
     * add Organization Detail Data
     *
     * @param addList
     * @return
     */
    // int addDetailCommCodeGrid(List<Object> addList, Integer crtUserId);

    /**
     * update Organization Detail Data
     *
     * @param updateList
     * @return
     */
    // int udtDetailCommCodeGrid(List<Object> updateList, Integer updUserId);
    /**
     * BranchCodeList
     *
     * @param params
     * @return
     */
    List<EgovMap> selectBranchList( Map<String, Object> params );

    /**
     * BranchCodeList
     *
     * @param grpCd
     * @return
     */
    List<EgovMap> selectBranchList( String grpCd );

    /**
     * BranchCodeList
     *
     * @param grpCd
     * @param separator
     * @return
     */
    List<EgovMap> selectBranchList( String grpCd, String separator );

    /**
     * Account 정보 조회 (크레딧 카드 리스트 / 은행 계좌 리스트)
     *
     * @param params
     * @return
     */
    List<EgovMap> getAccountList( Map<String, Object> params );

    List<EgovMap> getOrgCodeList( Map<String, Object> params );

    List<EgovMap> getDeptCodeList( Map<String, Object> params );

    List<EgovMap> getGrpCodeList( Map<String, Object> params );

    /**
     * select Bank Account Mapping
     *
     * @param params
     * @return
     */
    List<EgovMap> selectBankAccountList( Map<String, Object> params );

    /**
     * Branch ID로 User 정보 조회
     *
     * @param params
     * @return
     */
    List<EgovMap> getUsersByBranch( Map<String, Object> params );

    List<EgovMap> selectCountryList( Map<String, Object> params );

    List<EgovMap> selectStateList( Map<String, Object> params );

    List<EgovMap> selectAreaList( Map<String, Object> params );

    List<EgovMap> selectPostCdList( Map<String, Object> params );

    List<EgovMap> selectAddrSelCode( Map<String, Object> params );

    List<EgovMap> selectProductCodeList( Map<String, Object> params );

    List<EgovMap> selectInStckSelCodeList( Map<String, Object> params );

    List<EgovMap> selectStockLocationList( Map<String, Object> params );

    List<EgovMap> selectStockLocationList4( Map<String, Object> params );

    /**
     * IssuedBankList 조회
     *
     * @param
     * @return
     */
    List<EgovMap> selectBankList( Map<String, Object> param );

    EgovMap selectBrnchIdByPostCode( Map<String, Object> params );

    List<EgovMap> selectProductList();

    String selectDocNo( String docId );

    /**
     * Payment - Adjustment CN/DN : Adjustment Reason 정보 조회
     *
     * @param params
     * @return
     */
    List<EgovMap> selectAdjReasonList( Map<String, Object> params );

    String SysdateCall( Map<String, Object> params );

    List<EgovMap> selectReasonCodeList( Map<String, Object> params );

    List<EgovMap> getPublicHolidayList( Map<String, Object> params );

    /**
     * CodeList 조회
     *
     * @param grpCd
     * @return
     */
    List<EgovMap> selectCodeList( String grpCd );

    /**
     * CodeList 조회
     *
     * @param grpCd
     * @param orderVal
     * @return
     */
    List<EgovMap> selectCodeList( String grpCd, String orderVal );

    /**
     * select Homecare holiday list
     *
     * @Author KR-SH
     * @Date 2019. 11. 14.
     * @param params
     * @return
     */
    List<EgovMap> getHcHolidayList( Map<String, Object> params );

    // Homecare material category list in MDN
    List<EgovMap> selectHCMaterialCtgryList( Map<String, Object> params );

    // Homecare Product Size list
    List<EgovMap> selectProductSizeList( Map<String, Object> params );

    List<EgovMap> selectProductSizeListSearch( Map<String, Object> params );

    // Homecare Service Type list
    List<EgovMap> selectServiceTypeList( Map<String, Object> params );

    // Homecare Brand Type list
    List<EgovMap> selectBrandTypeList( Map<String, Object> params );

    // Homecare Unit Type list
    List<EgovMap> selectUnitTypeList( Map<String, Object> params );

    // Member Uniform list
    List<EgovMap> selectUniformSizeList( Map<String, Object> params );

    // Muslimah Scarft list
    List<EgovMap> selectMuslimahScarftList( Map<String, Object> params );

    // Inner Type list
    List<EgovMap> selectInnerTypeList( Map<String, Object> params );

    List<EgovMap> selectMemTypeCodeList( Map<String, Object> params );

    List<EgovMap> selectReasonCodeId( Map<String, Object> params );

    // Department
    List<EgovMap> selectDepartmentCode( Map<String, Object> params );

    // Cody list by department
    List<EgovMap> selectStockLocationListByDept( Map<String, Object> params );

    List<EgovMap> getMapProp( Map<String, Object> params );

    EgovMap getGeneralInstInfo( Map<String, Object> params );

    EgovMap getGeneralASInfo( Map<String, Object> params );

    EgovMap getGeneralPRInfo( Map<String, Object> params );

    EgovMap getGeneralHSInfo( Map<String, Object> params );

    List<EgovMap> selectTimePick();

    int selectSystemConfigurationParamValue( Map<String, Object> params );

    EgovMap selectSystemDefectConfiguration( Map<String, Object> params );

    List<EgovMap> selectFilterList( Map<String, Object> params );

    int getSstTaxRate();

    EgovMap getSstRelatedInfo();

    EgovMap reqEghlPmtLink( Map<String, Object> params ) throws IOException, JSONException;
}
