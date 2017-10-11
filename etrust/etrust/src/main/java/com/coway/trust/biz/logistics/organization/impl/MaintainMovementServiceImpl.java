/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.organization.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.organization.LocationService;
import com.coway.trust.biz.logistics.organization.MaintainMovementService;
import com.coway.trust.biz.logistics.organization.impl.MaintainMovementMapper;
import com.coway.trust.biz.logistics.stocks.StockService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("maintainService")
public class MaintainMovementServiceImpl extends EgovAbstractServiceImpl implements MaintainMovementService {
	
	@Resource(name = "maintainMapper")
	private MaintainMovementMapper maintainMapper;

	@Override
	public List<EgovMap> selectMaintainMovementList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return maintainMapper.selectMaintainMovementList(params);
	}
	@Override
	public void insMaintainMovement(Map<String, Object> params){
		// TODO Auto-generated method stub
		
		List<Object> insList = (List)params.get("add");
		List<Object> updList = (List)params.get("upd");
		List<Object> remList = (List)params.get("rem");
		
		if (insList.size() > 0){
			for (int i = 0 ; i < insList.size() ; i++){
	    		Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
	    		maintainMapper.insMaintainMovement(insMap);
			}
		}
		if (updList.size() > 0){
			for (int i = 0 ; i < updList.size() ; i++){
	    		Map<String, Object> updMap = (Map<String, Object>) updList.get(i);
	    		maintainMapper.updMaintainMovement(updMap);
			}
		}
		if (remList.size() > 0){
			for (int i = 0 ; i < remList.size() ; i++){
	    		Map<String, Object> remMap = (Map<String, Object>) remList.get(i);
	    		maintainMapper.removeMaintainMovement(remMap);
			}	
		}

		
	}
	
}