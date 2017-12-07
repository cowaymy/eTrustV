package com.coway.trust.biz.organization.organization.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.AllocationService;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("allocationService")
public class AllocationServiceImpl extends EgovAbstractServiceImpl implements AllocationService{
	private static final Logger logger = LoggerFactory.getLogger(AllocationService.class);

	private static final String String = null;
	
	@Resource(name = "allocationMapper")
	private AllocationMapper allocationMapper;

	@Override
	public List<EgovMap> selectList(Map<String, Object> params) {
		
		List<EgovMap>   baseList 			   =  null;
		List<EgovMap>   rtnList   				   =  null;
		List<EgovMap>   fList   				   =  null;

		List<EgovMap>   mergeHolidayList  =  null;
		List<EgovMap>   mergeVacationList=  null;

		
		//Level 1  getBaseList   CT_SUB_GRP   
		baseList =getBaseList(params);
	   //getBaseList   CT_SUB_GRP 
		
		
		//Level 2
		if(null != baseList ){
			if(baseList.size()>0){
				
				mergeHolidayList  = new ArrayList<EgovMap>();
				
				 for (Iterator<EgovMap> iterator = baseList.iterator(); iterator.hasNext();) {
					 
					 EgovMap   holiDayAddMap =  new EgovMap();
    				 EgovMap e = iterator.next();
    				 
    				 logger.debug(e.toString());
    			
    				 holiDayAddMap.put("ct",     CommonUtils.nvl(e.get("ct")));
    				 holiDayAddMap.put("cDate", (String)e.get("cDate"));
    				 holiDayAddMap.put("ctSubGrp", (String)e.get("ctSubGrp"));
    				 holiDayAddMap.put("brnchId", CommonUtils.nvl(e.get("brnchId"))); 

    				 try{
    					 	EgovMap vm = this.isMergeHoliDay(holiDayAddMap);
    					 	
    					 	logger.debug(" isMergeHoliDay ==> "+vm.toString());
        					
    					 	if(null != vm){
    					 		
    					 		holiDayAddMap.put("isHoliDay",  "true");
    					 		holiDayAddMap.put("holiDayCtCode", CommonUtils.nvl(vm.get("memId")) );
    					 		holiDayAddMap.put("oldCt", vm.get("ct") );
    					 		holiDayAddMap.put("ct", CommonUtils.nvl(vm.get("memId") ));
    					 		
        					}else {
        						
        						holiDayAddMap.put("isHoliDay",   "false");
        						holiDayAddMap.put("holiDayCtCode","" );
        					}
    					 
					 }catch(Exception ex){
						 holiDayAddMap.put("isHoliDay",  "false");
					 }
    				
    				 mergeHolidayList.add(holiDayAddMap);
				} // eof mergeHolidayList  
				 
				///Collections.sort(  (ArrayList) mergeHolidayList);   
			}
		}// eof baseList
		
		
		
		
		//Level 3 
		if(null !=mergeHolidayList){
			if(mergeHolidayList.size()>0){
				mergeVacationList = new ArrayList<EgovMap>();
				
				
				for (Iterator<EgovMap> iterator = mergeHolidayList.iterator(); iterator.hasNext();) {
				
						 EgovMap   vacationAddMap =  new EgovMap();
    					 EgovMap   e = iterator.next();
       					
    					 vacationAddMap.put("ct",     CommonUtils.nvl(e.get("ct")));
    					 vacationAddMap.put("cDate", (String)e.get("cDate"));
    					 vacationAddMap.put("ctSubGrp", (String)e.get("ctSubGrp"));
    					 vacationAddMap.put("brnchId", CommonUtils.nvl (e.get("brnchId"))); 
    					 vacationAddMap.put("isHoliDay", (String)e.get("isHoliDay"));
    					 vacationAddMap.put("holiDayCtCode", (String)e.get("holiDayCtCode"));
    					 vacationAddMap.put("oldCt",CommonUtils.nvl(e.get("oldCt")));


    					 try{
     					 		EgovMap vm = this.isVacation(vacationAddMap);
     					 		
     					 		logger.debug(" isVacation ==> "+vm.toString());
         					  
         					 	if(null != vm){
         					 		vacationAddMap.put("isVact",  "true");
         					 		vacationAddMap.put("vactReplCt",CommonUtils.nvl( vm.get("vactReplCt")));
         					 		vacationAddMap.put("ct",      CommonUtils.nvl(vm.get("vactReplCt")));
         					 		
             					}else{
             						vacationAddMap.put("isVact",   "false");  
             						vacationAddMap.put("vactReplCt","" );
             					}
     					 
     					 }catch(Exception ex){
     						vacationAddMap.put("isVact",  "false");
     					 }
    					 
    				mergeVacationList.add(vacationAddMap);
				 } // eof mergeVacationList
			}
		}
		
		
		//level 5  setViewList 
		rtnList = new ArrayList<EgovMap>();
		fList= new ArrayList<EgovMap>();
		if(null !=mergeVacationList){
			if(mergeVacationList.size()>0){  
				for (Iterator<EgovMap> iterator = mergeVacationList.iterator(); iterator.hasNext();) {
					
						EgovMap    viewdMap =  new EgovMap();
						EgovMap    v = iterator.next();
						
						if("true".equals((String)v.get("isVact"))  ||  "true".equals((String)v.get("isHoliDay"))){
							v.put("repla","true");
						}
					
						EgovMap   eM=	allocationMapper.makeViewList(v);
						
						fList.add(eM);
				}
			}
		}
		
		
		//level5  중복 제거 
		HashSet<EgovMap> hs = new HashSet<EgovMap>(fList); 
		Iterator it = hs.iterator(); 
		
		while(it.hasNext()){
			rtnList.add((EgovMap)it.next());
		}
		
		
		return rtnList;
	}
	
	
	
	public  EgovMap  isMergeHoliDay(Map<String, Object> params){
	
		params.put("brnchId",params.get("brnchId"));
		params.put("holiday",params.get("cDate"));
		
		logger.debug(" isMergeHoliDay ==> "+params.toString());

		
	    EgovMap  eM=	allocationMapper.isSubGroupHoliDay(params);
	    
		return  eM; 
	}
	
	
	
	public  EgovMap  isVacation(Map<String, Object> params){
		
		params.put("vactReplCt",CommonUtils.nvl((params.get("ct"))));
		params.put("rDate",params.get("cDate"));
		
		EgovMap  eM=	allocationMapper.selectVacationList(params);
	    
		return  eM; 
	}
	
	
	
	
	
	
	
	
	@Override
	public List<EgovMap> selectDetailList(Map<String, Object> params) {
		return allocationMapper.selectDetailList(params);
	}
	
	
	
	public List<EgovMap>  getBaseList(Map<String, Object> params){
		
		return allocationMapper.selectBaseList(params);
	} 
	
}
