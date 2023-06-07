package com.coway.trust.biz.services.servicePlanning.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.servicePlanning.CTSubGroupListService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("CTSubGroupListService")
public class CTSubGroupListServiceImpl  extends EgovAbstractServiceImpl implements CTSubGroupListService{
	private static final Logger logger = LoggerFactory.getLogger(CTSubGroupListService.class);

	@Resource(name = "CTSubGroupListMapper")
	private CTSubGroupListMapper CTSubGroupListMapper;

	@Override
	public List<EgovMap> selectCTSubGroupList(Map<String, Object> params) {
		return CTSubGroupListMapper.selectCTSubGroupList(params);
	}

	@Override
	public List<EgovMap> selectCTAreaSubGroupList(Map<String, Object> params) {
		return CTSubGroupListMapper.selectCTAreaSubGroupList(params);
	}

	@Override
	public List<EgovMap> selectCTSubGroupDscList(Map<String, Object> params) {
		return CTSubGroupListMapper.selectCTSubGroupDscList(params);
	}

	@Override
	public List<EgovMap> selectCTM(Map<String, Object> params) {
		return CTSubGroupListMapper.selectCTM(params);
	}

	@Override
	public void insertCTSubGroup(List<Object> params) {
		for(int i=0; i< params.size(); i++){
			Map<String, Object>  insertValue = (Map<String, Object>) params.get(i);
			logger.debug("insertValue {}", insertValue);
			CTSubGroupListMapper.insertCTSubGroup(insertValue);
		}
	}

	@Override
	public void updateCTSubGroupByExcel(List<Map<String, Object>> updateList) {
		for(int i=0; i< updateList.size(); i++){
			Map<String, Object>  insertValue = (Map<String, Object>) updateList.get(i);
			logger.debug("insertValue {}", insertValue);
			CTSubGroupListMapper.insertCTSubGroup(insertValue);
		}
	}

	@Override
	public void insertCTSubAreaGroup(List<Object> params) {
		for(int i=0; i< params.size(); i++){
			Map<String, Object>  insertValue = (Map<String, Object>) params.get(i);
			if(insertValue.get("locType").toString().equals("Local")){
				insertValue.put("locType", "L");
				insertValue.put("serviceWeek", 0);
			}else{
				insertValue.put("locType", "O");
				if(insertValue.get("svcWeek") != null){
					insertValue.put("serviceWeek", Integer.parseInt(insertValue.get("svcWeek").toString()));
				}
			}
			logger.debug("insertValue {}", insertValue);
			CTSubGroupListMapper.insertCTSubAreaGroup(insertValue);
		}
	}

	@Override
	public void updateCTAreaByExcel(List<Map<String, Object>> updateList) {
		for(int i=0; i< updateList.size(); i++){
			Map<String, Object>  insertValue = (Map<String, Object>) updateList.get(i);
			if(insertValue.get("locType").toString().equals("Local")){
				insertValue.put("locType", "L");
				insertValue.put("serviceWeek", 0);
			}else{
				insertValue.put("locType", "O");
				if(insertValue.get("svcWeek") != null){
					insertValue.put("serviceWeek", Integer.parseInt(insertValue.get("svcWeek").toString()));
				}
			}
			logger.debug("insertValue {}", insertValue);
			CTSubGroupListMapper.insertCTSubAreaGroup(insertValue);
		}
	}

	@Override
	public List<EgovMap> selectCTMByDSC(Map<String, Object> params) {

		return CTSubGroupListMapper.selectCTMByDSC(params);
	}

	@Override
	public List<EgovMap> selectCTSubGrb(Map<String, Object> params) {

		return CTSubGroupListMapper.selectCTSubGrb(params);
	}

