package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.SessionCapacityListService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("sessionCapacityListService")
public class SessionCapacityListServiceImpl extends EgovAbstractServiceImpl implements SessionCapacityListService{



	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(MemberEventServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "sessionCapacityListMapper")
	private SessionCapacityListMapper sessionCapacityListMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;


	@Override
	public List<EgovMap> selectSsCapacityBrList(Map<String, Object> params) {
		params.put("branchTypeId", CommonUtils.nvl2(params.get("branchTypeId"), HomecareConstants.DSC_BRANCH_TYPE));

		return sessionCapacityListMapper.selectSsCapacityBrList(params);
	}

	@Override
	public List<EgovMap> selectSsCapacityCTM(Map<String, Object> params) {
		params.put("memType", CommonUtils.nvl2(params.get("memType"), HomecareConstants.MEM_TYPE.CT));

		return sessionCapacityListMapper.selectSsCapacityCTM(params);
	}

	@Override
	public List<EgovMap> seleCtCodeSearch(Map<String, Object> params) {

		return sessionCapacityListMapper.seleCtCodeSearch(params);
	}
	@Override
	public List<EgovMap> seleCtCodeSearch2(Map<String, Object> params) {

		return sessionCapacityListMapper.seleCtCodeSearch2(params);
	}

	@Override
	public List<EgovMap> seleBranchCodeSearch(Map<String, Object> params) {

		return sessionCapacityListMapper.seleBranchCodeSearch(params);
	}

	Object ParseInteger(Object object) {
		if (object != null && object.toString().length() > 0) {
			try {
				return (int) Double.parseDouble(object.toString());
	       } catch(Exception e) {
	    	   return -1;
	       }
	   }
	   else return null;
	}

	@Override
	public void deleteCapacity(List<Object> params, SessionVO sessionVO) {
		if(params.size() > 0){
			Map<String, Object>  deleteValue = (Map<String, Object>) params.get(0);
//			deleteValue.put("userId", sessionVO.getUserId());
			logger.debug("deleteValue {}", deleteValue);
			sessionCapacityListMapper.deleteCapacity(deleteValue);
		}
	}

	@Override
	public void deleteCapacityByExcel(List<Map<String, Object>> updateList, SessionVO sessionVO) {
		if(updateList.size() > 0){
			Map<String, Object>  deleteValue = (Map<String, Object>) updateList.get(0);
//			deleteValue.put("userId", sessionVO.getUserId());
			logger.debug("deleteValue {}", deleteValue);
			sessionCapacityListMapper.deleteCapacity(deleteValue);
		}
	}

	/**
	 * Select Count Cpacity CTM
	 * @Author KR-SH
	 * @Date 2019. 12. 10.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.organization.organization.SessionCapacityListService#selectCountSsCapacityCTM(java.util.Map)
	 */
	@Override
	public int selectCountSsCapacityCTM(Map<String, Object> params) {
		return sessionCapacityListMapper.selectCountSsCapacityCTM(params);
	}


	@Override
	public List<EgovMap> selectAllCarModelList() {
		return sessionCapacityListMapper.selectAllCarModelList();
	}

