/**
 * 
 */
package com.coway.trust.web.commission.calculation;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.commission.calculation.CommissionCalculationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.commission.CommissionConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Controller
@RequestMapping(value = "/commission/calculation")
public class CommissionCalculationController {

	private static final Logger logger = LoggerFactory.getLogger(CommissionCalculationController.class);

	@Resource(name = "commissionCalculationService")
	private CommissionCalculationService commissionCalculationService;

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	/**
	 * Call run commission management
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/runCommissionMng.do")
	public String runCommissionMng(@RequestParam Map<String, Object> params, ModelMap model) {
		params.put("mstId",CommissionConstants.COMIS_PRO_CD_A);
		List<EgovMap> orgGrList = commissionCalculationService.selectCommPrdGroupListl(params);
		model.addAttribute("orgGrList", orgGrList);

		String dt = CommonUtils.getCalMonth(-1);
		dt = dt.substring(4,6) + "/" + dt.substring(0, 4);

		model.addAttribute("searchDt", dt);
		model.addAttribute("orgGrList", orgGrList);
		// 호출될 화면
		return "commission/commissionCalculationMng";
	}
	
	/**
	 * procedure Basic List Page call
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/runCommissionBasicProMng.do")
	public String runCommissionBasicProMng(@RequestParam Map<String, Object> params, ModelMap model) {
		String dt = CommonUtils.getNowDate().substring(0, 6);
		dt = (Integer.parseInt(dt.substring(4))-1) + "/" + dt.substring(0, 4);
		if(dt.length()<7){
			dt = "0"+dt;
		}

		model.addAttribute("searchDt", dt);
		// 호출될 화면
		return "commission/commissionCalculationBasicMng";
	}

	/**
	 * calculation List Select
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCalculationList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCalculationList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		List<EgovMap> itemList = null;
		
		if( (CommissionConstants.COMIS_ACTION_TYPE).equals(params.get("actionType").toString()) ){
			params.put("mstId", CommissionConstants.COMIS_PRO_CD_A);
			// 조회.
			params.put("searchDt", (params.get("searchDt").toString()).replace("/", ""));
			itemList = commissionCalculationService.selectCalculationList(params);
		}else{
			params.put("mstId", CommissionConstants.COMIS_PRO_CD_S);
			// 조회.
			params.put("searchDt", (params.get("searchDt").toString()).replace("/", ""));
			itemList = commissionCalculationService.selectCalculationList(params);
		}

		// 데이터 리턴.
		return ResponseEntity.ok(itemList);
	}
	
	/**
	 * Basic List Select
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectBasicCalculationList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBasicCalculationList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		params.put("mstId", CommissionConstants.COMIS_PRO_CD_A);
		// 조회.
		params.put("searchDt", (params.get("searchDt").toString()).replace("/", ""));
		List<EgovMap> itemList = commissionCalculationService.selectBasicList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(itemList);
	}
	/**
	 * Basic Procedure State Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectBasicStatus", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectBasicStatus(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		params.put("mstId", CommissionConstants.COMIS_PRO_CD_A);
		// 조회.
		params.put("searchDt", (params.get("searchDt").toString()).replace("/", ""));
		Map map = commissionCalculationService.selectBasicStatus(params);

		// 데이터 리턴.
		return ResponseEntity.ok(map);
	}
	
	private int taskIdCalculation(String prams){
		String dt = "";
		int sTaskID = 0;
		if(prams ==null || String.valueOf(prams).equals("")){
			dt = CommonUtils.getNowDate().substring(4,6)+"/"+CommonUtils.getNowDate().substring(0, 4);
		}else{
			dt = String.valueOf(prams);
		}
		
		int pvMonth = Integer.parseInt(dt.substring(0,2));
		int pvYear = Integer.parseInt(dt.substring(3));		
		
		sTaskID = (((pvMonth) + (pvYear) * 12) - 24157);
		
		return sTaskID;
	}
	
	@RequestMapping(value = "/runningPrdCheck", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> runningPrdCheck(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		ReturnMessage message = new ReturnMessage();
		
		params.put("stateId",CommissionConstants.COMIS_RUNNING);
		if(CommissionConstants.COMIS_ACTION_TYPE.equals( params.get("actionType")) ){
			params.put("mstId",CommissionConstants.COMIS_PRO_CD_A);
		}else if(CommissionConstants.COMIS_SIMUL_TYPE.equals( params.get("actionType")) ){
			params.put("mstId",CommissionConstants.COMIS_PRO_CD_S);
		}
		
		List<EgovMap> map = commissionCalculationService.runningPrdCheck(params);
		System.out.println(map);
		message.setData(map);
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/runPrdTimeValid", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> runPrdTimeValid(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		ReturnMessage message = new ReturnMessage();
		
		params.put("stateId",CommissionConstants.COMIS_RUNNING);
		if(CommissionConstants.COMIS_ACTION_TYPE.equals( params.get("actionType")) ){
			params.put("mstId",CommissionConstants.COMIS_PRO_CD_A);
		}else if(CommissionConstants.COMIS_SIMUL_TYPE.equals( params.get("actionType")) ){
			params.put("mstId",CommissionConstants.COMIS_PRO_CD_S);
		}
		
		List<EgovMap> map = commissionCalculationService.runPrdTimeValid(params);
		System.out.println(map);
		message.setData(map);
		
		return ResponseEntity.ok(message);
	}

	/**
	 * call Procedure Batch
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/callCommissionProcedureBatch", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> callCommissionProcedureBatch(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, HttpServletRequest request) {
		// public ResponseEntity<ReturnMessage> callCommissionProcedure(@RequestBody Map<String, ArrayList<Object>>
		// params, Model model) {
		EgovMap item = new EgovMap();
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if (sessionVO == null) {
			loginId = "1000000000";
		} else {
			loginId = String.valueOf(sessionVO.getUserId());
		}
		List<Object> gridList =  params.get(AppConstants.AUIGRID_ALL); // 그리드 데이터 가져오기
		List<Object> formList =  params.get(AppConstants.AUIGRID_FORM); // 폼 객체 데이터 가져오기
		
		Map<String, Object> formMap = new HashMap<String, Object>();
		
		if (formList.size() > 0) {
    		
    		formList.forEach(obj -> {
                Map<String, Object> map = (Map<String, Object>) obj;
                formMap.put((String)map.get("name"),map.get("value"));
    		});    		
    	}

		/*
		 * Date and taskId
		 */
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());	
		Calendar calendar = Calendar.getInstance();
		Date date = calendar.getTime();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd", Locale.getDefault(Locale.Category.FORMAT));

		
		if (gridList.size() > 0) {
			Map lMap = null; 		//log map
			Map pMap = null;		//prceduar map
			Map dMap = null;		//data Map
			Map<String, Object> prdBatchMap = null;
			Map<String, Object> prdMap = null;//procedual information map
			
			/*
			 * call Procedure Log Insert
			 */
			String taskId = String.valueOf(sTaskID);
			String searchDt = df.format(date);
			
			List<Object> prdList = new ArrayList();
			for (Object map : gridList) {
				lMap = (HashMap<String, Object>) map;
				lMap.put("searchDt",searchDt);
				lMap.put("taskId", taskId);
				lMap.put("loginId", loginId);
				prdBatchMap = new HashMap<String, Object>();
				
				prdBatchMap.put("state",CommissionConstants.COMIS_RUNNING); 
				prdBatchMap.put("procedureNm",lMap.get("codeName")); 
				prdBatchMap.put("cdds",lMap.get("cdds")); 
				prdBatchMap.put("calState",lMap.get("calState")); 
				prdBatchMap.put("calStartTime",lMap.get("calStartTime")); 
				prdBatchMap.put("codeId", lMap.get("codeId").toString()); 
				prdBatchMap.put("code",lMap.get("code")); 
				prdBatchMap.put("mstId", CommissionConstants.COMIS_PRO_CD_A);
				prdBatchMap.put("searchDt",lMap.get("searchDt"));
				prdBatchMap.put("taskId", String.valueOf(sTaskID));
				prdBatchMap.put("loginId", lMap.get("loginId"));
				prdBatchMap.put("calYM", (formMap.get("searchDt").toString()).replace("/", ""));
				prdBatchMap.put("actionType", formMap.get("actionType").toString());
				int cnt = commissionCalculationService.callCommPrdLogIns(prdBatchMap); 
			}
			
			/*
			 * call Procedure success / fail update
			 */
			
			int failCntTemp = 0;
			for (Object map : gridList) {
				pMap = (HashMap<String, Object>) map;
				prdMap = new HashMap<String, Object>();
				
				prdMap.put("searchDt",searchDt);
				prdMap.put("taskId", taskId);
				prdMap.put("loginId", loginId);
				prdMap.put("codeId", pMap.get("codeId"));
				
				List<EgovMap> logList = commissionCalculationService.selectCommRunningPrdLog(prdMap); //Running Data Select
				
				
				prdMap.put("calSeq", logList.get(0).get("calSeq"));
				prdMap.put("procedureNm", logList.get(0).get("calName"));
				prdMap.put("startDt", logList.get(0).get("calStartTime"));
				prdMap.put("codeId", logList.get(0).get("calCode"));
				String callDt = formMap.get("searchDt").toString();
				callDt = callDt.substring(3,7)+callDt.substring(0,2)+"01";
				prdMap.put("searchDt",callDt);
				
				if(failCntTemp >0){
					prdMap.put("state",CommissionConstants.COMIS_FAIL_NEXT); //8:FAIL
					failCntTemp = commissionCalculationService.callCommFailNextPrdLog(prdMap);
				}else{
					/*System.out.println(formMap.get("searchDt")+"###################################################"+prdMap.get("searchDt"));*/
					item = (EgovMap) commissionCalculationService.callCommProcedure(prdMap); // call proceduar
					
    				if (CommissionConstants.COMIS_SUCCESS.equals(prdMap.get("v_result"))) {
    					prdMap.put("state",CommissionConstants.COMIS_SUCCESS); //0:SUCCESS
    					commissionCalculationService.callCommPrdLogUpdate(prdMap);
    				} else {
    					prdMap.put("state",CommissionConstants.COMIS_FAIL); //9:FAIL
    					commissionCalculationService.callCommPrdLogUpdate(prdMap);
    					failCntTemp = Integer.parseInt(CommissionConstants.COMIS_FAIL);
    				}
				}
			}
		}
		

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
	
	/**
	 * call Procedure Row
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/callCommissionProcedure", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> callCommissionProcedure(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		// public ResponseEntity<ReturnMessage> callCommissionProcedure(@RequestBody Map<String, ArrayList<Object>>
		// params, Model model) {
		EgovMap item = new EgovMap();
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if (sessionVO == null) {
			loginId = "1000000000";
		} else {
			loginId = String.valueOf(sessionVO.getUserId());
		}
		params.put("mstId", CommissionConstants.COMIS_PRO_CD_A);
		
		/*
		 * Date and taskId
		 */
		Calendar calendar = Calendar.getInstance();	
		Date date = calendar.getTime();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd", Locale.getDefault(Locale.Category.FORMAT));
		
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());	
		String callDt = params.get("searchDt").toString();
		callDt = callDt.substring(3,7)+callDt.substring(0,2)+"01";
		
		params.put("calYM", (params.get("searchDt").toString()).replace("/", ""));
		params.put("searchDt",callDt);
		params.put("taskId", String.valueOf(sTaskID));
		params.put("loginId", loginId);
		params.put("state",CommissionConstants.COMIS_RUNNING); //1:Running
		params.put("actionType", params.get("actionType").toString());
		
		/*
		 * call Procedure List
		 */
		int cnt = commissionCalculationService.callCommPrdLogIns(params); 
		
		List<EgovMap> logList = commissionCalculationService.selectCommRunningPrdLog(params); //Running Data Select
		for(int i=0; i<logList.size();i++){
			params.put("calSeq", logList.get(i).get("calSeq"));
			params.put("calName", logList.get(i).get("calName"));
			params.put("startDt", logList.get(i).get("calStartTime"));
		}
		
		item = (EgovMap) commissionCalculationService.callCommProcedure(params);
		logger.debug("params : {}", params);
		logger.debug("v_result : {}", params.get("v_result"));
		logger.debug("v_sqlcode : {}", params.get("v_sqlcode"));
		logger.debug("v_sqlcont : {}", params.get("v_sqlcont"));
		
		if (params.get("v_result").equals(CommissionConstants.COMIS_SUCCESS)) {
			params.put("state",CommissionConstants.COMIS_SUCCESS); //0:SUCCESS
			commissionCalculationService.callCommPrdLogUpdate(params);
		} else {
			params.put("state",CommissionConstants.COMIS_FAIL); //9:FAIL
			commissionCalculationService.callCommPrdLogUpdate(params);
		}
		

		// 결과 만들기.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
	
	
	
	/**
	 * procedure Calculation Log Pop
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/calCommLogPop.do")
	public String calCommLogPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("codeId", params.get("codeId"));
		// 호출될 화면
		return "commission/commissionCalculationLogPop";
	}
	/**
	 * procedure Basic Log Pop
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/calBasicLogPop.do")
	public String calBasicLogPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("calName", CommissionConstants.COMIS_BSG_P01);
		// 호출될 화면
		return "commission/commissionCalculationLogPop";
	}
	
	
	/**
	 * procedure Log Select
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectCommLog")
	public ResponseEntity<List<EgovMap>> selectCommLog(@RequestParam Map<String, Object> params, ModelMap model) {
		List<EgovMap> logList = commissionCalculationService.selectLogList(params);
		model.addAttribute("logList", logList);
		// 호출될 화면
		return ResponseEntity.ok(logList);
	}
	
	
	
	/*********************************************************************************************
	 * calculation Data Pop
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 **********************************************************************************************/
	@RequestMapping(value = "/calCommDataPop.do")
	public String calCalculationDataPop(@RequestParam Map<String, Object> params, ModelMap model) {
		params.put("mstId", CommissionConstants.COMIS_EMP_CD);
		List<EgovMap> orgGrList = commissionCalculationService.selectOrgGrList(params);
		model.addAttribute("orgGrList", orgGrList);
				
		
		model.addAttribute("codeId", params.get("codeId"));
		model.addAttribute("prdNm", params.get("prdNm"));
		model.addAttribute("prdDec", params.get("prdDec"));
		model.addAttribute("code", params.get("code"));
		model.addAttribute("searchDt_pop", params.get("searchDt"));
		model.addAttribute("actionType", params.get("actionType"));
		
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);	
		
		model.addAttribute("today", today);
		
		String popName= "";
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P01)){
			popName = "calculationData7001CTL_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTM_P01)) {
			popName = "calculationData7001CTM_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTR_P01)){
			popName = "calculationData7001CTW_Pop";
		}
		else if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P01)) {
			popName = "calculationData7001CDC_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CDG_P01)) {
			popName = "calculationData7001CDG_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CDM_P01)) {
			popName = "calculationData7001CDM_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CDN_P01)) {
			popName = "calculationData7001CDN_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CDS_P01)){
			popName = "calculationData7001CDS_Pop";
		}
		else if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P01)){
			popName = "calculationData7001HPF_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPG_P01)){
			popName = "calculationData7001HPG_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPM_P01)){
			popName = "calculationData7001HPM_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPS_P01)){
			popName = "calculationData7001HPS_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPT_P01)){
			popName = "calculationData7001HPT_Pop";
		}
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P02)){
			popName = "calculationData7002CTL_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTM_P02)) {
			popName = "calculationData7002CTM_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTR_P02)){
			popName = "calculationData7002CTW_Pop";
		}
		else if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P02)){
			popName = "calculationData7002CDC_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CDG_P02)){
			popName = "calculationData7002CDG_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CDM_P02)){
			popName = "calculationData7002CDM_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CDN_P02)){
			popName = "calculationData7002CDN_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CDS_P02)){
			popName = "calculationData7002CDS_Pop";
		}
		else if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P02)){
			popName = "calculationData7002HPF_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPG_P02)){
			popName = "calculationData7002HPG_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPM_P02)){
			popName = "calculationData7002HPM_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPS_P02)){
			popName = "calculationData7002HPS_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPT_P02)){
			popName = "calculationData7002HPT_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPB_P02)){
			popName = "calculationData7002HPB_Pop";
		}
		
		if((params.get("code")).equals(CommissionConstants.COMIS_HPB_P01)){
			popName = "calculationData0016T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTB_P01)){
			popName = "calculationData0018T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTB_P02)){
			popName = "calculationData0019T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTB_P03)){
			popName = "calculationData0020T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTB_P04)){
			popName = "calculationData0021T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CTB_P05)){
			popName = "calculationData0024T_Pop";
		}
		
		// 호출될 화면
		if(popName != null && !"".equals(popName)){
			return "commission/"+popName;
		}else{
			return null;
		}
	}
	
	
	/**
	 * Search CT Data 7001
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectData7001CT")
	public ResponseEntity<List<EgovMap>> selectData7001CT(@RequestParam Map<String, Object> params, ModelMap model) {
		
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());	
		
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_CT);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CTR_P01))
			params.put("emplyLev", CommissionConstants.COMIS_CT_CT_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P01))
			params.put("emplyLev", CommissionConstants.COMIS_CT_CTL_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_CT_CTM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7001(params);
		
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/cntData7001CT")
	public ResponseEntity<Integer> cntData7001CT(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_CT);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTR_P01))
			params.put("emplyLev", CommissionConstants.COMIS_CT_CT_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P01))
			params.put("emplyLev", CommissionConstants.COMIS_CT_CTL_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_CT_CTM_LEV);
		
		int cnt = commissionCalculationService.cntCMM0028D(params);
		return ResponseEntity.ok(cnt);
	}
	/**
	 * Search CT Data 7002
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectData7002CT")
	public ResponseEntity<List<EgovMap>> selectData7002CT(@RequestParam Map<String, Object> params, ModelMap model) {
		
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_CT);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CTR_P02))
			params.put("emplyLev", CommissionConstants.COMIS_CT_CT_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P02))
			params.put("emplyLev", CommissionConstants.COMIS_CT_CTL_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_CT_CTM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7002(params);
		
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/cntData7002CT")
	public ResponseEntity<Integer> cntData7002CT(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_CT);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CTR_P02))
			params.put("emplyLev", CommissionConstants.COMIS_CT_CT_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P02))
			params.put("emplyLev", CommissionConstants.COMIS_CT_CTL_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_CT_CTM_LEV);
		
		int cnt = commissionCalculationService.cntCMM0029D(params);
		return ResponseEntity.ok(cnt);
	}
	
	/**
	 * Search CD Data 7001
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectData7001CD")
	public ResponseEntity<List<EgovMap>> selectData7001CD(@RequestParam Map<String, Object> params, ModelMap model) {
		
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		
		params.put("taskId", String.valueOf(sTaskID));
		params.put("isExclude", 0);
		params.put("codeGruop", CommissionConstants.COMIS_CD);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P01) ){
			params.put("emplyLev", CommissionConstants.COMIS_CD_CD_LEV);
			params.put("bizType", CommissionConstants.COMIS_CD_CDC_BIZTYPE);
		}
		if( (params.get("code")).equals(CommissionConstants.COMIS_CDN_P01)){
			params.put("emplyLev", CommissionConstants.COMIS_CD_CD_LEV);
			params.put("bizType", CommissionConstants.COMIS_CD_CDN_BIZTYPE);
		}
		if((params.get("code")).equals(CommissionConstants.COMIS_CDM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_CD_CM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDS_P01))
			params.put("emplyLev", CommissionConstants.COMIS_CD_SCM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7001(params);
		
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/cntData7001CD")
	public ResponseEntity<Integer> cntData7001CD(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_CD);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P01) ){
			params.put("emplyLev", CommissionConstants.COMIS_CD_CD_LEV);
			params.put("bizType", CommissionConstants.COMIS_CD_CDC_BIZTYPE);
		}
		if( (params.get("code")).equals(CommissionConstants.COMIS_CDN_P01)){
			params.put("emplyLev", CommissionConstants.COMIS_CD_CD_LEV);
			params.put("bizType", CommissionConstants.COMIS_CD_CDN_BIZTYPE);
		}
		if((params.get("code")).equals(CommissionConstants.COMIS_CDM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_CD_CM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDS_P01))
			params.put("emplyLev", CommissionConstants.COMIS_CD_SCM_LEV);
		
		int cnt = commissionCalculationService.cntCMM0028D(params);
		return ResponseEntity.ok(cnt);
	}
	/**
	 * Search CD Data 7002
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectData7002CD")
	public ResponseEntity<List<EgovMap>> selectData7002CD(@RequestParam Map<String, Object> params, ModelMap model) {
		
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		
		params.put("taskId", String.valueOf(sTaskID));
		params.put("isExclude", 0);
		params.put("codeGruop", CommissionConstants.COMIS_CD);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P02) ){
			params.put("emplyLev", CommissionConstants.COMIS_CD_CD_LEV);
			params.put("bizType", CommissionConstants.COMIS_CD_CDC_BIZTYPE);
		}
		if( (params.get("code")).equals(CommissionConstants.COMIS_CDN_P02)){
			params.put("emplyLev", CommissionConstants.COMIS_CD_CD_LEV);
			params.put("bizType", CommissionConstants.COMIS_CD_CDN_BIZTYPE);
		}
		if((params.get("code")).equals(CommissionConstants.COMIS_CDM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_CD_CM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDS_P02))
			params.put("emplyLev", CommissionConstants.COMIS_CD_SCM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7002(params);
		
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/cntData7002CD")
	public ResponseEntity<Integer> cntData7002CD(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_CD);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P02) ){
			params.put("emplyLev", CommissionConstants.COMIS_CD_CD_LEV);
			params.put("bizType", CommissionConstants.COMIS_CD_CDC_BIZTYPE);
		}
		if( (params.get("code")).equals(CommissionConstants.COMIS_CDN_P02)){
			params.put("emplyLev", CommissionConstants.COMIS_CD_CD_LEV);
			params.put("bizType", CommissionConstants.COMIS_CD_CDN_BIZTYPE);
		}
		if((params.get("code")).equals(CommissionConstants.COMIS_CDM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_CD_CM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDS_P02))
			params.put("emplyLev", CommissionConstants.COMIS_CD_SCM_LEV);
		
		int cnt = commissionCalculationService.cntCMM0029D(params);
		return ResponseEntity.ok(cnt);
	}
	/**
	 * Search HP Data 7001
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectData7001HP")
	public ResponseEntity<List<EgovMap>> selectData7001HP(@RequestParam Map<String, Object> params, ModelMap model) {
		
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());	
		
		params.put("taskId", String.valueOf(sTaskID));
		params.put("isExclude", 0);
		params.put("codeGruop", CommissionConstants.COMIS_HP);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P01))
			params.put("emplyLev", CommissionConstants.COMIS_HP_HP_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPG_P01))
			params.put("emplyLev", CommissionConstants.COMIS_HP_GM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_HP_HM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPS_P01))
			params.put("emplyLev", CommissionConstants.COMIS_HP_SM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPT_P01))
			params.put("emplyLev", CommissionConstants.COMIS_HP_SGM_LEV);
		
		
		List<EgovMap> dataList = commissionCalculationService.selectData7001(params);
		
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/cntData7001HP")
	public ResponseEntity<Integer> cntData7001HP(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_HP);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P01))
			params.put("emplyLev", CommissionConstants.COMIS_HP_HP_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPG_P01))
			params.put("emplyLev", CommissionConstants.COMIS_HP_GM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_HP_HM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPS_P01))
			params.put("emplyLev", CommissionConstants.COMIS_HP_SM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPT_P01))
			params.put("emplyLev", CommissionConstants.COMIS_HP_SGM_LEV);
		
		int cnt = commissionCalculationService.cntCMM0028D(params);
		return ResponseEntity.ok(cnt);
	}
	/**
	 * Search HP Data 7002
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectData7002HP")
	public ResponseEntity<List<EgovMap>> selectData7002HP(@RequestParam Map<String, Object> params, ModelMap model) {
		
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());		
		
		params.put("taskId", String.valueOf(sTaskID));
		params.put("isExclude", 0);
		params.put("codeGruop", CommissionConstants.COMIS_HP);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P02))
			params.put("emplyLev", CommissionConstants.COMIS_HP_HP_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPG_P02))
			params.put("emplyLev", CommissionConstants.COMIS_HP_GM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_HP_HM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPS_P02))
			params.put("emplyLev", CommissionConstants.COMIS_HP_SM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPT_P02))
			params.put("emplyLev", CommissionConstants.COMIS_HP_SGM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPB_P02))
			params.put("emplyLev", CommissionConstants.COMIS_HP_HP_LEV);
		
		
		List<EgovMap> dataList = commissionCalculationService.selectData7002(params);
		
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/cntData7002HP")
	public ResponseEntity<Integer> cntData7002HP(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_HP);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P02))
			params.put("emplyLev", CommissionConstants.COMIS_HP_HP_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPG_P02))
			params.put("emplyLev", CommissionConstants.COMIS_HP_GM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_HP_HM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPS_P02))
			params.put("emplyLev", CommissionConstants.COMIS_HP_SM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPT_P02))
			params.put("emplyLev", CommissionConstants.COMIS_HP_SGM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPB_P02))
			params.put("emplyLev", CommissionConstants.COMIS_HP_HP_LEV);
		
		int cnt = commissionCalculationService.cntCMM0029D(params);
		return ResponseEntity.ok(cnt);
	}
	
	
	/*********************************************************************************************
	 * Basic Data Pop
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 **********************************************************************************************/
	@RequestMapping(value = "/calBasicDataPop.do")
	public String calBasicDataPop(@RequestParam Map<String, Object> params, ModelMap model) {
		params.put("mstId", CommissionConstants.COMIS_EMP_CD);
		List<EgovMap> orgGrList = commissionCalculationService.selectOrgGrList(params);
		model.addAttribute("orgGrList", orgGrList);
		
		String code = params.get("codeId").toString();
		params.put("code", code);
		model.addAttribute("code", params.get("code"));
		model.addAttribute("prdNm", params.get("prdNm"));
		model.addAttribute("prdDec", params.get("prdDec"));
		model.addAttribute("searchDt_pop", params.get("searchDt"));
		
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);	
		
		model.addAttribute("today", today);
		
		String popName= "";
		if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P01)){
			popName = "calculationData0006T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P02)){
			popName = "calculationData0007T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P03)){
			popName = "calculationData0008T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P04)){
			popName = "calculationData0009T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P05)){
			popName = "calculationData0010T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P06)){
			popName = "calculationData0011T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P07)){
			popName = "calculationData0012T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P08)){
			popName = "calculationData0013T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P09)){
			popName = "calculationData0014T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P010)){
			popName = "calculationData0015T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P011)){
			popName = "calculationData0017T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P012)){
			popName = "calculationData0022T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P013)){
			popName = "calculationData0023T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P014)){
			popName = "calculationData0025T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P015)){
			popName = "calculationData0026T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P016)){
			popName = "calculationData0060T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P017)){
			popName = "calculationData0067T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P018)){
			popName = "calculationData0068T_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_BSD_P019)){
			popName = "calculationData0069T_Pop";
		}else{
			return null;
		}
		// 호출될 화면
		return "commission/"+popName;
	}
	
	
	@RequestMapping(value = "/cntCMM0006T")
	public ResponseEntity<Integer> cntCMM0006T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0006T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0007T")
	public ResponseEntity<Integer> cntCMM0007T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0007T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0008T")
	public ResponseEntity<Integer> cntCMM0008T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0008T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0009T")
	public ResponseEntity<Integer> cntCMM0009T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0009T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0010T")
	public ResponseEntity<Integer> cntCMM0010T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0010T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0011T")
	public ResponseEntity<Integer> cntCMM0011T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0011T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0012T")
	public ResponseEntity<Integer> cntCMM0012T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0012T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0013T")
	public ResponseEntity<Integer> cntCMM0013T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0013T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0014T")
	public ResponseEntity<Integer> cntCMM0014T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0014T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0015T")
	public ResponseEntity<Integer> cntCMM0015T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0015T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0016T")
	public ResponseEntity<Integer> cntCMM0016T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0016T(params);
		return ResponseEntity.ok(cnt);
	}
	@RequestMapping(value = "/cntCMM0017T")
	public ResponseEntity<Integer> cntCMM0017T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0017T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0018T")
	public ResponseEntity<Integer> cntCMM0018T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0018T(params);
		return ResponseEntity.ok(cnt);
	}
	@RequestMapping(value = "/cntCMM0019T")
	public ResponseEntity<Integer> cntCMM0019T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0019T(params);
		return ResponseEntity.ok(cnt);
	}
	@RequestMapping(value = "/cntCMM0020T")
	public ResponseEntity<Integer> cntCMM0020T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0020T(params);
		return ResponseEntity.ok(cnt);
	}
	@RequestMapping(value = "/cntCMM0021T")
	public ResponseEntity<Integer> cntCMM0021T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0021T(params);
		return ResponseEntity.ok(cnt);
	}
	@RequestMapping(value = "/cntCMM0022T")
	public ResponseEntity<Integer> cntCMM0022T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0022T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0023T")
	public ResponseEntity<Integer> cntCMM0023T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0023T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0024T")
	public ResponseEntity<Integer> cntCMM0024T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0024T(params);
		return ResponseEntity.ok(cnt);
	}
	@RequestMapping(value = "/cntCMM0025T")
	public ResponseEntity<Integer> cntCMM0025T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0025T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0026T")
	public ResponseEntity<Integer> cntCMM0026T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0026T(params);
		return ResponseEntity.ok(cnt);
	}	
	
	@RequestMapping(value = "/cntCMM0060T")
	public ResponseEntity<Integer> cntCMM0060T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0060T(params);
		return ResponseEntity.ok(cnt);
	}	
	
	@RequestMapping(value = "/cntCMM0067T")
	public ResponseEntity<Integer> cntCMM0067T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0067T(params);
		return ResponseEntity.ok(cnt);
	}	
	
	@RequestMapping(value = "/cntCMM0068T")
	public ResponseEntity<Integer> cntCMM0068T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0068T(params);
		return ResponseEntity.ok(cnt);
	}	
	
	@RequestMapping(value = "/cntCMM0069T")
	public ResponseEntity<Integer> cntCMM0069T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		int cnt = commissionCalculationService.cntCMM0069T(params);
		return ResponseEntity.ok(cnt);
	}	
	
	
	
	@RequestMapping(value = "/selectDataCMM006T")
	public ResponseEntity<List<EgovMap>> selectDataCMM006T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0006T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM007T")
	public ResponseEntity<List<EgovMap>> selectDataCMM007T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0007T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM008T")
	public ResponseEntity<List<EgovMap>> selectDataCMM008T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0008T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM009T")
	public ResponseEntity<List<EgovMap>> selectDataCMM009T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0009T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM010T")
	public ResponseEntity<List<EgovMap>> selectDataCMM010T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0010T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM011T")
	public ResponseEntity<List<EgovMap>> selectDataCMM011T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0011T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM012T")
	public ResponseEntity<List<EgovMap>> selectDataCMM012T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0012T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM013T")
	public ResponseEntity<List<EgovMap>> selectDataCMM013T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0013T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM014T")
	public ResponseEntity<List<EgovMap>> selectDataCMM014T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0014T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM015T")
	public ResponseEntity<List<EgovMap>> selectDataCMM015T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0015T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM016T")
	public ResponseEntity<List<EgovMap>> selectDataCMM016T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0016T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM017T")
	public ResponseEntity<List<EgovMap>> selectDataCMM017T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0017T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM018T")
	public ResponseEntity<List<EgovMap>> selectDataCMM018T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0018T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM019T")
	public ResponseEntity<List<EgovMap>> selectDataCMM019T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0019T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM020T")
	public ResponseEntity<List<EgovMap>> selectDataCMM020T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0020T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM021T")
	public ResponseEntity<List<EgovMap>> selectDataCMM021T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0021T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM022T")
	public ResponseEntity<List<EgovMap>> selectDataCMM022T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0022T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM023T")
	public ResponseEntity<List<EgovMap>> selectDataCMM023T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0023T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM024T")
	public ResponseEntity<List<EgovMap>> selectDataCMM024T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0024T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM025T")
	public ResponseEntity<List<EgovMap>> selectDataCMM025T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0025T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM026T")
	public ResponseEntity<List<EgovMap>> selectDataCMM026T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0026T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM060T")
	public ResponseEntity<List<EgovMap>> selectDataCMM060T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0060T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM067T")
	public ResponseEntity<List<EgovMap>> selectDataCMM067T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0067T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM068T")
	public ResponseEntity<List<EgovMap>> selectDataCMM068T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0068T(params);
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/selectDataCMM069T")
	public ResponseEntity<List<EgovMap>> selectDataCMM069T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		List<EgovMap> dataList = commissionCalculationService.selectCMM0069T(params);
		return ResponseEntity.ok(dataList);
	}
	
	/**
	 * Use Map and Edit Grid Insert,Update,Delete
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updatePrdData_06T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_06T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0006T(cMap);
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_07T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_07T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0007T(cMap);
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_08T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_08T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0008T(cMap);
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_09T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_09T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0009T(cMap);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_10T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_10T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0010T(cMap);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_11T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_11T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0011T(cMap);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_12T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_12T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0012T(cMap);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_13T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_13T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0013T(cMap);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_14T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_14T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0014T(cMap);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_15T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_15T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0015T(cMap);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_17T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_17T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0017T(cMap);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_18T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_18T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0018T(cMap);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_19T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_19T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0019T(cMap);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_20T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_20T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0020T(cMap);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_21T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_21T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0021T(cMap);
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_22T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_22T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0022T(cMap);
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_23T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_23T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0023T(cMap);
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_26T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_25T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0026T(cMap);
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_60T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_60T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0060T(cMap);
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_67T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_67T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0067T(cMap);
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_68T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_68T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0068T(cMap);
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_69T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_69T(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map cMap = null;
		
		for (Object map : checkList) {
			cMap = (HashMap<String, Object>) map;
			commissionCalculationService.udtDataCMM0069T(cMap);
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	
	
	@RequestMapping(value = "/commAdjustment.do")
	public String commAdjustment(@RequestParam Map<String, Object> params, ModelMap model) {
		params.put("mstId",CommissionConstants.COMIS_ADJUST_CD);
		List<EgovMap> adjustList = commissionCalculationService.adjustmentCodeList(params);
		model.addAttribute("adjustList", adjustList);
		
		// 호출될 화면
		return "commission/commissionAdjustment";
	}
	
	@RequestMapping(value = "/memberInfoSearch")
	public ResponseEntity<Map> memberExistence(@RequestParam Map<String, Object> params, ModelMap model) {
		Map<String, Object> memInfo = commissionCalculationService.memberInfoSearch(params);
		return ResponseEntity.ok(memInfo);
	}
	
	@RequestMapping(value = "/saveAdjustment")
	public ResponseEntity<ReturnMessage> saveAdjustment(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if (sessionVO == null) {
			loginId = "1000000000";
		} else {
			loginId = String.valueOf(sessionVO.getUserId());
		}
		params.put("loginId", loginId);
		
		String ordId ="0";
		try{
			Map<String, Object> ordNoInfo = commissionCalculationService.ordNoInfoSearch(params);
			 ordId = ordNoInfo.get("ORDID") != null?ordNoInfo.get("ORDID").toString():"0";
		}catch(Exception e){
			 ordId = "0";
		}
		
		params.put("ordId",ordId);
		
		int sTaskID = 0;
		String dt = CommonUtils.getNowDate().substring(4,6)+"/"+CommonUtils.getNowDate().substring(0, 4);
		
		int pvMonth = Integer.parseInt(dt.substring(0,2))-1;
		int pvYear = Integer.parseInt(dt.substring(3));
		
		sTaskID = (((pvMonth) + (pvYear) * 12) - 24157);
		
		params.put("aMonth",pvMonth);
		params.put("aYear",pvYear);
		params.put("taskId",sTaskID);
		
		//params : {memId=8393, adjustmentType=900, memCode=508023, ordNo=0410694, adjustmentAmt=, adjustmentDesc=, ordId=64244, aMonth=8, aYear=2017, taskId=55}
		
		try{
			commissionCalculationService.adjustmentInsert(params);
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}catch(Exception e){
			message.setMessage("Error Insert!");
		}
		

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/commNeoUpload.do")
	public String commNeoUpload(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "commission/commissionNeoProUpload";
	}
	
	/**
	 * EnrollResultNew업로드
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/neoUploadFile", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> neoUploadFile(
			@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {
		String message = "";
		
		// 결과 만들기.
    	ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);
		
		commissionCalculationService.neoProInsert(params,sessionVO);
		message = AppConstants.MSG_SUCCESS;
		
		msg.setMessage(message);
        return ResponseEntity.ok(msg);
	}
	
	@RequestMapping(value = "/commCTUpload.do")
	public String commCTUpload(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "commission/commissionCTUpload";
	}
	
	/**
	 * EnrollResultNew업로드
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/ctUploadFile", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> ctUploadFile(
			@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {
		String message = "";
		
		// 결과 만들기.
    	ReturnMessage msg = new ReturnMessage();
    	msg.setCode(AppConstants.SUCCESS);
		
		commissionCalculationService.ctUploadInsert(params, sessionVO);
    	message = AppConstants.MSG_SUCCESS;
    	
		msg.setMessage(message);
        return ResponseEntity.ok(msg);
	}
	
	/**
	 * Incentive Target Upload Pop
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/commIncentiveTargetUpload.do")
	public String commInsentiveUpload(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "commission/commissionIncentiveTargetUpload";
	}
	
	/**
	 * search Member Type List
	 * @param params
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/searchMemTypeList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> searchMemTypeList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		List memType = commissionCalculationService.incentiveType(params);
		return ResponseEntity.ok(memType);
	}
	/**
	 * search status id list
	 * @param params
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/searchStatusList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> searchStatusList(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		params.put("statusId",CommissionConstants.COMIS_STATUS_ID);
		List statusList = commissionCalculationService.incentiveStatus(params);
		return ResponseEntity.ok(statusList);
	}
	
	/**
	 * select incentive target list 
	 * @param params
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/selectIncentiveTargetList", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectIncentiveTargetList(@RequestBody Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		
		List<Object> type = (List<Object>) params.get("typeList");
		List<Object> memberType = (List<Object>) params.get("memberTypeList");
		List<Object> status = (List<Object>) params.get("statusList");
		
		//TODO 조건 변경하기.
		if(type !=null){
			String typeTemp ="";
			for(int i = 0; i < type.size() ; i++){
				typeTemp+=type.get(i)+",";
			}
			params.put("typeList", typeTemp.substring(0,typeTemp.length()-1));
		}
		if(memberType !=null){
			String memberTypeTemp ="";
			for(int i = 0; i < memberType.size() ; i++){
				memberTypeTemp+=memberType.get(i)+",";
			}
			params.put("memberTypeList", memberTypeTemp.substring(0,memberTypeTemp.length()-1));
		}
		if(status !=null){
			String statusTemp ="";
			for(int i = 0; i < status.size() ; i++){
				statusTemp+=status.get(i)+",";
			}
			params.put("statusList", statusTemp.substring(0,statusTemp.length()-1));
		}
		// 조회.
		List<EgovMap> itemList = commissionCalculationService.incentiveTargetList(params);

		// 데이터 리턴.
		return ResponseEntity.ok(itemList);
	}
	
	/**
	 * incentive target upload new pop
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/incntivUploadNewPop.do")
	public String commIncentiveUploadNewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		List memType = commissionCalculationService.incentiveType(params);
		model.addAttribute("memType", memType);
		// 호출될 화면
		return "commission/commissionIncentiveTargetUploadNewPop";
	}
	
	/**
	 * Incentive Upload Sample Pop 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/incntivUploadSamplePop.do")
	public String commIncentiveUploadSample(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "commission/commissionIncentiveUploadSamplePop";
	}
	
	/**
	 * Sample HP List
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/incntivSampleHpList")
	public ResponseEntity<List<EgovMap>> incntivSampleHpList(@RequestParam Map<String, Object> params, ModelMap model) {
		params.put("mstId",CommissionConstants.COMIS_SAMPLE_HP);
		List sampleList = commissionCalculationService.incentiveSample(params);
		// 호출될 화면
		return ResponseEntity.ok(sampleList);
	}
	/**
	 * Sample CD List
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/incntivSampleCdList")
	public ResponseEntity<List<EgovMap>> incntivSampleCdList(@RequestParam Map<String, Object> params, ModelMap model) {
		params.put("mstId",CommissionConstants.COMIS_SAMPLE_CD);
		List sampleList = commissionCalculationService.incentiveSample(params);
		// 호출될 화면
		return ResponseEntity.ok(sampleList);
	}
	
	/**
	 * Csv File Overlap Count Search
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/csvFileOverlapCnt")
	public ResponseEntity<Integer> csvFileOverlapCnt(@RequestParam Map<String, Object> params, ModelMap model) {
		params.put("statusId", CommissionConstants.COMIS_INCENTIVE_ACTIVE);
		int cnt = commissionCalculationService.cntUploadBatch(params);
		return ResponseEntity.ok(cnt);
	}	
	
	/**
	 * incentive Confirm pop
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/commIncntiveConfirmPop.do")
	public String commIncentiveConfirm(@RequestParam Map<String, Object> params, ModelMap model) {
		Map detail = commissionCalculationService.incentiveMasterDetail(Integer.parseInt(params.get("uploadId").toString()));
		model.addAttribute("detail", detail);
		
		Map map = new HashMap<>();
		map.put("uploadId", params.get("uploadId"));
		
		int totalCnt = commissionCalculationService.incentiveItemCnt(map);
		model.addAttribute("totalCnt", totalCnt);
		
		map.put("vStusId", CommissionConstants.COMIS_INCENTIVE_VALID);
		int totalValid = commissionCalculationService.incentiveItemCnt(map);
		model.addAttribute("totalValid", totalValid);
		
		map.put("vStusId", CommissionConstants.COMIS_INCENTIVE_INVALID);
		int totalInvalid = commissionCalculationService.incentiveItemCnt(map);
		model.addAttribute("totalInvalid", totalInvalid);
		
		model.addAttribute("uploadId", params.get("uploadId"));
		model.addAttribute("typeId", params.get("typeId"));
		
		// 호출될 화면
		return "commission/commissionIncentiveConfirmPop";
	}
	
	/**
	 * incentive valid / invalid list search
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/incentiveItemList")
	public ResponseEntity<List<EgovMap>> incentiveItemList(@RequestParam Map<String, Object> params, ModelMap model) {
		List itemList = commissionCalculationService.incentiveItemList(params);
		
		// 호출될 화면
		return ResponseEntity.ok(itemList);
	}
	
	/**
	 * remove incentive item update
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/removeIncentiveItem.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> removeIncentiveItem(@RequestBody Map<String, ArrayList<Object>> params, Model model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if (sessionVO == null) {
			loginId = "1000000000";
		} else {
			loginId = String.valueOf(sessionVO.getUserId());
		}
		
		List<Object> checkList =  params.get(AppConstants.AUIGRID_UPDATE);
		Map iMap = null;
		
		for (Object map : checkList) {
			iMap = (HashMap<String, Object>) map;
			iMap.put("statusId", CommissionConstants.COMIS_INCENTIVE_REMOVE);
			iMap.put("loginId", loginId);
			
			if( "1".equals(iMap.get("remove")) ){
				commissionCalculationService.removeIncentiveItem(iMap);;
			}
		}
		Map cntMap = new HashMap();
		cntMap.put("uploadId", iMap.get("uploadId"));
		
		int totalCnt = commissionCalculationService.incentiveItemCnt(cntMap);
		cntMap.put("totalCnt", totalCnt);
		
		cntMap.put("vStusId", CommissionConstants.COMIS_INCENTIVE_VALID);
		int totalValid = commissionCalculationService.incentiveItemCnt(cntMap);
		cntMap.put("totalValid", totalValid);
		
		cntMap.put("vStusId", CommissionConstants.COMIS_INCENTIVE_INVALID);
		int totalInvalid = commissionCalculationService.incentiveItemCnt(cntMap);
		cntMap.put("totalInvalid", totalInvalid);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(cntMap);

		return ResponseEntity.ok(message);
	}
	
	/**
	 * incentive item add pop
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/commInctivItemAddPop.do")
	public String commInctivItemAddPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("uploadId", params.get("uploadId"));
		model.addAttribute("uploadTypeId", params.get("uploadTypeId"));
		model.addAttribute("typeCd", params.get("typeCd"));
		// 호출될 화면
		return "commission/commissionIncentiveAddItemPop";
	}
	
	
	@RequestMapping(value = "/incentiveItemValid", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> incentiveItemValid(@RequestParam Map<String, Object> params, Model model) {
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.FAIL);
		
		String msg = "";
		
		Map memMap = commissionCalculationService.incentiveItemAddMem(params);
		if(memMap.get("MEM_CODE") == null || "".equals(memMap.get("MEM_CODE"))){
			msg = "Invalid member.";
		}else{
            if( ("1".equals(memMap.get("MEM_TYPE").toString())) ||  ("2".equals(memMap.get("MEM_TYPE").toString())) ){
            	if(!(params.get("uploadTypeCd").toString()).equals(memMap.get("MEM_TYPE").toString())){
            		msg="Invalid member type.";
            	}else if( !("1".equals(memMap.get("STUS").toString())) ){
            		msg = "This member is not active.";
            	}else{
            		params.put("statusId", CommissionConstants.COMIS_INCENTIVE_ACTIVE);
            		params.put("vStusId", CommissionConstants.COMIS_INCENTIVE_VALID);
            		params.put("memId", memMap.get("MEM_ID"));
            		int cnt = commissionCalculationService.cntIncentiveMem(params);
            		if(cnt > 0){
            			msg = "This member is existing in the upload batch";
            		}else{
            			message.setCode(AppConstants.SUCCESS);
            			message.setData(memMap);
            		}
            	}
            }else{
            	msg="Invalid member type.";
            }
		}
		
		
		
		message.setMessage(msg);

		return ResponseEntity.ok(message);
	}
	
	
	/**
	 * incentive member info search
	 * @param params
	 * @param model
	 * @param request
	 * @return
	 */
	/*@RequestMapping(value = "/incntivMemCheck", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> incntivMemCheck(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		Map map = commissionCalculationService.incentiveItemAddMem(params);
		// 데이터 리턴.
		return ResponseEntity.ok(map);
	}*/
	/**
	 * incentive member check count search
	 * @param params
	 * @param model
	 * @return
	 */
	/*@RequestMapping(value = "/cntIncntivMemCheck")
	public ResponseEntity<Integer> cntIncntivMemCheck(@RequestParam Map<String, Object> params, ModelMap model) {
		params.put("statusId", CommissionConstants.COMIS_INCENTIVE_ACTIVE);
		int totalValid = commissionCalculationService.cntIncentiveMem(params);
		return ResponseEntity.ok(totalValid);
	}	*/
	
	/**
	 * incentive item insert
	 * @param params
	 * @param model
	 * @param sessionVO
	 * @return
	 */
	@RequestMapping(value = "/incentiveItemInsert", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> incentiveItemInsert(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {
		String message = "";
		ReturnMessage msg = new ReturnMessage();
		msg.setCode(AppConstants.SUCCESS);
		 
		String loginId = "";
		if (sessionVO == null) {
			loginId = "1000000000";
		} else {
			loginId = String.valueOf(sessionVO.getUserId());
		}
		
		params.put("loginId", loginId);
		params.put("statusId", CommissionConstants.COMIS_INCENTIVE_ACTIVE);
		params.put("vStatusId", CommissionConstants.COMIS_INCENTIVE_VALID);
		int memCnt = commissionCalculationService.cntUploadMemberCheck(params);
		
		if(memCnt > 0){
			//update
			Map memMap = commissionCalculationService.incentiveUploadMember(params);
			
			params.put("updateDetId", memMap.get("UPLOAD_DET_ID"));
			
			commissionCalculationService.incentiveItemUpdate(params);
		}else{
			//insert
			commissionCalculationService.incentiveItemInsert(params);
		}
		
		
		params.put("vStusId", null);
		int totalCnt = commissionCalculationService.incentiveItemCnt(params);
		params.put("totalCnt", totalCnt);
		
		params.put("vStusId", CommissionConstants.COMIS_INCENTIVE_VALID);
		int totalValid = commissionCalculationService.incentiveItemCnt(params);
		params.put("totalValid", totalValid);
		
		params.put("vStusId", CommissionConstants.COMIS_INCENTIVE_INVALID);
		int totalInvalid = commissionCalculationService.incentiveItemCnt(params);
		params.put("totalInvalid", totalInvalid);
		
		
		// 결과 만들기.
    	message = AppConstants.MSG_SUCCESS;
    	
		msg.setMessage(message);
		msg.setData(params);
        return ResponseEntity.ok(msg);
	}
	
	/**
	 * incentive view pop
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/commIncntivViewPop.do")
	public String commIncntivViewPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		Map detail = commissionCalculationService.incentiveMasterDetail(Integer.parseInt(params.get("uploadId").toString()));
		model.addAttribute("detail", detail);
		
		Map map = new HashMap<>();
		map.put("uploadId", params.get("uploadId"));
		
		int totalCnt = commissionCalculationService.incentiveItemCnt(map);
		model.addAttribute("totalCnt", totalCnt);
		
		map.put("vStusId", CommissionConstants.COMIS_INCENTIVE_VALID);
		int totalValid = commissionCalculationService.incentiveItemCnt(map);
		model.addAttribute("totalValid", totalValid);
		
		map.put("vStusId", CommissionConstants.COMIS_INCENTIVE_INVALID);
		int totalInvalid = commissionCalculationService.incentiveItemCnt(map);
		model.addAttribute("totalInvalid", totalInvalid);
		
		model.addAttribute("uploadId", params.get("uploadId"));
		// 호출될 화면
		return "commission/commissionIncentiveViewPop";
	}
	
	/**
	 * deactivate Check
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/deactivateCheck")
	public ResponseEntity<Integer> deactivateCheck(@RequestParam Map<String, Object> params, ModelMap model) {
		int cnt = commissionCalculationService.deactivateCheck(params.get("uploadId").toString());
		return ResponseEntity.ok(cnt);
	}	
	
	/**
	 * incentive Deactivate Update
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/incentiveDeactivate")
	public ResponseEntity<ReturnMessage> incentiveDeactivate(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if (sessionVO == null) {
			loginId = "1000000000";
		} else {
			loginId = String.valueOf(sessionVO.getUserId());
		}
		params.put("loginId", loginId);
		params.put("statusId", CommissionConstants.COMIS_INCENTIVE_REMOVE);

		commissionCalculationService.incentiveDeactivate(params);
		
		return ResponseEntity.ok(message);
	}
	
	/**
	 * incentive confirm 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/incentiveConfirm")
	public ResponseEntity<ReturnMessage> incentiveConfirm(@RequestParam Map<String, Object> params, ModelMap model) {
		ReturnMessage message = new ReturnMessage();
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if (sessionVO == null) {
			loginId = "1000000000";
		} else {
			loginId = String.valueOf(sessionVO.getUserId());
		}
		params.put("loginId", loginId);

		commissionCalculationService.callIncentiveConfirm(params);
		
		String msg = null;
		if(params.get("v_sqlcode") != null)
			msg = "("+ params.get("v_sqlcode") +")"+ params.get("v_sqlcont");
		System.out.println("##msg : "+msg);
		Map detail = commissionCalculationService.incentiveMasterDetail(Integer.parseInt(params.get("uploadId").toString()));
		
		message.setData(detail);
		message.setMessage(msg);
		return ResponseEntity.ok(message);
	}
	
}
