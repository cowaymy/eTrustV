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
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
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

	
	@RequestMapping(value = "/monthlyBudgetList.do")
	public String monthlyBudgetList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		String year = CommonUtils.getNowDate().substring(0,4);
		
		model.addAttribute("year", year);
		return "eAccounting/budget/monthlyBudgetList";
	}
	
	@RequestMapping(value = "/selectMonthlyBudgetList", method = RequestMethod.GET) 
	public ResponseEntity<List<EgovMap>> selectMonthlyBudgetList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{	
		
		List<EgovMap> budgetList = null; 

		
		LOGGER.debug("groupCd =====================================>>  " + params);
		
		budgetList = budgetService.selectMonthlyBudgetList(params);
		
		return ResponseEntity.ok(budgetList);
		
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
	public ResponseEntity <List<EgovMap>>  selectAdjustmentList (@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{
		
		LOGGER.debug("params =====================================>>  " + params);

		String[] budgetAdjType = request.getParameterValues("budgetAdjType");

		params.put("budgetAdjType", budgetAdjType);
		
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
	public String budgetAdjustment (@RequestParam Map<String, Object> params,   ModelMap model) throws Exception{
		
		LOGGER.debug("params =====================================>>  " + params);
		
		model.addAttribute("budgetStatus", "Y");
		
		if(!StringUtils.isEmpty(params.get("gridBudgetDocNo"))){
						
			List<EgovMap> adjustmentList = null; 
			List<EgovMap> fileList = null; 

			Map param = new HashMap();
			param.put("budgetDocNo", params.get("gridBudgetDocNo"));
			adjustmentList= budgetService.selectAdjustmentList(param);
			
			
			if(!StringUtils.isEmpty(params.get("atchFileGrpId"))){
				fileList= budgetService.selectFileList(params);	
			}
			
			model.addAttribute("fileList", fileList);
			model.addAttribute("adjustmentList", new Gson().toJson(adjustmentList));

			model.addAttribute("budgetStatus", adjustmentList.get(0).get("status"));	
			if(!adjustmentList.get(0).get("status").toString().equals("Open")){
				model.addAttribute("budgetStatus","N");
			}else{
				if(!CommonUtils.isEmpty(params.get("appvFlag")) && "Y".equals(params.get("appvFlag").toString())){					
					model.addAttribute("budgetStatus", "N");					
				}else{
					model.addAttribute("budgetStatus","Y");
				}
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
	public ResponseEntity<ReturnMessage> saveAdjustmentList (HttpServletRequest request, @RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{		
		
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
		
		result = budgetService.saveAdjustmentInfo(params);
		
		
		// 결과 만들기 예.
    	ReturnMessage message = new ReturnMessage();
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
	
	@RequestMapping(value = "/selectPlanMaster", method = RequestMethod.POST) 
	public ResponseEntity<ReturnMessage> selectPlanMaster (@RequestBody Map<String, Object> params, ModelMap model,	SessionVO sessionVO) throws Exception{		
		
		LOGGER.debug("params =====================================>>  " + params);
		
		Map<String, Object> sendParam = new HashMap<String, Object>();
		Map<String, Object> recvParam = new HashMap<String, Object>();
		Map<String, Object> result = new HashMap<String, Object>();
		
		int send = 0;
		int recv = 0;
		
		sendParam.put("costCenter", params.get("sendCostCenter"));
		sendParam.put("glAccCode", params.get("sendGlAccCode"));
		sendParam.put("budgetCode", params.get("sendBudgetCode"));
		
		send = budgetService.selectPlanMaster(sendParam);
		
		
		if(!StringUtils.isEmpty(params.get("recvCostCenter"))){

			recvParam.put("costCenter", params.get("recvCostCenter"));
			recvParam.put("glAccCode", params.get("recvGlAccCode"));
			recvParam.put("budgetCode", params.get("recvBudgetCode"));			

			recv = budgetService.selectPlanMaster(recvParam);
		}

		result.put("send", "N");
		result.put("recv", "N");
		
		if(send > 0){
			result.put("send", "Y");
		}else{
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
	
}

