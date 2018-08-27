package com.coway.trust.web.eAccounting.budget;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.budget.BudgetService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/budget")
public class BudgetController {

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	@Autowired
	private FileApplication fileApplication;

	private static final Logger LOGGER = LoggerFactory.getLogger(BudgetController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "budgetService")
	private BudgetService budgetService;

	@Autowired
	private FileService fileService;

	@Autowired
	private SessionHandler sessionHandler;


	@RequestMapping(value = "/budgetControlMaster.do")
	public String selectBudgetControlList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		return "eAccounting/budget/budgetControlMaster";
	}

	@RequestMapping(value = "/selectBudgetControlList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBudgetControlList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		List<EgovMap> budgetControlList = null;
		budgetControlList = budgetService.selectBudgetControlList(params);
		return ResponseEntity.ok(budgetControlList);
	}

	@RequestMapping(value = "/budgetSystemMaintenance.do")
	public String selectBudgetSysList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		return "eAccounting/budget/budgetSystemMaintenance";
	}

	@RequestMapping(value = "/selectBudgetSysMaintenanceList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBudgetSysList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {
		List<EgovMap> selectBudgetSysMaintenanceList = null;
		selectBudgetSysMaintenanceList = budgetService.selectBudgetSysMaintenanceList(params);

		return ResponseEntity.ok(selectBudgetSysMaintenanceList);
	}

	@RequestMapping(value = "/saveBudgetSysMaintGrid.do", method = RequestMethod.POST)
	public  ResponseEntity<ReturnMessage>  saveBudgetSysMaintGrid(@RequestBody Map<String, ArrayList<Object>> params, Model model) {

		String dt = CommonUtils.getNowDate();

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		String loginId = "";
		if(sessionVO==null){
			loginId="1000000000";
		}else{
			loginId=String.valueOf(sessionVO.getUserId());
		}

		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList

		int cnt = 0;

		if (addList.size() > 0) {
			cnt = budgetService.addBudgetSysMaintGrid(addList, loginId);
		}
		if (udtList.size() > 0) {
			cnt = budgetService.udtBudgetSysMaintGrid(udtList,loginId);
		}

		model.addAttribute("searchDt", dt);
		//model.addAttribute("year",  Integer.parseInt(dt.substring(3)));
		//model.addAttribute("month", Integer.parseInt(dt.substring(0,2)));

		//logger.info("수정 : {}", udtList.toString());
		//logger.info("추가 : {}", addList.toString());
		//logger.info("삭제 : {}", delList.toString());
		//logger.info("카운트 : {}", cnt);

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/monthlyBudgetList.do")
	public String monthlyBudgetList (@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

		String year = CommonUtils.getNowDate().substring(0,4);

		model.addAttribute("year", year);
		return "eAccounting/budget/monthlyBudgetList";
	}

	@RequestMapping(value = "/selectMonthlyBudgetList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMonthlyBudgetList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception{

		List<EgovMap> budgetList = null;

		// add jgkim
		int[] roleIds = {87, 96, 279, 130, 264, 94, 155, 261, 104, 193, 207, 52, 82, 200, 180, 296, 254, 289, 96};
		List<Object> roleIdList = new ArrayList<Object>();
		for(int i = 0; i < roleIds.length; i++) {
			roleIdList.add(roleIds[i]);
		}

		if(roleIdList.indexOf(sessionVO.getRoleId()) >= 0) {
			params.put("costCentr", sessionVO.getCostCentr());
		}

		if(sessionVO.getUserId() == 79333) {
			params.put("costCentr", "A1701");
			params.put("costCentr2", "A2101");
		}

		LOGGER.debug("params =====================================>>  " + params);

		budgetList = budgetService.selectMonthlyBudgetList(params);

		return ResponseEntity.ok(budgetList);

	}

	// add jgkim
	@RequestMapping(value = "/selectAdjustmentCBG.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAdjustmentCBG (@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception{

		List<EgovMap> info = null;

		params.put("costCentr", sessionVO.getCostCentr());

		LOGGER.debug("params =====================================>>  " + params);

		info = budgetService.selectAdjustmentCBG(params);

		return ResponseEntity.ok(info);

	}

	@RequestMapping(value = "/availableBudgetDisplayPop.do")
	public String availableBudgetDisplay (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		params.put("budgetPlanYear",  params.get("item[budgetPlanYear]"));
		params.put("budgetPlanMonth",  params.get("month"));

		if(params.get("month").toString().length() == 1){

			params.put("month", "0"+ params.get("month"));
		}

		params.put("costCentr",  params.get("item[costCentr]"));

		if( !CommonUtils.isEmpty(params.get("item[costCenterText]")) ){
			params.put("costCenterText", params.get("item[costCenterText]"));
		}

		params.put("glAccCode",  params.get("item[glAccCode]"));

		if( !CommonUtils.isEmpty(params.get("item[glAccDesc]")) ){
			params.put("glAccDesc", params.get("item[glAccDesc]"));
		}

		params.put("budgetCode",  params.get("item[budgetCode]"));

		if( !CommonUtils.isEmpty(params.get("item[budgetCodeText]")) ){
			params.put("glAccDesc", params.get("item[budgetCodeText]"));
		}

		LOGGER.debug("item =====================================>>  " + params);

		Map result = budgetService.selectAvailableBudgetAmt(params);


		model.addAttribute("result", result);
		model.addAttribute("item", params);
		return "eAccounting/budget/availableBudgetDisplayPop";
	}


	@RequestMapping(value = "/adjustmentAmountPop.do")
	public String adjustmentAmountPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		model.addAttribute("item", params);
		return "eAccounting/budget/adjustmentAmountPop";
	}

	@RequestMapping(value = "/selectAdjustmentAmountList")
	public ResponseEntity<List<EgovMap>>  selectAdjustmentAmountList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> adjustmentList = null;

		adjustmentList= budgetService.selectAdjustmentAmount(params);

		return ResponseEntity.ok(adjustmentList);
	}

	@RequestMapping(value = "/pendingConsumedAmountPop.do")
	public String pendingConsumedAmountPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);
		model.addAttribute("item", params);

		return "eAccounting/budget/pendingConsumedAmountPop";
	}

	@RequestMapping(value = "/selectPenConAmountList")
	public ResponseEntity<List<EgovMap>>  selectPenConAmountList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		List<EgovMap> adjustmentList = null;

		adjustmentList= budgetService.selectPenConAmount(params);

		return ResponseEntity.ok(adjustmentList);
	}

	@RequestMapping(value = "/budgetAdjustmentList.do")
	public String budgetAdjustmentList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		String yearMonth =  CommonUtils.getNowDate().substring(4,6) +"/" +CommonUtils.getNowDate().substring(0,4);


		model.addAttribute("stYearMonth",  yearMonth );
		model.addAttribute("edYearMonth",  yearMonth );


		return "eAccounting/budget/budgetAdjustmentList";
	}

	@RequestMapping(value = "/selectAdjustmentList")
	public ResponseEntity <List<EgovMap>>  selectAdjustmentList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		String[] budgetAdjType = request.getParameterValues("budgetAdjType");
		String[] appvStus = request.getParameterValues("appvStus");

		params.put("budgetAdjType", budgetAdjType);
		params.put("appvStus", appvStus);

		int[] roleIds = {87, 96, 279, 130, 264, 94, 155, 261, 104, 193, 207, 52, 82, 200, 180, 296, 254, 289, 96};
		List<Object> roleIdList = new ArrayList<Object>();
		for(int i = 0; i < roleIds.length; i++) {
			roleIdList.add(roleIds[i]);
		}

		if(roleIdList.indexOf(sessionVO.getRoleId()) >= 0) {
			params.put("costCentr", sessionVO.getCostCentr());
		}

		List<EgovMap> adjustmentList = null;

		adjustmentList= budgetService.selectAdjustmentList(params);

		return ResponseEntity.ok(adjustmentList);
	}

	@RequestMapping(value = "/selectAdjustmentPopList")
	public ResponseEntity <EgovMap>  selectAdjustmentPopList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		String[] budgetAdjType = request.getParameterValues("budgetAdjType");

		params.put("budgetAdjType", budgetAdjType);

		params.put("budgetDocNo", params.get("pBudgetDocNo"));

		LOGGER.debug("params =====================================>>  " + params);
		EgovMap result = new EgovMap();

		List<EgovMap> adjustmentList = null;
		/*List<EgovMap> fileList = null; */

		adjustmentList= budgetService.selectAdjustmentList(params);

		/*if(!CommonUtils.isEmpty(params.get("atchFileGrpId"))){
			fileList= budgetService.selectFileList(params);
		}*/

		result.put("adjustmentList", adjustmentList);
		/*result.put("fileList", fileList);*/

		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/budgetAdjustmentPop.do")
	public String budgetAdjustment (@RequestParam Map<String, Object> params,   ModelMap model, SessionVO sessionVO) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		// add jgkim
		int[] roleIds = {87, 96, 279, 130, 264, 94, 155, 261, 104, 193, 207, 52, 82, 200, 180, 296, 254, 289, 96};
		List<Object> roleIdList = new ArrayList<Object>();
		for(int i = 0; i < roleIds.length; i++) {
			roleIdList.add(roleIds[i]);
		}

		if(roleIdList.indexOf(sessionVO.getRoleId()) >= 0) {
			model.addAttribute("mgrYn", "Y");
		} else {
			model.addAttribute("mgrYn", "N");
		}

		model.addAttribute("budgetStatus", "Y");

		if(!StringUtils.isEmpty(params.get("gridBudgetDocNo"))){

			List<EgovMap> adjustmentList = null;
			List<EgovMap> fileList = null;

			Map param = new HashMap();
			param.put("budgetDocNo", params.get("gridBudgetDocNo"));
			adjustmentList= budgetService.selectAdjustmentList(param);


			if(!StringUtils.isEmpty(params.get("atchFileGrpId"))){
				fileList= budgetService.selectFileList(params);
				LOGGER.debug("atchFileGrpId =======>>>" +  params.get("atchFileGrpId"));
				model.addAttribute("atchFileGrpId", params.get("atchFileGrpId"));
			}

			model.addAttribute("fileList", fileList);
			model.addAttribute("adjustmentList", new Gson().toJson(adjustmentList));

			model.addAttribute("budgetStatus", adjustmentList.get(0).get("status"));
			LOGGER.debug("status =======>>>" + adjustmentList.get(0).get("status").toString());

			if(!adjustmentList.get(0).get("status").toString().equals("Temp. Save")){
				model.addAttribute("budgetStatus","N");
				if(!CommonUtils.isEmpty(params.get("appvFlag")) && "Y".equals(params.get("appvFlag").toString())){
					model.addAttribute("appv", "Y");
				}
			}else{
/*
				LOGGER.debug("appvFlag =======>>>" +  model.get("appvFlag"));
				if(!CommonUtils.isEmpty(params.get("appvFlag")) && "Y".equals(params.get("appvFlag").toString())){
					model.addAttribute("budgetStatus", "N");
					model.addAttribute("appv", "Y");
					LOGGER.debug("appv =======>>>" +  model.get("appv"));
				}else{*/
					model.addAttribute("budgetStatus","Y");
			//	}
			}

			model.addAttribute("budgetDocNo", params.get("gridBudgetDocNo"));

			LOGGER.debug("gridBudgetDocNo =======>>>" +  params.get("gridBudgetDocNo"));
			LOGGER.debug(" fileList =======>>>" +  fileList);
			LOGGER.debug(" new Gson().toJson(adjustmentList)=======>>>" +  new Gson().toJson(adjustmentList));
		}


		return "eAccounting/budget/budgetAdjustmentPop";
	}

