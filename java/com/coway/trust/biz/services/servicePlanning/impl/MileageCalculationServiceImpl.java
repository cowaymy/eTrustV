package com.coway.trust.biz.services.servicePlanning.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.servicePlanning.MileageCalculationService;
import com.coway.trust.cmmn.model.SessionVO;
import com.ibm.icu.util.StringTokenizer;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("mileageCalculationService")
public class MileageCalculationServiceImpl extends EgovAbstractServiceImpl implements MileageCalculationService{
	private static final Logger logger = LoggerFactory.getLogger(MileageCalculationService.class);
	@Resource(name = "mileageCalculationMapper")
	private MileageCalculationMapper mileageCalculationMapper;
	
	@Override
	public void insertDCPMaster(List<Object> params, SessionVO sessionVO) {
		boolean addSuccess = false;
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  insertValue = (Map<String, Object>) params.get(i);
    			if(insertValue.get("memType").equals("CODY")){
    				insertValue.put("memType", 2);
    			}else{
    				insertValue.put("memType", 3);//CT
    			}
    			if( insertValue.get("distance") != null && insertValue.get("distance").toString().length() > 0 ) {
    				insertValue.put("distance", Integer.parseInt(insertValue.get("distance").toString()));
    			} else {
    				insertValue.put("distance", "");
    			}
//    			insertValue.put("distance", Integer.parseInt(insertValue.get("distance").toString()));
    			insertValue.put("userId", sessionVO.getUserId());
    			logger.debug("insertValue {}", insertValue);
    			mileageCalculationMapper.insertDCPMaster(insertValue);
    			mileageCalculationMapper.updatetDCPMasterLinked(insertValue);
    		}
		}
	}

	@Override
	public void updateDCPMaster(List<Object> params, SessionVO sessionVO) {
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  updateValue = (Map<String, Object>) params.get(i);
    			if(updateValue.get("memType").equals("CODY")){
    				updateValue.put("memType", 2);
    			}else{
    				updateValue.put("memType", 3);//CT
    			}
    			if( updateValue.get("distance") != null && updateValue.get("distance").toString().length() > 0 ) {
    				updateValue.put("distance", Integer.parseInt(updateValue.get("distance").toString()));
    			} else {
    				updateValue.put("distance", "");
    			}
//    			updateValue.put("distance", Integer.parseInt(updateValue.get("distance").toString()));
    			updateValue.put("userId", sessionVO.getUserId());
    			logger.debug("updateValue {}", updateValue);
    			mileageCalculationMapper.updatetDCPMaster(updateValue);
    			mileageCalculationMapper.updatetDCPMasterLinked(updateValue);
    		}
		}
	}

	@Override
	public void deleteDCPMaster(List<Object> params, SessionVO sessionVO) {
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  deleteValue = (Map<String, Object>) params.get(i);
    			if(deleteValue.get("memType").equals("CODY")){
    				deleteValue.put("memType", 2);
    			}else{
    				deleteValue.put("memType", 3);//CT
    			}
    			deleteValue.put("distance", Integer.parseInt(deleteValue.get("distance").toString()));
    			deleteValue.put("userId", sessionVO.getUserId());
    			logger.debug("deleteValue {}", deleteValue);
    			mileageCalculationMapper.deleteDCPMaster(deleteValue);
    		}
		}
	}
	
	@Override
	public void updateDCPMasterByExcel(List<Map<String, Object>> params, SessionVO sessionVO) {
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  updateValue = (Map<String, Object>) params.get(i);
    			if(updateValue.get("memType").equals("CODY")){
    				updateValue.put("memType", 2);
    			}else{
    				updateValue.put("memType", 3); //CT
    			}
    			
				if( updateValue.get("distance") != null && updateValue.get("distance").toString().length() > 0 ) {
					
					updateValue.put("distance", (int) Double.parseDouble(updateValue.get("distance").toString()));
					updateValue.put("userId", sessionVO.getUserId());
					
					logger.debug("updateValue {}", updateValue);
					mileageCalculationMapper.updatetDCPMaster(updateValue);
					mileageCalculationMapper.updatetDCPMasterLinked(updateValue);
				}
    		}
		}
	}
	
	@Override
	public List<EgovMap> selectDCPMaster(Map<String, Object> params) {
		return mileageCalculationMapper.selectDCPMaster(params);
	}
	
	@Override
	public int selectDCPMasterCount(Map<String, Object> params) {
		return mileageCalculationMapper.selectDCPMasterCount(params);
	}
	
	@Override
	public List<EgovMap> selectArea(Map<String, Object> params) {
		return mileageCalculationMapper.selectArea(params);
	}
	@Override
	public List<EgovMap> selectBranch(Map<String, Object> params) {
		return mileageCalculationMapper.selectBranch(params);
	}
	
	@Override
	public List<EgovMap> selectSchemaMgmt(Map<String, Object> params) {
		return mileageCalculationMapper.selectSchemaMgmt(params);
	}
	@Override
	public List<EgovMap> selectMemberCode(Map<String, Object> params) {
		return mileageCalculationMapper.selectMemberCode(params);
	}
	
	@Override
	public List<EgovMap> selectCity(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return mileageCalculationMapper.selectCity(params);
	}
	
	@Override
	public List<EgovMap> selectSchemaResultMgmt(Map<String, Object> params) {
		/*if(params.get("ManuaMyBSMonth") != null) {
    		StringTokenizer str1 = new StringTokenizer(params.get("month").toString());
    		
    		for(int i =0; i <= 1 ; i++) {
    			str1.hasMoreElements();
    			String result = str1.nextToken("/");            //특정문자로 자를시 사용
    			
    			logger.debug("iiiii: {}", i);
    			
    			if(i==0){
    				params.put("searchMonth", result);
    			}else{
    				params.put("searchYear", result);
    			}
    		}		
		}*/
		logger.debug("params {}" , params );
		if( ( String.valueOf( params.get("memType") ) ).equals("2")){ //memType cody 
			return mileageCalculationMapper.selectSchemaResultMgmt(params);
		}
		else { 
			
			return mileageCalculationMapper.selectCTResultMgmt(params);
		}
	}
	
	
	@Override
	public void insertSchemaMgmt(List<Object> params, SessionVO sessionVO) {
		boolean addSuccess = false;
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  insertValue = (Map<String, Object>) params.get(i);
    			if(insertValue.get("memType").equals("CODY")){
    				insertValue.put("memType", 2);
    			}else{
    				insertValue.put("memType", 3);//CT
    			}
    			insertValue.put("userId", sessionVO.getUserId());
    			logger.debug("insertValue {}", insertValue);
    			mileageCalculationMapper.insertSchemaMgmt(insertValue);
    		}
		}
	}

	@Override
	public void updateSchemaMgmt(List<Object> params, SessionVO sessionVO) {
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  updateValue = (Map<String, Object>) params.get(i);
    			if(updateValue.get("memType").equals("CODY")){
    				updateValue.put("memType", 2);
    			}else{
    				updateValue.put("memType", 3);//CT
    			}
    			updateValue.put("userId", sessionVO.getUserId());
    			logger.debug("updateValue {}", updateValue);
    			mileageCalculationMapper.updateSchemaMgmt(updateValue);
    		}
		}
	}

	@Override
	public void deleteSchemaMgmt(List<Object> params, SessionVO sessionVO) {
		if(params.size() > 0){
    		for(int i=0; i< params.size(); i++){
    			Map<String, Object>  deleteValue = (Map<String, Object>) params.get(i);
    			if(deleteValue.get("memType").equals("CODY")){
    				deleteValue.put("memType", 2);
    			}else{
    				deleteValue.put("memType", 3);//CT
    			}
    			deleteValue.put("userId", sessionVO.getUserId());
    			logger.debug("deleteValue {}", deleteValue);
    			mileageCalculationMapper.deleteSchemaMgmt(deleteValue);
    		}
		}
	}

	@Override
	public List<EgovMap> selectDCPFrom(Map<String, Object> params) {
		return mileageCalculationMapper.selectDCPFrom(params);
	}

	@Override
	public List<EgovMap> selectDCPTo(Map<String, Object> params) {
		return mileageCalculationMapper.selectDCPTo(params);
	}

}
