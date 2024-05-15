/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("commonMapper")
public interface CommonMapper
{
    List<EgovMap> selectCodeList( Map<String, Object> params );

    List<EgovMap> selectCodeGroup( Map<String, Object> params );

    // Homecare material category list in MDN
    List<EgovMap> selectHCMaterialCtgryList( Map<String, Object> params );

    List<EgovMap> selectCommonCodes( Map<String, Object> params );

    List<EgovMap> selectAllCommonCodes( Map<String, Object> params );

    List<EgovMap> selectCommonCodesPage( Map<String, Object> params );

    List<EgovMap> selectBanks( Map<String, Object> params );

    List<EgovMap> selectDefectMasters( Map<String, Object> params );

    List<EgovMap> selectDefectDetails( Map<String, Object> params );

    List<EgovMap> selectDefectDetailsHc( Map<String, Object> params );

    List<EgovMap> selectMalfunctionReasons( Map<String, Object> params );

    List<EgovMap> selectMalfunctionCodes( Map<String, Object> params );

    List<EgovMap> selectReasonCodes( Map<String, Object> params );

    List<EgovMap> selectProductMasters( Map<String, Object> params );

    List<EgovMap> selectProductDetails( Map<String, Object> params );

    int selectCommonCodeTotalCount( Map<String, Object> params );

    List<EgovMap> selectI18NList();

    /************************** User Exceptional Auth Mapping ****************************/
    List<EgovMap> selectUserExceptionInfoList( Map<String, Object> params );

    List<EgovMap> selectUserExceptAdjustList( Map<String, Object> params );

    int insertUserExceptAuthMapping( Map<String, Object> params );

    int updateUserExceptAuthMapping( Map<String, Object> params );

    int deleteUserExceptAuthMapping( Map<String, Object> params );

    /************************** Role Auth Mapping ****************************/
    List<EgovMap> selectRoleAuthMappingList( Map<String, Object> params );

    List<EgovMap> selectRoleAuthMappingBtn( Map<String, Object> params );

    List<EgovMap> selectRoleAuthMappingAdjustList( Map<String, Object> params );

    List<EgovMap> selectRoleAuthMappingPopUpList( Map<String, Object> params );

    int insertRoleAuthMapping( Map<String, Object> params );

    int updateRoleAuthMapping( Map<String, Object> params );

    int deleteRoleAuthMapping( Map<String, Object> params );

    int deleteMGRRoleAuthMapping( Map<String, Object> params );

    /************************** Role Management ****************************/
    List<EgovMap> selectRoleList( Map<String, Object> params );

    /************************** Auth Management ****************************/
    List<EgovMap> selectAuthList( Map<String, Object> params );

    int deleteAuth( Map<String, Object> params );

    int insertAuth( Map<String, Object> params );

    int updateAuth( Map<String, Object> params );

    /************************** Menu Management ****************************/
    // selectMenuList
    List<EgovMap> selectMenuList( Map<String, Object> params );

    List<EgovMap> selectUpperMenuList( Map<String, Object> params );

    int deleteMenuId( Map<String, Object> params );

    int insertMenuCode( Map<String, Object> params );

    int updateMenuCode( Map<String, Object> params );

    /************************** Program Management ****************************/
    List<EgovMap> selectProgramList( Map<String, Object> params );

    List<EgovMap> selectPgmTranList( Map<String, Object> params );

    int insertPgmId( Map<String, Object> params );

    int updatePgmId( Map<String, Object> params );

    int updPgmIdTrans( Map<String, Object> params );

    int deletePgmId( Map<String, Object> params );

    /************************** Status Code ****************************/
    // StatusCategory
    List<EgovMap> selectStatusCategoryList( Map<String, Object> params );

    // StatusCategory Code
    List<EgovMap> selectStatusCategoryCodeList( Map<String, Object> params );

    // StatusCode
    List<EgovMap> selectStatusCodeList( Map<String, Object> params );

    // StatusCode Category
    int insertStatusCategory( Map<String, Object> params );

    int updateStatusCategory( Map<String, Object> params );

    int deleteStatusCategoryCode( Map<String, Object> params );

    int deleteStatusCategoryMst( Map<String, Object> params );

    // StatusCode
    int insertStatusCode( Map<String, Object> params );

    int updateStatusCode( Map<String, Object> params );

    // Status Category Code
    int insertStatusCategoryCode( Map<String, Object> params );

    // Status Category Code Yn
    int updateCategoryCodeYN( Map<String, Object> params );