/*	@RequestMapping(value = "/uploadFile.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> uploadFile (MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		params.put("userId", sessionVO.getUserId());

		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "budget", AppConstants.UPLOAD_MAX_FILE_SIZE);

		LOGGER.debug("list.size : {}", list.size());

		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {

			fileApplication.businessAttach(FileType.WEB, FileVO.createList(list), params);
		}


		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(params.get("fileGroupKey"));
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);

	}*/


	@RequestMapping(value = "/uploadFile.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> uploadFile (MultipartHttpServletRequest request, @RequestParam Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		params.put("userId", sessionVO.getUserId());


		List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir,
				File.separator + "eAccounting" + File.separator + "budget", AppConstants.UPLOAD_MAX_FILE_SIZE, true);

		LOGGER.debug("list.size : {}", list.size());

		// serivce 에서 파일정보를 가지고, DB 처리.
		if (list.size() > 0) {

			if(!CommonUtils.isEmpty(params.get("pAtchFileGrpId"))){

				int pAtchFileGrpId = Integer.parseInt(params.get("pAtchFileGrpId").toString());

				fileService.removeFilesByFileGroupId(FileType.WEB_DIRECT_RESOURCE, pAtchFileGrpId);
			}

			/*int fileGroupKey = fileService.insertFiles(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, (Integer) params.get("userId"));
			params.put("fileGroupKey", fileGroupKey);*/

			fileApplication.businessAttach(FileType.WEB_DIRECT_RESOURCE, FileVO.createList(list), params);
		}


		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(params.get("fileGroupKey"));
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/saveAdjustmentList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAdjustmentList (HttpServletRequest request, @RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception {

		LOGGER.debug("params =====================================>>  " + params);
		LOGGER.debug("request :: atchFileGrpId ==============>> " + params.get("pAtchFileGrpId"));

		if(!CommonUtils.isEmpty(params.get("pAtchFileGrpId").toString())){

			int atchFileGrpId =  Integer.parseInt(params.get("pAtchFileGrpId").toString());
			params.put("atchFileGrpId", atchFileGrpId);
		}
		String type =  params.get("type").toString();
		params.put("type", type);

		LOGGER.debug("params :: atchFileGrpId ==============>> " + params.get("atchFileGrpId"));

		int totCnt = 0;

		params.put("userId", sessionVO.getUserId());

		Map result = new HashMap<String, Object>();

    	ReturnMessage message = new ReturnMessage();


    	try{
    		result = budgetService.saveAdjustmentInfo(params);
    	}catch (ApplicationException e){
    		e.printStackTrace();

    		result.put("totCnt", params.get("totCnt"));
    		result.put("budgetDocNo", params.get("budgetDocNo"));
    		result.put("resultAmtList", params.get("resultAmtList"));
    		result.put("overbudget", params.get("overbudget"));

    		// 결과 만들기 예.
        	message.setCode(AppConstants.SUCCESS);
        	message.setData(result);
        	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

        	return ResponseEntity.ok(message);
    	}

		// 결과 만들기 예.
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(result);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);

	}

