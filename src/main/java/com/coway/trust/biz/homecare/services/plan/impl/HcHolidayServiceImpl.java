package com.coway.trust.biz.homecare.services.plan.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.services.plan.HcHolidayService;
import com.coway.trust.biz.services.servicePlanning.HolidayService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcHolidayServiceImpl.java
 * @Description : Homecare Holiday Management ServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 14.   KR-SH        First creation
 * </pre>
 */
@Service("hcHolidayService")
public class HcHolidayServiceImpl extends EgovAbstractServiceImpl implements HcHolidayService{

	@Resource(name = "hcHolidayMapper")
	private HcHolidayMapper hcHolidayMapper;

	@Resource(name = "holidayService")
	private HolidayService holidayService;


	/**
	 * Select Homecare Holiday List
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcHolidayService#selectHcHolidayList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectHcHolidayList(Map<String, Object> params) {
		return hcHolidayMapper.selectHcHolidayList(params);
	}


	/**
	 * Select DT Branch(HDC) Assign Holiday List
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcHolidayService#selectDTAssignList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectDTAssignList(Map<String, Object> params) {
		params.put("hdcBranchType", HomecareConstants.HDC_BRANCH_TYPE);
		return hcHolidayMapper.selectDTAssignList(params);
	}

	@Override
	public List<EgovMap> selectLTAssignList(Map<String, Object> params) {
		params.put("hdcBranchType", HomecareConstants.HDC_BRANCH_TYPE);
		return hcHolidayMapper.selectLTAssignList(params);
	}


	/**
	 * Save Homecare Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcHolidayService#saveHcHoliday(java.util.Map, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public ReturnMessage saveHcHoliday(Map<String, List<Map<String, Object>>> params, SessionVO sessionVO) throws Exception{
		ReturnMessage message = new ReturnMessage();
		boolean beforeToday = false;
		boolean alreadyHoliday = false;

		List<Map<String, Object>> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Map<String, Object>> addList = params.get(AppConstants.AUIGRID_ADD); 		    // Get grid addList
		List<Map<String, Object>> delList = params.get(AppConstants.AUIGRID_REMOVE);     // Get grid DeleteList

		// 행 추가시
		if(addList != null) {
			for(Map<String, Object> insertValue : addList) {
    			beforeToday = holidayService.checkBeforeToday(insertValue);
    			// 오늘보다 전날짜면
    			if(beforeToday) {
    				message.setCode(AppConstants.FAIL);
    				message.setMessage("Already Gone");
    				return message;
    			}
    			alreadyHoliday = checkAlreadyHoliday(insertValue);
    			// 중복건인 경우
    			if(alreadyHoliday) {
    				message.setCode(AppConstants.FAIL);
    				message.setMessage("The Holiday Exist Already");
    				return message;
    			}
			}
			insertHcHoliday(addList, sessionVO);
		}

		// 행 수정시
		if(udtList != null) {
			updateHcHoliday(udtList, sessionVO);
		}

		// 행 삭제시
		if(delList != null) {
			for(Map<String, Object> delValue : addList) {
    			beforeToday = holidayService.checkBeforeToday(delValue);
    			//오늘보다 전날짜면
    			if(beforeToday) {
    				message.setCode(AppConstants.FAIL);
    				message.setMessage("Already Gone");
    				return message;
    			}
			}
			deleteHcHoliday(delList, sessionVO);
		}

		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Save Success Homecare Holiday");
		return message;
	}

	/**
	 * Check Duplication Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param insertValue
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcHolidayService#checkAlreadyHoliday(java.util.Map)
	 */
	@Override
	public boolean checkAlreadyHoliday(Map<String, Object> insertValue) {
		int  checkCnt = hcHolidayMapper.selectAlreadyHoliday(insertValue);
		//중복 날짜 존재
		return (checkCnt > 0) ? true : false;
	}

