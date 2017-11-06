package com.coway.trust.biz.organization.organization.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.organization.organization.TerritoryManagementService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.excel.TerritoryRawDataVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("territoryManagementService")
public class TerritoryManagementServiceImpl extends EgovAbstractServiceImpl implements TerritoryManagementService{
	private static final Logger logger = LoggerFactory.getLogger(TerritoryManagementService.class);
	
	@Resource(name = "territoryManagementMapper")
	private TerritoryManagementMapper territoryManagementMapper;
	
	@Resource(name = "memberListMapper")
	private MemberListMapper memberListMapper;

	@Override
	public List<EgovMap> selectList(Map<String, Object> params) {
		return territoryManagementMapper.selectList(params);
	}
	
	@Override
	public List<EgovMap> selectTerritory(Map<String, Object> params) {
		return territoryManagementMapper.selectTerritory(params);
	}
	
	@Override
	public List<EgovMap> selectMagicAddress(Map<String, Object> params) {
		return territoryManagementMapper.selectMagicAddress(params);
	}
	
	
	
	@Transactional
	@Override
	public  EgovMap  uploadVaild(Map<String, Object> params,SessionVO sessionVO ){
		
		String bType = (String)params.get("comBranchTypep");
		List<TerritoryRawDataVO> vos =(List)params.get("voList");
		
		
		EgovMap  reslutMap = null; 
		EgovMap  rtnMap =new EgovMap(); 
		
		EgovMap requestNo = getDocNo("156");
		String nextDocNo= getNextDocNo("TCR",requestNo.get("docNo").toString());
		requestNo.put("nextDocNo", nextDocNo);
		memberListMapper.updateDocNo(requestNo);
		List<TerritoryRawDataVO> vo =  vos;
		//for (TerritoryRawDataVO vo : vos) {
		for ( int i=1; i<vo.size(); i++) {
			   logger.debug("vo {}", vo.toString());
			   
			   Map<String,Object> q = new HashMap<String, Object>();
			   q.put("areaId", vo.get(i).getAreaId());
			   q.put("branch",vo.get(i).getBranch());
			   q.put("extBranch", vo.get(i).getExtBranch());
			   q.put("brnchId", Integer.parseInt(bType.toString()));
			   q.put("reqstNo", requestNo.get("docNo"));
			   q.put("requester", sessionVO.getUserId());
			   if("42".equals(bType)){  //Cody Branch
				   
				  // reslutMap =	territoryManagementMapper.cody42Vaild(q);
				   
				   boolean isErr =false;
				  StringBuffer msg = new StringBuffer();
				  
				  /* if("0".equals( String.valueOf(reslutMap.get("acnt"))) ){
					   
					   isErr =true;
					   msg.append("["+vo.get(i).getAreaId() +"]code does not exist \n");
				   }*/
				   
				  /* if("0".equals( String.valueOf( reslutMap.get("bcnt"))) ){
					   isErr =true;
					   msg.append("["+vo.get(i).getBranch() +"]code does not exist \n");
					   
				   }
  
                   if("0".equals( String.valueOf( reslutMap.get("ucnt")) )){
                	   isErr =true;
					   msg.append("["+vo.get(i).getExtBranch() +"]code does not exist \n");
					   
                   }*/
                  
                  
				  territoryManagementMapper.insertCody(q);
                   
                   if(isErr){
                       rtnMap.put("isErr", isErr);
                       rtnMap.put("errMsg", msg.toString());
                       return   rtnMap;
                   }
                   
                   
			   }else if("43".equals(bType)){  //Dream Service Center
				   
					//reslutMap =	 territoryManagementMapper.dream43Vaild(q);

				   /*boolean isErr =false;
				   StringBuffer msg = new StringBuffer();*/
				  
				  /* if("0".equals( String.valueOf(reslutMap.get("acnt"))) ){
					   
					   isErr =true;
					   msg.append("["+vo.get(i).getAreaId() +"]code does not exist \n");
				   }*/
				   
				   /*if("0".equals( String.valueOf( reslutMap.get("bcnt"))) ){
					   isErr =true;
					   msg.append("["+vo.get(i).getBranch() +"]code does not exist \n");
					   
				   }
  
                   if("0".equals( String.valueOf( reslutMap.get("ucnt")) )){
                	   isErr =true;
					   msg.append("["+vo.get(i).getExtBranch() +"]code does not exist \n");
					   
                   }*/
                   
				   territoryManagementMapper.insertDreamServiceCenter(q);
				   
                  /* if(isErr){
                       rtnMap.put("isErr", isErr);
                       rtnMap.put("errMsg", msg.toString());
                       return   rtnMap;
                   }*/
			   }else{
					
				}
		}  
		
		  
		 rtnMap.put("isErr", false);
		 rtnMap.put("errMsg", "upload success");
		   
		return rtnMap;
		
		//return territoryManagementMapper.selectList();
	}
	@Transactional
	@Override
	public boolean updateMagicAddressCode(Map<String, Object> params) {
		boolean success=false;
		if(params.get("brnchType").toString().equals("42")){
    		//reqstNo로 19M에 데이터를 다 가져옴
    		List<EgovMap> select19M = territoryManagementMapper.select19M(params);
    		logger.debug("select19M {}", select19M);
    		//가져온값 64M에 UPDATE
    		if(select19M.size() > 0){
    			for(int i=0; i<select19M.size(); i++){
    				territoryManagementMapper.updateSYS0064M(select19M.get(i));
    				//전에 썼던 것을 N으로 바꿔줘야된다(area_id로 이전 데이터가 쌓이니까 
    				//area_id로 n을 주고 밑에서 area_id랑 reqstNo로 구분해 y로 바꿔주므로 n으로 바꿈)
    				territoryManagementMapper.updateORG0019MFlag(select19M.get(i));
    				//19M에 AVAIL_FLAG 'Y'로 변경, CONFIRM STUS 4
    				territoryManagementMapper.updateORG0019M(select19M.get(i));
    			}
    			
    		}
    		
		}else{
			//reqstNo로 19M에 데이터를 다 가져옴
    		List<EgovMap> select19M = territoryManagementMapper.select19M(params);
    		logger.debug("select19M {}", select19M);
    		//가져온값 64M에 UPDATE
    		if(select19M.size() > 0){
    			for(int i=0; i<select19M.size(); i++){
    				territoryManagementMapper.updateSYS0064MDream(select19M.get(i));
    				//전에 썼던 것을 N으로 바꿔줘야된다(area_id로 이전 데이터가 쌓이니까 
    				//area_id로 n을 주고 밑에서 area_id랑 reqstNo로 구분해 y로 바꿔주므로 n으로 바꿈)
    				territoryManagementMapper.updateORG0019MFlag(select19M.get(i));
    				//19M에 AVAIL_FLAG 'Y'로 변경, CONFIRM STUS 4
    				territoryManagementMapper.updateORG0019M(select19M.get(i));
    			}
    			
    		}
    		
		}
		return true;
	}
	