	@Override
	public void insertCapacity(List<Object> params, SessionVO sessionVO) {
		boolean addSuccess = false;
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  insertValue = (Map<String, Object>) params.get(i);
    			insertValue.put("userId", sessionVO.getUserId());
    			logger.debug("insertValue {}", insertValue);
    			sessionCapacityListMapper.insertCapacity(insertValue);
    		}
		}
	}

	@Override
	public void updateCapacity(List<Object> params, SessionVO sessionVO) {
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  updateValue = (Map<String, Object>) params.get(i);
    			updateValue.put("userId", sessionVO.getUserId());
    			logger.debug("updateValue {}", updateValue);
    			sessionCapacityListMapper.updateCapacity(updateValue);
    		}
		}
	}

	@Override
	public void updateCTMCapacity(List<Object> params, SessionVO sessionVO) {
		if(params.size() > 0){
			Map<String, Object>  updateValue = (Map<String, Object>) params.get(0);
			updateValue.put("userId", sessionVO.getUserId());
			logger.debug("updateValue {}", updateValue);
			sessionCapacityListMapper.updateCTMCapacity(updateValue);
		}
	}

	@Override
	public void updateCapacityByExcel(List<Map<String, Object>> updateList, SessionVO sessionVO) {
		if(updateList.size() > 0){
    		for(int i=0; i< updateList.size(); i++){
    			Map<String, Object>  updateValue = (Map<String, Object>) updateList.get(i);
    			updateValue.put("userId", sessionVO.getUserId());

    			if( (updateValue.get("morngSesionAs") != null && updateValue.get("morngSesionAs").toString().length() > 0)
    					|| (updateValue.get("morngSesionIns") != null && updateValue.get("morngSesionIns").toString().length() > 0)
    					|| (updateValue.get("morngSesionRtn") != null && updateValue.get("morngSesionRtn").toString().length() > 0)
    					|| (updateValue.get("aftnonSesionAs") != null && updateValue.get("aftnonSesionAs").toString().length() > 0)
    					|| (updateValue.get("aftnonSesionIns") != null && updateValue.get("aftnonSesionIns").toString().length() > 0)
    					|| (updateValue.get("aftnonSesionRtn") != null && updateValue.get("aftnonSesionRtn").toString().length() > 0)
    					|| (updateValue.get("evngSesionAs") != null && updateValue.get("evngSesionAs").toString().length() > 0)
    					|| (updateValue.get("evngSesionIns") != null && updateValue.get("evngSesionIns").toString().length() > 0)
    					|| (updateValue.get("evngSesionRtn") != null && updateValue.get("evngSesionRtn").toString().length() > 0) ) {

    				updateValue.put("codeId", ParseInteger(updateValue.get("codeId")));
    				updateValue.put("memId", ParseInteger(updateValue.get("memId")));
    				updateValue.put("morngSesionAs", ParseInteger(updateValue.get("morngSesionAs")));
    				updateValue.put("morngSesionIns", ParseInteger(updateValue.get("morngSesionIns")));
    				updateValue.put("morngSesionRtn", ParseInteger(updateValue.get("morngSesionRtn")));
    				updateValue.put("aftnonSesionAs", ParseInteger(updateValue.get("aftnonSesionAs")));
    				updateValue.put("aftnonSesionIns", ParseInteger(updateValue.get("aftnonSesionIns")));
    				updateValue.put("aftnonSesionRtn", ParseInteger(updateValue.get("aftnonSesionRtn")));
    				updateValue.put("evngSesionAs", ParseInteger(updateValue.get("evngSesionAs")));
    				updateValue.put("evngSesionIns", ParseInteger(updateValue.get("evngSesionIns")));
    				updateValue.put("evngSesionRtn", ParseInteger(updateValue.get("evngSesionRtn")));

    				logger.debug("updateValue {}", updateValue);
    				sessionCapacityListMapper.updateCapacity(updateValue);
    				sessionCapacityListMapper.deleteCapacity(updateValue);
    			}
    		}
		}
	}

	@Override
	public void updateCTMCapacityByExcel(List<Map<String, Object>> updateList, SessionVO sessionVO) {
		if(updateList.size() > 0){
			Map<String, Object>  updateValue = (Map<String, Object>) updateList.get(0);
			updateValue.put("userId", sessionVO.getUserId());
			logger.debug("updateValue {}", updateValue);
			sessionCapacityListMapper.updateCTMCapacity(updateValue);
		}
	}

	/*
	/ ENHANCE PART FOR Home Appliances ONLY
	*/
	@Override
	public List<EgovMap> selectSsCapacityBrListEnhance(Map<String, Object> params) {
		params.put("branchTypeId", CommonUtils.nvl2(params.get("branchTypeId"), HomecareConstants.DSC_BRANCH_TYPE));

		return sessionCapacityListMapper.selectSsCapacityBrListEnhance(params);
	}

	@Override
	public void insertCapacityEnhance(List<Object> params, SessionVO sessionVO) {
		boolean addSuccess = false;
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  insertValue = (Map<String, Object>) params.get(i);
    			insertValue.put("userId", sessionVO.getUserId());
    			logger.debug("insertValue {}", insertValue);
    			sessionCapacityListMapper.insertCapacityEnhance(insertValue);
    		}
		}
	}

	@Override
	public void updateCapacityEnhance(List<Object> params, SessionVO sessionVO) {
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  updateValue = (Map<String, Object>) params.get(i);
    			updateValue.put("userId", sessionVO.getUserId());
    			logger.debug("updateValue {}", updateValue);
    			sessionCapacityListMapper.updateCapacityEnhance(updateValue);
    		}
		}
	}

	@Override
	public void updateCTMCapacityEnhance(List<Object> params, SessionVO sessionVO) {
		if(params.size() > 0){
			Map<String, Object>  updateValue = (Map<String, Object>) params.get(0);
			updateValue.put("userId", sessionVO.getUserId());
			logger.debug("updateValue {}", updateValue);
			sessionCapacityListMapper.updateCTMCapacityEnhance(updateValue);
		}
	}

	@Override
	public void updateCapacityByExcelEnhance(List<Map<String, Object>> updateList, SessionVO sessionVO) {
		if(updateList.size() > 0){
    		for(int i=0; i< updateList.size(); i++){
    			Map<String, Object>  updateValue = (Map<String, Object>) updateList.get(i);
    			updateValue.put("userId", sessionVO.getUserId());

    			if((updateValue.get("morngSesionAs") != null && updateValue.get("morngSesionAs").toString().length() > 0)
				|| (updateValue.get("morngSesionIns") != null && updateValue.get("morngSesionIns").toString().length() > 0)
				|| (updateValue.get("morngSesionRtn") != null && updateValue.get("morngSesionRtn").toString().length() > 0)
				|| (updateValue.get("aftnonSesionAs") != null && updateValue.get("aftnonSesionAs").toString().length() > 0)
				|| (updateValue.get("aftnonSesionIns") != null && updateValue.get("aftnonSesionIns").toString().length() > 0)
				|| (updateValue.get("aftnonSesionRtn") != null && updateValue.get("aftnonSesionRtn").toString().length() > 0)
				|| (updateValue.get("evngSesionAs") != null && updateValue.get("evngSesionAs").toString().length() > 0)
				|| (updateValue.get("evngSesionIns") != null && updateValue.get("evngSesionIns").toString().length() > 0)
				|| (updateValue.get("evngSesionRtn") != null && updateValue.get("evngSesionRtn").toString().length() > 0)
   				|| (updateValue.get("morngSesionAsSt") != null && updateValue.get("morngSesionAsSt").toString().length() > 0)
				|| (updateValue.get("morngSesionAsDsk") != null && updateValue.get("morngSesionAsDsk").toString().length() > 0)
				|| (updateValue.get("morngSesionAsSml") != null && updateValue.get("morngSesionAsSml").toString().length() > 0)
   				|| (updateValue.get("morngSesionInsSt") != null && updateValue.get("morngSesionInsSt").toString().length() > 0)
				|| (updateValue.get("morngSesionInsDsk") != null && updateValue.get("morngSesionInsDsk").toString().length() > 0)
				|| (updateValue.get("morngSesionInsSml") != null && updateValue.get("morngSesionInsSml").toString().length() > 0)
   				|| (updateValue.get("morngSesionRtnSt") != null && updateValue.get("morngSesionRtnSt").toString().length() > 0)
				|| (updateValue.get("morngSesionRtnDsk") != null && updateValue.get("morngSesionRtnDsk").toString().length() > 0)
				|| (updateValue.get("morngSesionRtnSml") != null && updateValue.get("morngSesionRtnSml").toString().length() > 0)
				|| (updateValue.get("aftnonSesionAsSt") != null && updateValue.get("aftnonSesionAsSt").toString().length() > 0)
				|| (updateValue.get("aftnonSesionAsDsk") != null && updateValue.get("aftnonSesionAsDsk").toString().length() > 0)
				|| (updateValue.get("aftnonSesionAsSml") != null && updateValue.get("aftnonSesionAsSml").toString().length() > 0)
				|| (updateValue.get("aftnonSesionInsSt") != null && updateValue.get("aftnonSesionInsSt").toString().length() > 0)
				|| (updateValue.get("aftnonSesionInsDsk") != null && updateValue.get("aftnonSesionInsDsk").toString().length() > 0)
				|| (updateValue.get("aftnonSesionInsSml") != null && updateValue.get("aftnonSesionInsSml").toString().length() > 0)
				|| (updateValue.get("aftnonSesionRtnSt") != null && updateValue.get("aftnonSesionRtnSt").toString().length() > 0)
				|| (updateValue.get("aftnonSesionRtnDsk") != null && updateValue.get("aftnonSesionRtnDsk").toString().length() > 0)
				|| (updateValue.get("aftnonSesionRtnSml") != null && updateValue.get("aftnonSesionRtnSml").toString().length() > 0)
				|| (updateValue.get("evngSesionAsSt") != null && updateValue.get("evngSesionAsSt").toString().length() > 0)
				|| (updateValue.get("evngSesionAsDsk") != null && updateValue.get("evngSesionAsDsk").toString().length() > 0)
				|| (updateValue.get("evngSesionAsSml") != null && updateValue.get("evngSesionAsSml").toString().length() > 0)
				|| (updateValue.get("evngSesionInsSt") != null && updateValue.get("evngSesionInsSt").toString().length() > 0)
				|| (updateValue.get("evngSesionInsDsk") != null && updateValue.get("evngSesionInsDsk").toString().length() > 0)
				|| (updateValue.get("evngSesionInsSml") != null && updateValue.get("evngSesionInsSml").toString().length() > 0)
				|| (updateValue.get("evngSesionRtnSt") != null && updateValue.get("evngSesionRtnSt").toString().length() > 0)
				|| (updateValue.get("evngSesionRtnDsk") != null && updateValue.get("evngSesionRtnDsk").toString().length() > 0)
				|| (updateValue.get("evngSesionRtnSml") != null && updateValue.get("evngSesionRtnSml").toString().length() > 0)
				)
    			{
    				updateValue.put("codeId", ParseInteger(updateValue.get("codeId")));
    				updateValue.put("memId", ParseInteger(updateValue.get("memId")));
    				updateValue.put("morngSesionAs", ParseInteger(updateValue.get("morngSesionAs")));
    				updateValue.put("morngSesionIns", ParseInteger(updateValue.get("morngSesionIns")));
    				updateValue.put("morngSesionRtn", ParseInteger(updateValue.get("morngSesionRtn")));
    				updateValue.put("aftnonSesionAs", ParseInteger(updateValue.get("aftnonSesionAs")));
    				updateValue.put("aftnonSesionIns", ParseInteger(updateValue.get("aftnonSesionIns")));
    				updateValue.put("aftnonSesionRtn", ParseInteger(updateValue.get("aftnonSesionRtn")));
    				updateValue.put("evngSesionAs", ParseInteger(updateValue.get("evngSesionAs")));
    				updateValue.put("evngSesionIns", ParseInteger(updateValue.get("evngSesionIns")));
    				updateValue.put("evngSesionRtn", ParseInteger(updateValue.get("evngSesionRtn")));

    				updateValue.put("morngSesionAsSt", ParseInteger(updateValue.get("morngSesionAsSt")));
    				updateValue.put("morngSesionAsDsk", ParseInteger(updateValue.get("morngSesionAsDsk")));
    				updateValue.put("morngSesionAsSml", ParseInteger(updateValue.get("morngSesionAsSml")));
    				updateValue.put("morngSesionInsSt", ParseInteger(updateValue.get("morngSesionInsSt")));
    				updateValue.put("morngSesionInsDsk", ParseInteger(updateValue.get("morngSesionInsDsk")));
    				updateValue.put("morngSesionInsSml", ParseInteger(updateValue.get("morngSesionInsSml")));
    				updateValue.put("morngSesionRtnSt", ParseInteger(updateValue.get("morngSesionRtnSt")));
    				updateValue.put("morngSesionRtnDsk", ParseInteger(updateValue.get("morngSesionRtnDsk")));
    				updateValue.put("morngSesionRtnSml", ParseInteger(updateValue.get("morngSesionRtnSml")));
    				updateValue.put("aftnonSesionAsSt", ParseInteger(updateValue.get("aftnonSesionAsSt")));
    				updateValue.put("aftnonSesionAsDsk", ParseInteger(updateValue.get("aftnonSesionAsDsk")));
    				updateValue.put("aftnonSesionAsSml", ParseInteger(updateValue.get("aftnonSesionAsSml")));
    				updateValue.put("aftnonSesionInsSt", ParseInteger(updateValue.get("aftnonSesionInsSt")));
    				updateValue.put("aftnonSesionInsDsk", ParseInteger(updateValue.get("aftnonSesionInsDsk")));
    				updateValue.put("aftnonSesionInsSml", ParseInteger(updateValue.get("aftnonSesionInsSml")));
    				updateValue.put("aftnonSesionRtnSt", ParseInteger(updateValue.get("aftnonSesionRtnSt")));
    				updateValue.put("aftnonSesionRtnDsk", ParseInteger(updateValue.get("aftnonSesionRtnDsk")));
    				updateValue.put("aftnonSesionRtnSml", ParseInteger(updateValue.get("aftnonSesionRtnSml")));
    				updateValue.put("evngSesionAsSt", ParseInteger(updateValue.get("evngSesionAsSt")));
    				updateValue.put("evngSesionAsDsk", ParseInteger(updateValue.get("evngSesionAsDsk")));
    				updateValue.put("evngSesionAsSml", ParseInteger(updateValue.get("evngSesionAsSml")));
    				updateValue.put("evngSesionInsSt", ParseInteger(updateValue.get("evngSesionInsSt")));
    				updateValue.put("evngSesionInsDsk", ParseInteger(updateValue.get("evngSesionInsDsk")));
    				updateValue.put("evngSesionInsSml", ParseInteger(updateValue.get("evngSesionInsSml")));
    				updateValue.put("evngSesionRtnSt", ParseInteger(updateValue.get("evngSesionRtnSt")));
    				updateValue.put("evngSesionRtnDsk", ParseInteger(updateValue.get("evngSesionRtnDsk")));
    				updateValue.put("evngSesionRtnSml", ParseInteger(updateValue.get("evngSesionRtnSml")));

    				logger.debug("updateValue {}", updateValue);
    				sessionCapacityListMapper.updateCapacityEnhance(updateValue);
    				sessionCapacityListMapper.deleteCapacity(updateValue);
    			}
    		}
		}
	}

	@Override
	public void updateCTMCapacityByExcelEnhance(List<Map<String, Object>> updateList, SessionVO sessionVO) {
		if(updateList.size() > 0){
			Map<String, Object>  updateValue = (Map<String, Object>) updateList.get(0);
			updateValue.put("userId", sessionVO.getUserId());
			logger.debug("updateValue {}", updateValue);
			sessionCapacityListMapper.updateCTMCapacityEnhance(updateValue);
		}
	}

