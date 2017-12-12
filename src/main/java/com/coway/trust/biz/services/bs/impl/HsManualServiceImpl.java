package com.coway.trust.biz.services.bs.impl;

import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
	public Map<String, Object> addIHsResult(Map<String, Object> params, List<Object> docType, SessionVO sessionVO) throws ParseException {

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


	private Map<String, Object> SaveResult(boolean isfreepromo,Map<String, Object> params, List<Object> docType, SessionVO sessionVO) throws ParseException{

		int schdulId =  Integer.parseInt(params.get("hidschdulId").toString());
		String docNo= commonMapper.selectDocNo("11");
//		EgovMap selectHSResultMList = hsManualMapper.selectHSResultMList(params);
		int masterCnt = hsManualMapper.selectHSResultMCnt(params);
//		EgovMap selectDetailList = hsManualMapper.selectDetailList(params);
		int nextSeq  = hsManualMapper.getNextSvc006dSeq();
//		EgovMap selectHSDocNoList =   hsManualMapper.selectHSDocNoList(params); //현재 docNo
//		String resultNo = selectHSDocNoList.get("c2").toString()+selectHSDocNoList.get("c1").toString(); //현재 docNo

		EgovMap insertHsResultfinal = new EgovMap();



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

			//BSResultM
			insertHsResultfinal.put("resultId", nextSeq);

			insertHsResultfinal.put("docNo", docNo);
			insertHsResultfinal.put("typeId", 306);
			insertHsResultfinal.put("schdulId", schdulId);
			insertHsResultfinal.put("salesOrdId", params.get("hidSalesOrdId"));
			insertHsResultfinal.put("codyId", params.get("hidCodyId"));

			insertHsResultfinal.put("setlDt", params.get("settleDate"));
			insertHsResultfinal.put("resultStusCodeId", params.get("cmbStatusType"));
//			insertHsResultfinal.put("failResnId", params.get("failReason"));
			insertHsResultfinal.put("failResnId", 0);
			insertHsResultfinal.put("renColctId", params.get("cmbCollectType"));
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

			hsManualMapper.insertHsResultfinal(insertHsResultfinal);


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
  					hsManualMapper.insertHsResultD(docSub);

  					String filterLastserial =  hsManualMapper.select0087DFilter(docSub);

  		            if("".equals(filterLastserial)){
  		            	docSub.put("prvSerialNo", filterLastserial);
  		            }else {
  		            	docSub.put("lastSerialNo", docSub.get("SerialNo"));
  		            }

  	                docSub.put("settleDate", params.get("settleDate"));
  	                docSub.put("hidCodyId", params.get("hidCodyId"));
  	                params.put("srvConfigId", docSub.get("srvConfigId"));

  		            hsManualMapper.updateHsFilterSiriNo(docSub);
  				}



			}

			hsManualMapper.updateHs009d(params);

		}


		EgovMap getHsResultMList = hsManualMapper.selectHSResultMList(params);

		 //BSScheduleM
		int scheduleCnt = hsManualMapper.selectHSScheduleMCnt(params);

		if(scheduleCnt > 0 ) {

			EgovMap insertHsScheduleM = new EgovMap();


			insertHsScheduleM.put("hidschdulId", params.get("hidschdulId"));
			insertHsScheduleM.put("resultStusCodeId", getHsResultMList.get("resultStusCodeId"));
			insertHsScheduleM.put("actnMemId", getHsResultMList.get("codyId"));

            hsManualMapper.updateHsScheduleM(insertHsScheduleM);

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
		if(Integer.parseInt(params.get("cmbStatusType").toString()) == 4 ){

			/////////////////////////물류 호출//////////////////////
			logPram =new HashMap<String, Object>();
            logPram.put("ORD_ID",      params.get("hidSalesOrdCd")   );
            logPram.put("RETYPE", "COMPLET");
            logPram.put("P_TYPE", "OD05");
            logPram.put("P_PRGNM", "HSCOM");
            logPram.put("USERID", sessionVO.getUserId());

            logger.debug("HSCOM 물류 호출 PRAM ===>"+ logPram.toString());
            servicesLogisticsPFCMapper.install_Active_SP_LOGISTIC_REQUEST(logPram);
            logger.debug("ORDERCALL 물류 호출 결과 ===> {}" , logPram);
            /////////////////////////물류 호출 END //////////////////////

      }else if(Integer.parseInt(params.get("cmbStatusType").toString()) == 21){

    	  /////////////////////////물류 호출//////////////////////
    		logPram =new HashMap<String, Object>();
            logPram.put("ORD_ID",     params.get("hidSalesOrdCd"));
            logPram.put("RETYPE", "SVO");
            logPram.put("P_TYPE", "OD06");
            logPram.put("P_PRGNM", "HSCAN");
            logPram.put("USERID", sessionVO.getUserId());

            logger.debug("ORDERCALL 물류 호출 PRAM ===>"+ logPram.toString());
          servicesLogisticsPFCMapper.install_Active_SP_LOGISTIC_REQUEST(logPram);
            logger.debug("ORDERCALL 물류 호출 결과 ===>");
            /////////////////////////물류 호출 END //////////////////////
      }





		Map<String, Object> resultValue = new HashMap<String, Object>();
		resultValue.put("resultId",  params.get("hidSalesOrdCd"));
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
		return hsManualMapper.selectHsViewfilterInfo(params);
	}



	@Override
	public EgovMap selectSettleInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualMapper.selectSettleInfo(params);
	}



	@Override
	@Transactional
	public Map<String, Object> UpdateHsResult(Map<String, Object> params, List<Object> docType, SessionVO sessionVO) throws ParseException {

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
				hsManualMapper.updateAssignCody(updateMap) ;

				rtnValue += "Cody Transfer for HS Order ‘" + updateMap.get("no") +"'" + " from " + "'" + updateMap.get("oldCodyCd") +"'"+ " to " + "'" +updateMap.get("codyCd")  + "'"  + "\r\n";
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
		if(productID == "892"){
			if(filterCode == "303" || filterCode == "901"){
				filterPeriod = "6";
			}
		}
		
		Map<String, Object> send_sal0087D = new HashMap();
		
		if(configID != null && !"0".equals(configID)){
			EgovMap sal0087D = hsManualMapper.getSrvConfigFilter_SAL0087D(params);
			
			if( sal0087D != null){
				send_sal0087D.put("SRV_FILTER_PRIOD", filterPeriod);
				send_sal0087D.put("SRV_FILTER_PRV_CHG_DT", params.get("lastChangeDate"));
				send_sal0087D.put("SRV_FILTER_STUS_ID", 1);
				send_sal0087D.put("SRV_FILTER_UPD_USER_ID" , params.get("updator"));
				send_sal0087D.put("SRV_FILTER_REM", params.get("remark"));
				
                hsManualMapper.saveChanges(send_sal0087D);

			}else {
				send_sal0087D.put("SRV_FILTER_ID"          ,0);
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

				hsManualMapper.saveChanges(send_sal0087D);
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
	
	
	
}
