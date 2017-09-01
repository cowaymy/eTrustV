/*
\ * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.CommStatusFormVO;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.web.common.CommStatusGridData;
import com.coway.trust.web.common.CommStatusVO;
import com.crystaldecisions.reports.common.value.StringValue;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("commonService")
public class CommonServiceImpl extends EgovAbstractServiceImpl implements CommonService {

	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;

	@Override
	public List<EgovMap> selectCodeList(Map<String, Object> params) {
		return commonMapper.selectCodeList(params);
	}

	@Override
	public List<EgovMap> getCommonCodes(Map<String, Object> params) {
		return commonMapper.selectCommonCodes(params);
	}

	@Override
	public List<EgovMap> getAllCommonCodes(Map<String, Object> params) {
		return commonMapper.selectAllCommonCodes(params);
	}

	@Override
	public List<EgovMap> getCommonCodesPage(Map<String, Object> params) {
		return commonMapper.selectCommonCodesPage(params);
	}

	@Override
	public List<EgovMap> getBanks(Map<String, Object> params) {
		return commonMapper.selectBanks(params);
	}

	@Override
	public List<EgovMap> getDefectMasters(Map<String, Object> params) {
		return commonMapper.selectDefectMasters(params);
	}

	@Override
	public List<EgovMap> getDefectDetails(Map<String, Object> params) {
		return commonMapper.selectDefectDetails(params);
	}

	@Override
	public List<EgovMap> getMalfunctionReasons(Map<String, Object> params) {
		return commonMapper.selectMalfunctionReasons(params);
	}

	@Override
	public List<EgovMap> getMalfunctionCodes(Map<String, Object> params) {
		return commonMapper.selectMalfunctionCodes(params);
	}

	@Override
	public List<EgovMap> getReasonCodes(Map<String, Object> params) {
		return commonMapper.selectReasonCodes(params);
	}

	@Override
	public int getCommonCodeTotalCount(Map<String, Object> params) {
		return commonMapper.selectCommonCodeTotalCount(params);
	}

	@Override
	public List<EgovMap> selectI18NList() {
		return commonMapper.selectI18NList();
	}
	
	/************************** User Exceptional Auth Mapping ****************************/
	
	@Override
	public List<EgovMap> selectUserExceptionInfoList(Map<String, Object> params) {
		return commonMapper.selectUserExceptionInfoList(params);
	}	
	
	@Override
	public List<EgovMap> selectUserExceptAdjustList(Map<String, Object> params) {
		return commonMapper.selectUserExceptAdjustList(params);
	}
	
	@Override
	public int insertUserExceptAuthMapping(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;

		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			logger.debug(" >>>>> insertUserExceptAuthMapping ");
			logger.debug(" userId : {}", ((Map<String, Object>) obj).get("userId"));
			
			//String tmpStr =  (String) ((Map<String, Object>) obj).get("hidden");
			//((Map<String, Object>) obj).put("userId", ((Map<String, Object>) obj).get("userId") );
			
			saveCnt++;

			commonMapper.insertUserExceptAuthMapping((Map<String, Object>) obj);
		}

		return saveCnt;
	}
	
	@Override
	public int updateUserExceptAuthMapping(List<Object> updList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : updList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			logger.debug(" >>>>> updateUserExceptAuthMapping ");
			/*logger.debug(" hidden : {}", ((Map<String, Object>) obj).get("hidden"));			
			((Map<String, Object>) obj).put("userId", ((Map<String, Object>) obj).get("hidden") );*/
			
			logger.debug("UserId : {}", ((Map<String, Object>) obj).get("userId"));
			
			saveCnt++;
			
			commonMapper.updateUserExceptAuthMapping((Map<String, Object>) obj);
			
		}
		
		return saveCnt;
	}	
	
	@Override
	public int deleteUserExceptAuthMapping(List<Object> delList, Integer crtUserId) 
	{
		int delCnt = 0;
		
		for (Object obj : delList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			logger.debug(" >>>>> deleteUserExceptAuthMapping ");
			logger.debug("UserId : {}", ((Map<String, Object>) obj).get("userId"));
			
			delCnt++;
			
			commonMapper.deleteUserExceptAuthMapping((Map<String, Object>) obj);

		}
		
		return delCnt;
	}		
	
	/************************** Role Auth Mapping ****************************/
	
	@Override
	public List<EgovMap> selectRoleAuthMappingPopUpList(Map<String, Object> params) {
		return commonMapper.selectRoleAuthMappingPopUpList(params);
	}	
	
	@Override
	public List<EgovMap> selectRoleAuthMappingBtn(Map<String, Object> params) {
		return commonMapper.selectRoleAuthMappingBtn(params);
	}	
	
	@Override
	public List<EgovMap> selectRoleAuthMappingAdjustList(Map<String, Object> params) {
		return commonMapper.selectRoleAuthMappingAdjustList(params);
	}	
	
	@Override
	public List<EgovMap> selectRoleAuthMappingList(Map<String, Object> params) {
		return commonMapper.selectRoleAuthMappingList(params);
	}
	
	@Override
	public int insertRoleAuthMapping(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;

		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			logger.debug(" >>>>> insertRoleAuthMapping ");
			logger.debug(" hidden : {}", ((Map<String, Object>) obj).get("hidden"));
			
			String tmpStr =  (String) ((Map<String, Object>) obj).get("hidden");
			

			saveCnt++;

			commonMapper.insertRoleAuthMapping((Map<String, Object>) obj);
		}

		return saveCnt;
	}	
	
	@Override
	public int updateRoleAuthMapping(List<Object> updList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : updList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			logger.debug(" >>>>> updateRoleAuthMapping ");
			logger.debug(" authCode : {}", ((Map<String, Object>) obj).get("authCode"));
			
			saveCnt++;
			
			commonMapper.updateRoleAuthMapping((Map<String, Object>) obj);
			
		}
		
		return saveCnt;
	}
	
	@Override
	public int deleteRoleAuthMapping(List<Object> delList, Integer crtUserId) 
	{
		int delCnt = 0;
		
		for (Object obj : delList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			logger.debug(" >>>>> deleteRoleAuthMapping ");
			logger.debug(" authCode : {}", ((Map<String, Object>) obj).get("authCode"));
			
			delCnt++;
			
			if ( ((Map<String, Object>) obj).get("authCode").equals("INT"))
            {   
				logger.debug(" deleteRoleAuthMapping_MGR_AuthCode : {}", ((Map<String, Object>) obj).get("authCode"));
				
				((Map<String, Object>) obj).put("oldRoleId",String.valueOf(((Map<String, Object>) obj).get("oldRoleId")));	
				
				commonMapper.deleteMGRRoleAuthMapping((Map<String, Object>) obj);
            }
			else
			{
				commonMapper.deleteRoleAuthMapping((Map<String, Object>) obj);
			}
			
		}
		
		return delCnt;
	}		
	
	@Override
	public int deleteMGRRoleAuthMapping(List<Object> delList, Integer crtUserId) 
	{
		int delCnt = 0;
		
		for (Object obj : delList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			logger.debug(" >>>>> deleteRoleAuthMapping_MGR");
			logger.debug(" hidden : {}", ((Map<String, Object>) obj).get("hidden"));
			
			delCnt++;
			
			commonMapper.deleteMGRRoleAuthMapping((Map<String, Object>) obj);
			
		}
		
		return delCnt;
	}		
	
	/************************** Role Management ****************************/
	
	@Override
	public List<EgovMap> selectRoleList(Map<String, Object> params) {
		return commonMapper.selectRoleList(params);
	}	
	
	/************************** Authorization Management ****************************/
	
	@Override
	public List<EgovMap> selectAuthList(Map<String, Object> params) {
		return commonMapper.selectAuthList(params);
	}	
	
	@Override
	public int insertAuth(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;

		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			logger.debug(" >>>>> insertAuth ");
			logger.debug(" hidden : {}", ((Map<String, Object>) obj).get("hidden"));
			
			String tmpStr =  (String) ((Map<String, Object>) obj).get("hidden");

			saveCnt++;

			commonMapper.insertAuth((Map<String, Object>) obj);
		}

		return saveCnt;
	}
	
	@Override
	public int updateAuth(List<Object> updList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : updList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			logger.debug(" >>>>> updateAuth ");
			logger.debug(" authCode : {}", ((Map<String, Object>) obj).get("authCode"));
			
			saveCnt++;
			
			commonMapper.updateAuth((Map<String, Object>) obj);
			
		}
		
		return saveCnt;
	}
	
	@Override
	public int deleteAuth(List<Object> delList, Integer crtUserId) 
	{
		int delCnt = 0;
		
		for (Object obj : delList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			logger.debug(" >>>>> deleteAuthCode ");
			logger.debug(" authCode : {}", ((Map<String, Object>) obj).get("authCode"));
			
			delCnt++;
			
			commonMapper.deleteAuth((Map<String, Object>) obj);
		}
		
		return delCnt;
	}	
		
	/************************** Menu Management ****************************/
	
	@Override
	public List<EgovMap> selectMenuList(Map<String, Object> params) {
		return commonMapper.selectMenuList(params);
	}	
	
	@Override
	public int deleteMenuId(List<Object> delList, Integer crtUserId) 
	{
		int delCnt = 0;
		
		for (Object obj : delList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
						
			logger.debug(" >>>>> deleteMenuId ");
			logger.debug(" menuId : {}", ((Map<String, Object>) obj).get("menuCode"));
			
			delCnt++;
			
			commonMapper.deleteMenuId((Map<String, Object>) obj);
		}
		
		return delCnt;
	}
	
	@Override
	public int insertMenuCode(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;

		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			logger.debug(" >>>>> insertMenuCode ");
			logger.debug(" menuCode : {}", ((Map<String, Object>) obj).get("menuCode"));

			saveCnt++;

			commonMapper.insertMenuCode((Map<String, Object>) obj);
		}

		return saveCnt;
	}
	
	@Override
	public int updateMenuCode(List<Object> updList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : updList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			logger.debug(" >>>>> updateMenuCode ");
			logger.debug(" menuCode : {}", ((Map<String, Object>) obj).get("menuCode"));
			
			saveCnt++;
			
			commonMapper.updateMenuCode((Map<String, Object>) obj);
			
		}
		
		return saveCnt;
	}	
	
	/************************** Program Management ****************************/
	@Override
	public List<EgovMap> selectProgramList(Map<String, Object> params) {
		return commonMapper.selectProgramList(params);
	}	
	
	@Override
	public List<EgovMap> selectPgmTranList(Map<String, Object> params) {
		return commonMapper.selectPgmTranList(params);
	}	
	
	@Override
	public int deletePgmId(List<Object> delList, Integer crtUserId) 
	{
		int delCnt = 0;
		
		for (Object obj : delList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			if (String.valueOf(((Map<String, Object>) obj).get("pgmCode")).length() == 0 
				|| "null".equals(String.valueOf(((Map<String, Object>) obj).get("pgmCode")))) 
			{
				continue;
			}
			
			logger.debug(" >>>>> deletePgmId ");
			logger.debug(" pgmCode : {}", ((Map<String, Object>) obj).get("pgmCode"));

			
			delCnt++;
			
			commonMapper.deletePgmId((Map<String, Object>) obj);
		}
		
		return delCnt;
	}
	
	@Override
	public int insertPgmId(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;

		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);

			logger.debug(" >>>>> InsertPgmId ");
			logger.debug(" orgCode : {}", ((Map<String, Object>) obj).get("orgCode"));
			logger.debug(" pgmName : {}", ((Map<String, Object>) obj).get("pgmName"));
			logger.debug(" pgmPath : {}", ((Map<String, Object>) obj).get("pgmPath"));
			logger.debug(" pgmDesc : {}", ((Map<String, Object>) obj).get("pgmDesc"));

			saveCnt++;

			commonMapper.insertPgmId((Map<String, Object>) obj);
		}

		return saveCnt;
	}
	
	@Override
	public int updatePgmId(List<Object> updList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : updList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);
			
			logger.debug(" ========= updPgmIdTrans ============== ");
			logger.debug(" pgmCode : {}", ((Map<String, Object>) obj).get("pgmCode"));
			logger.debug(" pgmName : {}", ((Map<String, Object>) obj).get("pgmName"));
			logger.debug(" pgmPath : {}", ((Map<String, Object>) obj).get("pgmPath"));
			logger.debug(" pgmDesc : {}", ((Map<String, Object>) obj).get("pgmDesc"));
			
			saveCnt++;
			
			commonMapper.updatePgmId((Map<String, Object>) obj);
			
		}
		
		return saveCnt;
	}
	
	@Override
	public int updPgmIdTrans(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;

		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);

			if (String.valueOf(((Map<String, Object>) obj).get("pgmCode")).length() == 0) 
			{
				continue;
			}

			logger.debug(" ========= updPgmIdTrans ============== ");
			logger.debug(" pgmCode : {}", ((Map<String, Object>) obj).get("pgmCode"));
			logger.debug(" pgmName : {}", ((Map<String, Object>) obj).get("pgmName"));
			logger.debug(" funcView : {}", ((Map<String, Object>) obj).get("funcView"));
			logger.debug(" funcChng : {}", ((Map<String, Object>) obj).get("funcChng"));
			logger.debug(" funcPrt : {}", ((Map<String, Object>) obj).get("funcPrt"));
			logger.debug(" funcUserDfn1 : {}", ((Map<String, Object>) obj).get("funcUserDfn1"));
			logger.debug(" descUserDfn1 : {}", ((Map<String, Object>) obj).get("descUserDfn1"));
			logger.debug(" funcUserDfn2 : {}", ((Map<String, Object>) obj).get("funcUserDfn2"));
			logger.debug(" descUserDfn2 : {}", ((Map<String, Object>) obj).get("descUserDfn2"));
			logger.debug(" funcUserDfn3 : {}", ((Map<String, Object>) obj).get("funcUserDfn3"));
			logger.debug(" descUserDfn3 : {}", ((Map<String, Object>) obj).get("descUserDfn3"));
			logger.debug(" funcUserDfn4 : {}", ((Map<String, Object>) obj).get("funcUserDfn4"));
			logger.debug(" descUserDfn4 : {}", ((Map<String, Object>) obj).get("descUserDfn4"));
			logger.debug(" funcUserDfn5 : {}", ((Map<String, Object>) obj).get("funcUserDfn5"));
			logger.debug(" descUserDfn5 : {}", ((Map<String, Object>) obj).get("descUserDfn5"));

			saveCnt++;

			commonMapper.updPgmIdTrans((Map<String, Object>) obj);

		}

		return saveCnt;
	}	

	/************************** Status Code ****************************/
	// StatusCategory
	@Override
	public List<EgovMap> selectStatusCategoryList(Map<String, Object> params) {
		return commonMapper.selectStatusCategoryList(params);
	}

	// StatusCategory Code
	@Override
	public List<EgovMap> selectStatusCategoryCodeList(Map<String, Object> params) {
		return commonMapper.selectStatusCategoryCodeList(params);
	}

	// StatusCode
	@Override
	public List<EgovMap> selectStatusCodeList(Map<String, Object> params) {
		return commonMapper.selectStatusCodeList(params);
	}

	@Override
	public int insertStatusCategory(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;

		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);

			if (String.valueOf(((Map<String, Object>) obj).get("stusCtgryName")).length() == 0) 
			{
				continue;
			}

			logger.debug(" InsertSatusCategory ");
			logger.debug(" stusCtgryId : {}", ((Map<String, Object>) obj).get("stusCtgryId"));
			logger.debug(" stusCtgryName : {}", ((Map<String, Object>) obj).get("stusCtgryName"));
			logger.debug(" stusCtgryDesc : {}", ((Map<String, Object>) obj).get("stusCtgryDesc"));
			logger.debug(" crtUserId : {}", ((Map<String, Object>) obj).get("crtUserId"));
			logger.debug(" updUserId : {}", ((Map<String, Object>) obj).get("updUserId"));

			saveCnt++;

			commonMapper.insertStatusCategory((Map<String, Object>) obj);

		}

		return saveCnt;
	}

	@Override
	public int updateStatusCategory(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;

		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);

			if (String.valueOf(((Map<String, Object>) obj).get("stusCtgryName")).length() == 0) 
			{
				continue;
			}

			logger.debug(" InsertSatusCategory ");
			logger.debug(" stusCtgryId : {}", ((Map<String, Object>) obj).get("stusCtgryId"));
			logger.debug(" stusCtgryName : {}", ((Map<String, Object>) obj).get("stusCtgryName"));
			logger.debug(" stusCtgryDesc : {}", ((Map<String, Object>) obj).get("stusCtgryDesc"));
			logger.debug(" crtUserId : {}", ((Map<String, Object>) obj).get("crtUserId"));
			logger.debug(" updUserId : {}", ((Map<String, Object>) obj).get("updUserId"));

			saveCnt++;

			commonMapper.updateStatusCategory((Map<String, Object>) obj);

		}

		return saveCnt;
	}

	@Override
	public int insertStatusCode(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;

		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);

			logger.debug("[insertStatusCode]");
			logger.debug(" codeName : {}", ((Map<String, Object>) obj).get("codeName"));
			logger.debug(" code : {}", ((Map<String, Object>) obj).get("code"));

			saveCnt++;

			commonMapper.insertStatusCode((Map<String, Object>) obj);
		}
		return saveCnt;
	}

	@Override
	public int updateStatusCode(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;

		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);

			logger.debug(" updateStatusCode ");
			logger.debug(" stusCodeId : {}", ((Map<String, Object>) obj).get("stusCodeId"));
			logger.debug(" codeName : {}", ((Map<String, Object>) obj).get("codeName"));
			logger.debug(" code : {}", ((Map<String, Object>) obj).get("code"));

			saveCnt++;

			commonMapper.updateStatusCode((Map<String, Object>) obj);
		}

		return saveCnt;
	}

	@Override
	public int insertStatusCategoryCode(CommStatusVO formDataParameters, Integer crtUserId) 
	{
		int saveCnt = 0;

		GridDataSet<CommStatusGridData> gridDataSet = formDataParameters.getGridDataSet();
		List<CommStatusGridData> updateList = gridDataSet.getUpdate(); // check 된 리스트
		CommStatusFormVO commStatusVO = formDataParameters.getCommStatusVO();// form내의 input 객체
				
		Map<String, Object> param = null;
		for (CommStatusGridData gridData : updateList) 
		{
			param = BeanConverter.toMap(gridData);  // list --> map
			
		//	logger.debug("list: " + param.toString() );
			
			if ("0".equals(String.valueOf(param.get("checkFlag"))))
			{
				continue;
			}
			
			param.put("stusCtgryId", commStatusVO.getCatalogId());
			param.put("crtUserId", crtUserId);
			param.put("updUserId", crtUserId);
			
			commonMapper.insertStatusCategoryCode(param);
			
			saveCnt++;
		}

		return saveCnt;
	}

	// SUS0037M DisibleYN
	@Override
	public int updateCategoryCodeYN(CommStatusVO formDataParameters, Integer updUserId) 
	{
		int saveCnt = 0;

		GridDataSet<CommStatusGridData> gridDataSet = formDataParameters.getGridDataSet();
		List<CommStatusGridData> updateList = gridDataSet.getUpdate(); // grid에서 check 된 리스트
		CommStatusFormVO commStatusVO = formDataParameters.getCommStatusVO();// form내의 input 객체
		
		Map<String, Object> param = null;
		for (CommStatusGridData gridData : updateList) 
		{
			param = BeanConverter.toMap(gridData);  // grid의 필드명(key)과 데이타값을 map형식으로 자동변환

			param.put("stusCtgryId", commStatusVO.getCatalogId());  // form의 input객체를 map형식으로 변환
			//param.put("updUserId", updUserId); 
			
			commonMapper.updateCategoryCodeYN(param);
			
			saveCnt++;
		}

		return saveCnt;
	}

	/************************** Account Code ****************************/
	@Override
	public List<EgovMap> getAccountCodeList(Map<String, Object> params) 
	{
		return commonMapper.getAccountCodeList(params);
	}

	// Account Code Count
	@Override
	public int getAccCodeCount(Map<String, Object> params) 
	{
		return commonMapper.getAccCodeCount(params);
	}

	// AccoutCode Insert
	/*
	 * @Override public int insertAccountCode(Map<String, Object> params) { return
	 * commonMapper.insertAccountCode(params); }
	 */

	// AccoutCode Merge
	@Override
	public int mergeAccountCode(Map<String, Object> params) 
	{
		return commonMapper.mergeAccountCode(params);
	}

	// Gerneral Code
	@Override
	public List<EgovMap> getMstCommonCodeList(Map<String, Object> params) 
	{
		return commonMapper.getMstCommonCodeList(params);
	}

	@Override
	public List<EgovMap> getDetailCommonCodeList(Map<String, Object> params) 
	{
		return commonMapper.getDetailCommonCodeList(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public int addCommCodeGrid(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;

		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);

			logger.debug(" InsertMstCommCd ");
			logger.debug(" codeMasterId : {}", ((Map<String, Object>) obj).get("codeMasterId"));
			logger.debug(" disabled : {}", ((Map<String, Object>) obj).get("disabled"));
			logger.debug(" codeMasterName : {}", ((Map<String, Object>) obj).get("codeMasterName"));
			logger.debug(" codeDesc : {}", ((Map<String, Object>) obj).get("codeDesc"));
			logger.debug(" createName : {}", ((Map<String, Object>) obj).get("createName"));
			logger.debug(" crtDt : {}", ((Map<String, Object>) obj).get("crtDt"));

			saveCnt++;

			commonMapper.addCommCodeGrid((Map<String, Object>) obj);
		}

		return saveCnt;
	}

	@Override
	public int udtCommCodeGrid(List<Object> udtList, Integer updUserId) 
	{
		int saveCnt = 0;

		for (Object obj : udtList) 
		{
			((Map<String, Object>) obj).put("crtUserId", updUserId);
			((Map<String, Object>) obj).put("updUserId", updUserId);

			logger.debug(" update CommCode");
			logger.debug(" codeMasterId : {}", ((Map<String, Object>) obj).get("codeMasterId"));
			logger.debug(" disabled : {}", ((Map<String, Object>) obj).get("disabled"));
			logger.debug(" codeMasterName : {}", ((Map<String, Object>) obj).get("codeMasterName"));
			logger.debug(" codeDesc : {}", ((Map<String, Object>) obj).get("codeDesc"));
			logger.debug(" createName : {}", ((Map<String, Object>) obj).get("createName"));
			logger.debug(" crtDt : {}", ((Map<String, Object>) obj).get("crtDt"));

			saveCnt++;

			commonMapper.updCommCodeGrid((Map<String, Object>) obj);
		}
		return saveCnt;
	}

	@SuppressWarnings("unchecked")
	@Override
	public int addDetailCommCodeGrid(List<Object> addList, Integer crtUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : addList) 
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);

			logger.debug(" [[Insert Deatail]] ");
			logger.debug(" codeMasterId : {}", ((Map<String, Object>) obj).get("codeMasterId"));
			logger.debug(" detailcode : {}", ((Map<String, Object>) obj).get("detailcode"));
			logger.debug(" detailcodename : {}", ((Map<String, Object>) obj).get("detailcodename"));
			logger.debug(" detailcodedesc : {}", ((Map<String, Object>) obj).get("detailcodedesc"));
			logger.debug(" detaildisabled : {}", ((Map<String, Object>) obj).get("detaildisabled"));
			logger.debug(" crtUserId : {}", ((Map<String, Object>) obj).get("crtUserId"));
			logger.debug(" updUserId : {}", ((Map<String, Object>) obj).get("updUserId"));
			
			saveCnt++;

			commonMapper.addDetailCommCodeGrid((Map<String, Object>) obj);
		}

		return saveCnt;// commit;
	}

	@Override
	public int udtDetailCommCodeGrid(List<Object> udtList, Integer updUserId) 
	{
		int saveCnt = 0;
		
		for (Object obj : udtList) 
		{
			((Map<String, Object>) obj).put("crtUserId", updUserId);
			((Map<String, Object>) obj).put("updUserId", updUserId);

			logger.debug(" update_Detail ");
			logger.debug(" detailcode : {}", ((Map<String, Object>) obj).get("detailcode"));
			logger.debug(" detailcodename : {}", ((Map<String, Object>) obj).get("detailcodename"));
			logger.debug(" detailcodedesc : {}", ((Map<String, Object>) obj).get("detailcodedesc"));
			logger.debug(" detaildisabled : {}", ((Map<String, Object>) obj).get("detaildisabled"));
			logger.debug(" updUserId : {}", ((Map<String, Object>) obj).get("updUserId"));
			logger.debug(" detailcodeid : {}", ((Map<String, Object>) obj).get("detailcodeid"));
			
			saveCnt++;

			commonMapper.updDetailCommCodeGrid((Map<String, Object>) obj);
		}
		
		return saveCnt;
	}

	@Override
	public List<EgovMap> selectBranchList(Map<String, Object> params) 
	{
		return commonMapper.selectBranchList(params);
	}

	/**
	 * Account 정보 조회 (크레딧 카드 리스트 / 은행 계좌 리스트)
	 * 
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> getAccountList(Map<String, Object> params) {
		return commonMapper.getAccountList(params);
	}

	/**
	 * Branch ID로 User 정보 조회
	 * 
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> getUsersByBranch(Map<String, Object> params) {
		return commonMapper.getUsersByBranch(params);
	}

	@Override
	public List<EgovMap> selectAddrSelCode(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return commonMapper.selectAddrSelCode(params);
	}

	@Override
	public List<EgovMap> selectInStckSelCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return commonMapper.selectInStckSelCodeList(params);
	}
	
	@Override
	public List<EgovMap> selectStockLocationList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return commonMapper.selectStockLocationList(params);
	}

	@Override
	public List<EgovMap> selectBankList() {
		// TODO Auto-generated method stub
		return commonMapper.selectBankList();
	}

	@Override
	public EgovMap selectBrnchIdByPostCode(Map<String, Object> params) {
		return commonMapper.selectBrnchIdByPostCode(params);
	}
	
	@Override
	public List<EgovMap> selectProductList() {
		// TODO Auto-generated method stub
		return commonMapper.selectProductList();
	}

	

	@Override
	public List<EgovMap> selectProductCodeList(Map<String, Object> params) {
		// TODO ProductCodeList 호출시 error남 
		return commonMapper.selectProductCodeList(params);
	}

	@Override
	public List<EgovMap> selectUpperMenuList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return commonMapper.selectUpperMenuList(params);
		
	}
	
	@Override
	public String selectDocNo(String  docId) {	
		return commonMapper.selectDocNo(docId);
	}
	
	/**
	 * Payment - Adjustment CN/DN : Adjustment Reason 정보 조회
	 * 
	 * @param params
	 * @return
	 */
	@Override
	public List<EgovMap> selectAdjReasonList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return commonMapper.selectAdjReasonList(params);
		
	}
}