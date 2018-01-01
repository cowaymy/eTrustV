package com.coway.trust.web.sales.pos;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.pos.PosService;
import com.coway.trust.biz.sales.pos.vo.PosGridVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/pos")
public class PosController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PosController.class);
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@Resource(name = "posService")
	private PosService posService;
	
	@RequestMapping(value = "/selectPosList.do")
	public String selectPosList(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		//TODO 유저 권한에 따라 리스트 검색 조건 변경 (추후)
		
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		
		model.put("bfDay", bfDay);
		model.put("toDay", toDay);
		
		return "sales/pos/posList";
	}
	
	
	@RequestMapping(value = "/selectPosModuleCodeList")
	public ResponseEntity<List<EgovMap>> selectPosModuleCodeList(@RequestParam Map<String, Object> params , @RequestParam(value = "codeIn[]") List<String> arr) throws Exception{
		
		List<EgovMap> codeList = null;
		params.put("codeArray", arr);
		
		codeList = posService.selectPosModuleCodeList(params);
		
		return ResponseEntity.ok(codeList);
		
	}
	
	
	@RequestMapping(value = "/selectStatusCodeList")
	public ResponseEntity<List<EgovMap>> selectStatusCodeList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> codeList = null;
		
		codeList = posService.selectStatusCodeList(params);
		
		return ResponseEntity.ok(codeList);
	}
 	
	
	@RequestMapping(value = "/selectWhBrnchList")
	public ResponseEntity<List<EgovMap>> selectWhBrnchList () throws Exception{
		
		List<EgovMap> codeList = null;
		
		codeList = posService.selectWhBrnchList();
		
		return ResponseEntity.ok(codeList);
		
	}
	
	
	@RequestMapping(value = "/selectWarehouse")
	public ResponseEntity<EgovMap> selectWarehouse(@RequestParam Map<String, Object> params) throws Exception{
		
		EgovMap codeMap = null;
		
		codeMap = posService.selectWarehouse(params);
		
		return ResponseEntity.ok(codeMap);
		
	}
	
	
	@RequestMapping(value = "/selectPosJsonList")
	public ResponseEntity<List<EgovMap>> selectPosJsonList (@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{
		
		List<EgovMap> listMap = null;
		
		//params
		String systemArray[] = request.getParameterValues("posTypeId");
		String statusArray[] = request.getParameterValues("posStatusId");
		
		params.put("systemArray", systemArray);
		params.put("statusArray", statusArray);
		
		listMap = posService.selectPosJsonList(params);
		
		return ResponseEntity.ok(listMap);
		
	}
	
	
	@RequestMapping(value = "/posSystemPop.do")
	public String posSystemPop(@RequestParam Map<String, Object> params,  ModelMap model) throws Exception{
		
	   SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
	   
		params.put("userId", sessionVO.getUserId());
		
		EgovMap memCodeMap = null;
		EgovMap locMap = null;
		memCodeMap = posService.getMemCode(params); //get Brncn ID
		
		if(memCodeMap != null){
			
			if(memCodeMap.get("brnch") != null){ //BRNCH
				params.put("brnchId", memCodeMap.get("brnch"));
				locMap = posService.selectWarehouse(params);
			}
			
		}
		
		model.addAttribute("memCodeMap", memCodeMap);
		model.addAttribute("locMap", locMap);
		
		return "sales/pos/posSystemPop";
	}
	
	
	@RequestMapping(value = "/posItmSrchPop.do")
	public String posItmSrchPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		//Params translate
		model.addAttribute("posSystemModuleType", params.get("insPosModuleType"));
		model.addAttribute("posSystemType", params.get("insPosSystemType"));
		model.addAttribute("whBrnchId", params.get("hidLocId"));
		//model.addAttribute("", params.get("hidLocDesc"));
		
		return "sales/pos/posItmSrchPop";
		
	}
	
	
	@RequestMapping(value = "/selectPosTypeList")
	public ResponseEntity<List<EgovMap>> selectPosTypeList(@RequestParam Map<String, Object> params , @RequestParam(value = "codes[]")  String[] codes) throws Exception{
		
		List<EgovMap> codeList = null;
		
		params.put("codArr", codes);
		codeList = posService.selectPosTypeList(params);
		
		return ResponseEntity.ok(codeList);
	}
	
