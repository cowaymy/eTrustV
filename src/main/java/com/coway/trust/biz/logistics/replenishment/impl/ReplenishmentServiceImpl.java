/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.replenishment.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;

import com.coway.trust.biz.logistics.replenishment.ReplenishmentService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ReplenishmentService")
public class ReplenishmentServiceImpl extends EgovAbstractServiceImpl implements ReplenishmentService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "ReplenishmentMapper")
	private ReplenishmentMapper replenishment;

		
	@Override
	public Map<String, Object> excelDataSearch(Map<String, Object> params) {

		Map<String, Object> hdMap = replenishment.excelDataSearch(params);
		
		return hdMap;
	}


	@Override
	public void relenishmentSave(Map<String, Object> params , int userid) {
		// TODO Auto-generated method stub
		List<Object> insList = (List<Object>) params.get("add");
		List<Object> updList = (List<Object>) params.get("update");
		if (insList.size() > 0) {
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
				insMap.put("userid" , userid);
				replenishment.relenishmentSave(insMap);
			}
		}
		
		if (updList.size() > 0){
			for (int i = 0; i < updList.size(); i++) {
				Map<String, Object> updMap = (Map<String, Object>) updList.get(i);
				updMap.put("userid" , userid);
				replenishment.relenishmentSave(updMap);
			}
		}
		
	}


	@Override
	public List<EgovMap> searchList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return replenishment.selectSearchList(params);
	}


	@Override
	public void relenishmentPopSave(Map<String, Object> params, int userid) {
		// TODO Auto-generated method stub
		params.put("userid", userid);
		replenishment.relenishmentSave(params);
		
	}
	
}
