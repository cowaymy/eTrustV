package com.coway.trust.biz.common.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.AreaManagementService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("areaManagementService")
public class AreaManagementServiceImpl extends EgovAbstractServiceImpl implements AreaManagementService {

	@Resource(name = "areaManagementMapper")
	private AreaManagementMapper areaManagementMapper;
	
	@Override
	public List<EgovMap> selectAreaManagement(Map<String, Object> params) throws Exception {
		return areaManagementMapper.selectAreaManagement(params);
	}
	
	@Override
	public int udtAreaManagement(List<Object> udtList,String loginId) {
		
		int cnt=0;
		for (Object obj : udtList) {
			((Map<String, Object>) obj).put("updUserId", loginId);
			
			cnt=cnt+areaManagementMapper.udtAreaManagement((Map<String, Object>) obj);
		}
		return cnt;
	}
	
	@Override
	public int addCopyAddressMaster(List<Object> addList,String loginId) {	
		
		int cnt=0;
		
		for (Object obj : addList) {

			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);
			
			cnt=cnt+areaManagementMapper.addCopyAddressMaster((Map<String, Object>) obj);
		}
		return cnt;
	}
	
	@Override
	public int addCopyOtherAddressMaster(List<Object> addList,String loginId) {	
		
		int cnt=0;
		
		for (Object obj : addList) {

			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);
			
			cnt=cnt+areaManagementMapper.addCopyOtherAddressMaster((Map<String, Object>) obj);
		}
		return cnt;
	}
	
	@Override
	public int addOtherAddressMaster(List<Object> addList,String loginId) {	
		
		int cnt=0;
		
		for (Object obj : addList) {

			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);
			
			cnt=cnt+areaManagementMapper.addOtherAddressMaster((Map<String, Object>) obj);
		}
		return cnt;
	}
	
	@Override
	public int addMyAddressMaster(List<Object> addList,String loginId) {	
		
		int cnt=0;
		
		for (Object obj : addList) {

			((Map<String, Object>) obj).put("crtUserId", loginId);
			((Map<String, Object>) obj).put("updUserId", loginId);
			
			cnt=cnt+areaManagementMapper.addMyAddressMaster((Map<String, Object>) obj);
		}
		return cnt;
	}
	
	@Override 
	public List<EgovMap> selectMyPostcode(Map<String, Object> params) throws Exception {
		return areaManagementMapper.selectMyPostcode(params);
	}
	
}