	/**
	 * Insert Homecare Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcHolidayService#insertHcHoliday(java.util.List, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public boolean insertHcHoliday(List<Map<String, Object>> params, SessionVO sessionVO) {
		int rtnCnt = 0;

		if(params.size() > 0) {
    		for(Map<String, Object> param : params) {
    			param.put("holidayType", (CommonUtils.nvl(param.get("holidayType"))).substring(0, 1));
    			param.put("userId", sessionVO.getUserId());

    			rtnCnt = hcHolidayMapper.insertHcHoliday(param);
    			if(rtnCnt <= 0) {
					throw new ApplicationException(AppConstants.FAIL, "Homecare Holiday Insert Failed.");
				}
    		}
    		return true;
		}

		return false;
	}

	/**
	 * update Homecare Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcHolidayService#updateHcHoliday(java.util.List, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public boolean updateHcHoliday(List<Map<String, Object>> params, SessionVO sessionVO) {
		int rtnCnt = 0;

		if(params.size() > 0) {
    		for(Map<String, Object> param : params) {
    			param.put("holidayType", (CommonUtils.nvl(param.get("holidayType"))).substring(0, 1));
    			param.put("userId", sessionVO.getUserId());

    			rtnCnt = hcHolidayMapper.updateHcHoliday(param);
    			if(rtnCnt <= 0) {
					throw new ApplicationException(AppConstants.FAIL, "Homecare Holiday Update Failed.");
				}
    		}
    		return true;
		}
		return false;
	}

	/**
	 * Delete Homecare Holiday
	 * @Author KR-SH
	 * @Date 2019. 11. 14.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcHolidayService#deleteHcHoliday(java.util.List, com.coway.trust.cmmn.model.SessionVO)
	 */
	@Override
	public boolean deleteHcHoliday(List<Map<String, Object>> params, SessionVO sessionVO) {
		int rtnCnt = 0;
		if(params.size() > 0) {
    		for(Map<String, Object> param : params) {
    			param.put("holidayType", (CommonUtils.nvl(param.get("holidayType"))).substring(0, 1));
    			param.put("userId", sessionVO.getUserId());

    			rtnCnt = hcHolidayMapper.deleteHcHoliday(param);
    			if(rtnCnt <= 0) {
					throw new ApplicationException(AppConstants.FAIL, "Homecare Holiday Delete Failed.");
				}
    		}
    		return true;
		}
		return false;
	}


	@SuppressWarnings("unchecked")
	@Override
	public ReturnMessage DTAssignSave(Map<String, Object> params, SessionVO sessionVO) throws Exception {
		ReturnMessage message = new ReturnMessage();

		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Object> delList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);     // Get grid DeleteList

		// 행 수정시
		if(updList != null) {
			insertDTLTAssign(updList, formMap);
		}

		// 행 삭제시
		if(delList != null) {
			deleteDTLTAssign(delList, formMap);
		}

		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Save Success Replacement DT Entry");
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public ReturnMessage LTAssignSave(Map<String, Object> params, SessionVO sessionVO) throws Exception {
		ReturnMessage message = new ReturnMessage();

		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Object> delList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);     // Get grid DeleteList

		// 행 수정시
		if(updList != null) {
			insertDTLTAssign(updList, formMap);
		}

		// 행 삭제시
		if(delList != null) {
			deleteDTLTAssign(delList, formMap);
		}

		message.setCode(AppConstants.SUCCESS);
		message.setMessage("Save Success Replacement LT Entry");
		return message;
	}

	public boolean  insertDTLTAssign(List<Object> updList,Map<String , Object> formMap) {
		Map<String, Object>  insertValue = null;
		for(int i=0; i< updList.size(); i++){
			insertValue = (Map<String, Object>) updList.get(i);
			insertValue.put("holidayType",(formMap.get("holidayType").toString()).substring(0, 1));
			insertValue.put("holiday", formMap.get("holiday"));
			insertValue.put("branchName", formMap.get("branchName"));
			insertValue.put("holidayDesc", formMap.get("holidayDesc") != null ?formMap.get("holidayDesc"):"" );
			insertValue.put("holidaySeq", Integer.parseInt(formMap.get("holidaySeq").toString()));
			insertValue.put("state", formMap.get("state"));
			insertValue.put("memType", formMap.get("memType"));
			//holidaySeq1과 asignSeq 둘다 값이 있으면 inset 되어있다.
			List<EgovMap> CTInfo = hcHolidayMapper.selectDTLTInfo(insertValue);

			if(CTInfo.size() >  0){
			}else{
				hcHolidayMapper.insertDTLTAssign(insertValue);
			}
		}
		return true;
	}

	public boolean  deleteDTLTAssign(List<Object> delList,Map<String , Object> formMap) {
		Map<String, Object>  delValue = null;
		for(int i=0; i< delList.size(); i++){
			delValue = (Map<String, Object>) delList.get(i);
			delValue.put("holidayType", (formMap.get("holidayType").toString()).substring(0, 1));
			delValue.put("holiday", formMap.get("holiday"));
			delValue.put("branchName", formMap.get("branchName"));
			delValue.put("holidayDesc", formMap.get("holidayDesc") != null ?formMap.get("holidayDesc"):"" );
			delValue.put("holidaySeq", Integer.parseInt(formMap.get("holidaySeq").toString()));
			hcHolidayMapper.deleteDTLTAssign(delValue);
		}

		return true;
	}

}
