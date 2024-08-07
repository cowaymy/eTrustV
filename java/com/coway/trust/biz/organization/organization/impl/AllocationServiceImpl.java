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

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.organization.organization.AllocationService;
import com.coway.trust.biz.organization.organization.orgUts.VComparator;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("allocationService")
public class AllocationServiceImpl extends EgovAbstractServiceImpl implements AllocationService{
	private static final Logger logger = LoggerFactory.getLogger(AllocationService.class);

	@Resource(name = "allocationMapper")
	private AllocationMapper allocationMapper;

	  @Resource(name = "commonMapper")
	  private CommonMapper commonMapper;

	@Override
	public List<EgovMap> selectList(Map<String, Object> params) {

		List<EgovMap>   baseList 			   =  null;
		List<EgovMap>   rtnList   				   =  null;
		List<EgovMap>   fList   				   =  null;

		List<EgovMap>   mergeHolidayList  =  null;
		List<EgovMap>   mergeVacationList=  null;
		List<EgovMap>   mergeNoSvcList = null;

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

    				 //logger.debug(e.toString());
    				 holiDayAddMap.put("ct",     CommonUtils.nvl(e.get("ct")));
    				 holiDayAddMap.put("cDate", (String)e.get("cDate"));
    				 holiDayAddMap.put("ctSubGrp", (String)e.get("ctSubGrp"));
    				 holiDayAddMap.put("brnchId", CommonUtils.nvl(e.get("brnchId")));

    				 try{
    					 List<EgovMap> vm = this.isMergeHoliDay(holiDayAddMap);
    					//logger.debug(" isMergeHoliDay ==> "+vm.toString());

 					 	// KR. JIN. - 2019-11-25
 					 	if(null != vm && vm.size() > 0){
     					 	for(EgovMap em : vm){

     					 		EgovMap   hMap =  new EgovMap();
     					 		hMap.put("isHoliDay",  "true");
     					 		hMap.put("holiDayCtCode", CommonUtils.nvl( em.get("memId")) );
     					 		hMap.put("oldCt", em.get("ct") );
     					 		hMap.put("ct", CommonUtils.nvl(em.get("memId") ));

     					 		hMap.put("cDate", holiDayAddMap.get("cDate"));
     					 		hMap.put("ctSubGrp", holiDayAddMap.get("ctSubGrp"));
     					 		hMap.put("brnchId", holiDayAddMap.get("brnchId"));
         					 	mergeHolidayList.add(hMap);

         					}
 					 	}else{
 					 		holiDayAddMap.put("isHoliDay", "false");
     						holiDayAddMap.put("holiDayCtCode", "");
 					 		mergeHolidayList.add(holiDayAddMap);
 					 	}

 					 	/*
 					 	if(null != vm){

 					 		holiDayAddMap.put("isHoliDay",  "true");
 					 		holiDayAddMap.put("holiDayCtCode", CommonUtils.nvl(vm.get("memId")) );
 					 		holiDayAddMap.put("oldCt", vm.get("ct") );
 					 		holiDayAddMap.put("ct", CommonUtils.nvl(vm.get("memId") ));

     					}else{

     						holiDayAddMap.put("isHoliDay",   "false");
     						holiDayAddMap.put("holiDayCtCode","" );
     					}
     					*/

					 }catch(Exception ex){
						 holiDayAddMap.put("isHoliDay",  "false");
						 mergeHolidayList.add(holiDayAddMap);
					 }

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
     					 		//logger.debug(" isVacation ==> "+vm.toString());

         					 	if(null != vm){
         					 		vacationAddMap.put("isVact",  "true");
         					 		vacationAddMap.put("vactReplCt",CommonUtils.nvl( vm.get("vactReplCt")));
         					 		vacationAddMap.put("ct",      CommonUtils.nvl(vm.get("vactReplCt")));

             					}else{
             						vacationAddMap.put("isVact", "false");
             						vacationAddMap.put("vactReplCt", "");
             					}

     					 }catch(Exception ex){
     						vacationAddMap.put("isVact",  "false");
     					 }