	public EgovMap getDocNo(String docNoId){
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = memberListMapper.selectDocNo(docNoId);
		logger.debug("selectDocNo : {}",selectDocNo);
		String prefix = "";
		
		if(Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){
			
			if(selectDocNo.get("c2") != null){
				prefix = (String) selectDocNo.get("c2");
			}else{
				prefix = "";
			}
			docNo = prefix.trim()+(String) selectDocNo.get("c1");
			//prefix = (selectDocNo.get("c2")).toString();
			logger.debug("prefix : {}",prefix);
			selectDocNo.put("docNo", docNo);
			selectDocNo.put("prefix", prefix);
		}
		return selectDocNo;
	}
	
	public String getNextDocNo(String prefixNo,String docNo){
		String nextDocNo = "";
		int docNoLength=0;
		System.out.println("!!!"+prefixNo);
		if(prefixNo != null && prefixNo != ""){
			System.out.println("들어오면안됨");
			docNoLength = docNo.replace(prefixNo, "").length();
			docNo = docNo.replace(prefixNo, "");
		}else{
			System.out.println("들어와얗ㅁ");
			docNoLength = docNo.length();
		}
		
		int nextNo = Integer.parseInt(docNo) + 1;
		nextDocNo = String.format("%0"+docNoLength+"d", nextNo);
		logger.debug("nextDocNo : {}",nextDocNo);
		return nextDocNo;
	}
}
