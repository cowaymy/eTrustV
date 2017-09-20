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
		params.put("mstId",CommissionConstants.COMIS_PRO_CD);
		List<EgovMap> orgGrList = commissionCalculationService.selectCommPrdGroupListl(params);
		model.addAttribute("orgGrList", orgGrList);


		String dt = CommonUtils.getNowDate().substring(0, 6);
		dt = (Integer.parseInt(dt.substring(4))-1) + "/" + dt.substring(0, 4);
		if(dt.length()<7){
			dt = "0"+dt;
		}

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
		params.put("mstId", CommissionConstants.COMIS_PRO_CD);
		// 조회.
		params.put("searchDt", (params.get("searchDt").toString()).replace("/", ""));
		List<EgovMap> itemList = commissionCalculationService.selectCalculationList(params);

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
		params.put("mstId", CommissionConstants.COMIS_PRO_CD);
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
		params.put("mstId", CommissionConstants.COMIS_PRO_CD);
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
		Calendar calendar = Calendar.getInstance();
		calendar.set(pvYear, pvMonth, 1);
		calendar.add(calendar.MONTH, 0);	
		
		sTaskID = (((pvMonth) + (pvYear) * 12) - 24157);
		
		return sTaskID;
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
				prdBatchMap.put("mstId", CommissionConstants.COMIS_PRO_CD);
				prdBatchMap.put("searchDt",lMap.get("searchDt"));
				prdBatchMap.put("taskId", String.valueOf(sTaskID));
				prdBatchMap.put("loginId", lMap.get("loginId"));
				prdBatchMap.put("calYM", (formMap.get("searchDt").toString()).replace("/", ""));
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
				
				if(failCntTemp >0){
					prdMap.put("state",CommissionConstants.COMIS_FAIL_NEXT); //8:FAIL
					failCntTemp = commissionCalculationService.callCommFailNextPrdLog(prdMap);
				}else{
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
		params.put("mstId", CommissionConstants.COMIS_PRO_CD);
		
		/*
		 * Date and taskId
		 */
		Calendar calendar = Calendar.getInstance();	
		Date date = calendar.getTime();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd", Locale.getDefault(Locale.Category.FORMAT));
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());	
		
		params.put("calYM", (params.get("searchDt").toString()).replace("/", ""));
		params.put("searchDt",df.format(date));
		params.put("taskId", String.valueOf(sTaskID));
		params.put("loginId", loginId);
		params.put("state",CommissionConstants.COMIS_RUNNING); //1:Running
		
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
				
		model.addAttribute("searchDt_pop", params.get("searchDt"));
		
		model.addAttribute("codeId", params.get("codeId"));
		
		String code = (params.get("code").toString()).substring(0, 7);
		params.put("code", code);
		model.addAttribute("code", code);
		
		String popName= "";
		System.out.println(params.get("code"));
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P01) || (params.get("code")).equals(CommissionConstants.COMIS_CTM_P01) 
				|| (params.get("code")).equals(CommissionConstants.COMIS_CTW_P01)){
			popName = "calculationData7001CT_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P01) || (params.get("code")).equals(CommissionConstants.COMIS_CDG_P01) 
				|| (params.get("code")).equals(CommissionConstants.COMIS_CDM_P01)|| (params.get("code")).equals(CommissionConstants.COMIS_CDN_P01)
				|| (params.get("code")).equals(CommissionConstants.COMIS_CDS_P01)){
			popName = "calculationData7001CD_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P01) || (params.get("code")).equals(CommissionConstants.COMIS_HPG_P01) 
				|| (params.get("code")).equals(CommissionConstants.COMIS_HPM_P01)|| (params.get("code")).equals(CommissionConstants.COMIS_HPS_P01)
				|| (params.get("code")).equals(CommissionConstants.COMIS_HPT_P01)){
			popName = "calculationData7001HP_Pop";
		}
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P02) || (params.get("code")).equals(CommissionConstants.COMIS_CTM_P02) 
				|| (params.get("code")).equals(CommissionConstants.COMIS_CTW_P02)){
			popName = "calculationData7002CT_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P02) || (params.get("code")).equals(CommissionConstants.COMIS_CDG_P02) 
				|| (params.get("code")).equals(CommissionConstants.COMIS_CDM_P02)|| (params.get("code")).equals(CommissionConstants.COMIS_CDN_P02)
				|| (params.get("code")).equals(CommissionConstants.COMIS_CDS_P02)){
			popName = "calculationData7002CD_Pop";
		}else if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P02) || (params.get("code")).equals(CommissionConstants.COMIS_HPG_P02) 
				|| (params.get("code")).equals(CommissionConstants.COMIS_HPM_P02)|| (params.get("code")).equals(CommissionConstants.COMIS_HPS_P02)
				|| (params.get("code")).equals(CommissionConstants.COMIS_HPT_P02) || (params.get("code")).equals(CommissionConstants.COMIS_HPB_P02)){
			popName = "calculationData7002HP_Pop";
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
		return "commission/"+popName;
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
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CTW_P01))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P01))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7001(params);
		
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/cntData7001CT")
	public ResponseEntity<Integer> cntData7001CT(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_CT);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTW_P01))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P01))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
		
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
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CTW_P02))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P02))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7002(params);
		
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/cntData7002CT")
	public ResponseEntity<Integer> cntData7002CT(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_CT);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CTW_P02))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTL_P02))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CTM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
		
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
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P01) || (params.get("code")).equals(CommissionConstants.COMIS_CDN_P01))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDS_P01))
			params.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7001(params);
		
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/cntData7001CD")
	public ResponseEntity<Integer> cntData7001CD(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_CD);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P01) || (params.get("code")).equals(CommissionConstants.COMIS_CDN_P01))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDS_P01))
			params.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
		
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
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P02) || (params.get("code")).equals(CommissionConstants.COMIS_CDN_P02))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDS_P02))
			params.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
		
		List<EgovMap> dataList = commissionCalculationService.selectData7002(params);
		
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/cntData7002CD")
	public ResponseEntity<Integer> cntData7002CD(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_CD);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_CDC_P02) || (params.get("code")).equals(CommissionConstants.COMIS_CDN_P02))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_CDS_P02))
			params.put("emplyLev", CommissionConstants.COMIS_S_MANAGER_MEM_LEV);
		
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
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPG_P01))
			params.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPS_P01))
			params.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPT_P01))
			params.put("emplyLev", CommissionConstants.COMIS_S_G_MANAGER_MEM_LEV);
		
		
		List<EgovMap> dataList = commissionCalculationService.selectData7001(params);
		
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/cntData7001HP")
	public ResponseEntity<Integer> cntData7001HP(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_HP);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P01))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPG_P01))
			params.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPM_P01))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPS_P01))
			params.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPT_P01))
			params.put("emplyLev", CommissionConstants.COMIS_S_G_MANAGER_MEM_LEV);
		
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
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPG_P02))
			params.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPS_P02))
			params.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPT_P02))
			params.put("emplyLev", CommissionConstants.COMIS_S_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPB_P02))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		
		
		List<EgovMap> dataList = commissionCalculationService.selectData7002(params);
		
		return ResponseEntity.ok(dataList);
	}
	@RequestMapping(value = "/cntData7002HP")
	public ResponseEntity<Integer> cntData7002HP(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", String.valueOf(sTaskID));
		params.put("codeGruop", CommissionConstants.COMIS_HP);
		
		if((params.get("code")).equals(CommissionConstants.COMIS_HPF_P02))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPG_P02))
			params.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPM_P02))
			params.put("emplyLev", CommissionConstants.COMIS_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPS_P02))
			params.put("emplyLev", CommissionConstants.COMIS_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPT_P02))
			params.put("emplyLev", CommissionConstants.COMIS_S_G_MANAGER_MEM_LEV);
		if((params.get("code")).equals(CommissionConstants.COMIS_HPB_P02))
			params.put("emplyLev", CommissionConstants.COMIS_NORMAL_MEM_LEV);
		
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
		
		model.addAttribute("searchDt_pop", params.get("searchDt"));
		
		
		String code = params.get("codeId").toString();
		params.put("code", code);
		model.addAttribute("code", params.get("code"));
		
		System.out.println(" ** code : "+params.get("code"));
		
		
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
		}
		
		// 호출될 화면
		return "commission/"+popName;
	}
	
	
	@RequestMapping(value = "/cntCMM0006T")
	public ResponseEntity<Integer> cntCMM0006T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0006T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0007T")
	public ResponseEntity<Integer> cntCMM0007T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0007T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0008T")
	public ResponseEntity<Integer> cntCMM0008T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0008T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0009T")
	public ResponseEntity<Integer> cntCMM0009T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0009T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0010T")
	public ResponseEntity<Integer> cntCMM0010T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0010T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0011T")
	public ResponseEntity<Integer> cntCMM0011T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0011T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0012T")
	public ResponseEntity<Integer> cntCMM0012T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0012T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0013T")
	public ResponseEntity<Integer> cntCMM0013T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0013T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0014T")
	public ResponseEntity<Integer> cntCMM0014T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0014T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0015T")
	public ResponseEntity<Integer> cntCMM0015T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
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
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0017T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0018T")
	public ResponseEntity<Integer> cntCMM0018T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0018T(params);
		return ResponseEntity.ok(cnt);
	}
	@RequestMapping(value = "/cntCMM0019T")
	public ResponseEntity<Integer> cntCMM0019T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0019T(params);
		return ResponseEntity.ok(cnt);
	}
	@RequestMapping(value = "/cntCMM0020T")
	public ResponseEntity<Integer> cntCMM0020T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0020T(params);
		return ResponseEntity.ok(cnt);
	}
	@RequestMapping(value = "/cntCMM0021T")
	public ResponseEntity<Integer> cntCMM0021T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0021T(params);
		return ResponseEntity.ok(cnt);
	}
	@RequestMapping(value = "/cntCMM0022T")
	public ResponseEntity<Integer> cntCMM0022T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0022T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0023T")
	public ResponseEntity<Integer> cntCMM0023T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0023T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0024T")
	public ResponseEntity<Integer> cntCMM0024T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0024T(params);
		return ResponseEntity.ok(cnt);
	}
	@RequestMapping(value = "/cntCMM0025T")
	public ResponseEntity<Integer> cntCMM0025T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0025T(params);
		return ResponseEntity.ok(cnt);
	}	
	@RequestMapping(value = "/cntCMM0026T")
	public ResponseEntity<Integer> cntCMM0026T(@RequestParam Map<String, Object> params, ModelMap model) {
		int sTaskID = taskIdCalculation(params.get("searchDt").toString());
		params.put("taskId", sTaskID);
		params.put("useYnCombo", null);
		int cnt = commissionCalculationService.cntCMM0026T(params);
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
	
	/**
	 * Use Map and Edit Grid Insert,Update,Delete
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updatePrdData_06T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_06T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0006T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0006T(udtMap);
			}
		}
		
		
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_07T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_07T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0007T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0007T(udtMap);
			}
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_08T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_08T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0008T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0008T(udtMap);
			}
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_09T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_09T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0009T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0009T(udtMap);
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_10T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_10T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0010T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0010T(udtMap);
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_11T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_11T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0011T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0011T(udtMap);
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_12T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_12T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0012T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0012T(udtMap);
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_13T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_13T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		Map<String, Object> udtMap = null;
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0013T(formMap);
		
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0013T(udtMap);
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_14T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_14T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		Map<String, Object> udtMap = null;

		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0014T(formMap);
		
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0014T(udtMap);
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_15T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_15T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		Map<String, Object> udtMap = null;
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0015T(formMap);
		
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0015T(udtMap);
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_17T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_17T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		Map<String, Object> udtMap = null;

		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0017T(formMap);
		
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0017T(udtMap);
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_18T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_18T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0018T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0018T(udtMap);
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_19T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_19T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0019T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0019T(udtMap);
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/updatePrdData_20T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_20T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0020T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0020T(udtMap);
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_21T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_21T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0021T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0021T(udtMap);
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_22T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_22T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0022T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0022T(udtMap);
			}
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_23T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_23T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0023T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0023T(udtMap);
			}
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
	@RequestMapping(value = "/updatePrdData_26T.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updatePrdData_25T(@RequestBody Map<String, Object> params, Model model) {
		
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		
		//task id
		int sTaskID = taskIdCalculation(formMap.get("searchDt").toString());
		formMap.put("taskId", sTaskID);
		
		commissionCalculationService.udtExcludeDataCMM0026T(formMap);
		
		Map<String, Object> udtMap = null;
		if (checkList.size() > 0) {
			for (int i = 0; i < checkList.size(); i++) {
				Map<String, Object> tmpMap = (Map<String, Object>) checkList.get(i);
				udtMap = (Map<String, Object>) tmpMap.get("item");
				commissionCalculationService.udtDataCMM0026T(udtMap);
			}
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}

}
