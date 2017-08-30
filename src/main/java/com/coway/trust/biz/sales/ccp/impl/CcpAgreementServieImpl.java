package com.coway.trust.biz.sales.ccp.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.sales.ccp.CcpAgreementService;
import com.coway.trust.cmmn.model.EmailVO;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("ccpAgreementService")
public class CcpAgreementServieImpl extends EgovAbstractServiceImpl implements CcpAgreementService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpAgreementServieImpl.class);
	
	@Resource(name = "ccpAgreementMapper")
	private CcpAgreementMapper ccpAgreementMapper;
	
	@Autowired
	private AdaptorService adaptorService;
	
	@Override
	public List<EgovMap> selectContactAgreementList(Map<String, Object> params) throws Exception {
		
		if("" != params.get("salesOrdNo") && null != params.get("salesOrdNo")){
			
			List<String> tempList = null;
			
			tempList = ccpAgreementMapper.selectItemBatchNofromSalesOrdNo(params);
			
			if(tempList != null){
					
				params.put("exist", "1");
				params.put("getBatchNoList", tempList);
				
			}else{
				
				params.put("exist", "0");
			}
			
		}
		
		return ccpAgreementMapper.selectContactAgreementList(params);
	}

	
	@Override
	public EgovMap getOrderId(Map<String, Object> params) throws Exception {
		
		return ccpAgreementMapper.getOrderId(params);
	}

	@Override
	public List<EgovMap> selectAfterServiceJsonList(Map<String, Object> params) throws Exception {
		
		return ccpAgreementMapper.selectAfterServiceJsonList(params);
	}


	@Override
	public List<EgovMap> selectBeforeServiceJsonList(Map<String, Object> params) throws Exception {
		
		return ccpAgreementMapper.selectBeforeServiceJsonList(params);
	}


	@Override
	public List<EgovMap> selectSearchOrderNo(Map<String, Object> params) throws Exception {
		
		return ccpAgreementMapper.selectSearchOrderNo(params);
	}


	@Override
	public List<EgovMap> selectSearchMemberCode(Map<String, Object> params) throws Exception {
		
		return ccpAgreementMapper.selectSearchMemberCode(params);
	}


	@Override
	public EgovMap getMemCodeConfirm(Map<String, Object> params) throws Exception {
		
		return ccpAgreementMapper.getMemCodeConfirm(params);
	}


	@Override
	public List<EgovMap> selectCurierListJsonList() throws Exception {
		
		return ccpAgreementMapper.selectCurierListJsonList();
	}


	@Override
	public List<EgovMap> selectOrderJsonList(Map<String, Object> params) throws Exception {
		
		return ccpAgreementMapper.selectOrderJsonList(params);
	}

	@Override
	@Transactional
	public Map<String, Object> insertAgreement(Map<String, Object> params) throws Exception {
		
		//Gird
		List<Object> grid =  (List<Object>)params.get(AppConstants.AUIGRID_ADD); 
		//Form
	    Map<String, Object> formMap = (Map<String, Object>)params.get(AppConstants.AUIGRID_FORM);
		
		/*#####################  User Roll Id Setting ########################*/
		//TODO 추후 삭제
		params.put("userId", "52366"); // 추후 삭제
    	EgovMap userRollMap = ccpAgreementMapper.getUserInfo(params);
    	
    	int rollId;
    	if(userRollMap == null ){
    		rollId = 0;
    	}else{
    		rollId = (Integer)userRollMap.get("govAgRoleId");
    	}
    	formMap.put("rollId", rollId);
		
		/* ##################  Document Number Numbering Set Param #####################*/
		//put Code Id = 51
    	formMap.put("docNoId", SalesConstants.AGREEMENT_CODEID	);
    	String docNo = "";
    	docNo = ccpAgreementMapper.getDocNo(formMap); //docNo
    	
    	formMap.put("docNo", docNo);
		
		/* ################## insert 1 ##########################*/
		//Send Date
		formMap.put("sendDt", SalesConstants.DEFAULT_DATE2);
		//RECIVE DATE
		if(SalesConstants.AGREEMENT_TRUE.equals(formMap.get("consignment"))){
			formMap.put("rcivDt", formMap.get("consignmentReciveDt"));
		}else{
			formMap.put("rcivDt", SalesConstants.DEFAULT_DATE);
		}
		
		ccpAgreementMapper.insertGovAgreementInfo(formMap);
		LOGGER.info("######################################################");
		LOGGER.info("################### Insert 1 Complete ###################");
		LOGGER.info("######################################################");
		
		/* ##################   insert 2 ######################*/
		ccpAgreementMapper.insertGovAgreementMessLog(formMap);
		LOGGER.info("######################################################");
		LOGGER.info("################### Insert 2 Complete ###################");
		LOGGER.info("######################################################");
		
		
		if(SalesConstants.AGREEMENT_TRUE.equals(formMap.get("consignment"))){
			
			formMap.put("agCnsgnSendDt", SalesConstants.DEFAULT_DATE);
			if(SalesConstants.CONSIGNMENT_HAND.equals(formMap.get("inputCourier"))){  
				formMap.put("consignBtHand", '1'); 
			}else{
				formMap.put("consignBtHand", '0');
			}
			
			ccpAgreementMapper.insertConsignment(formMap);
			
			LOGGER.info("######################################################");
			LOGGER.info("################### Consignment Complete ###################");
			LOGGER.info("######################################################");
			
		}
		
		/*################# Grid Insert( Insert 3, 4, 5) , Update 1 #######################*/
		for (int idx = 0; idx < grid.size(); idx++) {
			
			Map<String, Object> insMap = (Map<String, Object>)grid.get(idx);
			
			//Param Setting
			insMap.put("inputPeriodStart", formMap.get("inputPeriodStart"));
			insMap.put("inputPeriodEnd", formMap.get("inputPeriodEnd"));
			insMap.put("docNoId",  SalesConstants.AGREEMENT_CODEID);
			insMap.put("agreementAgmRemark", formMap.get("agreementAgmRemark"));
			
			//SUB
			ccpAgreementMapper.insertGovAgreementSub(insMap);
			
			LOGGER.info("######################################################");
			LOGGER.info("################### NO.["+  idx +"]  Grid Insert Complete(AgreementSub) ###################");
			LOGGER.info("######################################################");
			
			//CALL ENTRY
			ccpAgreementMapper.insertCallEntry(insMap); //result ID
			
			LOGGER.info("######################################################");
			LOGGER.info("################### NO.["+  idx +"]  Grid Insert Complete(Call Entry) ###################");
			LOGGER.info("######################################################");
			
			//CALL RESULT
			
			ccpAgreementMapper.insertCallResult(insMap); //CallResultID;
			
			LOGGER.info("######################################################");
			LOGGER.info("################### NO.["+  idx +"]  Grid Insert Complete(Call Result) ###################");
			LOGGER.info("######################################################");
			
			//Update Result Id
			ccpAgreementMapper.updateResultId();
			
			LOGGER.info("######################################################");
			LOGGER.info("################### NO.["+  idx +"]  Update Complete(Call Result) ###################");
			LOGGER.info("######################################################");
			
		}
		LOGGER.info("######################################################");
		LOGGER.info("###################  Insert 3, 4, 5 Complete Update 1 Complete ###################");
		LOGGER.info("######################################################");
		
		
		/*################# UPDATE 2 #######################*/
		ccpAgreementMapper.updatePreUpdUserId();
		
		
		//Return
		String msgId = "";
		msgId = ccpAgreementMapper.getReturnMsgId();
		//docNo
		
		Map<String, Object> returnMap = new HashMap<String, Object>(); 
		
		returnMap.put("msgId", msgId);
		returnMap.put("docNo", docNo);
		
		return returnMap;
	}


	@Override
	public boolean sendSuccessEmail(Map<String, Object> params) throws Exception {
		
		EmailVO email = new EmailVO();
		List<String> toList = new ArrayList<String>();
		toList.add("nurul@coway.com.my");
		//toList.add("amira.crt@coway.com.my");
		//TODO 테스트
		toList.add("dandanhead1@naver.com");
		
		String subject = "Agreement No (" + params.get("docNo") + ") - Closed With Status Approved ";
		String content = "Please to inform you that Agreement No (" + params.get("docNo") + ") has been closed with status active by [" + params.get("fullName") + "] on " + getCurTime()  + ".<br />" +
                "Please check in web system for more details.<br /><br/>" +
                "Please do not reply this email.<br />" +
                "Thank you.";
		
		email.setTo(toList);
		email.setHtml(false);
		email.setSubject(subject);
		email.setText(content);
		
		boolean isSuccess = adaptorService.sendEmail(email, false);
		
		return isSuccess;
	}
	
	private String getCurTime(){
		
		long time = System.currentTimeMillis(); 

		SimpleDateFormat dayTime = new SimpleDateFormat("yyyy-mm-dd hh:mm:ss");

		String str = dayTime.format(new Date(time));

		return str;
	}
}
