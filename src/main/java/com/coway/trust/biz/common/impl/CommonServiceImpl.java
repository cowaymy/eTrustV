/*
 * Copyright 2008-2009 the original author or authors.
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

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.cmmn.model.SessionVO;

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
	public List<EgovMap> selectI18NList() {
		return commonMapper.selectI18NList();
	}
	
	@Override
	public 	List<EgovMap> getMstCommonCodeList(Map<String, Object> params) {
		return commonMapper.getMstCommonCodeList(params);
	}
	
	@Override
	public 	List<EgovMap> getDetailCommonCodeList(Map<String, Object> params) {
		return commonMapper.getDetailCommonCodeList(params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public int addCommCodeGrid(List<Object> addList) 
	{
		//HttpSession session = sessionHandler.getCurrentSession();
		int user=99999;
		int saveCnt = 0;
		
		/*if(session != null){
			user = session.getId();
			
		}*/
		
		logger.debug("Add_Size: " + addList.size());
		
		for(Object obj : addList)
		{
			
			/*((Map<String, Object>) obj).put("endDt", CommissionConstants.COMIS_END_DT);*/
			((Map<String, Object>) obj).put("crtUserId", user);
			((Map<String, Object>) obj).put("updUserId", user);
			
			if (String.valueOf(((Map<String, Object>) obj).get("codeMasterName")).length() == 0)
			{
				continue;
			}
			
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
	public int udtCommCodeGrid(List<Object> udtList) 
	{
		int user=99999;
		int saveCnt = 0;
		
		for(Object obj : udtList){
			/*((Map<String, Object>) obj).put("endDt", CommissionConstants.COMIS_END_DT);*/
			((Map<String, Object>) obj).put("crtUserId", user);
			((Map<String, Object>) obj).put("updUserId", user);
			
			if (String.valueOf(((Map<String, Object>) obj).get("codeDesc")).trim().length() == 0)
			{
				logger.debug("AAAAAA_tr");
				((Map<String, Object>) obj).put("codeDesc", "");
			}
			else
			{
				logger.debug("AAAAA_LENGTH: "+ String.valueOf(((Map<String, Object>) obj).get("codeDesc")).length() );
			}
			
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
	public int addDetailCommCodeGrid(List<Object> addList) 
	{
		//HttpSession session = sessionHandler.getCurrentSession();
		int user=99999;
		
		/*if(session != null){
			user = session.getId();
			
		}*/
		
		logger.debug("Detail_Add_Size: " + addList.size());
		
		for(Object obj : addList)
		{
			/*((Map<String, Object>) obj).put("endDt", CommissionConstants.COMIS_END_DT);*/
			((Map<String, Object>) obj).put("crtUserId", user);
			((Map<String, Object>) obj).put("updUserId", user);
			
			
			if (String.valueOf(((Map<String, Object>) obj).get("detailcodename")).length() == 0)
			   {
					continue;
			   }
			
			//{detailcodeid=1D79D7B5-A35F-77D5-CF91-35F79447E439, detailcode=test11, detailcodename=testD, detailcodedesc=testD, detaildisabled=N, codeMasterId=155, crtUserId=99999, updUserId=99999}  		
			logger.debug(" [[Insert Deatail]] ");
			logger.debug(" codeMasterId : {}", ((Map<String, Object>) obj).get("codeMasterId"));
			logger.debug(" detailcode : {}", ((Map<String, Object>) obj).get("detailcode"));
			logger.debug(" detailcodename : {}", ((Map<String, Object>) obj).get("detailcodename"));
			logger.debug(" detailcodedesc : {}", ((Map<String, Object>) obj).get("detailcodedesc"));
			logger.debug(" detaildisabled : {}", ((Map<String, Object>) obj).get("detaildisabled"));
			logger.debug(" crtUserId : {}", ((Map<String, Object>) obj).get("crtUserId"));	
			logger.debug(" updUserId : {}", ((Map<String, Object>) obj).get("updUserId"));	
			
			commonMapper.addDetailCommCodeGrid((Map<String, Object>) obj);
		}
		
		return 0;
	}
	
	@Override
	public int udtDetailCommCodeGrid(List<Object> udtList) 
	{
		int user=99999;
		for(Object obj : udtList){
			((Map<String, Object>) obj).put("crtUserId", user);
			((Map<String, Object>) obj).put("updUserId", user);
			
			logger.debug(" update_Detail ");
			logger.debug(" detailcode : {}", ((Map<String, Object>) obj).get("detailcode"));
			logger.debug(" detailcodename : {}", ((Map<String, Object>) obj).get("detailcodename"));
			logger.debug(" detailcodedesc : {}", ((Map<String, Object>) obj).get("detailcodedesc"));
			logger.debug(" detaildisabled : {}", ((Map<String, Object>) obj).get("detaildisabled"));
			logger.debug(" updUserId : {}", ((Map<String, Object>) obj).get("updUserId"));	
			logger.debug(" detailcodeid : {}", ((Map<String, Object>) obj).get("detailcodeid"));	
			
			commonMapper.updDetailCommCodeGrid((Map<String, Object>) obj);
		}
		return 0;
	}

	@Override
	public void saveCodes(Map<String, Object> params) 
	{
		SessionVO sessionVO = (SessionVO) params.get(AppConstants.SESSION_INFO);
		Map<String, List<Object>> mstList = (Map<String, List<Object>>)params.get("mstData");
		Map<String, List<Object>> dtlList = (Map<String, List<Object>>)params.get("dtlData");
		
		logger.debug("mstList_Size: " + mstList.size() + "dtlList_Size: " + dtlList.size());
		
		List<Object> mstUdtList = mstList.get(AppConstants.AUIGrid_UPDATE); // Get gride UpdateList
		List<Object> mstAddList = mstList.get(AppConstants.AUIGRID_ADD); // Get grid addList
		//List<Object> mstDelList = mstList.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList
		
		List<Object> dtlUdtList = dtlList.get(AppConstants.AUIGrid_UPDATE); // Get gride UpdateList
		List<Object> dtlAddList = dtlList.get(AppConstants.AUIGRID_ADD); // Get grid addList
		//List<Object> dtlDelList = dtlList.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList		
		
		mstAddList.forEach(list -> {
			Map<String, Object> map = (Map<String, Object>)list;
			map.put("crtUserId", sessionVO.getId());
			map.put("updUserId", sessionVO.getId());
			commonMapper.addCommCodeGrid(map);
		});
		
		mstUdtList.forEach(list -> {
			Map<String, Object> map = (Map<String, Object>)list;
			map.put("crtUserId", sessionVO.getId());
			map.put("updUserId", sessionVO.getId());
			commonMapper.updCommCodeGrid(map);
		});
		
		dtlAddList.forEach(list -> {
			Map<String, Object> map = (Map<String, Object>)list;
			map.put("crtUserId", sessionVO.getId());
			map.put("updUserId", sessionVO.getId());
			commonMapper.addDetailCommCodeGrid(map);
		});
		
		dtlUdtList.forEach(list -> {
			Map<String, Object> map = (Map<String, Object>)list;
			map.put("crtUserId", sessionVO.getId());
			map.put("updUserId", sessionVO.getId());
			commonMapper.updDetailCommCodeGrid(map);
		});
		
	}
	
}