    				mergeVacationList.add(vacationAddMap);
				 } // eof mergeVacationList
			}
		}

		//Level 4 - no Service day  : KR. JIN. - 2020.01.04
		if(null !=mergeVacationList){
			if(mergeVacationList.size() > 0) {
				mergeNoSvcList = new ArrayList<EgovMap>();

				for (Iterator<EgovMap> iterator = mergeVacationList.iterator(); iterator.hasNext();) {
					EgovMap noSvcListMap = new EgovMap();
                    EgovMap e = iterator.next();

                    noSvcListMap.put("ct", CommonUtils.nvl(e.get("ct")));
                    noSvcListMap.put("cDate", CommonUtils.nvl(e.get("cDate")));
                    noSvcListMap.put("ctSubGrp", CommonUtils.nvl(e.get("ctSubGrp")));
                    noSvcListMap.put("brnchId", CommonUtils.nvl(e.get("brnchId")));
                    noSvcListMap.put("isHoliDay", CommonUtils.nvl(e.get("isHoliDay")));
                    noSvcListMap.put("holiDayCtCode", CommonUtils.nvl(e.get("holiDayCtCode")));
                    noSvcListMap.put("oldCt", CommonUtils.nvl(e.get("oldCt")));
                    noSvcListMap.put("isVact", CommonUtils.nvl(e.get("isVact")));
                    noSvcListMap.put("vactReplCt", CommonUtils.nvl(e.get("vactReplCt")));
                    noSvcListMap.put("ordId", params.get("ORD_ID"));
                    noSvcListMap.put("prdType", 6665); // Home Appliance

    				try {
    					int vm = allocationMapper.isMergeNosvcDay(noSvcListMap);

    					if(vm > 0) {
    						noSvcListMap.put("isNoSvcDay", "true");
							mergeNoSvcList.add(noSvcListMap);

    					} else {
    						noSvcListMap.put("isNoSvcDay", "false");
    						mergeNoSvcList.add(noSvcListMap);
    					}

    				} catch(Exception ex) {
    					noSvcListMap.put("isNoSvcDay", "false");
    				}
    				mergeNoSvcList.add(noSvcListMap);
				} // eof mergeVacationList
			}
		}

		//level 5  setViewList
		rtnList = new ArrayList<EgovMap>();
		fList= new ArrayList<EgovMap>();

		if(null !=mergeNoSvcList){
			if(mergeNoSvcList.size()>0){
				for (Iterator<EgovMap> iterator = mergeNoSvcList.iterator(); iterator.hasNext();) {
						EgovMap v = iterator.next();

						if( "true".equals(CommonUtils.nvl(v.get("isVact"))) || "true".equals(CommonUtils.nvl(v.get("isNoSvcDay"))) ){
							continue;
						}

						if( "true".equals(CommonUtils.nvl(v.get("isHoliDay"))) ){
							v.put("repla", "true");
						}

						EgovMap eM = allocationMapper.makeViewList(v);
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
		Collections.sort(rtnList, new VComparator());

		return rtnList;
	}


	@Override
	public  List<EgovMap>  isMergeHoliDay(Map<String, Object> params){

		params.put("brnchId",params.get("brnchId"));
		params.put("holiday",params.get("cDate"));

		logger.debug(" isMergeHoliDay ==> "+params.toString());


		List<EgovMap>  eM=	allocationMapper.isSubGroupHoliDay(params);

		return  eM;
	}


	@Override
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


	@Override
	public List<EgovMap>  getBaseList(Map<String, Object> params){

		// Added for Special Delivery CT enhancement by Hui Ding, 31-03-2020
		EgovMap superCT = commonMapper.selectSuperCtInd();
		if (superCT != null){
			params.put("superCT", "Y");
		}

		return allocationMapper.selectBaseList(params);
	}


	@Override
	public int isMergeNosvcDay(Map<java.lang.String, Object> params) {
		return allocationMapper.isMergeNosvcDay(params);
	}

}

