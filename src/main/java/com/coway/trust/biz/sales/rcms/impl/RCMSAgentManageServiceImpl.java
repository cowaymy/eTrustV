package com.coway.trust.biz.sales.rcms.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.sales.rcms.RCMSAgentManageService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("rcmsAgentManageService")
public class RCMSAgentManageServiceImpl extends EgovAbstractServiceImpl  implements RCMSAgentManageService{

	
	@Resource(name = "rcmsAgentManageMapper")
	private RCMSAgentManageMapper rcmsAgentManageMapper;
	
	
	private static final Logger LOGGER = LoggerFactory.getLogger(RCMSAgentManageServiceImpl.class);

	@Override
	public List<EgovMap> selectAgentTypeList(Map<String, Object> params) throws Exception {
		
		return rcmsAgentManageMapper.selectAgentTypeList(params);
	}

	@Override
	public List<Object> checkWebId(Map<String, Object> params) throws Exception {
		
		List<Object> rtnList = new ArrayList<Object>();
		
		List<Object> addList = (List<Object>)params.get("add");
		List<Object> updList = (List<Object>)params.get("upd");
		
		if(addList != null && addList.size() > 0){
			
			for (int idx = 0; idx < addList.size(); idx++) {
				
				Map<String, Object> addMap = (Map<String, Object>)addList.get(idx);
				EgovMap rtnMap = null;
				rtnMap = rcmsAgentManageMapper.chkUserNameByUserId(addMap);
				if(rtnMap == null){
					rtnList.add(addMap.get("userId"));
				}
			}
		}
		
		if(updList != null && updList.size() > 0){
			for (int idx = 0; idx < updList.size(); idx++) {
				
				Map<String, Object> addMap = (Map<String, Object>)updList.get(idx);
				EgovMap rtnMap = null;
				rtnMap = rcmsAgentManageMapper.chkUserNameByUserId(addMap);
				if(rtnMap == null){
					rtnList.add(addMap.get("userId"));
				}
			}
		}
		
		return rtnList;
	}

	@Override
	@Transactional
	public void insUpdAgent(Map<String, Object> params) throws Exception {
		
		List<Object> addList = (List<Object>)params.get("add");
		List<Object> updList = (List<Object>)params.get("upd");
		
		//__________________________________________________________________________________Add
		if(addList != null && addList.size() > 0){
			
			for (int idx = 0; idx < addList.size(); idx++) {
				
				Map<String, Object> addMap = (Map<String, Object>)addList.get(idx);
				
				//params Set
				Map<String, Object> insMap = new HashMap<String, Object>();
				int agentSeq = 0;
				agentSeq = rcmsAgentManageMapper.getSeqSAL0148M();
				insMap.put("agentSeq", agentSeq);
				insMap.put("agentType", Integer.parseInt(String.valueOf(addMap.get("agentType"))));
				insMap.put("agentName", addMap.get("agentName"));
				insMap.put("stusId", Integer.parseInt(String.valueOf(addMap.get("stusId"))));
				insMap.put("userId", 	addMap.get("userId"));
				insMap.put("crtUserId", params.get("crtUserId"));
				
				rcmsAgentManageMapper.insAgentMaster(insMap);
				
			}
		}
		
		//__________________________________________________________________________________Update
		if(updList != null && updList.size() > 0){
			for (int idx = 0; idx < updList.size(); idx++) {
				
				Map<String, Object> editMap = (Map<String, Object>)updList.get(idx);
				
				//params Set
				Map<String, Object> updMap = new HashMap<String, Object>();
				updMap.put("agentType", Integer.parseInt(String.valueOf(editMap.get("agentType"))));
				updMap.put("agentName", editMap.get("agentName"));
				updMap.put("stusId", Integer.parseInt(String.valueOf(editMap.get("stusId"))));
				updMap.put("userId", editMap.get("userId"));
				updMap.put("crtUserId", params.get("crtUserId"));
				updMap.put("agentId", Integer.parseInt(String.valueOf(editMap.get("agentId"))));
				
				rcmsAgentManageMapper.updAgentMaster(updMap);
				
			}
		}
	}

	@Override
	public List<Object> chkDupWebId(Map<String, Object> params) throws Exception {
		List<Object> rtnList = new ArrayList<Object>();
		
		List<Object> addList = (List<Object>)params.get("add");
		
		if(addList != null && addList.size() > 0){
			
			for (int idx = 0; idx < addList.size(); idx++) {
				
				Map<String, Object> addMap = (Map<String, Object>)addList.get(idx);
				EgovMap rtnMap = null;
				rtnMap = rcmsAgentManageMapper.chkDupWebId(addMap);
				if(rtnMap != null){
					rtnList.add(addMap.get("userId"));
				}
			}
		}
		
		return rtnList;
	}

	@Override
	public List<EgovMap> selectAgentList(Map<String, Object> params) throws Exception {
		
		return rcmsAgentManageMapper.selectAgentList(params);
	}
}