	@Override
	public List<EgovMap> selectCTSubGroupMajor(Map<String, Object> params) {

		return CTSubGroupListMapper.selectCTSubGroupMajor(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public int ctSubGroupSave(Map<String, Object> params, SessionVO sessionVO) {
		int rntCnt = 0;
		// user id 빼기
		params.put("userId", sessionVO.getUserId());

		// 1.subgroup
		List<Object> subGroups = (List<Object>) params.get("subGroupList");
		Map<String, Object>  insertValue = null;
		List<String> insertSubgrps = new ArrayList<String>();

		if(subGroups != null && subGroups.size() != 0){
    		for(int i=0; i< subGroups.size(); i++) {
    			insertValue = (Map<String, Object>) subGroups.get(i);
    			insertValue.put("memId", params.get("memId"));
    			insertValue.put("userId", params.get("userId"));

    			insertSubgrps.add(CommonUtils.nvl(insertValue.get("ctSubGrp")));

    			// 이미 있나 확인
    			int ctSubGroupCnt = CTSubGroupListMapper.selectOneCTSubGrb(insertValue);
    			if(ctSubGroupCnt <= 0) {
    				CTSubGroupListMapper.insertSvc0054m(insertValue);
    			}

    		}
    		// 세이브 한거 이외 있으면 지워 주기
    		insertValue.put("insertSubgrps", insertSubgrps);
    		logger.debug("{}",  insertValue);
    		List<EgovMap> isDelete = CTSubGroupListMapper.selectNotChooseCTSubGrb(insertValue);

    		if(isDelete != null && isDelete.size() != 0 ){
    			CTSubGroupListMapper.deleteSvc0054m(insertValue);
    		}

    	} else{
			//없으면 다지우기
			CTSubGroupListMapper.deleteSvc0054m(params);
		}

		//2.mainGroup 이미 있나 확인
		String isMain = (String) params.get("mainGroup");

		if( isMain != null && isMain != "") {
			int mainGroupCnt =CTSubGroupListMapper.selectOneMainGroup(params);

			if(mainGroupCnt <= 0) {
    			// 앞에서 넣어줬을 경우, 이미 있는 경우
    			EgovMap ctSubGroup = CTSubGroupListMapper.selectAlreadyCTSubGrb(params);

    			if( ctSubGroup != null && ctSubGroup.size() != 0){
    				// 업데이트, 앞에서 넣어줬을경우
    				CTSubGroupListMapper.updateMajorgroup(params);
    			} else {
    				// 넣어주기
    				CTSubGroupListMapper.insertMajorgroup(params);
    			}
			}
		}
		// 선택 안된거는 다지우기
		CTSubGroupListMapper.updateNotMajorGroup(params);

		return rntCnt;
	}

	/**
	 * 월단위 년달력 조회
	 * @Author KR-SH
	 * @Date 2019. 11. 21.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.services.servicePlanning.CTSubGroupListService#selectYearCalendar(java.util.Map)
	 */
	@Override
	public Map<String, List<EgovMap>> selectYearCalendar(Map<String, Object> params) {
		String paramYear = CommonUtils.nvl2(params.get("paramYear"), CommonUtils.getDateToFormat("YYYY"));
		String paramMonth = "";
		Map<String, List<EgovMap>> rtnMap = new HashMap<String, List<EgovMap>>();

		for(int i = 1; i<=12; ++i) {
			paramMonth = StringUtils.leftPad(CommonUtils.nvl(i), 2, "0");
			params.put("paramMonth", paramYear+paramMonth);
			rtnMap.put("MON_"+paramMonth, CTSubGroupListMapper.selectMonthCalendar(params));
		}

		return rtnMap;
	}

	/**
	 * select Sub Group Service Day List
	 * @Author KR-SH
	 * @Date 2019. 11. 21.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.services.servicePlanning.CTSubGroupListService#selectSubGroupServiceDayList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectSubGroupServiceDayList(Map<String, Object> params) {
		return CTSubGroupListMapper.selectSubGroupServiceDayList(params);
	}

	/**
	 * Save Sub Group Service Day List
	 * @Author KR-SH
	 * @Date 2019. 11. 22.
	 * @param params
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@Override
	public ReturnMessage saveSubGroupServiceDayList(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new  ReturnMessage();
		int rtnCnt = 0;

		// 기존 리스트 가져온다.
		List<EgovMap> orgListMap = CTSubGroupListMapper.selectSubGroupServiceDayList(params);
		List<String> orgList = new ArrayList<String>();
		int logInUserId = sessionVO.getUserId();

		if(orgListMap.size() > 0) {
    		for(EgovMap orgMap : orgListMap) {
    			orgList.add(CommonUtils.nvl(orgMap.get("noscvDt")));
    		}
		}

		// 대상 데이터
		List<String> tarList = (ArrayList<String>) params.get("paramSaveDate");
		Map<String, Object> paramMap = new HashMap<String, Object>();

		if(tarList.size() > 0) {
			for(String tarDate : tarList) {
				// 기존 데이터 리스트와 비교한다.
				if(orgList.indexOf(tarDate) > -1) {	// 동일한 데이터인 경우. - skip
					// 기존 데이터에서 지워준다.
					orgList.remove(orgList.indexOf(tarDate));

			    } else { // 대상 데이터에 내역이 있는 경우. - insert
			    	paramMap.clear();
			    	paramMap.put("areaId", CommonUtils.nvl(params.get("paramAreaId")));
			    	paramMap.put("noscvDt", tarDate);
			    	paramMap.put("disab", HomecareConstants.TB_ORG0029H_DISAB.ADD);  // 추가
			    	paramMap.put("crtUserId", logInUserId);
			    	paramMap.put("updUserId", logInUserId);
			    	paramMap.put("paramSubGrpType", CommonUtils.nvl(params.get("paramSubGrpType")));

			    	// ORG0029H - history table insert
			    	rtnCnt = insert_ORG0029H(paramMap);
			    	if(rtnCnt <= 0) {
	    				throw new ApplicationException(AppConstants.FAIL, "Sub Group ServiceDay List Save Failed.");
	    			}
			    	// ORG0028M - insert
			    	rtnCnt = insert_ORG0028M(paramMap);
			    	if(rtnCnt <= 0) {
			    		throw new ApplicationException(AppConstants.FAIL, "Sub Group ServiceDay List Save Failed.");
	    			}
			    }
			}
		}

		if(orgList.size() > 0) {
			// 남은 기존데이터 내역 - delete
			for(String tarDate : orgList) {
		    	paramMap.clear();
		    	paramMap.put("areaId", CommonUtils.nvl(params.get("paramAreaId")));
		    	paramMap.put("noscvDt", tarDate);
		    	paramMap.put("disab", HomecareConstants.TB_ORG0029H_DISAB.DELETE);  // 삭제
		    	paramMap.put("crtUserId", logInUserId);
		    	paramMap.put("updUserId", logInUserId);
		    	paramMap.put("paramSubGrpType", CommonUtils.nvl(params.get("paramSubGrpType")));

		    	// ORG0029H - history table insert
		    	rtnCnt = insert_ORG0029H(paramMap);
		    	if(rtnCnt <= 0) {
		    		throw new ApplicationException(AppConstants.FAIL, "Sub Group ServiceDay List Save Failed.");
    			}
		    	// ORG0028M - delete
		    	rtnCnt = delete_ORG0028M(paramMap);
		    	if(rtnCnt <= 0) {
		    		throw new ApplicationException(AppConstants.FAIL, "Sub Group ServiceDay List Save Failed.");
    			}
			}
		}

		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Save Success Sub Group ServiceDay List");

		return message;
	}

	/**
	 * Insert Sub Group Service Day
	 * @Author KR-SH
	 * @Date 2019. 11. 22.
	 * @param params
	 * @return
	 */
	@Override
	public int insert_ORG0028M(Map<String, Object> params) {
		return CTSubGroupListMapper.insert_ORG0028M(params);
	}

	/**
	 * Delete Sub Group Service Day
	 * @Author KR-SH
	 * @Date 2019. 11. 22.
	 * @param params
	 * @return
	 */
	@Override
	public int delete_ORG0028M(Map<String, Object> params) {
		return CTSubGroupListMapper.delete_ORG0028M(params);
	}

	/**
	 * Insert Sub Group Service Day - History Table
	 * @Author KR-SH
	 * @Date 2019. 11. 22.
	 * @param params
	 * @return
	 */
	@Override
	public int insert_ORG0029H(Map<String, Object> params) {
		return CTSubGroupListMapper.insert_ORG0029H(params);
	}

	/**
	 * Save All Sub Group Service Day List
	 * @Author KR-SH
	 * @Date 2019. 11. 25.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.services.servicePlanning.CTSubGroupListService#saveAllSubGroupServiceDayList(java.util.Map, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public ReturnMessage saveAllSubGroupServiceDayList(Map<String, Object> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		params.put("updUserId", sessionVO.getUserId());
		// Call Procedure
		CTSubGroupListMapper.saveAllSubGroupServiceDayList(params);

		if(params.get("paramAcSubGrp") != null && !params.get("paramAcSubGrp") .toString().isEmpty()){
			params.put("paramCtSubGrp", params.get("paramAcSubGrp"));
			CTSubGroupListMapper.saveAllSubGroupServiceDayList(params);
		}

		message.setCode(CommonUtils.nvl(params.get("pErrcode")));
		message.setMessage(CommonUtils.nvl(params.get("pErrmsg")));

		return message;
	}

	/**
	 * Save CT Sub Group
	 * @Author KR-SH
	 * @Date 2019. 11. 28.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.services.servicePlanning.CTSubGroupListService#saveCTSubGroup(java.util.List, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public ReturnMessage saveCTSubGroup(List<Map<String, Object>> params, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();

		for(Map<String, Object> insertValue : params) {
			// Update - ORG0005D
			CTSubGroupListMapper.insertCTSubGroup(insertValue);

			insertValue.put("userId", sessionVO.getUserId());
			if(insertValue.get("ltSubGrp") != null && insertValue.get("ltSubGrp") != "")
			{
				insertValue.put("ctSubGrp", insertValue.get("ltSubGrp"));
			}else if(insertValue.get("acSubGrp") != null && insertValue.get("acSubGrp") != "")
			{
				insertValue.put("ctSubGrp", insertValue.get("acSubGrp"));
			}
			else{
				insertValue.put("ctSubGrp", insertValue.get("ctSubGrp"));
			}
			insertValue.put("mainGroup", CommonUtils.nvl(insertValue.get("ctSubGrp")));

			int mainGroupCnt =CTSubGroupListMapper.selectOneMainGroup(insertValue);

			if(mainGroupCnt <= 0) {
				// SVC0054M.MEM_ID 기준으로 전체 Update
				CTSubGroupListMapper.updateNotMajorGroup(insertValue);
    			// 앞에서 넣어줬을 경우, 이미 있는 경우
    			EgovMap ctSubGroup = CTSubGroupListMapper.selectAlreadyCTSubGrb(insertValue);

    			// Update - SVC0054M
    			if( ctSubGroup != null && ctSubGroup.size() != 0){
    				// 업데이트, 앞에서 넣어줬을경우
    				CTSubGroupListMapper.updateMajorgroup(insertValue);
    			} else {
    				// 넣어주기
    				CTSubGroupListMapper.insertMajorgroup(insertValue);
    			}
			}
		}

		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Save Success Sub Group");

		return message;
	}

}
