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
	
		return sessionCapacityListMapper.selectSsCapacityBrList(params);
	}
	@Override
	public List<EgovMap> seleCtCodeSearch(Map<String, Object> params) {
	
		return sessionCapacityListMapper.seleCtCodeSearch(params);
	}
	
	@Override
	public List<EgovMap> seleBranchCodeSearch(Map<String, Object> params) {
	
		return sessionCapacityListMapper.seleBranchCodeSearch(params);
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
	public void deleteCapacity(List<Object> params, SessionVO sessionVO) {
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  deleteValue = (Map<String, Object>) params.get(i);
    			deleteValue.put("userId", sessionVO.getUserId());
    			logger.debug("deleteValue {}", deleteValue);
    			sessionCapacityListMapper.deleteCapacity(deleteValue);
    		}
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