//	@Override
//	public List<EgovMap> selectHpChildList(Map<String, Object> params) {
//
//		return sessionCapacityListMapper.selectHpChildList(params);
//	}

	/*@Override
	public List<EgovMap> getDeptTreeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<EgovMap> getGroupTreeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<EgovMap> selectOrgChartCdList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<EgovMap> selectOrgChartCtList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}












	@Override
	public List<EgovMap> selectHpChildList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}



	*/






//
//	@Override
//	public List<EgovMap> selectOrgChartCdList(Map<String, Object> params) {
//
//		return orgChartListMapper.selectOrgChartCdList(params);
//	}
//
//
//
//	@Override
//	public List<EgovMap> selectOrgChartCtList(Map<String, Object> params) {
//
//		return orgChartListMapper.selectOrgChartCtList(params);
//	}
//
//	@Override
//	public List<EgovMap> getDeptTreeList(Map<String, Object> params) {
//
//		String memUpId ="";
//
//		if(params.get("groupCode").equals("1")){
//			memUpId = "124";
//		}else if(params.get("groupCode").equals("2")){
//			memUpId = "31983";
//		}else if(params.get("groupCode").equals("3")){
//			memUpId = "23259";
//		}
//		params.put("memUpId", memUpId);
//
//		return orgChartListMapper.getDeptTreeList(params);
//	}
//
//
//
//	@Override
//	public List<EgovMap> getGroupTreeList(Map<String, Object> params) {
//		// TODO Auto-generated method stub
//		return orgChartListMapper.getGroupTreeList(params);
//
//	}




}
