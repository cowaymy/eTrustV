/*
 * \ * Copyright 2008-2009 the original author or authors.
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

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.springframework.beans.factory.annotation.Value;
import org.codehaus.jettison.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import org.codehaus.jettison.json.JSONObject;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommStatusFormVO;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.mlog.impl.MlogApiMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.CommStatusGridData;
import com.coway.trust.web.common.CommStatusVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("commonService")
public class CommonServiceImpl
  implements CommonService {
  private static final Logger LOGGER = LoggerFactory.getLogger( CommonServiceImpl.class );

  @Resource(name = "commonMapper")
  private CommonMapper commonMapper;

  @Resource(name = "MlogApiMapper")
  private MlogApiMapper MlogApiMapper;

  @Value("${eghl.pmtLink.merchId}")
  private String pmtLinkMerchId;

  @Value("${eghl.pmtLink.merchPassword}")
  private String pmtLinkMerchPassw;

  @Value("${eghl.pmtLink.authToken.url}")
  private String eGhlAuthTokenUrl;

  @Value("${eghl.pmtLink.pmtLink.url}")
  private String eGhlPmtLinkUrl;

  @Override
  public List<EgovMap> selectCodeList( Map<String, Object> params ) {
    return commonMapper.selectCodeList( params );
  }

  @Override
  public List<EgovMap> selectCodeGroup( Map<String, Object> params ) {
    return commonMapper.selectCodeGroup( params );
  }

  @Override
  public List<EgovMap> selectHCMaterialCtgryList( Map<String, Object> params ) {
    // Homecare material category list in MDN
    return commonMapper.selectHCMaterialCtgryList( params );
  }

  @Override
  public List<EgovMap> getCommonCodes( Map<String, Object> params ) {
    return commonMapper.selectCommonCodes( params );
  }

  @Override
  public List<EgovMap> getAllCommonCodes( Map<String, Object> params ) {
    return commonMapper.selectAllCommonCodes( params );
  }

  @Override
  public List<EgovMap> getCommonCodesPage( Map<String, Object> params ) {
    return commonMapper.selectCommonCodesPage( params );
  }

  @Override
  public List<EgovMap> getBanks( Map<String, Object> params ) {
    return commonMapper.selectBanks( params );
  }

  @Override
  public List<EgovMap> getDefectMasters( Map<String, Object> params ) {
    return commonMapper.selectDefectMasters( params );
  }

  @Override
  public List<EgovMap> getDefectDetails( Map<String, Object> params ) {
    String homeCareGroupChkYn = commonMapper.getHomeCareGroupChkYn( params );
    if ( "Y".equals( homeCareGroupChkYn ) ) {
      return commonMapper.selectDefectDetailsHc( params );
    }
    else {
      return commonMapper.selectDefectDetails( params );
    }
  }

  @Override
  public List<EgovMap> getMalfunctionReasons( Map<String, Object> params ) {
    return commonMapper.selectMalfunctionReasons( params );
  }

  @Override
  public List<EgovMap> getMalfunctionCodes( Map<String, Object> params ) {
    return commonMapper.selectMalfunctionCodes( params );
  }

  @Override
  public List<EgovMap> getReasonCodes( Map<String, Object> params ) {
    return commonMapper.selectReasonCodes( params );
  }

  @Override
  public List<EgovMap> getProductMasters( Map<String, Object> params ) {
    return commonMapper.selectProductMasters( params );
  }

  @Override
  public List<EgovMap> getProductDetails( Map<String, Object> params ) {
    return commonMapper.selectProductDetails( params );
  }

  @Override
  public int getCommonCodeTotalCount( Map<String, Object> params ) {
    return commonMapper.selectCommonCodeTotalCount( params );
  }

  @Override
  public List<EgovMap> selectI18NList() {
    return commonMapper.selectI18NList();
  }

  /************************** User Exceptional Auth Mapping ****************************/
  @Override
  public List<EgovMap> selectUserExceptionInfoList( Map<String, Object> params ) {
    return commonMapper.selectUserExceptionInfoList( params );
  }

  @Override
  public List<EgovMap> selectUserExceptAdjustList( Map<String, Object> params ) {
    return commonMapper.selectUserExceptAdjustList( params );
  }

  /*
   * @Override public int insertUserExceptAuthMapping(List<Object> addList, Integer crtUserId) { int
   * saveCnt = 0; for (Object obj : addList) { ((Map<String, Object>) obj).put("crtUserId",
   * crtUserId); ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug(
   * " >>>>> insertUserExceptAuthMapping "); LOGGER.debug(" userId : {}", ((Map<String, Object>)
   * obj).get("userId")); // String tmpStr = (String) ((Map<String, Object>) obj).get("hidden"); //
   * ((Map<String, Object>) obj).put("userId", ((Map<String, Object>) obj).get("userId") );
   * saveCnt++; commonMapper.insertUserExceptAuthMapping((Map<String, Object>) obj); } return
   * saveCnt; }
   * @Override public int updateUserExceptAuthMapping(List<Object> updList, Integer crtUserId) { int
   * saveCnt = 0; for (Object obj : updList) { ((Map<String, Object>) obj).put("crtUserId",
   * crtUserId); ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug(
   * " >>>>> updateUserExceptAuthMapping "); // LOGGER.debug(" hidden : {}", ((Map<String, Object>)
   * obj).get("hidden")); ((Map<String, Object>) // obj).put("userId", ((Map<String, Object>)
   * obj).get("hidden") ); LOGGER.debug("UserId : {}", ((Map<String, Object>) obj).get("userId"));
   * saveCnt++; commonMapper.updateUserExceptAuthMapping((Map<String, Object>) obj); } return
   * saveCnt; }
   * @Override public int deleteUserExceptAuthMapping(List<Object> delList, Integer crtUserId) { int
   * delCnt = 0; for (Object obj : delList) { ((Map<String, Object>) obj).put("crtUserId",
   * crtUserId); ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug(
   * " >>>>> deleteUserExceptAuthMapping "); LOGGER.debug("UserId : {}", ((Map<String, Object>)
   * obj).get("userId")); delCnt++; commonMapper.deleteUserExceptAuthMapping((Map<String, Object>)
   * obj); } return delCnt; }
   */
  /**
   * Insert, Update, Delete UserExceptional Auth Mapping List :
   * insertUserExceptAuthMapping+updateUserExceptAuthMapping+deleteUserExceptAuthMapping => Change
   * One Transaction
   *
   * @Author KR-OHK
   * @Date 2019. 9. 10.
   * @param addList
   * @param udtList
   * @param delList
   * @param userId
   * @return
   * @see com.coway.trust.biz.common.CommonService#saveUserExceptAuthMapping(java.util.List,
   *      java.util.List, java.util.List, java.lang.Integer)
   */
  @SuppressWarnings("unchecked")
  @Override
  public int saveUserExceptAuthMapping( List<Object> addList, List<Object> udtList, List<Object> delList,
                                        Integer userId ) {
    int saveCnt = 0;
    // insert
    for ( Object obj : addList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> saveUserExceptAuthMapping insertUserExceptAuthMapping " );
      LOGGER.debug( " userId : {}", ( (Map<String, Object>) obj ).get( "userId" ) );
      saveCnt++;
      commonMapper.insertUserExceptAuthMapping( (Map<String, Object>) obj );
    }
    // update
    for ( Object obj : udtList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> saveUserExceptAuthMapping updateUserExceptAuthMapping " );
      /*
       * LOGGER.debug(" hidden : {}", ((Map<String, Object>) obj).get("hidden")); ((Map<String,
       * Object>) obj).put("userId", ((Map<String, Object>) obj).get("hidden") );
       */
      LOGGER.debug( "UserId : {}", ( (Map<String, Object>) obj ).get( "userId" ) );
      saveCnt++;
      commonMapper.updateUserExceptAuthMapping( (Map<String, Object>) obj );
    }
    // delete
    for ( Object obj : delList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> saveUserExceptAuthMapping deleteUserExceptAuthMapping " );
      LOGGER.debug( "UserId : {}", ( (Map<String, Object>) obj ).get( "userId" ) );
      saveCnt++;
      commonMapper.deleteUserExceptAuthMapping( (Map<String, Object>) obj );
    }
    return saveCnt;
  }

  /************************** Role Auth Mapping ****************************/
  @Override
  public List<EgovMap> selectRoleAuthMappingPopUpList( Map<String, Object> params ) {
    return commonMapper.selectRoleAuthMappingPopUpList( params );
  }

  @Override
  public List<EgovMap> selectRoleAuthMappingBtn( Map<String, Object> params ) {
    return commonMapper.selectRoleAuthMappingBtn( params );
  }

  @Override
  public List<EgovMap> selectRoleAuthMappingAdjustList( Map<String, Object> params ) {
    return commonMapper.selectRoleAuthMappingAdjustList( params );
  }

  @Override
  public List<EgovMap> selectRoleAuthMappingList( Map<String, Object> params ) {
    return commonMapper.selectRoleAuthMappingList( params );
  }

  /*
   * @Override public int insertRoleAuthMapping(List<Object> addList, Integer crtUserId) { int
   * saveCnt = 0; for (Object obj : addList) { ((Map<String, Object>) obj).put("crtUserId",
   * crtUserId); ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug(
   * " >>>>> insertRoleAuthMapping "); LOGGER.debug(" hidden : {}", ((Map<String, Object>)
   * obj).get("hidden")); String tmpStr = (String) ((Map<String, Object>) obj).get("hidden");
   * saveCnt++; commonMapper.insertRoleAuthMapping((Map<String, Object>) obj); } return saveCnt; }
   * @Override public int updateRoleAuthMapping(List<Object> updList, Integer crtUserId) { int
   * saveCnt = 0; for (Object obj : updList) { ((Map<String, Object>) obj).put("crtUserId",
   * crtUserId); ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug(
   * " >>>>> updateRoleAuthMapping "); LOGGER.debug(" authCode : {}", ((Map<String, Object>)
   * obj).get("authCode")); saveCnt++; commonMapper.updateRoleAuthMapping((Map<String, Object>)
   * obj); } return saveCnt; }
   * @Override public int deleteRoleAuthMapping(List<Object> delList, Integer crtUserId) { int
   * delCnt = 0; for (Object obj : delList) { ((Map<String, Object>) obj).put("crtUserId",
   * crtUserId); ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug(
   * " >>>>> deleteRoleAuthMapping "); LOGGER.debug(" authCode : {}", ((Map<String, Object>)
   * obj).get("authCode")); delCnt++; if (((Map<String, Object>) obj).get("authCode").equals("INT"))
   * { LOGGER.debug(" deleteRoleAuthMapping_MGR_AuthCode : {}" , ((Map<String, Object>)
   * obj).get("authCode")); ((Map<String, Object>) obj).put("oldRoleId",
   * String.valueOf(((Map<String, Object>) obj).get("oldRoleId")));
   * commonMapper.deleteMGRRoleAuthMapping((Map<String, Object>) obj); } else {
   * commonMapper.deleteRoleAuthMapping((Map<String, Object>) obj); } } return delCnt; }
   */
  /**
   * Insert, Update, Delete Role Auth Mapping List :
   * insertRoleAuthMapping+updateRoleAuthMapping+deleteRoleAuthMapping => Change One Transaction
   *
   * @Author KR-OHK
   * @Date 2019. 9. 10.
   * @param addList
   * @param udtList
   * @param delList
   * @param userId
   * @return
   * @see com.coway.trust.biz.common.CommonService#saveRoleAuthMapping(java.util.List,
   *      java.util.List, java.util.List, java.lang.Integer)
   */
  @SuppressWarnings("unchecked")
  @Override
  public int saveRoleAuthMapping( List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId ) {
    int saveCnt = 0;
    // insert
    for ( Object obj : addList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> saveRoleAuthMapping insertRoleAuthMapping " );
      LOGGER.debug( " hidden : {}", ( (Map<String, Object>) obj ).get( "hidden" ) );
      String tmpStr = (String) ( (Map<String, Object>) obj ).get( "hidden" );
      saveCnt++;
      commonMapper.insertRoleAuthMapping( (Map<String, Object>) obj );
    }
    // update
    for ( Object obj : udtList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> saveRoleAuthMapping updateRoleAuthMapping " );
      LOGGER.debug( " authCode : {}", ( (Map<String, Object>) obj ).get( "authCode" ) );
      saveCnt++;
      commonMapper.updateRoleAuthMapping( (Map<String, Object>) obj );
    }
    // delete
    for ( Object obj : delList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> saveRoleAuthMapping deleteRoleAuthMapping " );
      LOGGER.debug( " authCode : {}", ( (Map<String, Object>) obj ).get( "authCode" ) );
      saveCnt++;
      if ( ( (Map<String, Object>) obj ).get( "authCode" ).equals( "INT" ) ) {
        LOGGER.debug( " >>>>> saveRoleAuthMapping deleteRoleAuthMapping_MGR_AuthCode : {}",
                      ( (Map<String, Object>) obj ).get( "authCode" ) );
        ( (Map<String, Object>) obj ).put( "oldRoleId",
                                           String.valueOf( ( (Map<String, Object>) obj ).get( "oldRoleId" ) ) );
        commonMapper.deleteMGRRoleAuthMapping( (Map<String, Object>) obj );
      }
      else {
        commonMapper.deleteRoleAuthMapping( (Map<String, Object>) obj );
      }
    }
    return saveCnt;
  }

  @Override
  public int deleteMGRRoleAuthMapping( List<Object> delList, Integer crtUserId ) {
    int delCnt = 0;
    for ( Object obj : delList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", crtUserId );
      ( (Map<String, Object>) obj ).put( "updUserId", crtUserId );
      LOGGER.debug( " >>>>> deleteRoleAuthMapping_MGR" );
      LOGGER.debug( " hidden : {}", ( (Map<String, Object>) obj ).get( "hidden" ) );
      delCnt++;
      commonMapper.deleteMGRRoleAuthMapping( (Map<String, Object>) obj );
    }
    return delCnt;
  }

  /************************** Role Management ****************************/
  @Override
  public List<EgovMap> selectRoleList( Map<String, Object> params ) {
    return commonMapper.selectRoleList( params );
  }

  /************************** Authorization Management ****************************/
  @Override
  public List<EgovMap> selectAuthList( Map<String, Object> params ) {
    return commonMapper.selectAuthList( params );
  }

  /*
   * @Override public int insertAuth(List<Object> addList, Integer crtUserId) { int saveCnt = 0; for
   * (Object obj : addList) { ((Map<String, Object>) obj).put("crtUserId", crtUserId); ((Map<String,
   * Object>) obj).put("updUserId", crtUserId); LOGGER.debug(" >>>>> insertAuth "); LOGGER.debug(
   * " hidden : {}", ((Map<String, Object>) obj).get("hidden")); String tmpStr = (String)
   * ((Map<String, Object>) obj).get("hidden"); saveCnt++; commonMapper.insertAuth((Map<String,
   * Object>) obj); } return saveCnt; }
   * @Override public int updateAuth(List<Object> updList, Integer crtUserId) { int saveCnt = 0; for
   * (Object obj : updList) { ((Map<String, Object>) obj).put("crtUserId", crtUserId); ((Map<String,
   * Object>) obj).put("updUserId", crtUserId); LOGGER.debug(" >>>>> updateAuth "); LOGGER.debug(
   * " authCode : {}", ((Map<String, Object>) obj).get("authCode")); saveCnt++;
   * commonMapper.updateAuth((Map<String, Object>) obj); } return saveCnt; }
   * @Override public int deleteAuth(List<Object> delList, Integer crtUserId) { int delCnt = 0; for
   * (Object obj : delList) { ((Map<String, Object>) obj).put("crtUserId", crtUserId); ((Map<String,
   * Object>) obj).put("updUserId", crtUserId); LOGGER.debug( " >>>>> deleteAuthCode ");
   * LOGGER.debug(" authCode : {}", ((Map<String, Object>) obj).get("authCode")); delCnt++;
   * commonMapper.deleteAuth((Map<String, Object>) obj); } return delCnt; }
   */
  /**
   * Insert, Update, Delete Auth List : insertAuth+updateAuth+deleteAuth => Change One Transaction
   *
   * @Author KR-OHK
   * @Date 2019. 9. 10.
   * @param addList
   * @param udtList
   * @param delList
   * @param userId
   * @return
   * @see com.coway.trust.biz.common.CommonService#saveAuth(java.util.List, java.util.List,
   *      java.util.List, java.lang.Integer)
   */
  @SuppressWarnings("unchecked")
  @Override
  public int saveAuth( List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId ) {
    int saveCnt = 0;
    // insert
    for ( Object obj : addList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> saveAuth insertAuth " );
      LOGGER.debug( " hidden : {}", ( (Map<String, Object>) obj ).get( "hidden" ) );
      String tmpStr = (String) ( (Map<String, Object>) obj ).get( "hidden" );
      saveCnt++;
      commonMapper.insertAuth( (Map<String, Object>) obj );
    }
    // update
    for ( Object obj : udtList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> saveAuth updateAuth " );
      LOGGER.debug( " authCode : {}", ( (Map<String, Object>) obj ).get( "authCode" ) );
      saveCnt++;
      commonMapper.updateAuth( (Map<String, Object>) obj );
    }
    // delete
    for ( Object obj : delList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> saveAuth deleteAuthCode " );
      LOGGER.debug( " authCode : {}", ( (Map<String, Object>) obj ).get( "authCode" ) );
      saveCnt++;
      commonMapper.deleteAuth( (Map<String, Object>) obj );
    }
    return saveCnt;
  }

  /************************** Menu Management ****************************/
  @Override
  public List<EgovMap> selectMenuList( Map<String, Object> params ) {
    return commonMapper.selectMenuList( params );
  }

  /*
   * @Override public int deleteMenuId(List<Object> delList, Integer crtUserId) { int delCnt = 0;
   * for (Object obj : delList) { ((Map<String, Object>) obj).put("crtUserId", crtUserId);
   * ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug(" >>>>> deleteMenuId " );
   * LOGGER.debug(" menuId : {}", ((Map<String, Object>) obj).get("menuCode")); delCnt++;
   * commonMapper.deleteMenuId((Map<String, Object>) obj); } return delCnt; }
   * @Override public int insertMenuCode(List<Object> addList, Integer crtUserId) { int saveCnt = 0;
   * for (Object obj : addList) { ((Map<String, Object>) obj).put("crtUserId", crtUserId);
   * ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug( " >>>>> insertMenuCode "
   * ); LOGGER.debug(" menuCode : {}", ((Map<String, Object>) obj).get("menuCode")); saveCnt++;
   * commonMapper.insertMenuCode((Map<String, Object>) obj); } return saveCnt; }
   * @Override public int updateMenuCode(List<Object> updList, Integer crtUserId) { int saveCnt = 0;
   * for (Object obj : updList) { ((Map<String, Object>) obj).put("crtUserId", crtUserId);
   * ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug( " >>>>> updateMenuCode "
   * ); LOGGER.debug(" menuCode : {}", ((Map<String, Object>) obj).get("menuCode")); saveCnt++;
   * commonMapper.updateMenuCode((Map<String, Object>) obj); } return saveCnt; }
   */
  /**
   * Insert, Update, Delete Menu List : insertMenuCode+updateMenuCode+deleteMenuId => Change One
   * Transaction
   *
   * @Author KR-OHK
   * @Date 2019. 9. 10.
   * @param addList
   * @param udtList
   * @param delList
   * @param userId
   * @return
   * @see com.coway.trust.biz.common.CommonService#saveMenuId(java.util.List, java.util.List,
   *      java.util.List, java.lang.Integer)
   */
  @SuppressWarnings("unchecked")
  @Override
  public int saveMenuId( List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId ) {
    int saveCnt = 0;
    // insert
    for ( Object obj : addList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> saveMenuId insertMenuCode " );
      LOGGER.debug( " menuCode : {}", ( (Map<String, Object>) obj ).get( "menuCode" ) );
      saveCnt++;
      commonMapper.insertMenuCode( (Map<String, Object>) obj );
    }
    // update
    for ( Object obj : udtList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> saveMenuId updateMenuCode " );
      LOGGER.debug( " menuCode : {}", ( (Map<String, Object>) obj ).get( "menuCode" ) );
      saveCnt++;
      commonMapper.updateMenuCode( (Map<String, Object>) obj );
    }
    // delete
    for ( Object obj : delList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> saveMenuId deleteMenuId " );
      LOGGER.debug( " menuId : {}", ( (Map<String, Object>) obj ).get( "menuCode" ) );
      saveCnt++;
      commonMapper.deleteMenuId( (Map<String, Object>) obj );
    }
    return saveCnt;
  }

  /************************** Program Management ****************************/
  @Override
  public List<EgovMap> selectProgramList( Map<String, Object> params ) {
    return commonMapper.selectProgramList( params );
  }

  @Override
  public List<EgovMap> selectPgmTranList( Map<String, Object> params ) {
    return commonMapper.selectPgmTranList( params );
  }
  /*
   * @Override public int deletePgmId(List<Object> delList, Integer crtUserId) { int delCnt = 0; for
   * (Object obj : delList) { ((Map<String, Object>) obj).put("crtUserId", crtUserId); ((Map<String,
   * Object>) obj).put("updUserId", crtUserId); if (String.valueOf(((Map<String, Object>)
   * obj).get("pgmCode")).length() == 0 || "null".equals(String.valueOf(((Map<String, Object>)
   * obj).get("pgmCode")))) { continue; } LOGGER.debug(" >>>>> deletePgmId "); LOGGER.debug(
   * " pgmCode : {}", ((Map<String, Object>) obj).get("pgmCode")); delCnt++;
   * commonMapper.deletePgmId((Map<String, Object>) obj); } return delCnt; }
   * @Override public int insertPgmId(List<Object> addList, Integer crtUserId) { int saveCnt = 0;
   * for (Object obj : addList) { ((Map<String, Object>) obj).put("crtUserId", crtUserId);
   * ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug(" >>>>> InsertPgmId ");
   * LOGGER.debug(" orgCode : {}", ((Map<String, Object>) obj).get("orgCode")); LOGGER.debug(
   * " pgmName : {}", ((Map<String, Object>) obj).get("pgmName")); LOGGER.debug(" pgmPath : {}",
   * ((Map<String, Object>) obj).get("pgmPath")); LOGGER.debug(" pgmDesc : {}", ((Map<String,
   * Object>) obj).get("pgmDesc")); saveCnt++; commonMapper.insertPgmId((Map<String, Object>) obj);
   * } return saveCnt; }
   * @Override public int updatePgmId(List<Object> updList, Integer crtUserId) { int saveCnt = 0;
   * for (Object obj : updList) { ((Map<String, Object>) obj).put("crtUserId", crtUserId);
   * ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug(
   * " ========= updPgmIdTrans ============== "); LOGGER.debug(" pgmCode : {}", ((Map<String,
   * Object>) obj).get("pgmCode")); LOGGER.debug(" pgmName : {}", ((Map<String, Object>)
   * obj).get("pgmName")); LOGGER.debug(" pgmPath : {}", ((Map<String, Object>)
   * obj).get("pgmPath")); LOGGER.debug(" pgmDesc : {}", ((Map<String, Object>)
   * obj).get("pgmDesc")); saveCnt++; commonMapper.updatePgmId((Map<String, Object>) obj); } return
   * saveCnt; }
   * @Override public int updPgmIdTrans(List<Object> addList, Integer crtUserId) { int saveCnt = 0;
   * for (Object obj : addList) { ((Map<String, Object>) obj).put("crtUserId", crtUserId);
   * ((Map<String, Object>) obj).put("updUserId", crtUserId); if (String.valueOf(((Map<String,
   * Object>) obj).get("pgmCode")).length() == 0) { continue; } LOGGER.debug(
   * " ========= updPgmIdTrans ============== "); LOGGER.debug(" pgmCode : {}", ((Map<String,
   * Object>) obj).get("pgmCode")); LOGGER.debug(" pgmName : {}", ((Map<String, Object>)
   * obj).get("pgmName")); LOGGER.debug(" funcView : {}", ((Map<String, Object>)
   * obj).get("funcView")); LOGGER.debug(" funcChng : {}", ((Map<String, Object>)
   * obj).get("funcChng")); LOGGER.debug(" funcPrt : {}", ((Map<String, Object>)
   * obj).get("funcPrt")); LOGGER.debug(" funcUserDfn1 : {}", ((Map<String, Object>)
   * obj).get("funcUserDfn1")); LOGGER.debug(" descUserDfn1 : {}", ((Map<String, Object>)
   * obj).get("descUserDfn1")); LOGGER.debug(" funcUserDfn2 : {}", ((Map<String, Object>)
   * obj).get("funcUserDfn2")); LOGGER.debug(" descUserDfn2 : {}", ((Map<String, Object>)
   * obj).get("descUserDfn2")); LOGGER.debug(" funcUserDfn3 : {}", ((Map<String, Object>)
   * obj).get("funcUserDfn3")); LOGGER.debug(" descUserDfn3 : {}", ((Map<String, Object>)
   * obj).get("descUserDfn3")); LOGGER.debug(" funcUserDfn4 : {}", ((Map<String, Object>)
   * obj).get("funcUserDfn4")); LOGGER.debug(" descUserDfn4 : {}", ((Map<String, Object>)
   * obj).get("descUserDfn4")); LOGGER.debug(" funcUserDfn5 : {}", ((Map<String, Object>)
   * obj).get("funcUserDfn5")); LOGGER.debug(" descUserDfn5 : {}", ((Map<String, Object>)
   * obj).get("descUserDfn5")); saveCnt++; commonMapper.updPgmIdTrans((Map<String, Object>) obj); }
   * return saveCnt; }
   */

  /**
   * Insert, Update, Delete Program List : insertPgmId+updatePgmId+deletePgmId => Change One
   * Transaction
   *
   * @Author KR-OHK
   * @Date 2019. 9. 10.
   * @param addList
   * @param udtList
   * @param delList
   * @param userId
   * @return
   * @see com.coway.trust.biz.common.CommonService#savePgmId(java.util.List, java.util.List,
   *      java.util.List, java.lang.Integer)
   */
  @SuppressWarnings("unchecked")
  @Override
  public int savePgmId( List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId ) {
    int saveCnt = 0;
    // insert
    for ( Object obj : addList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> savePgmId InsertPgmId " );
      LOGGER.debug( " orgCode : {}", ( (Map<String, Object>) obj ).get( "orgCode" ) );
      LOGGER.debug( " pgmName : {}", ( (Map<String, Object>) obj ).get( "pgmName" ) );
      LOGGER.debug( " pgmPath : {}", ( (Map<String, Object>) obj ).get( "pgmPath" ) );
      LOGGER.debug( " pgmDesc : {}", ( (Map<String, Object>) obj ).get( "pgmDesc" ) );
      saveCnt++;
      commonMapper.insertPgmId( (Map<String, Object>) obj );
    }
    // update
    for ( Object obj : udtList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> savePgmId updPgmIdTrans " );
      LOGGER.debug( " pgmCode : {}", ( (Map<String, Object>) obj ).get( "pgmCode" ) );
      LOGGER.debug( " pgmName : {}", ( (Map<String, Object>) obj ).get( "pgmName" ) );
      LOGGER.debug( " pgmPath : {}", ( (Map<String, Object>) obj ).get( "pgmPath" ) );
      LOGGER.debug( " pgmDesc : {}", ( (Map<String, Object>) obj ).get( "pgmDesc" ) );
      saveCnt++;
      commonMapper.updatePgmId( (Map<String, Object>) obj );
    }
    // delete
    for ( Object obj : delList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      if ( String.valueOf( ( (Map<String, Object>) obj ).get( "pgmCode" ) ).length() == 0
        || "null".equals( String.valueOf( ( (Map<String, Object>) obj ).get( "pgmCode" ) ) ) ) {
        continue;
      }
      LOGGER.debug( " >>>>> savePgmId deletePgmId " );
      LOGGER.debug( " pgmCode : {}", ( (Map<String, Object>) obj ).get( "pgmCode" ) );
      saveCnt++;
      commonMapper.deletePgmId( (Map<String, Object>) obj );
    }
    return saveCnt;
  }

  /**
   * Update Program Trans List : updatePgmIdTrans => Change One Transaction
   *
   * @Author KR-OHK
   * @Date 2019. 9. 10.
   * @param addList
   * @param udtList
   * @param userId
   * @return
   * @see com.coway.trust.biz.common.CommonService#savePgmIdTrans(java.util.List, java.util.List,
   *      java.lang.Integer)
   */
  @SuppressWarnings("unchecked")
  @Override
  public int savePgmIdTrans( List<Object> addList, List<Object> udtList, Integer userId ) {
    int saveCnt = 0;
    for ( Object obj : addList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      if ( String.valueOf( ( (Map<String, Object>) obj ).get( "pgmCode" ) ).length() == 0 ) {
        continue;
      }
      LOGGER.debug( " ========= savePgmIdTrans [addList] ============== " );
      LOGGER.debug( " pgmCode : {}", ( (Map<String, Object>) obj ).get( "pgmCode" ) );
      LOGGER.debug( " pgmName : {}", ( (Map<String, Object>) obj ).get( "pgmName" ) );
      LOGGER.debug( " funcView : {}", ( (Map<String, Object>) obj ).get( "funcView" ) );
      LOGGER.debug( " funcChng : {}", ( (Map<String, Object>) obj ).get( "funcChng" ) );
      LOGGER.debug( " funcPrt : {}", ( (Map<String, Object>) obj ).get( "funcPrt" ) );
      LOGGER.debug( " funcUserDfn1 : {}", ( (Map<String, Object>) obj ).get( "funcUserDfn1" ) );
      LOGGER.debug( " descUserDfn1 : {}", ( (Map<String, Object>) obj ).get( "descUserDfn1" ) );
      LOGGER.debug( " funcUserDfn2 : {}", ( (Map<String, Object>) obj ).get( "funcUserDfn2" ) );
      LOGGER.debug( " descUserDfn2 : {}", ( (Map<String, Object>) obj ).get( "descUserDfn2" ) );
      LOGGER.debug( " funcUserDfn3 : {}", ( (Map<String, Object>) obj ).get( "funcUserDfn3" ) );
      LOGGER.debug( " descUserDfn3 : {}", ( (Map<String, Object>) obj ).get( "descUserDfn3" ) );
      LOGGER.debug( " funcUserDfn4 : {}", ( (Map<String, Object>) obj ).get( "funcUserDfn4" ) );
      LOGGER.debug( " descUserDfn4 : {}", ( (Map<String, Object>) obj ).get( "descUserDfn4" ) );
      LOGGER.debug( " funcUserDfn5 : {}", ( (Map<String, Object>) obj ).get( "funcUserDfn5" ) );
      LOGGER.debug( " descUserDfn5 : {}", ( (Map<String, Object>) obj ).get( "descUserDfn5" ) );
      saveCnt++;
      commonMapper.updPgmIdTrans( (Map<String, Object>) obj );
    }
    for ( Object obj : udtList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      if ( String.valueOf( ( (Map<String, Object>) obj ).get( "pgmCode" ) ).length() == 0 ) {
        continue;
      }
      LOGGER.debug( " ========= savePgmIdTrans [udtList] ============== " );
      LOGGER.debug( " pgmCode : {}", ( (Map<String, Object>) obj ).get( "pgmCode" ) );
      LOGGER.debug( " pgmName : {}", ( (Map<String, Object>) obj ).get( "pgmName" ) );
      LOGGER.debug( " funcView : {}", ( (Map<String, Object>) obj ).get( "funcView" ) );
      LOGGER.debug( " funcChng : {}", ( (Map<String, Object>) obj ).get( "funcChng" ) );
      LOGGER.debug( " funcPrt : {}", ( (Map<String, Object>) obj ).get( "funcPrt" ) );
      LOGGER.debug( " funcUserDfn1 : {}", ( (Map<String, Object>) obj ).get( "funcUserDfn1" ) );
      LOGGER.debug( " descUserDfn1 : {}", ( (Map<String, Object>) obj ).get( "descUserDfn1" ) );
      LOGGER.debug( " funcUserDfn2 : {}", ( (Map<String, Object>) obj ).get( "funcUserDfn2" ) );
      LOGGER.debug( " descUserDfn2 : {}", ( (Map<String, Object>) obj ).get( "descUserDfn2" ) );
      LOGGER.debug( " funcUserDfn3 : {}", ( (Map<String, Object>) obj ).get( "funcUserDfn3" ) );
      LOGGER.debug( " descUserDfn3 : {}", ( (Map<String, Object>) obj ).get( "descUserDfn3" ) );
      LOGGER.debug( " funcUserDfn4 : {}", ( (Map<String, Object>) obj ).get( "funcUserDfn4" ) );
      LOGGER.debug( " descUserDfn4 : {}", ( (Map<String, Object>) obj ).get( "descUserDfn4" ) );
      LOGGER.debug( " funcUserDfn5 : {}", ( (Map<String, Object>) obj ).get( "funcUserDfn5" ) );
      LOGGER.debug( " descUserDfn5 : {}", ( (Map<String, Object>) obj ).get( "descUserDfn5" ) );
      saveCnt++;
      commonMapper.updPgmIdTrans( (Map<String, Object>) obj );
    }
    return saveCnt;
  }

  /************************** Status Code ****************************/
  // StatusCategory
  @Override
  public List<EgovMap> selectStatusCategoryList( Map<String, Object> params ) {
    return commonMapper.selectStatusCategoryList( params );
  }

  // StatusCategory Code
  @Override
  public List<EgovMap> selectStatusCategoryCodeList( Map<String, Object> params ) {
    return commonMapper.selectStatusCategoryCodeList( params );
  }

  // StatusCode
  @Override
  public List<EgovMap> selectStatusCodeList( Map<String, Object> params ) {
    return commonMapper.selectStatusCodeList( params );
  }

  /*
   * @Override public int insertStatusCategory(List<Object> addList, Integer crtUserId) { int
   * saveCnt = 0; for (Object obj : addList) { ((Map<String, Object>) obj).put("crtUserId",
   * crtUserId); ((Map<String, Object>) obj).put("updUserId", crtUserId); if
   * (String.valueOf(((Map<String, Object>) obj).get("stusCtgryName")).length() == 0) { continue; }
   * LOGGER.debug(" InsertSatusCategory "); LOGGER.debug(" stusCtgryId : {}", ((Map<String, Object>)
   * obj).get("stusCtgryId")); LOGGER.debug(" stusCtgryName : {}", ((Map<String, Object>)
   * obj).get("stusCtgryName")); LOGGER.debug(" stusCtgryDesc : {}", ((Map<String, Object>)
   * obj).get("stusCtgryDesc")); LOGGER.debug(" crtUserId : {}", ((Map<String, Object>)
   * obj).get("crtUserId")); LOGGER.debug(" updUserId : {}", ((Map<String, Object>)
   * obj).get("updUserId")); saveCnt++; commonMapper.insertStatusCategory((Map<String, Object>)
   * obj); } return saveCnt; }
   * @Override public int updateStatusCategory(List<Object> addList, Integer crtUserId) { int
   * saveCnt = 0; for (Object obj : addList) { ((Map<String, Object>) obj).put("crtUserId",
   * crtUserId); ((Map<String, Object>) obj).put("updUserId", crtUserId); if
   * (String.valueOf(((Map<String, Object>) obj).get("stusCtgryName")).length() == 0) { continue; }
   * LOGGER.debug(" InsertSatusCategory "); LOGGER.debug(" stusCtgryId : {}", ((Map<String, Object>)
   * obj).get("stusCtgryId")); LOGGER.debug(" stusCtgryName : {}", ((Map<String, Object>)
   * obj).get("stusCtgryName")); LOGGER.debug(" stusCtgryDesc : {}", ((Map<String, Object>)
   * obj).get("stusCtgryDesc")); LOGGER.debug(" crtUserId : {}", ((Map<String, Object>)
   * obj).get("crtUserId")); LOGGER.debug(" updUserId : {}", ((Map<String, Object>)
   * obj).get("updUserId")); saveCnt++; commonMapper.updateStatusCategory((Map<String, Object>)
   * obj); } return saveCnt; }
   * @Override public int deleteStatusCategoryCode(List<Object> delList, Integer crtUserId) { int
   * delCnt = 0; for (Object obj : delList) { ((Map<String, Object>) obj).put("crtUserId",
   * crtUserId); ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug(
   * " >>>>> deleteStatusCategoryCode "); LOGGER.debug("stusCtgryId : {}", ((Map<String, Object>)
   * obj).get("stusCtgryId")); delCnt++; // SYS0037M
   * commonMapper.deleteStatusCategoryCode((Map<String, Object>) obj); // SYS0036M
   * commonMapper.deleteStatusCategoryMst((Map<String, Object>) obj); } return delCnt; }
   */
  /**
   * Insert, Update, Delete Status Category List :
   * insertStatusCategory+updateStatusCategory+deleteStatusCategoryCode => Change One Transaction
   *
   * @Author KR-OHK
   * @Date 2019. 9. 10.
   * @param addList
   * @param udtList
   * @param delList
   * @param userId
   * @return
   * @see com.coway.trust.biz.common.CommonService#saveStatusCategory(java.util.List,
   *      java.util.List, java.util.List, java.lang.Integer)
   */
  @SuppressWarnings("unchecked")
  @Override
  public int saveStatusCategory( List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId ) {
    int saveCnt = 0;
    // insert
    for ( Object obj : addList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      if ( String.valueOf( ( (Map<String, Object>) obj ).get( "stusCtgryName" ) ).length() == 0 ) {
        continue;
      }
      LOGGER.debug( "  >>>>>  saveStatusCategory InsertSatusCategory " );
      LOGGER.debug( " stusCtgryId : {}", ( (Map<String, Object>) obj ).get( "stusCtgryId" ) );
      LOGGER.debug( " stusCtgryName : {}", ( (Map<String, Object>) obj ).get( "stusCtgryName" ) );
      LOGGER.debug( " stusCtgryDesc : {}", ( (Map<String, Object>) obj ).get( "stusCtgryDesc" ) );
      LOGGER.debug( " crtUserId : {}", ( (Map<String, Object>) obj ).get( "crtUserId" ) );
      LOGGER.debug( " updUserId : {}", ( (Map<String, Object>) obj ).get( "updUserId" ) );
      saveCnt++;
      commonMapper.insertStatusCategory( (Map<String, Object>) obj );
    }
    // update
    for ( Object obj : udtList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      if ( String.valueOf( ( (Map<String, Object>) obj ).get( "stusCtgryName" ) ).length() == 0 ) {
        continue;
      }
      LOGGER.debug( " >>>>> saveStatusCategory UpdateSatusCategory " );
      LOGGER.debug( " stusCtgryId : {}", ( (Map<String, Object>) obj ).get( "stusCtgryId" ) );
      LOGGER.debug( " stusCtgryName : {}", ( (Map<String, Object>) obj ).get( "stusCtgryName" ) );
      LOGGER.debug( " stusCtgryDesc : {}", ( (Map<String, Object>) obj ).get( "stusCtgryDesc" ) );
      LOGGER.debug( " crtUserId : {}", ( (Map<String, Object>) obj ).get( "crtUserId" ) );
      LOGGER.debug( " updUserId : {}", ( (Map<String, Object>) obj ).get( "updUserId" ) );
      saveCnt++;
      commonMapper.updateStatusCategory( (Map<String, Object>) obj );
    }
    // delete
    for ( Object obj : delList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( " >>>>> saveStatusCategory DeleteStatusCategoryCode " );
      LOGGER.debug( "stusCtgryId : {}", ( (Map<String, Object>) obj ).get( "stusCtgryId" ) );
      saveCnt++;
      // SYS0037M
      commonMapper.deleteStatusCategoryCode( (Map<String, Object>) obj );
      // SYS0036M
      commonMapper.deleteStatusCategoryMst( (Map<String, Object>) obj );
    }
    return saveCnt;
  }

  @Override
  public int deleteStatusCategoryMst( List<Object> delList, Integer crtUserId ) {
    int delCnt = 0;
    for ( Object obj : delList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", crtUserId );
      ( (Map<String, Object>) obj ).put( "updUserId", crtUserId );
      LOGGER.debug( " >>>>> deleteStatusCategoryMst " );
      LOGGER.debug( "stusCtgryId : {}", ( (Map<String, Object>) obj ).get( "stusCtgryId" ) );
      delCnt++;
      commonMapper.deleteStatusCategoryMst( (Map<String, Object>) obj );
    }
    return delCnt;
  }

  /*
   * @Override public int insertStatusCode(List<Object> addList, Integer crtUserId) { int saveCnt =
   * 0; for (Object obj : addList) { ((Map<String, Object>) obj).put("crtUserId", crtUserId);
   * ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug("[insertStatusCode]");
   * LOGGER.debug(" codeName : {}", ((Map<String, Object>) obj).get("codeName")); LOGGER.debug(
   * " code : {}", ((Map<String, Object>) obj).get("code")); saveCnt++;
   * commonMapper.insertStatusCode((Map<String, Object>) obj); } return saveCnt; }
   * @Override public int updateStatusCode(List<Object> addList, Integer crtUserId) { int saveCnt =
   * 0; for (Object obj : addList) { ((Map<String, Object>) obj).put("crtUserId", crtUserId);
   * ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug(" updateStatusCode ");
   * LOGGER.debug(" stusCodeId : {}", ((Map<String, Object>) obj).get("stusCodeId")); LOGGER.debug(
   * " codeName : {}", ((Map<String, Object>) obj).get("codeName")); LOGGER.debug( " code : {}",
   * ((Map<String, Object>) obj).get("code")); saveCnt++; commonMapper.updateStatusCode((Map<String,
   * Object>) obj); } return saveCnt; }
   */
  /**
   * Insert, Update Status Code List : insertStatusCode+updateStatusCode => Change One Transaction
   *
   * @Author KR-OHK
   * @Date 2019. 9. 10.
   * @param addList
   * @param udtList
   * @param userId
   * @return
   * @see com.coway.trust.biz.common.CommonService#saveStatusCode(java.util.List, java.util.List,
   *      java.lang.Integer)
   */
  @SuppressWarnings("unchecked")
  @Override
  public int saveStatusCode( List<Object> addList, List<Object> udtList, Integer userId ) {
    int saveCnt = 0;
    // insert
    for ( Object obj : addList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( "  >>>>> saveStatusCode insertStatusCode " );
      LOGGER.debug( " codeName : {}", ( (Map<String, Object>) obj ).get( "codeName" ) );
      LOGGER.debug( " code : {}", ( (Map<String, Object>) obj ).get( "code" ) );
      saveCnt++;
      commonMapper.insertStatusCode( (Map<String, Object>) obj );
    }
    // update
    for ( Object obj : udtList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", userId );
      ( (Map<String, Object>) obj ).put( "updUserId", userId );
      LOGGER.debug( "  >>>>>  saveStatusCode updateStatusCode " );
      LOGGER.debug( " stusCodeId : {}", ( (Map<String, Object>) obj ).get( "stusCodeId" ) );
      LOGGER.debug( " codeName : {}", ( (Map<String, Object>) obj ).get( "codeName" ) );
      LOGGER.debug( " code : {}", ( (Map<String, Object>) obj ).get( "code" ) );
      saveCnt++;
      commonMapper.updateStatusCode( (Map<String, Object>) obj );
    }
    return saveCnt;
  }

  @Override
  public int insertStatusCategoryCode( CommStatusVO formDataParameters, Integer crtUserId ) {
    int saveCnt = 0;
    GridDataSet<CommStatusGridData> gridDataSet = formDataParameters.getGridDataSet();
    List<CommStatusGridData> updateList = gridDataSet.getUpdate(); // check 된 리스트
    CommStatusFormVO commStatusVO = formDataParameters.getCommStatusVO();// form내의 input 객체
    Map<String, Object> param = null;
    for ( CommStatusGridData gridData : updateList ) {
      param = BeanConverter.toMap( gridData ); // list --> map
      // LOGGER.debug("list: " + param.toString() );
      if ( "0".equals( String.valueOf( param.get( "checkFlag" ) ) ) ) {
        continue;
      }
      param.put( "stusCtgryId", commStatusVO.getCatalogId() );
      param.put( "crtUserId", crtUserId );
      param.put( "updUserId", crtUserId );
      commonMapper.insertStatusCategoryCode( param );
      saveCnt++;
    }
    return saveCnt;
  }

  // SUS0037M DisibleYN
  @Override
  public int updateCategoryCodeYN( CommStatusVO formDataParameters, Integer updUserId ) {
    int saveCnt = 0;
    GridDataSet<CommStatusGridData> gridDataSet = formDataParameters.getGridDataSet();
    List<CommStatusGridData> updateList = gridDataSet.getUpdate(); // grid에서 check 된 리스트
    List<CommStatusGridData> deleteList = gridDataSet.getRemove(); // grid에서 check 된 리스트
    CommStatusFormVO commStatusVO = formDataParameters.getCommStatusVO();// form내의 input 객체
    Map<String, Object> param = null;
    for ( CommStatusGridData gridData : updateList ) {
      param = BeanConverter.toMap( gridData ); // grid의 필드명(key)과 데이타값을 map형식으로 자동변환
      param.put( "stusCtgryId", commStatusVO.getCatalogId() ); // form의 input객체를 map형식으로 변환
      // param.put("updUserId", updUserId);
      commonMapper.updateCategoryCodeYN( param );
      saveCnt++;
    }
    LOGGER.debug( "updCnt: {} ", updateList.size() );
    LOGGER.debug( "delCnt: {} ", deleteList.size() );
    for ( CommStatusGridData gridData : deleteList ) {
      param = BeanConverter.toMap( gridData ); // grid의 필드명(key)과 데이타값을 map형식으로 자동변환
      param.put( "stusCtgryId", commStatusVO.getCatalogId() ); // form의 input객체를 map형식으로 변환
      commonMapper.deleteCategoryCode( param );
      saveCnt++;
    }
    return saveCnt;
  }

  /************************** Account Code ****************************/
  @Override
  public List<EgovMap> getAccountCodeList( Map<String, Object> params ) {
    return commonMapper.getAccountCodeList( params );
  }

  // Account Code Count
  @Override
  public int getAccCodeCount( Map<String, Object> params ) {
    return commonMapper.getAccCodeCount( params );
  }
  // AccoutCode Insert
  /*
   * @Override public int insertAccountCode(Map<String, Object> params) { return
   * commonMapper.insertAccountCode(params); }
   */

  // AccoutCode Merge
  @Override
  public int mergeAccountCode( Map<String, Object> params ) {
    return commonMapper.mergeAccountCode( params );
  }

  // Gerneral Code
  @Override
  public List<EgovMap> getMstCommonCodeList( Map<String, Object> params ) {
    return commonMapper.getMstCommonCodeList( params );
  }

  @Override
  public List<EgovMap> getDetailCommonCodeList( Map<String, Object> params ) {
    return commonMapper.getDetailCommonCodeList( params );
  }

  /**
   * Insert, Update Group Code list : addCommCodeGrid+udtCommCodeGrid => Change One Transaction
   *
   * @Author KR-MIN
   * @Date 2019. 9. 5.
   * @param addList
   * @param crtUserId
   * @param udtList
   * @param updUserId
   * @return
   * @see com.coway.trust.biz.common.CommonService#saveCommCodeGrid(java.util.List,
   *      java.lang.Integer, java.util.List, java.lang.Integer)
   */
  @SuppressWarnings("unchecked")
  @Override
  public int saveCommCodeGrid( List<Object> addList, Integer crtUserId, List<Object> udtList, Integer updUserId ) {
    int saveCnt = 0;
    for ( Object obj : addList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", crtUserId );
      ( (Map<String, Object>) obj ).put( "updUserId", crtUserId );
      LOGGER.debug( " InsertMstCommCd " );
      LOGGER.debug( " codeMasterId : {}", ( (Map<String, Object>) obj ).get( "codeMasterId" ) );
      LOGGER.debug( " disabled : {}", ( (Map<String, Object>) obj ).get( "disabled" ) );
      LOGGER.debug( " codeMasterName : {}", ( (Map<String, Object>) obj ).get( "codeMasterName" ) );
      LOGGER.debug( " codeDesc : {}", ( (Map<String, Object>) obj ).get( "codeDesc" ) );
      LOGGER.debug( " createName : {}", ( (Map<String, Object>) obj ).get( "createName" ) );
      LOGGER.debug( " crtDt : {}", ( (Map<String, Object>) obj ).get( "crtDt" ) );
      saveCnt++;
      commonMapper.addCommCodeGrid( (Map<String, Object>) obj );
    }
    for ( Object obj : udtList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", updUserId );
      ( (Map<String, Object>) obj ).put( "updUserId", updUserId );
      LOGGER.debug( " update CommCode" );
      LOGGER.debug( " codeMasterId : {}", ( (Map<String, Object>) obj ).get( "codeMasterId" ) );
      LOGGER.debug( " disabled : {}", ( (Map<String, Object>) obj ).get( "disabled" ) );
      LOGGER.debug( " codeMasterName : {}", ( (Map<String, Object>) obj ).get( "codeMasterName" ) );
      LOGGER.debug( " codeDesc : {}", ( (Map<String, Object>) obj ).get( "codeDesc" ) );
      LOGGER.debug( " createName : {}", ( (Map<String, Object>) obj ).get( "createName" ) );
      LOGGER.debug( " crtDt : {}", ( (Map<String, Object>) obj ).get( "crtDt" ) );
      saveCnt++;
      commonMapper.updCommCodeGrid( (Map<String, Object>) obj );
    }
    return saveCnt;
  }

  /*
   * @SuppressWarnings("unchecked")
   * @Override public int addCommCodeGrid(List<Object> addList, Integer crtUserId) { int saveCnt =
   * 0; for (Object obj : addList) { ((Map<String, Object>) obj).put("crtUserId", crtUserId);
   * ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug(" InsertMstCommCd ");
   * LOGGER.debug(" codeMasterId : {}", ((Map<String, Object>) obj).get("codeMasterId"));
   * LOGGER.debug(" disabled : {}", ((Map<String, Object>) obj).get("disabled")); LOGGER.debug(
   * " codeMasterName : {}", ((Map<String, Object>) obj).get("codeMasterName")); LOGGER.debug(
   * " codeDesc : {}", ((Map<String, Object>) obj).get("codeDesc")); LOGGER.debug(
   * " createName : {}", ((Map<String, Object>) obj).get("createName")); LOGGER.debug( " crtDt : {}"
   * , ((Map<String, Object>) obj).get("crtDt")); saveCnt++;
   * commonMapper.addCommCodeGrid((Map<String, Object>) obj); } return saveCnt; }
   * @Override public int udtCommCodeGrid(List<Object> udtList, Integer updUserId) { int saveCnt =
   * 0; for (Object obj : udtList) { ((Map<String, Object>) obj).put("crtUserId", updUserId);
   * ((Map<String, Object>) obj).put("updUserId", updUserId); LOGGER.debug(" update CommCode");
   * LOGGER.debug(" codeMasterId : {}", ((Map<String, Object>) obj).get("codeMasterId"));
   * LOGGER.debug(" disabled : {}", ((Map<String, Object>) obj).get("disabled")); LOGGER.debug(
   * " codeMasterName : {}", ((Map<String, Object>) obj).get("codeMasterName")); LOGGER.debug(
   * " codeDesc : {}", ((Map<String, Object>) obj).get("codeDesc")); LOGGER.debug(
   * " createName : {}", ((Map<String, Object>) obj).get("createName")); LOGGER.debug( " crtDt : {}"
   * , ((Map<String, Object>) obj).get("crtDt")); saveCnt++;
   * commonMapper.updCommCodeGrid((Map<String, Object>) obj); } return saveCnt; }
   */
  /**
   * Insert, Update Code list : addDetailCommCodeGrid+udtDetailCommCodeGrid => Change One
   * Transaction
   *
   * @Author KR-MIN
   * @Date 2019. 9. 5.
   * @param addList
   * @param crtUserId
   * @param udtList
   * @param updUserId
   * @return
   * @see com.coway.trust.biz.common.CommonService#saveDetailCommCodeGrid(java.util.List,
   *      java.lang.Integer, java.util.List, java.lang.Integer)
   */
  @SuppressWarnings("unchecked")
  @Override
  public int saveDetailCommCodeGrid( List<Object> addList, Integer crtUserId, List<Object> udtList,
                                     Integer updUserId ) {
    int saveCnt = 0;
    // add list
    for ( Object obj : addList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", crtUserId );
      ( (Map<String, Object>) obj ).put( "updUserId", crtUserId );
      LOGGER.debug( " [[Insert Deatail]] " );
      LOGGER.debug( " codeMasterId : {}", ( (Map<String, Object>) obj ).get( "codeMasterId" ) );
      LOGGER.debug( " detailcode : {}", ( (Map<String, Object>) obj ).get( "detailcode" ) );
      LOGGER.debug( " detailcodename : {}", ( (Map<String, Object>) obj ).get( "detailcodename" ) );
      LOGGER.debug( " detailcodedesc : {}", ( (Map<String, Object>) obj ).get( "detailcodedesc" ) );
      LOGGER.debug( " detaildisabled : {}", ( (Map<String, Object>) obj ).get( "detaildisabled" ) );
      LOGGER.debug( " crtUserId : {}", ( (Map<String, Object>) obj ).get( "crtUserId" ) );
      LOGGER.debug( " updUserId : {}", ( (Map<String, Object>) obj ).get( "updUserId" ) );
      saveCnt++;
      commonMapper.addDetailCommCodeGrid( (Map<String, Object>) obj );
    }
    // update list
    for ( Object obj : udtList ) {
      ( (Map<String, Object>) obj ).put( "crtUserId", updUserId );
      ( (Map<String, Object>) obj ).put( "updUserId", updUserId );
      LOGGER.debug( " update_Detail " );
      LOGGER.debug( " detailcode : {}", ( (Map<String, Object>) obj ).get( "detailcode" ) );
      LOGGER.debug( " detailcodename : {}", ( (Map<String, Object>) obj ).get( "detailcodename" ) );
      LOGGER.debug( " detailcodedesc : {}", ( (Map<String, Object>) obj ).get( "detailcodedesc" ) );
      LOGGER.debug( " detaildisabled : {}", ( (Map<String, Object>) obj ).get( "detaildisabled" ) );
      LOGGER.debug( " updUserId : {}", ( (Map<String, Object>) obj ).get( "updUserId" ) );
      LOGGER.debug( " detailcodeid : {}", ( (Map<String, Object>) obj ).get( "detailcodeid" ) );
      saveCnt++;
      commonMapper.updDetailCommCodeGrid( (Map<String, Object>) obj );
    }
    return saveCnt;
  }

  /*
   * @SuppressWarnings("unchecked")
   * @Override public int addDetailCommCodeGrid(List<Object> addList, Integer crtUserId) { int
   * saveCnt = 0; for (Object obj : addList) { ((Map<String, Object>) obj).put("crtUserId",
   * crtUserId); ((Map<String, Object>) obj).put("updUserId", crtUserId); LOGGER.debug(
   * " [[Insert Deatail]] "); LOGGER.debug(" codeMasterId : {}", ((Map<String, Object>)
   * obj).get("codeMasterId")); LOGGER.debug(" detailcode : {}", ((Map<String, Object>)
   * obj).get("detailcode")); LOGGER.debug(" detailcodename : {}", ((Map<String, Object>)
   * obj).get("detailcodename")); LOGGER.debug(" detailcodedesc : {}", ((Map<String, Object>)
   * obj).get("detailcodedesc")); LOGGER.debug(" detaildisabled : {}", ((Map<String, Object>)
   * obj).get("detaildisabled")); LOGGER.debug(" crtUserId : {}", ((Map<String, Object>)
   * obj).get("crtUserId")); LOGGER.debug(" updUserId : {}", ((Map<String, Object>)
   * obj).get("updUserId")); saveCnt++; commonMapper.addDetailCommCodeGrid((Map<String, Object>)
   * obj); } return saveCnt;// commit; }
   * @Override public int udtDetailCommCodeGrid(List<Object> udtList, Integer updUserId) { int
   * saveCnt = 0; for (Object obj : udtList) { ((Map<String, Object>) obj).put("crtUserId",
   * updUserId); ((Map<String, Object>) obj).put("updUserId", updUserId); LOGGER.debug(
   * " update_Detail "); LOGGER.debug(" detailcode : {}", ((Map<String, Object>)
   * obj).get("detailcode")); LOGGER.debug(" detailcodename : {}", ((Map<String, Object>)
   * obj).get("detailcodename")); LOGGER.debug(" detailcodedesc : {}", ((Map<String, Object>)
   * obj).get("detailcodedesc")); LOGGER.debug(" detaildisabled : {}", ((Map<String, Object>)
   * obj).get("detaildisabled")); LOGGER.debug(" updUserId : {}", ((Map<String, Object>)
   * obj).get("updUserId")); LOGGER.debug(" detailcodeid : {}", ((Map<String, Object>)
   * obj).get("detailcodeid")); saveCnt++; commonMapper.updDetailCommCodeGrid((Map<String, Object>)
   * obj); } return saveCnt; }
   */
  @Override
  public List<EgovMap> selectBranchList( Map<String, Object> params ) {
    return commonMapper.selectBranchList( params );
  }

  @Override
  public List<EgovMap> selectUnitTypeList( Map<String, Object> params ) {
    return commonMapper.selectUnitTypeList( params );
  }

  @Override
  public List<EgovMap> selectProductSizeList( Map<String, Object> params ) {
    return commonMapper.selectProductSizeList( params );
  }

  @Override
  public List<EgovMap> selectProductSizeListSearch( Map<String, Object> params ) {
    return commonMapper.selectProductSizeListSearch( params );
  }

  @Override
  public List<EgovMap> selectServiceTypeList( Map<String, Object> params ) {
    return commonMapper.selectServiceTypeList( params );
  }

  @Override
  public List<EgovMap> selectBrandTypeList( Map<String, Object> params ) {
    return commonMapper.selectBrandTypeList( params );
  }

  @Override
  public List<EgovMap> selectUniformSizeList( Map<String, Object> params ) {
    return commonMapper.selectUniformSizeList( params );
  }

  @Override
  public List<EgovMap> selectMuslimahScarftList( Map<String, Object> params ) {
    return commonMapper.selectMuslimahScarftList( params );
  }

  @Override
  public List<EgovMap> selectInnerTypeList( Map<String, Object> params ) {
    return commonMapper.selectInnerTypeList( params );
  }

  @Override
  public List<EgovMap> selectBankAccountList( Map<String, Object> params ) {
    return commonMapper.selectBankAccountList( params );
  }

  @Override
  public List<EgovMap> selectReasonCodeList( Map<String, Object> params ) {
    return commonMapper.selectReasonCodeList( params );
  }

  /**
   * Account 정보 조회 (크레딧 카드 리스트 / 은행 계좌 리스트)
   *
   * @param params
   * @return
   */
  @Override
  public List<EgovMap> getAccountList( Map<String, Object> params ) {
    return commonMapper.getAccountList( params );
  }

  @Override
  public List<EgovMap> getOrgCodeList( Map<String, Object> params ) {
    return commonMapper.getOrgCodeList( params );
  }

  @Override
  public List<EgovMap> getDeptCodeList( Map<String, Object> params ) {
    return commonMapper.getDeptCodeList( params );
  }

  @Override
  public List<EgovMap> getGrpCodeList( Map<String, Object> params ) {
    return commonMapper.getGrpCodeList( params );
  }

  /**
   * Branch ID로 User 정보 조회
   *
   * @param params
   * @return
   */
  @Override
  public List<EgovMap> getUsersByBranch( Map<String, Object> params ) {
    return commonMapper.getUsersByBranch( params );
  }

  @Override
  public List<EgovMap> selectCountryList( Map<String, Object> params ) {
    return commonMapper.selectCountryList( params );
  }

  @Override
  public List<EgovMap> selectStateList( Map<String, Object> params ) {
    return commonMapper.selectStateList( params );
  }

  @Override
  public List<EgovMap> selectAreaList( Map<String, Object> params ) {
    return commonMapper.selectAreaList( params );
  }

  @Override
  public List<EgovMap> selectPostCdList( Map<String, Object> params ) {
    return commonMapper.selectPostCdList( params );
  }

  @Override
  public List<EgovMap> selectAddrSelCode( Map<String, Object> params ) {
    // TODO Auto-generated method stub
    return commonMapper.selectAddrSelCode( params );
  }

  @Override
  public List<EgovMap> selectInStckSelCodeList( Map<String, Object> params ) {
    // TODO Auto-generated method stub
    return commonMapper.selectInStckSelCodeList( params );
  }

  @Override
  public List<EgovMap> selectStockLocationList( Map<String, Object> params ) {
    // TODO Auto-generated method stub
    return commonMapper.selectStockLocationList( params );
  }

  @Override
  public List<EgovMap> selectStockLocationList4( Map<String, Object> params ) {
    // TODO Auto-generated method stub
    return commonMapper.selectStockLocationList4( params );
  }

  @Override
  public List<EgovMap> selectBankList( Map<String, Object> params ) {
    // TODO Auto-generated method stub
    return commonMapper.selectBankList( params );
  }

  @Override
  public EgovMap selectBrnchIdByPostCode( Map<String, Object> params ) {
    return commonMapper.selectBrnchIdByPostCode( params );
  }

  @Override
  public List<EgovMap> selectProductList() {
    // TODO Auto-generated method stub
    return commonMapper.selectProductList();
  }

  @Override
  public List<EgovMap> selectProductCodeList( Map<String, Object> params ) {
    // TODO ProductCodeList 호출시 error남
    return commonMapper.selectProductCodeList( params );
  }

  @Override
  public List<EgovMap> selectUpperMenuList( Map<String, Object> params ) {
    // TODO Auto-generated method stub
    return commonMapper.selectUpperMenuList( params );
  }

  @Override
  public String selectDocNo( String docId ) {
    return commonMapper.selectDocNo( docId );
  }

  /**
   * Payment - Adjustment CN/DN : Adjustment Reason 정보 조회
   *
   * @param params
   * @return
   */
  @Override
  public List<EgovMap> selectAdjReasonList( Map<String, Object> params ) {
    // TODO Auto-generated method stub
    return commonMapper.selectAdjReasonList( params );
  }

  @Override
  public String SysdateCall( Map<String, Object> params ) {
    return commonMapper.SysdateCall( params );
  }

  @Override
  public List<EgovMap> getPublicHolidayList( Map<String, Object> params ) {
    return commonMapper.selectPublicHolidayList( params );
  }

  @Override
  public List<EgovMap> selectCodeList( String grpCd ) {
    Map<String, Object> params = new HashMap<String, Object>();
    params.put( "groupCode", CommonUtils.nvl( grpCd ) );
    return selectCodeList( params );
  }

  @Override
  public List<EgovMap> selectCodeList( String grpCd, String orderVal ) {
    Map<String, Object> params = new HashMap<String, Object>();
    params.put( "groupCode", CommonUtils.nvl( grpCd ) );
    params.put( "orderValue", CommonUtils.nvl( orderVal ) );
    return selectCodeList( params );
  }

  @Override
  public List<EgovMap> selectBranchList( String grpCd ) {
    Map<String, Object> params = new HashMap<String, Object>();
    params.put( "groupCode", CommonUtils.nvl( grpCd ) );
    return selectBranchList( params );
  }

  @Override
  public List<EgovMap> selectBranchList( String grpCd, String separator ) {
    Map<String, Object> params = new HashMap<String, Object>();
    params.put( "groupCode", CommonUtils.nvl( grpCd ) );
    params.put( "separator", CommonUtils.nvl( separator ) );
    return selectBranchList( params );
  }

  /**
   * select Homecare holiday list
   *
   * @Author KR-SH
   * @Date 2019. 11. 14.
   * @param params
   * @return
   */
  @Override
  public List<EgovMap> getHcHolidayList( Map<String, Object> params ) {
    return commonMapper.getHcHolidayList( params );
  }

  @Override
  public List<EgovMap> selectMemTypeCodeList( Map<String, Object> params ) {
    return commonMapper.selectMemTypeCodeList( params );
  }

  @Override
  public List<EgovMap> selectReasonCodeId( Map<String, Object> params ) {
    return commonMapper.selectReasonCodeId( params );
  }

  @Override
  public List<EgovMap> selectDepartmentCode( Map<String, Object> params ) {
    return commonMapper.selectDepartmentCode( params );
  }

  public List<EgovMap> selectStockLocationListByDept( Map<String, Object> params ) {
    return commonMapper.selectStockLocationListByDept( params );
  }

  @Override
  public List<EgovMap> getMapProp( Map<String, Object> params ) {
    return commonMapper.getMapProp( params );
  }

  @Override
  public EgovMap getGeneralInstInfo( Map<String, Object> params ) {
    return commonMapper.getGeneralInstInfo( params );
  }

  @Override
  public EgovMap getGeneralASInfo( Map<String, Object> params ) {
    return commonMapper.getGeneralASInfo( params );
  }

  @Override
  public EgovMap getGeneralPRInfo( Map<String, Object> params ) {
    return commonMapper.getGeneralPRInfo( params );
  }

  @Override
  public EgovMap getGeneralHSInfo( Map<String, Object> params ) {
    return commonMapper.getGeneralHSInfo( params );
  }

  @Override
  public List<EgovMap> selectTimePick() {
    return commonMapper.selectTimePick();
  }

  public List<EgovMap> selectSystemConfigurationParamVal( Map<String, Object> params ) {
    return commonMapper.selectSystemConfigurationParamVal( params );
  }

  @Override
  public int selectSystemConfigurationParamValue( Map<String, Object> params ) {
    return commonMapper.selectSystemConfigurationParamValue( params );
  }

  @Override
  public EgovMap selectSystemDefectConfiguration( Map<String, Object> params ) {
    return commonMapper.selectSystemDefectConfiguration( params );
  }

  @Override
  public List<EgovMap> selectFilterList( Map<String, Object> params ) {
    // TODO Auto-generated method stub
    return commonMapper.selectFilterList( params );
  }

  @Override
  public int getSstTaxRate() {
    return CommonUtils.intNvl( commonMapper.getSstTaxRate() );
  }

  public EgovMap getSstRelatedInfo() {
    EgovMap sstInfo = commonMapper.getSstRelatedInfo();
    if ( sstInfo != null && !sstInfo.isEmpty() ) {
      return sstInfo;
    }
    else {
      sstInfo = new EgovMap(); // default a 0 value set to avoid calculation burst.
      sstInfo.put( "codeId", "32" ); //SR  Supply - Goods And Services Tax (Malaysia)
      sstInfo.put( "taxRate", "0" );
      sstInfo.put( "taxCode", "SR" ); //SR  Supply - Goods And Services Tax (Malaysia)
      return sstInfo;
    }
    // TODO Auto-generated method stub
    // return commonMapper.getSstRelatedInfo();
  }

  public EgovMap reqEghlPmtLink( Map<String, Object> params ) throws IOException, JSONException  {
    /*params.put( "custNm", "TESTING" );
    params.put( "custCtnt", "0163200016" );
    params.put( "custEmail", "wayne.ong@coway.com.my" );
    params.put( "ordDesc", "eSOF1021452" );
    params.put( "ordNo", "000001" );
    params.put( "ordTtlAmt", "1502.50" );
    params.put( "ordPmtLinkEmailInd", "N" );
    // GET TODAY DATE
    LocalDate today = LocalDate.now();

    // ADD 3 DAYS
    LocalDate futureDate = today.plusDays(3);

    // FORMAT THE DATE
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    String formattedDate = futureDate.format(formatter);
    params.put( "ordPmtExp", formattedDate );*/

    // STEP 1 :: VALIDATE MERCHART ID & MERCHART PASSWORD
    if ("".equals(CommonUtils.nvl(pmtLinkMerchId))) {
      throw new ApplicationException(AppConstants.FAIL, "NO VALUE FOR MERCHART LOGIN ID. PLEASE CHECK FOR MERCHART LOGIN ID.");
    }

    if ("".equals(CommonUtils.nvl(pmtLinkMerchPassw))) {
      throw new ApplicationException(AppConstants.FAIL, "NO VALUE FOR MERCHART LOGIN PASSWROD. PLEASE CHECK FOR MERCHART LOGIN PASSWORD.");
    }

    if ("".equals(CommonUtils.nvl(eGhlAuthTokenUrl))) {
      throw new ApplicationException(AppConstants.FAIL, "NO VALUE FOR eGHL TOKEN AUTHENTICATION URL. PLEASE CHECK FOR eGHL TOKEN AUTHENTICATION URL.");
    }

    if ("".equals(CommonUtils.nvl(eGhlPmtLinkUrl))) {
      throw new ApplicationException(AppConstants.FAIL, "NO VALUE FOR eGHL PAYMENT LINK CREATION URL. PLEASE CHECK FOR PAYMENT LINK CREATION URL.");
    }

    // STEP 2 :: VALIDATE REQUIRED PARAMETER
    if ("".equals( CommonUtils.nvl(params.get( "custNm" )))) {
      throw new ApplicationException(AppConstants.FAIL, "CUSTOMER NAME IS REQUIRED.");
    }
    if ("".equals( CommonUtils.nvl(params.get( "custCtnt" )))) {
      throw new ApplicationException(AppConstants.FAIL, "CUSTOMER CONTACT NUMBER IS REQUIRED.");
    }
    if ("".equals( CommonUtils.nvl(params.get( "custEmail" )))) {
      throw new ApplicationException(AppConstants.FAIL, "CUSTOMER EMAIL IS REQUIRED.");
    }
    if ("".equals( CommonUtils.nvl(params.get( "ordDesc" )))) {
      throw new ApplicationException(AppConstants.FAIL, "ORDER DESCRIPTION IS REQUIRED.");
    }
    if ("".equals( CommonUtils.nvl(params.get( "ordNo" )))) {
      throw new ApplicationException(AppConstants.FAIL, "ORDER DESCRIPTION IS REQUIRED.");
    }
    if ("".equals( CommonUtils.nvl(params.get( "ordTtlAmt" )))) {
      throw new ApplicationException(AppConstants.FAIL, "ORDER TOTAL AMOUNT IS REQUIRED.");
    }

    Map<String, Object> reqsTokenParam = new HashMap<>();
    reqsTokenParam.put( "eGhlTyp", 1 ); // REQUEST TOKEN
    if (!"".equals( CommonUtils.nvl(params.get( "reqsMod" )))) {
      reqsTokenParam.put( "reqsMod", CommonUtils.nvl(params.get( "reqsMod" )) ); // REQUEST MODULE - DEFAULT CMN
    }

    // CREATE JSON OBJECT WITH PARAMETERS
    JSONObject parameters = new JSONObject();
    parameters.put("ulcversion", 3);
    parameters.put("ulcuserlogin", pmtLinkMerchId);
    parameters.put("ulcpwd", pmtLinkMerchPassw);

    // INSERT REQUEST TOKEN DETAIL
    reqsTokenParam.put( "reqsId", commonMapper.getReqsId() );
    reqsTokenParam.put( "reqsParam", parameters.toString() ); // REQUEST PARAM
    commonMapper.createTokenReqs( reqsTokenParam );

    // STEP 3 :: SEND REQUEST TO eGHL FOR AUTHENTICATION TOKEN
    // URL OF THE API ENDPOINT
    URL reqAuthToken = new URL(eGhlAuthTokenUrl); // TOBE MOVE TO PROPERTIES FILE
    // OPEN A CONNECTION TO THE URL
    HttpURLConnection connection = (HttpURLConnection) reqAuthToken.openConnection();
    // SET THE REQUEST METHOD TO POST
    connection.setRequestMethod("POST");
    // SET HEADERS
    connection.setRequestProperty("Content-Type", "application/json");
    connection.setRequestProperty("Accept", "application/json");
    // ENABLE OUTPUT AND INPUT STREAM
    connection.setDoOutput(true);
    connection.setDoInput(true);
    // WRITE JSON PARAMETER TO THE OUT STREAM
    DataOutputStream outputStream = new DataOutputStream(connection.getOutputStream());
    outputStream.writeBytes(parameters.toString());
    outputStream.flush();
    outputStream.close();
    // READ RESPONSE FROM THE INPUT STREAM
    BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
    String line;
    StringBuilder response = new StringBuilder();
    while ((line = reader.readLine()) != null) {
        response.append(line);
    }
    reader.close();

    // PRINT RESPONSE
    System.out.println("Response: " + response.toString());

    // PARSE RESPONE JSON STRING TO JSONObject
    JSONObject jsonResponse = new JSONObject(response.toString());

    if ("".equals( CommonUtils.nvl(jsonResponse.getString("ulogintoken")) )) {
      throw new ApplicationException(AppConstants.FAIL, "FAIL TO OBTAIN AUTHENTICATION TOKEN FROM eGHL. MESSAGE : " + CommonUtils.nvl(jsonResponse.getString("uremark")));
    }

    // SET EACH PARAMETER FROM THE RESPONSE
    reqsTokenParam.put( "merchId", CommonUtils.nvl(jsonResponse.getString("uuserlogin")) ); // MERCHART ID
    reqsTokenParam.put( "authToken", CommonUtils.nvl(jsonResponse.getString("ulogintoken")) ); // AUTH. TOKEN
    reqsTokenParam.put( "merchCurr", CommonUtils.nvl(jsonResponse.getString("ucurrency")) ); // MERCHART CURRENCY
    reqsTokenParam.put( "authStat", CommonUtils.nvl(jsonResponse.getString("ustatus")) ); // GET AUTH. TOKEN STATUS
    reqsTokenParam.put( "authRmk", CommonUtils.nvl(jsonResponse.getString("uremark")) ); // GET AUTH. TOKEN REMARK;
    reqsTokenParam.put( "response", CommonUtils.nvl(response.toString()) ); // FULL RESPONSE CODE

    // UPDATE RESPONSE TOKEN DETAIL
    commonMapper.updateTokenResp( reqsTokenParam );

    Map<String, Object> reqsPmtLinkParam = new HashMap<>();
    reqsPmtLinkParam.put( "eGhlTyp", 2 ); // REQUEST PAYMENT LINK
    if (!"".equals( CommonUtils.nvl(params.get( "reqsMod" )))) {
      reqsPmtLinkParam.put( "reqsMod", CommonUtils.nvl(params.get( "reqsMod" )) ); // REQUEST MODULE - DEFAULT CMN
    }
    // MANDATORY FIELDS
    reqsPmtLinkParam.put( "epltoken", CommonUtils.nvl(reqsTokenParam.get( "authToken" )) );
    reqsPmtLinkParam.put( "eplcustomername", CommonUtils.nvl(params.get( "custNm" )) );
    reqsPmtLinkParam.put( "eplcustomercontact", CommonUtils.nvl(params.get( "custCtnt" )) );
    reqsPmtLinkParam.put( "eplcustomeremail", CommonUtils.nvl(params.get( "custEmail" )) );

    if (CommonUtils.nvl(params.get( "ordDesc" )).length() >= 97) { // MAX LENGTH FOR ORDER DESCRIPTION FOR EGHL IS 99
      StringBuilder ordDesc = new StringBuilder(CommonUtils.nvl(params.get( "ordDesc" )).substring(0, 97));
      ordDesc.append( ".." );
      reqsPmtLinkParam.put( "eplorderdesc", CommonUtils.nvl(ordDesc) );
    } else {
      reqsPmtLinkParam.put( "eplorderdesc", CommonUtils.nvl(params.get( "ordDesc" )) );
    }

    reqsPmtLinkParam.put( "eplordernumber", CommonUtils.nvl(params.get( "ordNo" )) );
    if ("".equals( CommonUtils.nvl(params.get( "ordCurr" )) )) {
      reqsPmtLinkParam.put( "eplcurrency", CommonUtils.nvl(reqsTokenParam.get( "merchCurr" )) );
    } else {
      reqsPmtLinkParam.put( "eplcurrency", CommonUtils.nvl(params.get( "ordCurr" )) );
    }
    reqsPmtLinkParam.put( "eplamount", CommonUtils.nvl(params.get( "ordTtlAmt" )) );

    // OPTIONAL FIELDS
    reqsPmtLinkParam.put( "eplreminder", CommonUtils.nvl(params.get( "ordRmd" )) );
    reqsPmtLinkParam.put( "eplserviceid", CommonUtils.nvl(params.get( "ordSvcId" )) );
    reqsPmtLinkParam.put( "eplexpiry", CommonUtils.nvl(params.get( "ordPmtExp" )) );
    reqsPmtLinkParam.put( "eplreminderindatetime", CommonUtils.nvl(params.get( "ordRmdDtTm" )) );
    reqsPmtLinkParam.put( "epldisableonsuccess", CommonUtils.nvl(params.get( "ordDisbSucc" )) );
    if ("".equals( CommonUtils.nvl(params.get( "ordPmtLinkEmailInd" )))) {
      reqsPmtLinkParam.put( "ordPmtLinkEmailInd", "N" );
    } else {
      reqsPmtLinkParam.put( "ordPmtLinkEmailInd", CommonUtils.nvl(params.get( "ordPmtLinkEmailInd" )) );
    }

    // CLOSE CONNECTION
    connection.disconnect();

    // CREATE JSON OBJECT WITH PARAMETERS
    parameters = new JSONObject();
    parameters.put("epltoken", reqsPmtLinkParam.get( "epltoken" ));
    parameters.put("eplcustomername", reqsPmtLinkParam.get( "eplcustomername" ));
    parameters.put("eplcustomercontact", reqsPmtLinkParam.get( "eplcustomercontact" ));
    parameters.put("eplcustomeremail", reqsPmtLinkParam.get( "eplcustomeremail" ));
    parameters.put("eplorderdesc", reqsPmtLinkParam.get( "eplorderdesc" ));
    parameters.put("eplordernumber", reqsPmtLinkParam.get( "eplordernumber" ));
    parameters.put("eplcurrency", reqsPmtLinkParam.get( "eplcurrency" ));
    parameters.put("eplamount", reqsPmtLinkParam.get( "eplamount" ));
    parameters.put("eplreminder", reqsPmtLinkParam.get( "eplreminder" ));
    parameters.put("eplserviceid", reqsPmtLinkParam.get( "eplserviceid" ));
    parameters.put("eplexpiry", reqsPmtLinkParam.get( "eplexpiry" ));
    parameters.put("eplreminderindatetime", reqsPmtLinkParam.get( "eplreminderindatetime" ));
    parameters.put("epldisableonsuccess", reqsPmtLinkParam.get( "epldisableonsuccess" ));

    // INSERT REQUEST PAYMENT LINK DETAIL
    reqsPmtLinkParam.put( "reqsId", commonMapper.getReqsId() );
    reqsPmtLinkParam.put( "reqsParam", parameters.toString() ); // REQUEST PARAM
    commonMapper.createPmtLinkReqs( reqsPmtLinkParam );

    // STEP 4 :: REQUEST PAYMENT LINK
    // CREATE URL OBJECT
    URL urlReqPntLink = new URL(eGhlPmtLinkUrl);
    // OPEN CONNECTION
    connection = (HttpURLConnection) urlReqPntLink.openConnection();
    // SET HEADERS
    connection.setRequestProperty("Content-Type", "application/json");
    connection.setRequestProperty("Accept", "application/json");
    // SET REQUEST METHOD
    connection.setRequestMethod("POST");
    // ENABLE OUTPUT AND INPUT STREAM
    connection.setDoOutput(true);
    connection.setDoInput(true);
    // WRITE JSON PARAMETER TO THE OUT STREAM
    outputStream = new DataOutputStream(connection.getOutputStream());
    outputStream.writeBytes(parameters.toString());
    outputStream.flush();
    outputStream.close();
    // READ RESPONSE FROM THE INPUT STREAM
    reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
    //String line;
    response = new StringBuilder();
    while ((line = reader.readLine()) != null) {
        response.append(line);
    }
    reader.close();

    // PRINT RESPONSE
    System.out.println("Response: " + response.toString());

    // PARSE RESPONE JSON STRING TO JSONObject
    jsonResponse = new JSONObject(response.toString());
    JSONObject queryResult = jsonResponse.getJSONObject("queryResult");

    if ("".equals( CommonUtils.nvl(queryResult.getString("paymentlink")) )) {
      throw new ApplicationException(AppConstants.FAIL, "FAIL TO OBTAIN PAYMENT LINK FROM eGHL. MESSAGE : " + CommonUtils.nvl(queryResult.getString( "respMessage" )));
    }

    reqsPmtLinkParam.put( "response", CommonUtils.nvl(response.toString()) );
    reqsPmtLinkParam.put( "pmtLink", CommonUtils.nvl(queryResult.getString("paymentlink")) );
    reqsPmtLinkParam.put( "respCde", CommonUtils.nvl(queryResult.getString("respCode")) );
    reqsPmtLinkParam.put( "respRmk", queryResult.isNull("respMessage") ? "" : CommonUtils.nvl(queryResult.getString("respMessage")) );

    // UPDATE RESPONSE PAYMENT LINK DETAIL
    commonMapper.updatePmtLinkResp( reqsPmtLinkParam );

    return null;
  }
}