/*	@RequestMapping(value = "/selectPSMItmTypeDeductionList")
	public ResponseEntity<List<EgovMap>> selectPSMItmTypeDeductionList(@RequestParam Map<String, Object> params, @RequestParam(value = "exceptCodes[]")  String[] exceptArr) throws Exception{
		
		List<EgovMap> codeList = null;
		
		params.put("exArr", exceptArr);
		
		codeList = posService.selectPosTypeList(params);
		
		return ResponseEntity.ok(codeList);
	}*/
	
	
/*	@RequestMapping(value = "/selectPIItmTypeList")
	public ResponseEntity<List<EgovMap>> selectPIItmTypeList() throws Exception{
		
		List<EgovMap> codeList = null;
		codeList = posService.selectPIItmTypeList();
		
		return ResponseEntity.ok(codeList);
	}*/
	
	
	/*@RequestMapping(value = "/selectPIItmList")
	public ResponseEntity<List<EgovMap>> selectPIItmList(@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{
		
		List<EgovMap> codeList = null;
		
		String itmIdArray [] = request.getParameterValues("itmLists"); 
		params.put("itmIdArray", itmIdArray);
		
		codeList = posService.selectPIItmList(params);
		return ResponseEntity.ok(codeList);
	}*/
	
	
	@RequestMapping(value = "/selectPosItmList")
	public ResponseEntity<List<EgovMap>> selectPosItmList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> codeList = null;
		
		params.put("stkTypeId", SalesConstants.POS_SALES_NOT_BANK); //2687
		codeList = posService.selectPosItmList(params);
		return ResponseEntity.ok(codeList);
		
	}
	
	
	@RequestMapping(value = "/chkStockList")
	public ResponseEntity<List<EgovMap>> chkStockList (@RequestParam Map<String, Object> params , HttpServletRequest request) throws Exception{
		
		
		String stkId[] = request.getParameterValues("itmLists");
		params.put("stkId", stkId);
		
		List<EgovMap> stokList = null;
		stokList = posService.chkStockList(params);
		
		return ResponseEntity.ok(stokList);
	}
	
	
	@RequestMapping(value = "/getReasonCodeList")
	public ResponseEntity<List<EgovMap>> getReasonCodeList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> codeList = null;
		codeList = posService.getReasonCodeList(params);
		
		return ResponseEntity.ok(codeList);
	}
	
	
	@RequestMapping(value = "/posFilterSrchPop.do" )
	public String posFilterSrchPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		model.addAttribute("basketStkCode", params.get("basketStkCode"));
		model.addAttribute("tempString", params.get("tempString"));
		
		return "sales/pos/posFilterSerialSrchPop";
	}

	
	@RequestMapping(value = "/getFilterSerialNum")
	public ResponseEntity<List<EgovMap>> getFilterSerialNum (@RequestParam Map<String, Object> params) throws Exception{
		//Session
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		
		List<EgovMap> serialList = null;
		serialList = posService.getFilterSerialNum(params);
		
		return ResponseEntity.ok(serialList);
	}
	
	
	@RequestMapping(value = "/getFilterSerialReNum")
	public ResponseEntity<List<EgovMap>> getFilterSerialReNum (@RequestParam Map<String, Object> params , @RequestParam(value = "tempSerialArr[]") String[] tempSerialArr) throws Exception{ 
		//Session
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
	 	params.put("serialArr", tempSerialArr);
		
		List<EgovMap> serialList = null;
		serialList = posService.getFilterSerialNum(params);
		
		return ResponseEntity.ok(serialList);
	}
	
	
	@RequestMapping(value = "/getConfirmFilterListAjax")
	public ResponseEntity<List<EgovMap>> getConfirmFilterListAjax(@RequestParam(value = "toArr[]") String[] toArr , @RequestParam Map<String, Object> params) throws Exception{
		
		//Session
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		
		//param Setting
		params.put("userId", sessionVO.getUserId());
		params.put("filterArr", toArr);
		List<EgovMap> filterList = null;
		filterList = posService.getConfirmFilterListAjax(params);
		
		return ResponseEntity.ok(filterList);
		
		
	}
	
	
	@RequestMapping(value = "/insertPos.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertPos(@RequestBody Map<String, Object> params) throws Exception{
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		params.put("userDeptId", sessionVO.getUserDeptId());
		params.put("userName", sessionVO.getUserName());
		Map<String, Object> retunMap = null;
		retunMap = posService.insertPos(params);
		
		return ResponseEntity.ok(retunMap);
		
	}
	
	@RequestMapping(value = "/posMemUploadPop.do")
	public String posMemUploadPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		model.addAttribute("mainBrnch", params.get("cmbWhBrnchIdPop"));
		
		return "sales/pos/posMemUploadPop";
	}
	
	
	@RequestMapping(value = "/getUploadMemList")   
	public ResponseEntity<List<EgovMap>> getUploadMemList (@RequestParam Map<String, Object> params, @RequestParam(value = "memIdArray[]") String[] memIdArray) throws Exception{
		List<EgovMap> memList = null;
		
		params.put("memberIdArr", memIdArray);
		
		memList = posService.getUploadMemList(params);
		
		return ResponseEntity.ok(memList);
	}
	
	
	@RequestMapping(value = "/chkReveralBeforeReversal")
	public  ResponseEntity<EgovMap> chkReveralBeforeReversal(@RequestParam Map<String, Object> params) throws Exception{
		
		EgovMap chkMap = null;
		
		
		LOGGER.info("############################ chkReveralBeforeReversal  params.toString :    " + params.toString());
		
		
		chkMap = posService.chkReveralBeforeReversal(params);
		
		return ResponseEntity.ok(chkMap);
	}
	
	
	
	@RequestMapping(value = "/posReversalPop.do")
	public String posReversalPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		//posId
		LOGGER.info("######################################### posID : " + params.get("posId"));
		EgovMap revDetailMap = null;
		EgovMap payDetailMap = null;
	
		revDetailMap = posService.posReversalDetail(params);
		params.put("posNo", revDetailMap.get("posNo"));
		payDetailMap = posService.posReversalPayDetail(params);
		
		//exist Pay Check
		String isPayed = "";
		
		if(payDetailMap != null){
			if(Integer.parseInt(String.valueOf(payDetailMap.get("payId")))	 == 0){
				isPayed = "0";
			}else{
				isPayed = "1";
			}
		}else{
			isPayed = "0";
		}
		
		model.addAttribute("revDetailMap", revDetailMap);
		model.addAttribute("payDetailMap" , payDetailMap);
		model.addAttribute("isPayed" , isPayed);
		
		return "sales/pos/posReversalPop";
		
	}
	
	
	@RequestMapping(value = "/getPosDetailList")
	public ResponseEntity<List<EgovMap>> getPosDetailList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> detailList = null;
		
		LOGGER.info("################################## detail Grid PARAM : " + params.toString());
		
		detailList = posService.getPosDetailList(params);
		
		return ResponseEntity.ok(detailList);
	}
	
	
	@RequestMapping(value = "/insertPosReversal.do" , method = RequestMethod.POST)
	public ResponseEntity<EgovMap> insertPosReversal(@RequestBody Map<String, Object> params) throws Exception{
		
		//Session
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		params.put("userId", sessionVO.getUserId());
		params.put("userDeptId", sessionVO.getUserDeptId());
		
		EgovMap revMap = null; 
		revMap = posService.insertPosReversal(params);
		
		return ResponseEntity.ok(revMap);
		
	}
	
	@RequestMapping(value = "/getPurchMemList")
	public ResponseEntity<List<EgovMap>> getPurchMemList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> memList = null;
		LOGGER.info("################################################ 멤버 params : " + params.toString());
		memList = posService.getPurchMemList(params);
		
		return ResponseEntity.ok(memList);
	}
	
	
	@RequestMapping(value= "/updatePosMStatus" , method = RequestMethod.POST)				 
	public ResponseEntity<ReturnMessage> updatePosMStatus (@RequestBody PosGridVO pgvo, SessionVO session) throws Exception{
		
		LOGGER.info("############################# pgvo : " + pgvo.toString());
		
		posService.updatePosMStatus(pgvo , Integer.parseInt(String.valueOf(session.getUserId())));
		
		//Return MSG
    	ReturnMessage message = new ReturnMessage();
    	
        message.setCode(AppConstants.SUCCESS);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    	
    	return ResponseEntity.ok(message);
	}
	
	
	@RequestMapping(value= "/updatePosDStatus" , method = RequestMethod.POST)				 
	public ResponseEntity<ReturnMessage> updatePosDStatus (@RequestBody PosGridVO pgvo, SessionVO session) throws Exception{
		
		LOGGER.info("############################# pgvo : " + pgvo.toString());
		
		int userId = session.getUserId();
		posService.updatePosDStatus(pgvo, userId);
		
		//Return MSG
    	ReturnMessage message = new ReturnMessage();
    	
        message.setCode(AppConstants.SUCCESS);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    	
    	return ResponseEntity.ok(message);
	}
	
	
	@RequestMapping(value= "/updatePosMemStatus" , method = RequestMethod.POST)				 
	public ResponseEntity<ReturnMessage> updatePosMemStatus (@RequestBody PosGridVO pgvo, SessionVO session) throws Exception{
		
		LOGGER.info("############################# pgvo : " + pgvo.toString());
		int userId = session.getUserId();
		posService.updatePosMemStatus(pgvo, userId);
		
		//Return MSG
    	ReturnMessage message = new ReturnMessage();
    	
        message.setCode(AppConstants.SUCCESS);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    	
    	return ResponseEntity.ok(message);
	}
	
	
	@RequestMapping(value = "/getpayBranchList")
	public ResponseEntity<List<EgovMap>> getpayBranchList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> payBrnchMap = null;
		
		payBrnchMap = posService.getpayBranchList(params);
		
		return ResponseEntity.ok(payBrnchMap);
		
	}

	
	@RequestMapping(value = "/getDebtorAccList")
	public ResponseEntity<List<EgovMap>> getDebtorAccList(@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> debtorMap = null;
		
		debtorMap = posService.getDebtorAccList(params);
		
		return ResponseEntity.ok(debtorMap);
		
	}
	
	
	@RequestMapping(value = "/getBankAccountList")
	public ResponseEntity<List<EgovMap>> getBankAccountList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> bankAccList = null;
		
		bankAccList = posService.getBankAccountList(params);
		
		return ResponseEntity.ok(bankAccList);
	}
	
	
	@RequestMapping(value = "/selectAccountIdByBranchId")
	public ResponseEntity<EgovMap> selectAccountIdByBranchId(@RequestParam Map<String, Object> params) throws Exception{
		
		EgovMap accMap = null;
		
		accMap = posService.selectAccountIdByBranchId(params);
		
		return ResponseEntity.ok(accMap);
	}
	
	
	@RequestMapping(value = "/isPaymentKnowOffByPOSNo")
	public ResponseEntity<Boolean> isPaymentKnowOffByPOSNo(@RequestParam Map<String, Object> params) throws Exception{
		
		boolean isPay = false;
		
		isPay = posService.isPaymentKnowOffByPOSNo(params);
		
		LOGGER.info("########################### check Reversal Possible Check : " + isPay);
		
		return ResponseEntity.ok(isPay);
		
	}
	
	
	@RequestMapping(value = "/getPayDetailList")
	public ResponseEntity<List<EgovMap>> getPayDetailList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> payDList = null;
		
		payDList = posService.getPayDetailList(params);
		
		return ResponseEntity.ok(payDList);
		
	}
	
	@RequestMapping(value = "/getMemCode")
	public ResponseEntity<EgovMap> getMemCode(@RequestParam Map<String, Object> params) throws Exception{
		
		EgovMap memMap = null;
		memMap = posService.getMemCode(params);
		
		return ResponseEntity.ok(memMap);
		
	}
	
	
	@RequestMapping(value = "/posRawDataPop.do")
	public String posRawDataPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-7), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
		
		model.put("bfDay", bfDay);
		model.put("toDay", toDay);
		
		return "sales/pos/posRawDataPop";
	}
	
	
	@RequestMapping(value = "/insertTransactionLog")
	public ResponseEntity<ReturnMessage> insertTransactionLog(@RequestParam Map<String, Object> params, SessionVO session) throws Exception{
		
		params.put("userId", session.getUserId());
		
		posService.insertTransactionLog(params);
		
		//Return MSG
    	ReturnMessage message = new ReturnMessage();
    	
        message.setCode(AppConstants.SUCCESS);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
    	
    	return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/posPaymentListingPop.do")
	public String posPaymentListingPop(@RequestParam Map<String, Object> params) throws Exception{
		return "sales/pos/posPaymentListingPop";
	}
	
	
	@RequestMapping(value = "/chkMemIdByMemCode")
	public ResponseEntity<EgovMap> chkMemIdByMemCode(@RequestParam Map<String, Object> params) throws Exception{
		
		EgovMap memMap = null;
		memMap = posService.chkMemIdByMemCode(params);
		
		return ResponseEntity.ok(memMap);
	}
	
	
	@RequestMapping(value = "/chkUserIdByUserName")
	public ResponseEntity<EgovMap> chkUserIdByUserName(@RequestParam Map<String, Object> params) throws Exception{
		EgovMap idMap = null;
		idMap = posService.chkUserIdByUserName(params);
		return ResponseEntity.ok(idMap);
	}
}
