package com.coway.trust.biz.organization.organization.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.TerritoryManagementService;
import com.coway.trust.web.organization.organization.excel.TerritoryRawDataVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("territoryManagementService")
public class TerritoryManagementServiceImpl extends EgovAbstractServiceImpl implements TerritoryManagementService{
	private static final Logger logger = LoggerFactory.getLogger(TerritoryManagementService.class);
	
	@Resource(name = "territoryManagementMapper")
	private TerritoryManagementMapper territoryManagementMapper;

	@Override
	public List<EgovMap> selectList(Map<String, Object> params) {
		return territoryManagementMapper.selectList(params);
	}
	
	@Override
	public  EgovMap  uploadVaild(Map<String, Object> params ){
		
		String bType = (String)params.get("comBranchTypep");
		List<TerritoryRawDataVO> vos =(List)params.get("voList");
		
		
		EgovMap  reslutMap = null; 
		EgovMap  rtnMap =new EgovMap(); 
		
		
		for (TerritoryRawDataVO vo : vos) {
			   logger.debug("vo {}", vo.toString());
			   
			   Map<String,Object> q = new HashMap<String, Object>();
			   q.put("areaId", vo.getAreaId());
			   q.put("branch", vo.getBranch());
			   q.put("extBranch", vo.getExtBranch());
			   
			   if("42".equals(bType)){  //Cody Branch
				   
				   reslutMap =	territoryManagementMapper.cody42Vaild(q);
				   
				   boolean isErr =false;
				   StringBuffer msg = new StringBuffer();
				   
				   if("0".equals( String.valueOf(reslutMap.get("acnt"))) ){
					   
					   isErr =true;
					   msg.append("["+vo.getAreaId() +"]code does not exist \n");
				   }
				   
				   if("0".equals( String.valueOf( reslutMap.get("bcnt"))) ){
					   isErr =true;
					   msg.append("["+vo.getBranch() +"]code does not exist \n");
					   
				   }
  
                   if("0".equals( String.valueOf( reslutMap.get("ucnt")) )){
                	   isErr =true;
					   msg.append("["+vo.getExtBranch() +"]code does not exist \n");
					   
                   }
                   
                   
                   if(isErr){
                       rtnMap.put("isErr", isErr);
                       rtnMap.put("errMsg", msg.toString());
                       return   rtnMap;
                   }
                   
                   
			   }else if("43".equals(bType)){  //Dream Service Center
				   
					reslutMap =	 territoryManagementMapper.dream43Vaild(q);

				   boolean isErr =false;
				   StringBuffer msg = new StringBuffer();
				   
				   if("0".equals( String.valueOf(reslutMap.get("acnt"))) ){
					   
					   isErr =true;
					   msg.append("["+vo.getAreaId() +"]code does not exist \n");
				   }
				   
				   if("0".equals( String.valueOf( reslutMap.get("bcnt"))) ){
					   isErr =true;
					   msg.append("["+vo.getBranch() +"]code does not exist \n");
					   
				   }
  
                   if("0".equals( String.valueOf( reslutMap.get("ucnt")) )){
                	   isErr =true;
					   msg.append("["+vo.getExtBranch() +"]code does not exist \n");
					   
                   }
                   
                   if(isErr){
                       rtnMap.put("isErr", isErr);
                       rtnMap.put("errMsg", msg.toString());
                       return   rtnMap;
                   }
			   }else{
					
				}
		}  
		
		  
		 rtnMap.put("isErr", false);
		 rtnMap.put("errMsg", "upload success");
		   
		return rtnMap;
		
		//return territoryManagementMapper.selectList();
	}
}
