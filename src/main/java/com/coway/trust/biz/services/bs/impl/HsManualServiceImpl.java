package com.coway.trust.biz.services.bs.impl;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.logistics.returnusedparts.ReturnUsedPartsService;
import com.coway.trust.biz.sales.ccp.impl.CcpAgreementMapper;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.bs.HsManualService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.organization.organization.MemberEventListController;
import com.ibm.icu.util.StringTokenizer;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("hsManualService")
public class HsManualServiceImpl extends EgovAbstractServiceImpl implements HsManualService {

	private static final Logger logger = LoggerFactory.getLogger(MemberEventListController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;

	@Resource(name = "hsManualMapper")
	private HsManualMapper hsManualMapper;

	@Resource(name = "returnUsedPartsService")
	private ReturnUsedPartsService returnUsedPartsService;

	@Resource(name = "servicesLogisticsPFCMapper")
	private ServicesLogisticsPFCMapper servicesLogisticsPFCMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectHsConfigList(Map<String, Object> params) {
		// TODO Auto-generated method stub

		if(params.get("ManuaMyBSMonth") != null) {
				StringTokenizer str1 = new StringTokenizer(params.get("ManuaMyBSMonth").toString());

        		for(int i =0; i <= 1 ; i++) {
        			str1.hasMoreElements();
        			String result = str1.nextToken("/");            //특정문자로 자를시 사용

        			logger.debug("iiiii: {}", i);

        			if(i==0){
        				params.put("myBSMonth", result);
        				logger.debug("myBSMonth : {}", params.get("myBSMonth"));
        			}else{
        				params.put("myBSYear", result);
        				logger.debug("myBSYear : {}", params.get("myBSYear"));
        			}
        		}

		}

		logger.debug("myBSMonth : {}", params.get("myBSMonth"));
		logger.debug("saleOrdListSp : {}", params.get("saleOrdListSp"));
		logger.debug("ManualCustId : {}", params.get("ManualCustId"));

		return hsManualMapper.selectHsConfigList(params);
	}

	@Override
	public List<EgovMap> selectHsManualList(Map<String, Object> params) {
		// TODO Auto-generated method stub

		if(params.get("ManuaMyBSMonth") != null) {
				StringTokenizer str1 = new StringTokenizer(params.get("ManuaMyBSMonth").toString());

        		for(int i =0; i <= 1 ; i++) {
        			str1.hasMoreElements();
        			String result = str1.nextToken("/");            //특정문자로 자를시 사용

        			logger.debug("iiiii: {}", i);

        			if(i==0){
        				params.put("myBSMonth", result);
        				logger.debug("myBSMonth : {}", params.get("myBSMonth"));
        			}else{
        				params.put("myBSYear", result);
        				logger.debug("myBSYear : {}", params.get("myBSYear"));
        			}
        		}

		}

		logger.debug("myBSMonth : {}", params.get("myBSMonth"));
		logger.debug("saleOrdListSp : {}", params.get("saleOrdListSp"));
		logger.debug("ManualCustId : {}", params.get("ManualCustId"));

		return hsManualMapper.selectHsManualList(params);
	}



	@Override
	public List<EgovMap> selectHsAssiinlList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		logger.debug("myBSMonth : {}", params.get("myBSMonth"));
		StringTokenizer str1 = new StringTokenizer(params.get("myBSMonth").toString());
		logger.debug("myBSMonth : {}", params.get("myBSMonth"));

		return hsManualMapper.selectHsAssiinlList(params);
	}