/*	@RequestMapping(value = "/budgetCheck", method = RequestMethod.POST)
	public ResponseEntity <EgovMap> budgetCheck(@RequestBody Map<String, Object> params, ModelMap model) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		params.put("month", params.get("sendYearMonth").toString().substring(0, 2));
		params.put("year", params.get("sendYearMonth").toString().substring(3));
		params.put("budgetPlanMonth", params.get("sendYearMonth").toString().substring(0, 2));
		params.put("budgetPlanYear", params.get("sendYearMonth").toString().substring(3));
		params.put("costCentr", params.get("sendCostCenter"));
		params.put("budgetCode", params.get("sendBudgetCode"));
		params.put("glAccCode", params.get("sendGlAccCode"));

		EgovMap result = new EgovMap();

		result = budgetService.getBudgetAmt(params);

    	return ResponseEntity.ok(result);
	}
	*/

	@RequestMapping(value = "/saveBudgetApprovalReq", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveBudgetApprovalReq (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		params.put("userId", sessionVO.getUserId());
		params.put("appvStus", "O");
		params.put("appvPrcssStus",  "R");

		Map result = new HashMap<String, Object>();

		result = budgetService.saveApprovalList(params);


		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(result);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/budgetApprove.do")
	public String budgetApprove (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		String yearMonth =  CommonUtils.getNowDate().substring(4,6) +"/" +CommonUtils.getNowDate().substring(0,4);

		model.addAttribute("stYearMonth",  yearMonth );
		model.addAttribute("edYearMonth",  yearMonth );

		return "eAccounting/budget/budgetApprove";
	}

	@RequestMapping(value = "/selectApprovalList")
	public ResponseEntity <List<EgovMap>>  selectApprovalList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		String[] budgetAdjType = request.getParameterValues("budgetAdjType");

		params.put("budgetAdjType", budgetAdjType);

		List<EgovMap> apporvalList = null;

		apporvalList= budgetService.selectApprovalList(params);

		return ResponseEntity.ok(apporvalList);
	}

	@RequestMapping(value = "/saveBudgetApproval", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveBudgetApproval (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		params.put("userId", sessionVO.getUserId());
		//params.put("appvStus", params.get("appvStus"));
		//params.put("appvPrcssStus", params.get("appvPrcssStus"));

		Map result = new HashMap<String, Object>();

		result = budgetService.saveApprovalList(params);


		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(result);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);

	}
	@RequestMapping(value = "/savePopBudgetApproval", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> savePopBudgetApproval (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		params.put("userId", sessionVO.getUserId());

		budgetService.saveApproval(params);


		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData("");
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/selectPlanMaster", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectPlanMaster (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		Map<String, Object> sendParam = new HashMap<String, Object>();
		Map<String, Object> recvParam = new HashMap<String, Object>();
		Map<String, Object> result = new HashMap<String, Object>();

		int send = 0;
		int recv = 0;

		result.put("send", "N");
		result.put("recv", "N");

		sendParam.put("costCenter", params.get("sendCostCenter"));
		sendParam.put("glAccCode", params.get("sendGlAccCode"));
		sendParam.put("budgetCode", params.get("sendBudgetCode"));

		send = budgetService.selectPlanMaster(sendParam);

		if(send > 0){
			result.put("send", "Y");
		}

		if(!StringUtils.isEmpty(params.get("recvCostCenter"))){

			recvParam.put("costCenter", params.get("recvCostCenter"));
			recvParam.put("glAccCode", params.get("recvGlAccCode"));
			recvParam.put("budgetCode", params.get("recvBudgetCode"));

			recv = budgetService.selectPlanMaster(recvParam);

			if(recv > 0){
				result.put("recv", "Y");
			}
		}

		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(result);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}


	@RequestMapping(value = "/selectCodeName", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectCostCenterName (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		String result ;

		if("SC".equals(params.get("codeType").toString()) || "RC".equals(params.get("codeType").toString())){

			result = budgetService.selectCostCenterName(params);
		}else if("SB".equals(params.get("codeType").toString()) || "RB".equals(params.get("codeType").toString())){

			result = budgetService.selectBudgetCodeName(params);
		}else{

			result = budgetService.selectGlAccCodeName(params);
		}


		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(result);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/deleteBudgetAdjustment", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteBudgetAdjustment (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		Map result = new HashMap<String, Object>();

		result = budgetService.deleteAdjustmentInfo(params);


		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(result);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

    	return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/selectCloseMonth", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectCloseMonth (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{

		LOGGER.debug("params =====================================>>  " + params);

		String closeMonth = budgetService.selectCloseMonth(params);

		ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setData(closeMonth);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/availableBudgetList.do")
	public String availableBudgetList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		//String year = CommonUtils.getNowDate().substring(0,4);

		//model.addAttribute("year", year);
		return "eAccounting/budget/availableBudgetList";
	}

	@RequestMapping(value = "/selectAvailableBudgetList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAvailableBudgetList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception{

		List<EgovMap> budgetList = null;

		// add jgkim
		int[] roleIds = {87, 96, 279, 130, 264, 94, 155, 261, 104, 193, 207, 52, 82, 200, 180, 296, 254, 289, 96};
		List<Object> roleIdList = new ArrayList<Object>();
		for(int i = 0; i < roleIds.length; i++) {
			roleIdList.add(roleIds[i]);
		}

		if(roleIdList.indexOf(sessionVO.getRoleId()) >= 0) {
			params.put("costCentr", sessionVO.getCostCentr());
		}

		LOGGER.debug("params =====================================>>  " + params);

		budgetList = budgetService.selectAvailableBudgetList(params);

		return ResponseEntity.ok(budgetList);

	}
}