    // Status Category Code Yn
    int deleteCategoryCode( Map<String, Object> params );

    /************************ accountCodeList *************************/
    List<EgovMap> getAccountCodeList( Map<String, Object> params );

    int getAccCodeCount( Map<String, Object> params );

    int insertAccountCode( Map<String, Object> params );

    int mergeAccountCode( Map<String, Object> params );

    /***********************************/
    List<EgovMap> getOrgCodeList( Map<String, Object> params );

    List<EgovMap> getDeptCodeList( Map<String, Object> params );

    List<EgovMap> getGrpCodeList( Map<String, Object> params );

    /* general Code */
    List<EgovMap> getMstCommonCodeList( Map<String, Object> params );

    List<EgovMap> getDetailCommonCodeList( Map<String, Object> params );

    int addCommCodeGrid( Map<String, Object> addList );

    int updCommCodeGrid( Map<String, Object> updateList );

    int addDetailCommCodeGrid( Map<String, Object> addList );

    int updDetailCommCodeGrid( Map<String, Object> updateList );

    List<EgovMap> selectBranchList( Map<String, Object> params );

    List<EgovMap> selectProductSizeList( Map<String, Object> params );

    List<EgovMap> selectProductSizeListSearch( Map<String, Object> params );

    List<EgovMap> selectServiceTypeList( Map<String, Object> params );

    List<EgovMap> selectReasonCodeList( Map<String, Object> params );

    List<EgovMap> selectBrandTypeList( Map<String, Object> params );

    List<EgovMap> selectUnitTypeList( Map<String, Object> params );

    List<EgovMap> selectUniformSizeList( Map<String, Object> params );

    List<EgovMap> selectMuslimahScarftList( Map<String, Object> params );

    List<EgovMap> selectInnerTypeList( Map<String, Object> params );

    /**
     * Account 정보 조회 (크레딧 카드 리스트 / 은행 계좌 리스트)
     *
     * @param params
     * @return
     */
    List<EgovMap> getAccountList( Map<String, Object> params );

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
    List<EgovMap> selectBankList( Map<String, Object> params );

    /**
     * IssuedBank 조회
     *
     * @param param
     * @return
     */
    String selectBankInfoById( String param );

    /**
     * CodeDetail조회
     *
     * @param payItmCcTypeId
     * @return
     */
    String codeNameById( int payItmCcTypeId );

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

    /**
     * select Public holiday list Data from last year to next year
     *
     * @param params
     * @return
     */
    List<EgovMap> selectPublicHolidayList( Map<String, Object> params );

    /**
     * select Bank Account Mapping
     *
     * @param params
     * @return
     */
    List<EgovMap> selectBankAccountList( Map<String, Object> params );

    /**
     * select Homecare holiday list Data from last year to next year
     *
     * @param params
     * @return
     */
    List<EgovMap> getHcHolidayList( Map<String, Object> params );

    String getHomeCareGroupChkYn( Map<String, Object> params );

    // Added for Special Delivery CT enhancement by Hui Ding, 31-03-2020
    EgovMap selectSuperCtInd();

    EgovMap selectSuperCtCode();

    List<EgovMap> selectMemTypeCodeList( Map<String, Object> params );

    List<EgovMap> selectReasonCodeId( Map<String, Object> params );

    List<EgovMap> selectDepartmentCode( Map<String, Object> params );

    List<EgovMap> selectStockLocationListByDept( Map<String, Object> params );

    List<EgovMap> getMapProp( Map<String, Object> params );

    EgovMap getGeneralInstInfo( Map<String, Object> params );

    EgovMap getGeneralASInfo( Map<String, Object> params );

    EgovMap getGeneralPRInfo( Map<String, Object> params );

    EgovMap getGeneralHSInfo( Map<String, Object> params );

    List<EgovMap> selectTimePick();

    List<EgovMap> selectSystemConfigurationParamVal( Map<String, Object> params );

    int selectSystemConfigurationParamValue( Map<String, Object> params );

    EgovMap selectSystemDefectConfiguration( Map<String, Object> params );

    List<EgovMap> selectFilterList( Map<String, Object> params );

    String getSstTaxRate();

    EgovMap getSstRelatedInfo();

    int getReqsId ();

    void createTokenReqs ( Map<String, Object> params );

    void updateTokenResp ( Map<String, Object> params );

    void createPmtLinkReqs ( Map<String, Object> params );

    void updatePmtLinkResp ( Map<String, Object> params );
}