	@Override
	public List<EgovMap> selectBranchList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectBranchList(params);
	}

	@Override
	public List<EgovMap> selectCtList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectCtList(params);
	}


	@Override
	public List<EgovMap> getCdUpMemList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		params.put("memLvl", 3);
		return hsManualMapper.getCdUpMemList(params);
	}

	@Override
	public List<EgovMap> getCdDeptList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		params.put("memLvl", 3);
		return hsManualMapper.getCdDeptList(params);
	}

	/* BY KV - Change to textBox -  txtcodyCode and below code no more used.
	@Override
	public List<EgovMap> getCdList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		params.put("memLvl", 4);
		return hsManualMapper.getCdUpMemList(params);
	}
	*/



	@Override
	public List<EgovMap> getCdList_1(Map<String, Object> params) {
		// TODO Auto-generated method stub
		params.put("memLvl", 3);
		return hsManualMapper.getCdList_1(params);
	}



	@Override
	public List<EgovMap> selectHsManualListPop(Map<String, Object> params) {
		// TODO Auto-generated method stub

        		if(params.get("ManuaMyBSMonth") != null) {
        				StringTokenizer str1 = new StringTokenizer(params.get("ManuaMyBSMonth").toString());

                		for(int i =0; i <= 1 ; i++) {
                			str1.hasMoreElements();
                			String result = str1.nextToken("/");            //특정문자로 자를시 사용

                			logger.debug("iiiii: {}", i);

                			if(i==0){
                				params.put("myBSMonth", result);
                				logger.debug("myBSMonth : {}", params.get("myBSMonth"));
                			}else{
                				params.put("myBSYear", result);
                				logger.debug("myBSYear : {}", params.get("myBSYear"));
                			}
                		}

        		}

        		logger.debug("myBSMonth : {}", params.get("myBSMonth"));
        		logger.debug("saleOrdListSp : {}", params.get("saleOrdListSp"));
        		logger.debug("ManualCustId : {}", params.get("ManualCustId"));

        		return hsManualMapper.selectHsManualListPop(params);
	}



	public Map<String, Object> insertHsResult(Map<String, Object> params, List<Object> docType)  {

		Boolean success = false;

		String appId="";
		String saveDocNo = "";
		Map<String, Object> codeMap1 = new HashMap<String, Object>();
		Map<String, Object> MemApp = new HashMap<String, Object>();
		Map<String, Object> resultValue = new HashMap<String, Object>();



		for(int i=0; i< docType.size(); i++){
//		for(Object obj : docType){

			Map<String, Object>  docSub = (Map<String, Object>) docType.get(i);

			int fomSalesOrdNo = Integer.parseInt((String)docSub.get("salesOrdNo"));
//			int nextSchId = (int) docSub.get("salesOrdNo");
			int nextSchId  = hsManualMapper.getNextSchdulId();
			String docNo= commonMapper.selectDocNo("10");


			if(docSub.get("year") != null) {
				StringTokenizer str1 = new StringTokenizer(docSub.get("year").toString());

	    		for(int k =0; k <= 1 ; k++) {
	    			str1.hasMoreElements();
	    			String result = str1.nextToken("/");            //특정문자로 자를시 사용

	    			logger.debug("iiiii: {}", i);

	    			if(k==0){
	    				docSub.put("myBSMonth", result);
	    				logger.debug("myBSMonth : {}", params.get("myBSMonth"));
	    			}else{
	    				docSub.put("myBSYear", result);
	    				logger.debug("myBSYear : {}", params.get("myBSYear"));
	    			}
	    		}

		}


			docSub.put("no", docNo);
			docSub.put("schdulId", nextSchId);
			docSub.put("salesOrdId", docSub.get("salesOrdId"));
    		docSub.put("resultID", 0);
    		//hsResult.put("custId", (params.get("custId").toString()));
    		docSub.put("salesOrdNo", String.format("%08d", fomSalesOrdNo));
    		docSub.put("month", docSub.get("myBSMonth"));
    		docSub.put("year",docSub.get("myBSYear"));
    		docSub.put("typeId", "438");
    		docSub.put("stus", docSub.get("stus"));
    		docSub.put("lok", "4");
    		docSub.put("lastSvc", "0");
    		docSub.put("codyId",docSub.get("codyId"));
    		docSub.put("creator", "1111");
    		docSub.put("created", new Date());


    		hsManualMapper.insertHsResult(docSub);
//    		hsManualMapper.insertHsResult((Map<String, Object>)obj);

    		saveDocNo += docNo;

    		if(docType.size()>1 && docType.size() > i){
    			saveDocNo += "," ;
    		}


    		resultValue.put("docNo", saveDocNo);
		}


		success=true;
		//hsManualMapper.insertHsResult(MemApp);

		return resultValue;
	}



	private boolean Save(boolean isfreepromo,Map<String, Object> params,SessionVO sessionVO) throws ParseException{

		String appId="";
		Map<String, Object> codeMap1 = new HashMap<String, Object>();
		Map<String, Object> MemApp = new HashMap<String, Object>();

		hsManualMapper.insertHsResult(MemApp);

		insertHs(MemApp);

		return true;
	}




	@Transactional
	private boolean insertHs(Map<String, Object> hsResult) throws ParseException{

		String appId="";
		Map<String, Object> codeMap1 = new HashMap<String, Object>();
		Map<String, Object> MemApp = new HashMap<String, Object>();

		hsManualMapper.insertHsResult(MemApp);
		return true;
	}




	@Override
	public EgovMap selectHsInitDetailPop(Map<String, Object> params) {
		// TODO Auto-generated method stub

        		return hsManualMapper.selectHsInitDetailPop(params);
	}




	@Override
	@Transactional
	public Map<String, Object> addIHsResult(Map<String, Object> params, List<Object> docType, SessionVO sessionVO) throws Exception   {

		Map<String, Object> resultValue = new HashMap<String, Object>();

			resultValue = SaveResult(true,params,docType,sessionVO);


			//logs(물류) call
			/////////////////////////물류 호출//////////////////////
//			String str = params.get("serviceNo").toString();
//			returnUsedPartsService.returnPartsInsert(str);
			/////////////////////////물류 호출 end /////////////////


		return resultValue;
	}



	public String getNextDocNo(String prefixNo,String docNo){
		String nextDocNo = "";
		int docNoLength=0;
		System.out.println("!!!"+prefixNo);
		if(prefixNo != null && prefixNo != ""){
			docNoLength = docNo.replace(prefixNo, "").length();
			docNo = docNo.replace(prefixNo, "");
		}else{
			docNoLength = docNo.length();
		}

		int nextNo = Integer.parseInt(docNo) + 1;
		nextDocNo = String.format("%0"+docNoLength+"d", nextNo);
		logger.debug("nextDocNo : {}",nextDocNo);
		return nextDocNo;
	}


	private Map<String, Object> SaveResult(boolean isfreepromo,Map<String, Object> params, List<Object> docType, SessionVO sessionVO) {

		int schdulId =  Integer.parseInt(params.get("hidschdulId").toString());
		String docNo= commonMapper.selectDocNo("11");
//		EgovMap selectHSResultMList = hsManualMapper.selectHSResultMList(params);
		int masterCnt = hsManualMapper.selectHSResultMCnt(params);
//		EgovMap selectDetailList = hsManualMapper.selectDetailList(params);
		int nextSeq  = hsManualMapper.getNextSvc006dSeq();
//		EgovMap selectHSDocNoList =   hsManualMapper.selectHSDocNoList(params); //현재 docNo
//		String resultNo = selectHSDocNoList.get("c2").toString()+selectHSDocNoList.get("c1").toString(); //현재 docNo

		EgovMap insertHsResultfinal = new EgovMap();

		String LOG_SVC0008D_NO ="";
		LOG_SVC0008D_NO  =(String)hsManualMapper.getSVC008D_NO(params);

		if(masterCnt > 0 ) { //master y

			params.put("resultId", nextSeq);
			hsManualMapper.insertHsResultCopy(params);

		} else {//master n
			params.put("resultId", nextSeq);

			//doc nextDocNo
//			String nextDocNo = getNextDocNo(selectHSDocNoList.get("c2").toString(),selectHSDocNoList.get("c1").toString()); //next docNo
//			logger.debug("nextDocNo : {}",nextDocNo);
//			//doc save
//			EgovMap docNoM = new EgovMap();
//			docNoM.put("nextDocNo", nextDocNo);
//			hsManualMapper.updateDocNo(docNoM);


			logger.debug("nextSeq : {}",nextSeq);
			logger.debug("nextSeq : {}",params);

			int status = 0;
			status = Integer.parseInt(params.get("cmbStatusType").toString());

			//BSResultM
			insertHsResultfinal.put("resultId", nextSeq);

			insertHsResultfinal.put("docNo", docNo);
			insertHsResultfinal.put("typeId", 306);
			insertHsResultfinal.put("schdulId", schdulId);
			insertHsResultfinal.put("salesOrdId", params.get("hidSalesOrdId"));
			insertHsResultfinal.put("codyId", params.get("hidCodyId"));

			//insertHsResultfinal.put("setlDt", params.get("settleDate"));
			if(params.get("settleDate")!=null||params.get("settleDate")!=""){
				insertHsResultfinal.put("setlDt", String.valueOf(params.get("settleDate")));
			}else{
				insertHsResultfinal.put("setlDt", "01/01/1900");
			}

			insertHsResultfinal.put("resultStusCodeId", params.get("cmbStatusType"));

			insertHsResultfinal.put("failResnId", params.get("failReason"));
//			insertHsResultfinal.put("renColctId", params.get("cmbCollectType"));

			/*if (status == 4) {	// Completed
				insertHsResultfinal.put("failResnId", 0);
			} else if (status == 21 || status == 10) {	// Fail & Cancelled
				insertHsResultfinal.put("failResnId", params.get("failReason"));
			}*/

			if (status == 4) {	// Completed
				insertHsResultfinal.put("renColctId", params.get("cmbCollectType"));
			} else if (status == 21 || status == 10) {	// Fail & Cancelled
				insertHsResultfinal.put("renColctId", params.get("cmbCollectType"));
			}

			insertHsResultfinal.put("whId", params.get("wareHouse"));

			insertHsResultfinal.put("resultRem", params.get("remark"));
//			insertHsResultfinal.put("resultCrtDt", SYSDATE);
			insertHsResultfinal.put("resultCrtUserId", sessionVO.getUserId());
//			insertHsResultfinal.put("resultUpdDt", SYSDATE);
			insertHsResultfinal.put("resultUpdUserId", sessionVO.getUserId());

			insertHsResultfinal.put("resultIsSync", '0');
			insertHsResultfinal.put("resultIsEdit", '0');
			insertHsResultfinal.put("resultStockUse", '1');
			insertHsResultfinal.put("resultIsCurr", '1');
			insertHsResultfinal.put("resultMtchId", '0');

			insertHsResultfinal.put("resultIsAdj", '0');

			//api추가
			insertHsResultfinal.put("temperateSetng", params.get("temperateSetng"));
			insertHsResultfinal.put("nextAppntDt", params.get("nextAppntDt"));
			insertHsResultfinal.put("nextAppointmentTime", params.get("nextAppointmentTime"));
			insertHsResultfinal.put("ownerCode", params.get("ownerCode"));
			insertHsResultfinal.put("resultCustName", params.get("resultCustName"));
			insertHsResultfinal.put("resultMobileNo", params.get("resultMobileNo"));
			insertHsResultfinal.put("resultRptEmailNo", params.get("resultRptEmailNo"));
			insertHsResultfinal.put("resultAceptName", params.get("resultAceptName"));
			insertHsResultfinal.put("sgnDt", params.get("sgnDt"));
			//api추가 end

			logger.debug("### insertHsResultfinal : {}", insertHsResultfinal);
			hsManualMapper.insertHsResultfinal(insertHsResultfinal);		// INSERT SVC0006D


	        //BSResultD
			for(int i=0; i< docType.size(); i++) {

				Map<String, Object>  docSub = (Map<String, Object>) docType.get(i);

	            docSub.put("bsResultId", nextSeq);
				docSub.put("bsResultPartId", docSub.get("stkId"));
	            docSub.put("bsResultPartDesc", docSub.get("stkDesc"));
	            docSub.put("bsResultPartQty", docSub.get("name"));
	            docSub.put("bsResultRem","");
//	            docSub.put("bsResultCrtDt");
	            docSub.put("bsResultCrtUserId",sessionVO.getUserId());
	            docSub.put("bsResultFilterClm",docSub.get("name"));


	  	      	String vstkId = String.valueOf( docSub.get("stkId"));



	      /*      String filterLastserial =  hsManualMapper.select0087DFilter(docSub);

	            if("".equals(filterLastserial)){
	            	docSub.put("prvSerialNo", filterLastserial);
	            }else {
	            	docSub.put("lastSerialNo", docSub.get("SerialNo"));
	            }

                docSub.put("settleDate", params.get("settleDate"));
                docSub.put("hidCodyId", params.get("hidCodyId"));
                params.put("srvConfigId", docSub.get("srvConfigId"));

	            hsManualMapper.updateHsFilterSiriNo(docSub);*/


  				if( !"".equals(vstkId) && !("null").equals(vstkId) && vstkId != null ) {

  					hsManualMapper.insertHsResultD(docSub);	// INSERT SVC0007D

  					String filterLastserial =  hsManualMapper.select0087DFilter(docSub);

  		            if("".equals(filterLastserial)){
  		            	docSub.put("prvSerialNo", filterLastserial);
  		            }else {
  		            	docSub.put("lastSerialNo", docSub.get("serialNo"));
  		            }

  	                docSub.put("settleDate", params.get("settleDate"));
  	                docSub.put("hidCodyId", params.get("hidCodyId"));
  	                params.put("srvConfigId", docSub.get("srvConfigId"));

  		            hsManualMapper.updateHsFilterSiriNo(docSub);	// UPDATE SAL0087D
  				}



			}

			hsManualMapper.updateHs009d(params);		// UPDATE SAL0090D

		}


		EgovMap getHsResultMList = hsManualMapper.selectHSResultMList(params);

		 //BSScheduleM
		int scheduleCnt = hsManualMapper.selectHSScheduleMCnt(params);

		if(scheduleCnt > 0 ) {

			EgovMap insertHsScheduleM = new EgovMap();


			insertHsScheduleM.put("hidschdulId", params.get("hidschdulId"));
			insertHsScheduleM.put("resultStusCodeId", params.get("cmbStatusType"));
			insertHsScheduleM.put("actnMemId", getHsResultMList.get("codyId"));

            hsManualMapper.updateHsScheduleM(insertHsScheduleM);		// UPDATE SVC0008D

		}


        //SrvConfiguration
		EgovMap srvConfiguration = hsManualMapper.selectSrvConfiguration(params);



		if(srvConfiguration.size()> 0){

			if(getHsResultMList.get("resultStusCodeId").toString().equals("4")){
//                    //COMPLETE
//                    qryConfig.SrvRemark = bsInstruction;
//                    qryConfig.SrvPreviousDate = bsResultMas.SettleDate;
//                    qryConfig.SrvBSWeek = bsPreferWeek;
//                    entity.SaveChanges();

				EgovMap insertHsSrvConfigM = new EgovMap();
				insertHsSrvConfigM.put("salesOrdId", getHsResultMList.get("salesOrdId"));
				insertHsSrvConfigM.put("srvRem", params.get("instruction"));
				insertHsSrvConfigM.put("srvPrevDt", params.get("settleDate"));
				insertHsSrvConfigM.put("srvBsWeek", params.get("srvBsWeek"));



				EgovMap callMas = new EgovMap();
				callMas.put("hcsoid",  getHsResultMList.get("salesOrdId") );
				callMas.put("hcTypeNo", params.get("hidSalesOrdCd") );
//				callMas.put("hcTypeNo", params.get("serviceNo") );
				callMas.put("crtUserId",  sessionVO.getUserId());
				callMas.put("updUserId",  sessionVO.getUserId());

				hsManualMapper.insertCcr0001d(callMas);



//				hsManualMapper.updateHsSrvConfigM(insertHsSrvConfigM);

//                    HappyCallM callMas = new HappyCallM();
//                    callMas.HCID = 0;
//                    callMas.HCSOID = bsResultMas.SalesOrderId;
//                    callMas.HCCallEntryID = 0;
//                    callMas.HCTypeNo = qrySchedule.No;
//                    callMas.HCTypeID = 509;
//                    callMas.HCStatusID = 33;
//                    callMas.HCRemark = "";
//                    callMas.HCCommentDID = 0;
//                    callMas.HCCommentGID = 0;
//                    callMas.HCCommentSID = 0;
//                    callMas.HCCommentDID = 0;
//                    callMas.Creator = bsResultMas.ResultCreator;
//                    callMas.Created = DateTime.Now;
//                    callMas.Updator = bsResultMas.ResultCreator;
//                    callMas.Updated = DateTime.Now;
//                    callMas.HCNoService = false;
//                    callMas.HCLock = false;
//                    callMas.HCCloseID = 0;
//                    entity.HappyCallMs.Add(callMas);
			}else{
                //OTHER STATUS
//                qryConfig.SrvRemark = bsInstruction;
//                qryConfig.SrvBSWeek = bsPreferWeek;
//                entity.SaveChanges();
            }

		}

		//물류 호출   add by hgham
        Map<String, Object>  logPram = null ;
		if(Integer.parseInt(params.get("cmbStatusType").toString()) == 4 ){	// Completed

			/////////////////////////물류 호출//////////////////////
			logPram =new HashMap<String, Object>();
            logPram.put("ORD_ID",  LOG_SVC0008D_NO );
            logPram.put("RETYPE", "COMPLET");
            logPram.put("P_TYPE", "OD05");
            logPram.put("P_PRGNM", "HSCOM");
            logPram.put("USERID", sessionVO.getUserId());

            logger.debug("HSCOM 물류 호출 PRAM ===>"+ logPram.toString());
            servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
            logger.debug("HSCOMCALL 물류 호출 결과 ===> {}" , logPram);
        	logPram.put("P_RESULT_TYPE", "HS");
    		logPram.put("P_RESULT_MSG", logPram.get("p1"));

            /////////////////////////물류 호출 END //////////////////////

      } /*else if(Integer.parseInt(params.get("cmbStatusType").toString()) == 21){	// Failed

    	  /////////////////////////물류 호출//////////////////////
    		logPram =new HashMap<String, Object>();
            logPram.put("ORD_ID",  LOG_SVC0008D_NO );
            logPram.put("RETYPE", "SVO");
            logPram.put("P_TYPE", "OD06");
            logPram.put("P_PRGNM", "HSCAN");
            logPram.put("USERID", sessionVO.getUserId());

            logger.debug("HSCOMCALL 물류 호출 PRAM ===>"+ logPram.toString());
             servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram);
            logPram.put("P_RESULT_TYPE", "HS");
     		logPram.put("P_RESULT_MSG", logPram.get("p1"));
            logger.debug("HSCOMCALL 물류 호출 결과 ===>");
            /////////////////////////물류 호출 END //////////////////////
      }*/



		Map<String, Object> resultValue = new HashMap<String, Object>();
		resultValue.put("resultId",  params.get("hidSalesOrdCd"));
		resultValue.put("spMap", logPram);
		return resultValue;
	}






	@Transactional
	private boolean insertHsResultfinal(int statusId,Map<String, Object> installResult,Map<String, Object> callEntry,Map<String, Object> callResult,Map<String, Object> orderLog) throws ParseException{
    		//installEntry status가 1,21 이면 그 밑에 있는걸 ㅌ야된다(컴플릿이 되어도 다시 상태값 변경 가능하게 해야된다
//    		String maxId = "";  //각 테이블에 maxid 값 가져온다(다음 실행할 쿼리에 값을 넣기 위해 사용)
//    		EgovMap maxIdValue = new EgovMap();
		hsManualMapper.insertHsResultfinal(installResult);
//    		EgovMap entry = installationResultListMapper.selectEntry(installResult);
//    		logger.debug("entry : {}", entry);
//    		maxIdValue.put("value", "resultId");
//    		maxId = installationResultListMapper.selectMaxId(maxIdValue);
//    		logger.debug("maxId : {}", maxId);
//    		entry.put("installResultId", maxId);
//    		entry.put("stusCodeId", installResult.get("statusCodeId"));
//    		entry.put("updated",  installResult.get("created"));
//    		entry.put("updator",  installResult.get("creator"));
//    		installationResultListMapper.updateInstallEntry(entry);
//    		if(installResult.get("statusCodeId").toString().equals("21")){
//    			if(callEntry != null){
//    				installationResultListMapper.insertCallEntry(callEntry);
//    				//callEntry에 max 값 구해서 CallResult에 저장
//    				maxIdValue.put("value", "callEntryId");
//    				maxId = installationResultListMapper.selectMaxId(maxIdValue);
//    				callResult.put("callEntryId", maxId);
//
//    				installationResultListMapper.insertCallResult(callResult);
//    				//callresult에 max값 구해서 callEntry에 업데이트
//    				maxIdValue.put("value", "callResultId");
//    				maxId = installationResultListMapper.selectMaxId(maxIdValue);
//    				callEntry.put("resultId", maxId);
//    				maxIdValue.put("value", "resultId");
//    				maxId = installationResultListMapper.selectMaxId(maxIdValue);
//    				callEntry.put("callEntryId", maxId);
//    				installationResultListMapper.updateCallEntry(callEntry);
//    			}
//
//			hsManualMapper.insertOrderLog(orderLog);
//    		}
		return true;
	}



	@Override
	public List<EgovMap> cmbCollectTypeComboList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.cmbCollectTypeComboList();
	}

	@Override
	public List<EgovMap> cmbCollectTypeComboList2(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.cmbCollectTypeComboList2();
	}


	@Override
	public List<EgovMap> cmbServiceMemList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.cmbServiceMemList();
	}


	@Override
	public List<EgovMap> selectHsFilterList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectHsFilterList(params);
	}



	@Override
	public EgovMap selectHsViewBasicInfo(Map<String, Object> params) {

		return hsManualMapper.selectHsViewBasicInfo(params);
	}



	@Override
	public List<EgovMap> failReasonList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.failReasonList(params);
	}



	@Override
	public List<EgovMap> serMemList(Map<String, Object> params) {
		return hsManualMapper.serMemList(params);
	}



	@Override
	public List<EgovMap> selectHsViewfilterInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		params.put("selSchdulId2" , params.get("selSchdulId"));
		logger.debug("jinmu{}" , params);
		return hsManualMapper.selectHsViewfilterInfo(params);
	}



	@Override
	public EgovMap selectSettleInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectSettleInfo(params);
	}



	@Override
	@Transactional
	public Map<String, Object> UpdateHsResult(Map<String, Object> params, List<Object> docType, SessionVO sessionVO)  {

		Map<String, Object> resultValue = new HashMap<String, Object>();

		EgovMap UpdateHsResult = new EgovMap();

        //BSResultD
		for(int i=0; i< docType.size(); i++) {
			Map<String, Object>  docSub = (Map<String, Object>) docType.get(i);
			docSub.put("bsResultId", params.get("hidschdulId"));
			docSub.put("bsResultPartId", docSub.get("stkId"));
            docSub.put("bsResultPartDesc", docSub.get("stkDesc"));
            docSub.put("bsResultPartQty", docSub.get("name"));
//            docSub.put("bsResultCrtDt");
            docSub.put("bsResultCrtUserId",sessionVO.getUserId());
            docSub.put("bsResultFilterClm",docSub.get("name"));

            hsManualMapper.updateHsResultD(docSub);
		}

		//BSResultM
		EgovMap HsResultUdateEdit = new EgovMap();
		HsResultUdateEdit.put("hidschdulId", params.get("hidschdulId"));
		HsResultUdateEdit.put("srvRem", params.get("instruction"));
		HsResultUdateEdit.put("codyId", params.get("cmbServiceMem"));
		HsResultUdateEdit.put("failReason", params.get("failReason"));
		HsResultUdateEdit.put("renColctId", params.get("cmbCollectType"));
		HsResultUdateEdit.put("srvBsWeek", params.get("srvBsWeek"));

	     hsManualMapper.updateHsResultM(HsResultUdateEdit);	//m



		 //BSScheduleM
		int scheduleCnt = hsManualMapper.selectHSScheduleMCnt(params);

		if(scheduleCnt > 0 ) {
			EgovMap insertHsScheduleM = new EgovMap();
			insertHsScheduleM.put("hidschdulId", params.get("hidschdulId"));
			insertHsScheduleM.put("resultStusCodeId", params.get("cmbStatusType2"));
			insertHsScheduleM.put("actnMemId", params.get("cmbServiceMem"));


            hsManualMapper.updateHsScheduleM(insertHsScheduleM);
		}


			EgovMap updateHsSrvConfigM = new EgovMap();

			updateHsSrvConfigM.put("salesOrdId", params.get("hidschdulId"));
			updateHsSrvConfigM.put("srvBsWeek", params.get("srvBsWeek"));

//			hsManualMapper.updateHsSrvConfigM(updateHsSrvConfigM);

		return resultValue;
	}



	@Override
	public List<EgovMap> selectFilterTransaction(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectFilterTransaction(params);
	}



	@Override
	public List<EgovMap> selectHistoryHSResult(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectHistoryHSResult(params);
	}



	@Override
	public EgovMap selectConfigBasicInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectConfigBasicInfo(params);
	}



	@Override
	public int updateHsConfigBasic(Map<String, Object> params, SessionVO sessionVO) {
		// TODO Auto-generated method stub

		int cnt =0;

		LinkedHashMap  hsBasicmap = (LinkedHashMap)  params.get("hsResultM");

		logger.debug("hsResultM services ===>"+params);
		EgovMap selectConfigBasicInfoYn = hsManualMapper.selectConfigBasicInfoYn(hsBasicmap);


		if(selectConfigBasicInfoYn.size() > 0) {
			Map<String, Object> sal0090 = new HashMap<String, Object>();

			sal0090.put("salesOrderId", hsBasicmap.get("salesOrderId"));
			sal0090.put("availability", hsBasicmap.get("availability"));
			sal0090.put("srvConfigId", selectConfigBasicInfoYn.get("srvConfigId"));
			sal0090.put("cmbServiceMem", hsBasicmap.get("cmbServiceMem"));
			sal0090.put("lstHSDate", hsBasicmap.get("lstHSDate"));
			sal0090.put("remark", hsBasicmap.get("remark"));
			sal0090.put("srvBsWeek", hsBasicmap.get("srvBsWeek"));
			sal0090.put("SrvUpdateAt", sessionVO.getUserId());
			sal0090.put("hscodyId", hsBasicmap.get("hscodyId"));
//			sal0090.put("SrvUpdateAt", SYSDATE);

			hsManualMapper.updateHsSVC0006D(sal0090);
			cnt = hsManualMapper.updateHsConfigBasic(sal0090);



	          //SrvConfigSetting --> Installation : 281
            List<EgovMap> configSettingMap = hsManualMapper.selectConfigSettingYn(hsBasicmap);

            if(configSettingMap.size()>0){
            	for(int i=0; i< configSettingMap.size(); i++){

            		Map<String, Object> sal0089 = configSettingMap.get(i);

            			if(configSettingMap.get(i).get("srvSettTypeId").toString().equals("281")){
        					if("1".equals(hsBasicmap.get("settIns").toString())){
                					sal0089.put("srvSettStusId", 1);
                				}else {
                    				sal0089.put("srvSettStusId", 8);
                    			}
            			}else if (configSettingMap.get(i).get("srvSettTypeId").toString().equals("280")){
        					if("1".equals(hsBasicmap.get("settHs").toString())){
            					sal0089.put("srvSettStusId", 1);
            				}else {
                				sal0089.put("srvSettStusId", 8);
                			}
            			}else if (configSettingMap.get(i).get("srvSettTypeId").toString().equals("279")){
            				if("1".equals(hsBasicmap.get("settAs").toString())){
            					sal0089.put("srvSettStusId", 1);
            				}else {
                				sal0089.put("srvSettStusId", 8);
                			}
            			}

            			sal0089.put("salesOrderId",hsBasicmap.get("salesOrderId"));
            			sal0089.put("configId",hsBasicmap.get("configId"));
            			sal0089.put("srvSettRem", "");
            			sal0089.put("srvSettCrtUserId", sessionVO.getUserId());


            			hsManualMapper.updateHsconfigSetting(sal0089);

            	}
            }
		}


		 return cnt;
	}



	@Override
	public EgovMap selectHSOrderView(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectHSOrderView(params);
	}



	@Override
	public List<EgovMap> selectOrderInactiveFilter(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectOrderInactiveFilter(params);
	}



	@Override
	public List<EgovMap> selectOrderActiveFilter(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectOrderActiveFilter(params);
	}



	@Override
	public String updateAssignCody(Map<String, Object> params) {
		List <EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);
		String rtnValue  ="";
		String line = System.getProperty("line.separator");


		if (updateItemList.size() > 0) {

			for (int i = 0; i < updateItemList.size(); i++) {
				Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);
				logger.debug("updateMap : {}"+updateMap);
				hsManualMapper.updateAssignCody(updateMap) ;
				hsManualMapper.updateAssignCody90D(updateMap) ;

				if (i != 0) {
					rtnValue += "<br>";
				}

				rtnValue += "* Cody Transfer for HS Order ‘" + updateMap.get("no") +"'" + "<br>from " + "'" + updateMap.get("oldCodyCd") +"'"+ " to " + "'" +updateMap.get("codyCd")  + "'"  + "\r\n";
				rtnValue = rtnValue.replace("\n", line);
			}
		}
		return rtnValue;
	}

	@Override
	public List<EgovMap> selectBranch_id(Map<String, Object> params) {
		return hsManualMapper.selectBranch_id(params);
	}

	@Override
	public List<EgovMap> selectCTMByDSC_id(Map<String, Object> params) {
		return hsManualMapper.selectCTMByDSC_id(params);
	}

	@Override
	public EgovMap selectCheckMemCode(Map<String, Object> params) {

		return hsManualMapper. selectCheckMemCode(params);
	}

	@Override
	public EgovMap serMember(Map<String, Object> params) {

		return hsManualMapper.selectSerMember(params);
	}

	@Override
	public List<EgovMap> selectHSCodyList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectHSCodyList(params);
	}

	@Override
	public String getSrvCodyIdbyMemcode(Map<String, Object> params) {

		return hsManualMapper.selectMemberId(params);
	}

	@Override
	public int updateSrvCodyId(Map<String, Object> params) {
		int cnt =0;
		hsManualMapper.updateSrvCodyId(params);
		return cnt;
	}


	@Override
	public List<EgovMap> selectHSAddFilterSetInfo(Map<String, Object> params) {
		return hsManualMapper.selectHSAddFilterSetInfo(params);
	}

	@Override
	public List<EgovMap> addSrvFilterIdCnt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.addSrvFilterIdCnt(params);
	}

	@Override
	public int updateFilterInfo(Map<String, Object> params, SessionVO sessionVO) {
		// TODO Auto-generated method stub
		return hsManualMapper.updateFilterInfo(params);
	}

	@Override
	public String getSrvConfigId_SAL009(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.getSrvConfigId_SAL009(params);
	}

	@Override
	public String getbomPartPriod_LOG0001M(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.getbomPartPriod_LOG0001M(params);
	}

	@Override
	public String getSalesDtSAL_0001D(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.getSalesDtSAL_0001D(params);
	}

	@Override
	public EgovMap getSrvConfigFilter_SAL0087D(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.getSrvConfigFilter_SAL0087D(params);
	}

	@Override
	public int saveHsFilterInfoAdd(Map<String, Object> params) {
		// TODO Auto-generated method stub
		int result = -1;

		String configID = hsManualMapper.getSrvConfigId_SAL009(params);
		String filterPeriod = hsManualMapper.getbomPartPriod_LOG0001M(params);
		String orderdate = hsManualMapper.getSalesDtSAL_0001D(params);

//        DateTime CutOffDate = DateTime.ParseExact("04/27/2016", "MM/dd/yyyy", CultureInfo.InvariantCulture);
		String productID = String.valueOf(params.get("productID"));
		String filterCode = String.valueOf(params.get("filterCode"));

//		if (ProductID == 892 || orderdate < CutOffDate)
		/*if(productID == "892"){
			if(filterCode == "303" || filterCode == "901"){
				filterPeriod = "6";
			}
		}*/

		Map<String, Object> send_sal0087D = new HashMap();

		if(configID != null && !"0".equals(configID)){
			EgovMap sal0087D = hsManualMapper.getSrvConfigFilter_SAL0087D(params);

			if( sal0087D != null){
				/*send_sal0087D.put("SRV_FILTER_PRIOD", filterPeriod);
				send_sal0087D.put("SRV_FILTER_PRV_CHG_DT", params.get("lastChangeDate"));
				send_sal0087D.put("SRV_FILTER_STUS_ID", 1);
				send_sal0087D.put("SRV_FILTER_UPD_USER_ID" , params.get("updator"));
				send_sal0087D.put("SRV_FILTER_REM", params.get("remark"));

                hsManualMapper.saveChanges(send_sal0087D);*/

				// 이미 존재
				result = -100;

			}else {
				/*send_sal0087D.put("SRV_FILTER_ID"          ,0);
				send_sal0087D.put("SRV_CONFIG_ID"          ,configID);
				send_sal0087D.put("SRV_FILTER_STK_ID"      ,filterCode);
				send_sal0087D.put("SRV_FILTER_PRIOD"       ,filterPeriod);
				send_sal0087D.put("SRV_FILTER_PRV_CHG_DT"  ,params.get("lastChangeDate"));
				send_sal0087D.put("SRV_FILTER_STUS_ID"     ,1);
				send_sal0087D.put("SRV_FILTER_REM"         ,params.get("remark"));
//				send_sal0087D.put("SRV_FILTER_CRT_DT"      ,); sysdate
				send_sal0087D.put("SRV_FILTER_CRT_USER_ID" , params.get("updator"));
//				send_sal0087D.put("SRV_FILTER_UPD_DT"      ,);sysdate
				send_sal0087D.put("SRV_FILTER_UPD_USER_ID" ,params.get("updator"));

				hsManualMapper.saveChanges(send_sal0087D);*/

				//Insert SAL0087D
				hsManualMapper.saveHsFilterInfoAdd(params);
				result = 1;

			}
		}

		return result;
	}

	@Override
	public int saveDeactivateFilter(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.saveDeactivateFilter(params);
	}

	@Override
	public int saveFilterUpdate(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.saveFilterUpdate(params);
	}

	@Override
	public List<EgovMap> selecthSFilterUseHistorycall (Map<String, Object> params){
		return hsManualMapper.selecthSFilterUseHistorycall(params);
	}

	@Override
	@Transactional
	public Map<String, Object> UpdateHsResult2(Map<String, Object> params, List<Object> docType, SessionVO sessionVO) throws ParseException {

		Map<String, Object> resultValue = new HashMap<String, Object>();

		EgovMap UpdateHsResult = new EgovMap();

		List<Map<String, Object>> bsResultDet = new ArrayList<Map<String, Object>>();

		for(int i=0; i< docType.size(); i++) {
			Map<String, Object> bsd = new HashMap<String, Object>();
			Map<String, Object>  docSub = (Map<String, Object>) docType.get(i);
			logger.debug("docSub{} : " + docSub);

			//bsd.put("BSResultItemID",0 );
			bsd.put("BSResultID",String.valueOf(params.get("hidschdulId")));
			bsd.put("BSResultPartID",String.valueOf(docSub.get("stkId") ));
			bsd.put("BSResultPartDesc",String.valueOf(docSub.get("stkDesc") ));
			bsd.put("BSResultPartQty",String.valueOf(docSub.get("name") ));
			bsd.put("BSResultRemark","" );
			//bsd.put("BSResultCreateAt",0 );
			bsd.put("BSResultCreateBy",String.valueOf(sessionVO.getUserId()) );
			bsd.put("BSResultFilterClaim",String.valueOf(1));
			bsd.put("SerialNo", docSub.get("serialNo")!=null ? String.valueOf(docSub.get("serialNo")) : "");

			bsResultDet.add(bsd);
		}

		Map<String, Object> bsResultMas = new HashMap<String, Object>();
		//bsResultMas.put("ResultID", 0);
		bsResultMas.put("No", "");
		bsResultMas.put("TypeID", String.valueOf(306));
		bsResultMas.put("ScheduleID", String.valueOf(params.get("hidschdulId")));
		bsResultMas.put("SalesOrderId", String.valueOf(params.get("hidSalesOrdId")));

		if(params.get("cmbServiceMem")==null || params.get("cmbServiceMem")==""){
			bsResultMas.put("CodyID", String.valueOf(sessionVO.getUserId()));
		}else{
			bsResultMas.put("CodyID", String.valueOf(params.get("cmbServiceMem")));
		}


		//bsResultMas.put("SettleDate", params.get("setlDt"));
		logger.debug(">>>>>>settleDt isEmpty : " + StringUtils.isEmpty(String.valueOf(params.get("settleDt")).trim()));
		if(params.get("settleDt")!=null||params.get("settleDt")!=""){
			bsResultMas.put("SettleDate", String.valueOf(params.get("settleDt")));
		}else{
			bsResultMas.put("SettleDate", "01/01/1900");
		}

		if(params.get("cmbStatusType2")==null || params.get("cmbStatusType2")==""){
			bsResultMas.put("ResultStatusCodeID", String.valueOf("0"));
		}else{
			bsResultMas.put("ResultStatusCodeID", String.valueOf(params.get("cmbStatusType2")));
		}


		if(params.get("failReason")==null || params.get("failReason")==""){
			bsResultMas.put("FailReasonID", String.valueOf("0"));
		}else{
			bsResultMas.put("FailReasonID", String.valueOf(params.get("failReason")));
		}

		if(params.get("cmbCollectType")==null || params.get("cmbCollectType")==""){
			bsResultMas.put("RenCollectionID", String.valueOf("0"));
		}else{
			bsResultMas.put("RenCollectionID", String.valueOf(params.get("cmbCollectType")));
		}
		//bsResultMas.put("RenCollectionID", String.valueOf(params.get("cmbCollectType")));

		if(params.get("wareHouse")==null || params.get("wareHouse")==""){
			bsResultMas.put("WarehouseID", String.valueOf("0"));
		}else{
			bsResultMas.put("WarehouseID",String.valueOf(params.get("wareHouse")));
		}

		//logger.debug("txtRemark isEmpty : " + StringUtils.isEmpty(String.valueOf(params.get(""txtRemark"")).trim()));
		bsResultMas.put("ResultRemark", String.valueOf(params.get("txtRemark")));

		/*logger.debug("configBsRem isEmpty : " + StringUtils.isEmpty(String.valueOf(params.get("configBsRem")).trim()));
		if(StringUtils.isEmpty(String.valueOf(params.get("configBsRem")).trim())){
			bsResultMas.put("ResultRemark", String.valueOf(0));
		}else{
			bsResultMas.put("ResultRemark", String.valueOf(params.get("configBsRem")));
		}*/

		//bsResultMas.put("ResultCreated", sysdate);
		bsResultMas.put("ResultCreator", String.valueOf(sessionVO.getUserId()));
		//bsResultMas.put("ResultUpdated", sysdate);
		bsResultMas.put("ResultIsSync", String.valueOf(1));
		bsResultMas.put("ResultIsEdit", String.valueOf(1));

		if(bsResultDet.size()>0){
			bsResultMas.put("ResultStockUse", String.valueOf(1));
		}else{
			bsResultMas.put("ResultStockUse", String.valueOf(0));
		}
		bsResultMas.put("ResultIsCurrent", String.valueOf(1));
		bsResultMas.put("ResultMatchID", String.valueOf(0));
		bsResultMas.put("ResultIsAdjust", String.valueOf(1));
		bsResultMas.put("bsPreferWeek", String.valueOf(params.get("srvBsWeek")));


		// UPDATE SAL0045D - INSTALLATION INSTRUCTION - TPY 20180629

		Map<String, Object> bsResultInst = new HashMap<String, Object>();

		bsResultInst.put("SalesOrderId", String.valueOf(params.get("hidSalesOrdId")));
		bsResultInst.put("userId", String.valueOf(sessionVO.getUserId()));
		bsResultInst.put("instct", String.valueOf(params.get("txtInstruction")));

		// END


		Map<String, Object> bsResultMas_Rev = new HashMap<String, Object>();

		String ResultNo_Rev = "";
		int BS_RESULT=11;
		bsResultMas_Rev.put("doctype", BS_RESULT);


		String docNo  = null;
		docNo = hsManualMapper.GetDocNo(bsResultMas_Rev);
		bsResultMas_Rev.put("docNo", docNo);

		String BS_RESULT_BSR = "BSR";

		String nextNo = getNextDocNo(BS_RESULT_BSR,docNo);
		/*
		String DocNoFormat = "";
		for (int i = 1; i <= BS_RESULT_BSR.length(); i++)
        {
            DocNoFormat += "0";
        }
        DocNoFormat = "{0:" + DocNoFormat + "}";

        int docNo_int = Integer.parseInt(docNo.replace(BS_RESULT_BSR, "").toString());
        int nextNo = docNo_int +1;
        */
		bsResultMas_Rev.put("ID_New", BS_RESULT);
        bsResultMas_Rev.put("nextDocNo_New", nextNo);
        hsManualMapper.updateQry_New(bsResultMas_Rev);
		//int docNo1 = hsManualMapper.GetDocNo1(bsResultMas_Rev);

		EgovMap qryBS_Rev =  null;
		qryBS_Rev=hsManualMapper.selectQryBS_Rev(bsResultMas);
		logger.debug("qryBS_Rev : {}" + qryBS_Rev);

		if(qryBS_Rev!=null){
			int BSResultM_resultID = hsManualMapper.getBSResultM_resultID();
    		bsResultMas_Rev.put("ResultID", BSResultM_resultID); //sequence
    		bsResultMas_Rev.put("No", String.valueOf(docNo));
    		bsResultMas_Rev.put("TypeID", String.valueOf("307"));
    		bsResultMas_Rev.put("ScheduleID", String.valueOf(qryBS_Rev.get("schdulId")));
    		bsResultMas_Rev.put("SalesOrderId", String.valueOf(qryBS_Rev.get("salesOrdId")));
    		bsResultMas_Rev.put("CodyID", String.valueOf(qryBS_Rev.get("codyId")));
    		bsResultMas_Rev.put("SettleDate", String.valueOf(qryBS_Rev.get("setlDt")));
    		bsResultMas_Rev.put("ResultStatusCodeID", String.valueOf(qryBS_Rev.get("resultStusCodeId")));//RESULT_STUS_CODE_ID
    		bsResultMas_Rev.put("FailReasonID", String.valueOf(qryBS_Rev.get("failResnId")));//FAIL_RESN_ID
    		bsResultMas_Rev.put("RenCollectionID", String.valueOf(qryBS_Rev.get("renColctId")));//REN_COLCT_ID
    		bsResultMas_Rev.put("WarehouseID", String.valueOf(qryBS_Rev.get("whId")));//WH_ID
    		bsResultMas_Rev.put("ResultRemark", String.valueOf(qryBS_Rev.get("resultRem")));//RESULT_REM
    		//bsResultMas_Rev.put("ResultCreated", "sysdate");
    		bsResultMas_Rev.put("ResultCreator", String.valueOf(sessionVO.getUserId()));
    		bsResultMas_Rev.put("ResultIsSync", String.valueOf(1));
    		bsResultMas_Rev.put("ResultIsEdit", String.valueOf(0));
    		bsResultMas_Rev.put("ResultStockUse", String.valueOf(qryBS_Rev.get("resultStockUse")));//RESULT_STOCK_USE
    		bsResultMas_Rev.put("ResultIsCurrent", String.valueOf(1));
    		bsResultMas_Rev.put("ResultMatchID", String.valueOf(qryBS_Rev.get("resultId")));//RESULT_ID
    		bsResultMas_Rev.put("ResultIsAdjust", String.valueOf(1));




    		logger.debug("selectQryResultDet : {}" + bsResultMas_Rev);
    		List<EgovMap> qryResultDet =  hsManualMapper.selectQryResultDet(bsResultMas_Rev);
    		logger.debug("qryResultDet : {}" + qryResultDet);
    		logger.debug("qryResultDet.size() : {}" + qryResultDet.size());

    		int checkInt =0 ;

    		// bsResultDet
    		Map<String, Object> bsResultDet_Rev = null;
    		for(int i = 0 ; i<qryResultDet.size() ; i++){

    			bsResultDet_Rev = new HashMap<String, Object>();
    			//bsResultDet_Rev.put("BSResultItemID", 0);
    			bsResultDet_Rev.put("BSResultID", BSResultM_resultID);
    			bsResultDet_Rev.put("BSResultPartID", String.valueOf(qryResultDet.get(i).get("bsResultPartId")));//BS_RESULT_PART_ID
    			bsResultDet_Rev.put("BSResultPartDesc", CommonUtils.nvl(qryResultDet.get(i).get("bsResultPartDesc")));//BS_RESULT_PART_DESC
    			if(String.valueOf(qryBS_Rev.get("resultId")) != null && String.valueOf(qryBS_Rev.get("resultId")) != ""){
    				bsResultDet_Rev.put("BSResultPartQty",  CommonUtils.intNvl( qryResultDet.get(i).get("bsResultPartQty"))*-1);//BS_RESULT_PART_QTY
    				logger.debug("jinmu {}" + String.valueOf(qryBS_Rev.get("resultId")));
    			}
    			else{
    				bsResultDet_Rev.put("BSResultPartQty",  CommonUtils.intNvl(qryResultDet.get(i).get("bsResultPartQty")));
    				logger.debug("jinmu111 {}" + String.valueOf(qryBS_Rev.get("resultId")));
    			}
    			bsResultDet_Rev.put("BSResultRemark",   CommonUtils.nvl(qryResultDet.get(i).get("bsResultRem")));//BS_RESULT_REM
    			bsResultDet_Rev.put("BSResultCreateAt","sysdate");//BS_RESULT_REM
    			bsResultDet_Rev.put("BSResultCreateBy",String.valueOf(sessionVO.getUserId()));
    			bsResultDet_Rev.put("BSResultFilterClaim",CommonUtils.intNvl( qryResultDet.get(i).get("bsResultFilterClm")));//BS_RESULT_FILTER_CLM

    			if(CommonUtils.intNvl( qryResultDet.get(i).get("bsResultPartQty")) > 0){
    				hsManualMapper.addbsResultDet_Rev(bsResultDet_Rev);	//insert svc 0007d c
    				checkInt ++;
    				if(i == (qryResultDet.size() - 1)){ // 마지막일때 넘기기

    				}
    			}
    		}

    		if(checkInt > 0){
    			hsManualMapper.addbsResultMas_Rev(bsResultMas_Rev); //svc 0006d B insert
    			logger.debug("reverse JM"+ String.valueOf(bsResultDet_Rev.get("BSResultID")));
				//물류 프로시져 호출
	    	    Map<String, Object>  logPram = null ;
	    	      logPram =new HashMap<String, Object>();
	    	         logPram.put("ORD_ID", String.valueOf(bsResultDet_Rev.get("BSResultID")));
	    	         logPram.put("RETYPE", "RETYPE");
	    	         logPram.put("P_TYPE", "OD06");
	    	         logPram.put("P_PRGNM", "HSCEN");
	    	         logPram.put("USERID", String.valueOf(sessionVO.getUserId()));


	    	    Map   SRMap=new HashMap();
	    	    logger.debug("ASManagementListServiceImpl.asResult_update in  CENCAL  물류 차감  PRAM ===>"+ logPram.toString());
	    	   servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST_REVERSE(logPram);
	    	    logger.debug("ASManagementListServiceImpl.asResult_update  in  CENCAL 물류 차감 결과   ===>" +logPram.toString());
    		}

    		EgovMap qry_stkReqM = null;
    		qry_stkReqM = hsManualMapper.selectQry_stkReqM(bsResultMas_Rev);

    		if(qry_stkReqM!=null){
        		String PDONo  = null;
        		int PDO_REQUEST = 26;
        		bsResultMas_Rev.put("docType", PDO_REQUEST);
        		PDONo = hsManualMapper.GetDocNo(bsResultMas_Rev);
        		bsResultMas_Rev.put("PDONo", PDONo);

        		String PDO_REQUEST_PDO = "PDO";

        		String nextDocNo_PDO = getNextDocNo(PDO_REQUEST_PDO,PDONo);

        		bsResultMas_Rev.put("ID_New", PDO_REQUEST);
                bsResultMas_Rev.put("nextDocNo_New", nextDocNo_PDO);
                hsManualMapper.updateQry_New(bsResultMas_Rev);
        		/*
        		String DocNoFormat_pod = "";
        		for (int i = 1; i <= PDO_REQUEST_PDO.length(); i++)
                {
                    DocNoFormat_pod += "0";
                }
                DocNoFormat_pod = "{0:" + DocNoFormat_pod + "}";

                docNo_int = Integer.parseInt(PDONo.replace(PDO_REQUEST_PDO, "").toString());
                int nextDocNo_PDO = docNo_int +1;
                bsResultMas_Rev.put("nextNo", nextDocNo_PDO);

                int qry_PDO = hsManualMapper.GetDocNo1(bsResultMas_Rev);
                */
                Map<String, Object> stkReqM_Rev = new HashMap<String, Object>();
                //stkReqM_Rev.put("StkReqID", 0);
                stkReqM_Rev.put("StkReqNo", String.valueOf(PDONo));
                stkReqM_Rev.put("StkReqLocFromID", String.valueOf(qry_stkReqM.get("stkReqLocFromId")));//STK_REQ_LOC_FROM_ID
                stkReqM_Rev.put("StkReqLocToID", String.valueOf(qry_stkReqM.get("stkReqLocToId")));//STK_REQ_LOC_TO_ID
                stkReqM_Rev.put("StkReqRemark", String.valueOf(qry_stkReqM.get("stkReqRem")));//STK_REQ_REM
                stkReqM_Rev.put("StkReqCreateAt","sysdate");//STK_REQ_REM
                stkReqM_Rev.put("StkReqCreateBy",String.valueOf(sessionVO.getUserId()));//STK_REQ_REM

                hsManualMapper.addstkReqM_Rev(stkReqM_Rev);

                int LocationID_Rev = 0;
                if(Integer.parseInt(qryBS_Rev.get("codyId").toString())!=0){
                	LocationID_Rev=hsManualMapper.getMobileWarehouseByMemID(qryBS_Rev);
                }

                int stkReqM_StkReqID = hsManualMapper.getStkReqM_StkReqID();

                EgovMap qryBS = null;
                qryBS = hsManualMapper.selectQryBS(bsResultMas);
                //bsResultMas_Rev.put("ResultMatchID
                EgovMap qry_stkReqD_Rev = null;
                qry_stkReqD_Rev = hsManualMapper.qry_stkReqD_Rev(bsResultMas_Rev);
                int stkCrdCounter_Rev = 1;
                for(int i = 0 ; i< qry_stkReqD_Rev.size(); i++){
                	Map<String, Object> stkReqD_Rev = new HashMap<String, Object>();
                	//stkReqD_Rev.put("ReqItemID", 0);//sequence
                	stkReqD_Rev.put("ReqID", String.valueOf(stkReqM_StkReqID));//
                	stkReqD_Rev.put("ReqItemTypeID", String.valueOf("464"));//
                	stkReqD_Rev.put("ReqItemRefID", String.valueOf(BSResultM_resultID));//BSResultM_resultID
                	stkReqD_Rev.put("ReqItemStkID", String.valueOf(qryBS.get("bsResultPartId")));//BS_RESULT_PART_ID
                	stkReqD_Rev.put("ReqItemStkDesc", String.valueOf(qryBS.get("bsResultPartDesc")));//
                	stkReqD_Rev.put("ReqItemQty", Integer.parseInt(qryBS.get("bsResultPartQty").toString())*-1);//
                	stkReqD_Rev.put("ReqItemStatusID", String.valueOf(1));//
                	stkReqD_Rev.put("ReqItemRemark", "");//BS_RESULT_REM

                	hsManualMapper.addStkReqD_Rev(stkReqD_Rev);

                	Map<String, Object> stkCrd_Rev = new HashMap<String, Object>();
                	stkCrd_Rev.put("LocationID", LocationID_Rev);
                	stkCrd_Rev.put("StockID", qry_stkReqD_Rev.get("bsResultPartId"));//BS_RESULT_PART_ID
                	stkCrd_Rev.put("EntryDate", "sysdate");//
                	stkCrd_Rev.put("TypeID", String.valueOf("464"));//
                	stkCrd_Rev.put("RefNo", qryBS.get("no"));
                	stkCrd_Rev.put("SalesOrderId", qryBS.get("salesOrdId"));//SALES_ORD_ID
                	stkCrd_Rev.put("SourceID", String.valueOf(477));
                	stkCrd_Rev.put("ProjectID", String.valueOf(0));
                	stkCrd_Rev.put("BatchNo", String.valueOf(0));
                	stkCrd_Rev.put("Qty", String.valueOf(qry_stkReqD_Rev.get("bsResultPartQty")));//BS_RESULT_PART_QTY
                	stkCrd_Rev.put("CurrID", String.valueOf(479));
                	stkCrd_Rev.put("CurrRate", String.valueOf(1));
                	stkCrd_Rev.put("Cost", String.valueOf(0));
                	stkCrd_Rev.put("Price", String.valueOf(0));
                	stkCrd_Rev.put("Remark", "");
                	stkCrd_Rev.put("SerialNo", "");
                	stkCrd_Rev.put("InstallNo", qryBS_Rev.get("no"));
                	stkCrd_Rev.put("CostDate", "sysdate");
                	stkCrd_Rev.put("AppTypeID", String.valueOf("0"));
                	stkCrd_Rev.put("StkGrade", "A");
                	stkCrd_Rev.put("InstallFail", String.valueOf(1));
                	stkCrd_Rev.put("IsSynch", String.valueOf(1));
                	stkCrd_Rev.put("EntryMethodID", String.valueOf(764));
                	stkCrd_Rev.put("Origin", "1");
                	stkCrd_Rev.put("ItemNo", stkCrdCounter_Rev);

                	hsManualMapper.addStkCrd_Rev(stkCrd_Rev);

                	stkCrdCounter_Rev = stkCrdCounter_Rev+1;
                }
    		}

    		Map<String, Object> qry_CurBS = new HashMap<String, Object>();
    		qry_CurBS.put("ScheduleID", String.valueOf(bsResultMas.get("ScheduleID")));
    		qry_CurBS.put("SalesOrderId", String.valueOf(bsResultMas.get("SalesOrderId")));
    		qry_CurBS.put("userId", sessionVO.getUserId());

    		hsManualMapper.updateQry_CurBS(qry_CurBS); // 업데이트 svc0006d



    		String ResultNo_New  = null;
    		BS_RESULT=11;
    		bsResultMas_Rev.put("doctype", String.valueOf(BS_RESULT));
    		ResultNo_New = hsManualMapper.GetDocNo(bsResultMas_Rev);

    		int ID_New = 11;
    		String nextDocNo_New = getNextDocNo(BS_RESULT_BSR,ResultNo_New);

    		Map<String, Object> qry_New = new HashMap<String, Object>();
    		qry_New.put("ID_New", String.valueOf(BS_RESULT));
    		qry_New.put("nextDocNo_New", String.valueOf(nextDocNo_New));
    		hsManualMapper.updateQry_New(qry_New);



			int BSResultM_resultID2 = hsManualMapper.getBSResultM_resultID();
    		bsResultMas.put("No", ResultNo_New);
    		bsResultMas.put("ResultId", BSResultM_resultID2);
    		bsResultMas.put("CodyId", String.valueOf(bsResultMas_Rev.get("codyId")));



    		//확인용
    		int cnt = 0;
    		for(int i = 0; i < bsResultDet.size(); i++) {
    			Map<String, Object> row = bsResultDet.get(i);

    			row.put("BSResultID", BSResultM_resultID2);

    			if(row.get("BSResultPartQty") != null && !row.get("BSResultPartQty").toString().equals("0")){
    				hsManualMapper.addbsResultDet_Rev(row); //인서트 svc 0007d
    				cnt++;
    				if(i == (bsResultDet.size() - 1)){
        				logger.debug("request JM"+ i + String.valueOf(row.get("BSResultID")));


    				}

    			}
    		}

    		if(cnt != 0){	// 0이 아닐 경우 인서트
    			hsManualMapper.addbsResultMas(bsResultMas); // insert 1건 svc0006d
    		} else if(cnt == 0){ // 0일 경우 업데이트
    			if(bsResultMas.get("SettleDate")!=null||bsResultMas.get("SettleDate")!=""){
    				bsResultMas.put("SettleDate", String.valueOf(bsResultMas.get("SettleDate")));
    			}else{
    				bsResultMas.put("SettleDate", "01/01/1900");
    			}
    			logger.debug(">>>>>>>>>>bsResultMas : {}", bsResultMas);
    			hsManualMapper.updatebsResultMas(bsResultMas); // UPDATE 1건 svc0006d
    		}

    		if(bsResultInst.get("instct")!=null){
    			hsManualMapper.updateInstRemark(bsResultInst); // UPDATE SAL0045D - TPY 20180629
    		}

    		hsManualMapper.updateQry_CurBSZero(qry_CurBS);// 최신거 업데이트

    		hsManualMapper.updateQrySchedule(bsResultMas);// 업데이트 00008d

    		Map<String, Object> qrySchedule = new HashMap<String, Object>();
    		qrySchedule = hsManualMapper.selectQrySchedule(bsResultMas);

     		//////////////////////물류호출/////////////////////
    		Map<String, Object> logPram2 =new HashMap<String, Object>();
            logPram2.put("ORD_ID",  String.valueOf(qrySchedule.get("no")));
            logPram2.put("RETYPE", "COMPLET");
            logPram2.put("P_TYPE", "OD05");
            logPram2.put("P_PRGNM", "HSCOM");
            logPram2.put("USERID", sessionVO.getUserId());

            logger.debug("HSCOM 물류 호출 PRAM ===>"+ logPram2.toString());
            servicesLogisticsPFCMapper.SP_LOGISTIC_REQUEST(logPram2);
            logger.debug("HSCOMCALL 물류 호출 결과 ===> {}" , logPram2);





    		hsManualMapper.updateQryConfig(bsResultMas);
    		Map<String, Object> qryConfig = new HashMap<String, Object>();
    		qryConfig = hsManualMapper.selectQryConfig(bsResultMas);

    		if(Integer.parseInt(bsResultMas.get("ResultStatusCodeID").toString())==4){
    			hsManualMapper.updateQryConfig4(bsResultMas);
    		}else{
    			hsManualMapper.updateQryConfig(bsResultMas);
    		}

    		if(bsResultDet.size()>0){
    			int ItemNo = 1;

    			for(int i = 0 ; i<bsResultDet.size() ; i++){
    				bsResultDet.get(i).put("BSResultID", BSResultM_resultID);

    				int LocationID = 0 ;

    				LocationID = hsManualMapper.selectLocationID(bsResultMas);

    				if(LocationID!=0){
    					Map<String, Object> stkCrd_new = new HashMap<String, Object>();
    					//stkCrd_new.put("SRCardID", 0); sequence
    					stkCrd_new.put("LocationID", String.valueOf(LocationID));
    					stkCrd_new.put("StockID", String.valueOf(bsResultDet.get(i).get("BSResultPartID")));
    					stkCrd_new.put("EntryDate","sysdate");
    					stkCrd_new.put("TypeID",String.valueOf(462));
    					stkCrd_new.put("RefNo",qrySchedule.get("no"));
    					stkCrd_new.put("SalesOrderId",String.valueOf(bsResultMas.get("SalesOrderId")));
    					stkCrd_new.put("ItemNo",String.valueOf(ItemNo));
    					stkCrd_new.put("SourceID",String.valueOf(477));
    					stkCrd_new.put("ProjectID",String.valueOf(0));
    					stkCrd_new.put("BatchNo",String.valueOf(0));
    					stkCrd_new.put("Qty",Integer.parseInt(bsResultDet.get(i).get("BSResultPartQty").toString())*-1);
    					stkCrd_new.put("CurrID",String.valueOf(479));
    					stkCrd_new.put("CurrRate",String.valueOf(1));
    					stkCrd_new.put("Cost",String.valueOf(0));
    					stkCrd_new.put("Price",String.valueOf(0));
    					stkCrd_new.put("Remark","");
    					stkCrd_new.put("SerialNo","");
    					stkCrd_new.put("InstallNo",bsResultMas.get("No"));
    					stkCrd_new.put("CostDate","1900-01-01");
    					stkCrd_new.put("AppTypeID",String.valueOf(0));
    					stkCrd_new.put("StkGrade","A");
    					stkCrd_new.put("InstallFail",String.valueOf(1));
    					stkCrd_new.put("IsSynch",String.valueOf(1));
    					stkCrd_new.put("EntryMethodID",String.valueOf(764));
    					stkCrd_new.put("Origin","1");

    					hsManualMapper.addStkCrd_new(stkCrd_new);
    				}
    				Map<String, Object> qryFilter_param = new HashMap<String, Object>();
    				//qryFilter_param.put("SrvConfigID", String.valueOf(qryConfig.get("SrvConfigID")));
    				qryFilter_param.put("SrvConfigID", String.valueOf(qryConfig.get("srvConfigId")));   //edit hgham  25-12 -2017
    				qryFilter_param.put("BSResultPartID", String.valueOf(bsResultDet.get(i).get("BSResultPartID")));
    				qryFilter_param.put("SettleDate", String.valueOf(bsResultMas.get("SettleDate")));
    				qryFilter_param.put("ResultCreator", String.valueOf(sessionVO.getUserId()));
    				hsManualMapper.updateQryFilter(qryFilter_param);

    				ItemNo = ItemNo + 1;
    			}
    		}else{
    		/*	Map<String, Object> bsResultDet_NoFilter = new HashMap<String, Object>();
    			bsResultDet_NoFilter.put("BSResultItemID", String.valueOf(0));
    			bsResultDet_NoFilter.put("BSResultID", BSResultM_resultID);
    			bsResultDet_NoFilter.put("BSResultPartID", String.valueOf(0));
    			bsResultDet_NoFilter.put("BSResultPartDesc", "");
    			bsResultDet_NoFilter.put("BSResultPartQty", String.valueOf(0));
    			bsResultDet_NoFilter.put("BSResultRemark", "0");
    			bsResultDet_NoFilter.put("BSResultCreateAt", "sysdate");
    			bsResultDet_NoFilter.put("BSResultCreateBy", String.valueOf(sessionVO.getUserId()));
    			bsResultDet_NoFilter.put("BSResultFilterClaim", 1);

    			hsManualMapper.addBsResultDet_NoFilter(bsResultDet_NoFilter); 이거때문에 */
    		}


		}
		return resultValue;
	}




	@Override
	public int  isHsAlreadyResult(Map<String, Object> params) {
		return hsManualMapper.isHsAlreadyResult(params);
	}

	@Override
	public int  saveValidation(Map<String, Object> params) {
		return hsManualMapper.saveValidation(params);
	}

	@Override
	public EgovMap selectHsOrderInMonth(Map<String, Object> params) {
		if(params.get("ManuaMyBSMonth") != null) {
			StringTokenizer str1 = new StringTokenizer(params.get("ManuaMyBSMonth").toString());

    		for(int i =0; i <= 1 ; i++) {
    			str1.hasMoreElements();
    			String result = str1.nextToken("/");            //특정문자로 자를시 사용

    			logger.debug("iiiii: {}", i);

    			if(i==0){
    				params.put("myBSMonth", result);
    				logger.debug("myBSMonth : {}", params.get("myBSMonth"));
    			}else{
    				params.put("myBSYear", result);
    				logger.debug("myBSYear : {}", params.get("myBSYear"));
    			}
    		}
		}
		return hsManualMapper.selectHsOrderInMonth(params);
	}

	@Override
	public List<EgovMap> hSMgtResultViewResultFilter(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.hSMgtResultViewResultFilter(params);
	}

	@Override
	public EgovMap hSMgtResultViewResult(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.hSMgtResultViewResult(params);
	}

	@Override
	public List<EgovMap> assignDeptMemUp(Map<String, Object> params) {
		return hsManualMapper.assignDeptMemUp(params);
	}

	@Override
	public List<EgovMap> selectCMList(Map<String, Object> params) {
		return hsManualMapper.selectCMList(params);
	}


	@Override
	public int  hsResultSync(Map<String, Object> params) {
		return hsManualMapper.hsResultSync(params);
	}



}
