package com.coway.trust.web.services.as;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.InHouseRepairService;
import com.coway.trust.biz.services.as.ServicesLogisticsPFCService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/services/as")
public class ASManagementListController {
	private static final Logger logger = LoggerFactory.getLogger(ASManagementListController.class);
	
	@Resource(name = "ASManagementListService")
	private ASManagementListService ASManagementListService;
	
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	
	@Resource(name = "InHouseRepairService")
	private InHouseRepairService inHouseRepairService;
	

	@Resource(name = "servicesLogisticsPFCService")
	private ServicesLogisticsPFCService servicesLogisticsPFCService;

	
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	 
	
	/**
	 * Services - AS  - AS Management List 메인 화면
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/initASManagementList.do")
	public String initASManagementList(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "services/as/ASManagementList";
	}
	
	

	
	@RequestMapping(value = "/asResultInfo.do")
	public String asResultInfo(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
				
		return "services/as/inc_asResultInfoPop";
	}

	
	@RequestMapping(value = "/asResultInfoEdit.do")
	public String asResultInfoEdit(@RequestParam Map<String, Object> params, ModelMap model ,SessionVO sessionVO) {
		// 호출될 화면
				

		

		model.put("USER_ID", sessionVO.getUserId());
		model.put("USER_NAME", sessionVO.getUserName());

		model.put("BRANCH_NAME", sessionVO.getBranchName());
		model.put("BRANCH_ID", sessionVO.getUserBranchId());
		
		return "services/as/inc_asResultEditPop";
	}
	
	
	   

	
	@RequestMapping(value = "/asInHouseEntryPop.do")
	public String asInHouseEntryPop(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		
		logger.debug("===================>"+params.toString());

		
		model.put("ORD_ID",(String) params.get("ord_Id"));   
		model.put("ORD_NO",(String) params.get("ord_No"));
		model.put("AS_ID", (String)params.get("as_Id"));   
		model.put("AS_NO", (String)params.get("as_No")); 
		
				
		return "services/as/asInHouseEntryPop";
	}
	
	
	
	
	/**
	 * Services - AS  - AS Management List Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchASManagementList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectASManagementList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params : {}", params);
		
		String[] asTypeList =  request.getParameterValues("asType");
		String[] asStatusList =  request.getParameterValues("asStatus");
		
		String cmbbranchId =  request.getParameter("cmbbranchId");
		logger.debug("cmbbranchId : " + cmbbranchId);
		String cmbctId =  request.getParameter("cmbctId");
		logger.debug("cmbctId : " + cmbctId);
		
		params.put("asTypeList",asTypeList);
		params.put("asStatusList",asStatusList);
		params.put("cmbbranchId",cmbbranchId);
		params.put("cmbctId",cmbctId);
		
		List<EgovMap> ASMList = ASManagementListService.selectASManagementList(params);
		
	
		logger.debug("ASMList : {}", ASMList);
		return ResponseEntity.ok(ASMList);
	}
	
	/**
	 * Services - AS  - ASReceiveEntry 메인화면
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ASReceiveEntryPop.do")
	public String initASReceiveEntry(@RequestParam Map<String, Object> params, ModelMap model) {
		
			model.put("ORD_ID",(String) params.get("in_ordId"));   
			model.put("ORD_NO",(String) params.get("in_ordNo"));
			model.put("AS_ID", (String)params.get("in_asId"));   
			model.put("AS_NO", (String)params.get("in_asNo")); 
			model.put("AS_ResultNO", (String)params.get("asResultNo"));
			model.put("AS_ResultId", (String)params.get("in_asResultId"));
			
			
			if(! "".equals((String) params.get("in_ordId"))){
				return "services/as/ASReceiveEntryPop";
			}else{
				return "services/as/ASReceiveEntryPop";
			}
			
		
		// 호출될 화면
		
	}
	
	@RequestMapping(value = "/asResultViewPop.do")
	public String asResultViewPop(@RequestParam Map<String, Object> params, ModelMap model) {

		
		
		model.put("ORD_ID",(String) params.get("ord_Id"));   
		model.put("ORD_NO",(String) params.get("ord_No"));
		model.put("AS_ID", (String)params.get("as_Id"));   
		model.put("AS_NO", (String)params.get("as_No")); 
		
		// 호출될 화면
		return "services/as/asResultViewPop";
	}
	
	
	
	/**
	 * Services - AS  - ASReceiveEntry Order No search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchOrderNo" , method = RequestMethod.GET)
	public ResponseEntity<EgovMap> selectOrderNo(@RequestParam Map<String, Object> params, ModelMap model) {
		logger.debug("params : {}", params);
		EgovMap basicInfo = ASManagementListService.selectOrderBasicInfo(params);
		logger.debug("basicInfo : {}", basicInfo);
		// 호출될 화면
		return ResponseEntity.ok(basicInfo);
	}
	     
	
	@RequestMapping(value = "/resultASReceiveEntryPop.do" )
	public String resultASReceiveEntryPop(@RequestParam Map<String, Object> params, ModelMap model ,SessionVO sessionVO) throws Exception  {
		
		logger.debug("params : {}", params.toString());
		
		logger.debug("in resultASReceiveEntryPop :==>" +params.toString());
		params.put("orderNo", params.get("ordNo"));
		    
		//[Tap]Basic Info 
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params ,sessionVO);
		EgovMap as_ord_basicInfo = ASManagementListService.selectOrderBasicInfo(params);
		EgovMap asentryInfo =null;
		
		model.put("orderDetail", orderDetail);   
		model.put("as_ord_basicInfo", as_ord_basicInfo); 
		model.put("AS_NO", (String)params.get("AS_NO"));     
		model.put("AS_ID", (String)params.get("AS_ID")); 
		model.put("MOD", (String)params.get("mod"));   
		model.put("IN_AsResultId", (String)params.get("asResultId"));   
		
		//ASR인경우  SET ERRCODE 
		model.put("mafuncId", (String)params.get("mafuncId"));   
		model.put("mafuncResnId", (String)params.get("mafuncResnId"));   
        
		
		/*
		if("VIEW".equals(params.get("mod"))){
			asentryInfo = ASManagementListService.selASEntryView(params);
			model.put("asentryInfo", asentryInfo); 
		}
		*/ 
		//logger.debug("in orderDetail :==>" +orderDetail.toString());
		logger.debug("in as_ord_basicInfo :==>" +as_ord_basicInfo.toString());
		
		return "services/as/resultASReceiveEntryPop";
	}  
	
	
	
	/**
	 * Services - AS  - ASReceiveEntry Order No search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveASEntry.do" , method = RequestMethod.POST)
	public ResponseEntity<EgovMap> saveASEntry(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		
		
		logger.debug("saveASEntry in...."); 
		logger.debug("params :"+ params.toString());
		params.put("USER_ID", sessionVO.getUserId());
		
		EgovMap sm = ASManagementListService.saveASEntry(params);
		logger.debug("sm :"+ sm.toString());
		
		
		if( null !=sm){
			HashMap   spMap =(HashMap)sm.get("spMap");
			logger.debug("spMap :"+ spMap.toString());   
			if(! "000".equals(spMap.get("P_RESULT_MSG"))){
				sm.put("logerr","Y");
			}
			
			servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
		}
		
		
		// 호출될 화면
		return ResponseEntity.ok(sm);
	}
	
	
	

	/**
	 * Services - AS  - saveASInHouseEntry in house 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/saveASInHouseEntry.do" , method = RequestMethod.POST)
	public ResponseEntity<EgovMap> saveASInHouseEntry(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		
		
		logger.debug("saveASEntry in...."); 
		logger.debug("params :"+ params.toString());
		params.put("updator", sessionVO.getUserId());
		
		EgovMap sm = ASManagementListService.saveASInHouseEntry(params);
		
		// 호출될 화면
		return ResponseEntity.ok(sm);
	}
	
	
	

	/**
	 * Services - AS  - saveASInHouseEntry in house 
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateASInHouseEntry.do" , method = RequestMethod.POST)
	public ResponseEntity<EgovMap> updateASInHouseEntry(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		
		
		logger.debug("updateASInHouseEntry in...."); 
		logger.debug("params :"+ params.toString());
		params.put("updator", sessionVO.getUserId());
		
		EgovMap sm = ASManagementListService.updateASInHouseEntry(params);
		
		// 호출될 화면
		return ResponseEntity.ok(sm);
	}
	
	
	
	/**
	 * Services - AS  - ASReceiveEntry Order No search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateASEntry.do" , method = RequestMethod.POST)
	public ResponseEntity<EgovMap> updateASEntry(@RequestBody Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		
		
		logger.debug("updateASEntry in...."); 
		logger.debug("params :"+ params.toString());
		params.put("USER_ID", sessionVO.getUserId());
		EgovMap sm = ASManagementListService.updateASEntry(params);
		
		// 호출될 화면
		return ResponseEntity.ok(sm);
	}
	
	
	
	
	/**
	 * Services - AS  - ASReceiveEntry 메인화면
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/ASNewResultPop.do")
	public String insertASResult(@RequestParam Map<String, Object> params, ModelMap model ,SessionVO sessionVO) {
		// 호출될 화면
		
		model.put("ORD_ID",(String) params.get("ord_Id"));   
		model.put("ORD_NO",(String) params.get("ord_No"));
		model.put("AS_NO", (String)params.get("as_No"));    
		model.put("AS_ID", (String)params.get("as_Id"));   
		model.put("REF_REQST", (String)params.get("refReqst"));     
		

		model.put("USER_ID", sessionVO.getUserId());
		model.put("USER_NAME", sessionVO.getUserName());

		model.put("BRANCH_NAME", sessionVO.getBranchName());
		model.put("BRANCH_ID", sessionVO.getUserBranchId());
		
		
		return "services/as/newASResultPop";
	}
	
	

	@RequestMapping(value = "/asResultEditViewPop.do")
	public String asResultEditViewPop(@RequestParam Map<String, Object> params, ModelMap model  ,SessionVO sessionVO) {
		// 호출될 화면
		
		model.put("ORD_ID",(String) params.get("ord_Id"));   
		model.put("ORD_NO",(String) params.get("ord_No"));
		model.put("AS_NO", (String)params.get("as_No"));    
		model.put("AS_ID", (String)params.get("as_Id"));     
		model.put("AS_RESULT_NO", (String)params.get("as_Result_No"));
		model.put("AS_RESULT_ID", (String)params.get("as_Result_Id"));     
		model.put("MOD", (String)params.get("mod")); 
		
		

		model.put("USER_ID", sessionVO.getUserId());
		model.put("USER_NAME", sessionVO.getUserName());

		model.put("BRANCH_NAME", sessionVO.getBranchName());
		model.put("BRANCH_ID", sessionVO.getUserBranchId());
		
		
		
		
		return "services/as/asResultEditViewPop";
	}
	
	@RequestMapping(value = "/asResultEditBasicPop.do")
	public String asResultEditBasicPop(@RequestParam Map<String, Object> params, ModelMap model  ,SessionVO sessionVO) {
		// 호출될 화면
		
		model.put("ORD_ID",(String) params.get("ord_Id"));   
		model.put("ORD_NO",(String) params.get("ord_No"));
		model.put("AS_NO", (String)params.get("as_No"));    
		model.put("AS_ID", (String)params.get("as_Id"));     
		model.put("AS_RESULT_NO", (String)params.get("as_Result_No"));
		model.put("AS_RESULT_ID", (String)params.get("as_Result_Id"));     
		model.put("MOD", (String)params.get("mod")); 
		
		

		model.put("USER_ID", sessionVO.getUserId());
		model.put("USER_NAME", sessionVO.getUserName());

		model.put("BRANCH_NAME", sessionVO.getBranchName());
		model.put("BRANCH_ID", sessionVO.getUserBranchId());
		
		
		return "services/as/asResultEditBasicPop";
	}
	 
	 
	
	
	/**
	 * Services - AS  - AS Management List Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getASHistoryList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getASHistoryList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("in  getASHistoryList.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap> sHistoryList = ASManagementListService.getASHistoryList(params);
		 
		return ResponseEntity.ok(sHistoryList);
	}   
	  
	

	/**
	 * Services - AS  - AS Management List Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getBSHistoryList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getBSHistoryList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getBSHistoryList.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap>  bHistoryList = ASManagementListService.getBSHistoryList(params);
		
		return ResponseEntity.ok(bHistoryList);
	}
	
	

	/**
	 * Services - AS  - AS Management List Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getBrnchId", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getBrnchId(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getBrnchId.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap>  list = ASManagementListService.getBrnchId(params);
		
		return ResponseEntity.ok(list);
	}
	
	

	
	@RequestMapping(value = "/getMemberBymemberID", method = RequestMethod.GET)
	public  ResponseEntity<Map>  getMemberBymemberID(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getBrnchId.....");		
		logger.debug("params : {}", params.toString());
		
		 EgovMap   meminfo = ASManagementListService.getMemberBymemberID(params);
		
		 Map<String, Object> map = new HashMap();
		 map.put("mInfo", meminfo);
			
		return ResponseEntity.ok(map);
	}
	
	

	
	@RequestMapping(value = "/getTotalUnclaimItem", method = RequestMethod.GET)
	public  ResponseEntity<Map>  getTotalUnclaimItem(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getTotalUnclaimItem.....");		
		logger.debug("params : {}", params.toString());
		
		 EgovMap   meminfo = ASManagementListService.spFilterClaimCheck(params);
		
		 Map<String, Object> map = new HashMap();
		 map.put("filter", meminfo); 
			
		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/selASEntryView", method = RequestMethod.GET)
	public  ResponseEntity<Map>  selASEntryView(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  selASEntryView.....");		
		logger.debug("params : {}", params.toString());
		
		 EgovMap   meminfo = ASManagementListService.selASEntryView(params);
		
		 Map<String, Object> map = new HashMap();
		 map.put("asentryInfo", meminfo);
			
		return ResponseEntity.ok(map);
	}
	
	
	
	
	/**
	 * Services - AS  - AS Management List Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getASOrderInfo", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getASOrderInfo(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getASOrderInfo.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap>  list = ASManagementListService.getASOrderInfo(params);
		
		return ResponseEntity.ok(list);
	}
	
	
	/**
	 * Services - AS  - AS Management List Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getASEvntsInfo", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getASEvntsInfo(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getASEvntsInfo.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap>  list = ASManagementListService.getASEvntsInfo(params);
		
		return ResponseEntity.ok(list);
	}
	
	
	/**
	 * Services - AS  - AS Management List Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getASHistoryInfo", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getASHistoryInfo(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getASHistoryInfo.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap>  list = ASManagementListService.getASHistoryInfo(params);
		
		return ResponseEntity.ok(list);
	}
	
	
	/**
	 * Services - AS  - AS Management List Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getASStockPrice", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getASStockPrice(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getASStockPrice.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap>  list = ASManagementListService.getASStockPrice(params);
		
		return ResponseEntity.ok(list);
	}
	
	

	/**
	 * Services - AS  - AS Management List Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getASFilterInfo", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getASFilterInfo(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getASFilterInfo.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap>  list = ASManagementListService.getASFilterInfo(params);
		
		return ResponseEntity.ok(list);  
	}
	
	/**
	 * Services - AS  - AS Management List Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getASReasonCode", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getASReasonCode(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getASReasonCode.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap>  list = ASManagementListService.getASReasonCode(params);
		
		return ResponseEntity.ok(list);  
	}
	
	
	/**
	 * Services - AS  - AS Management List Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getASReasonCode2", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getASReasonCode2(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getASReasonCode.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap>  list = ASManagementListService.getASReasonCode2(params);
		
		return ResponseEntity.ok(list);  
	}
	
	
	
	/**
	 * Services - AS  - AS Management List Search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/getASMember", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getASMember(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getASMember.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap>  list = ASManagementListService.getASMember(params);
		
		return ResponseEntity.ok(list);  
	}
	
	@RequestMapping(value = "/getCallLog", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getCallLog(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getCallLog.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap>  list = ASManagementListService.getCallLog(params);
		
		return ResponseEntity.ok(list);  
	}
	
	
	@RequestMapping(value = "/getASRulstSVC0004DInfo", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getASRulstSVC0004DInfo(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getASRulstSVC0004DInfo.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap>  list = ASManagementListService.getASRulstSVC0004DInfo(params);
		
		return ResponseEntity.ok(list);  
	}
	
	@RequestMapping(value = "/getASRulstEditFilterInfo", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getASRulstEditFilterInfo(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  getASRulstEditFilterInfo.....");		
		logger.debug("params : {}", params.toString());
		
		List<EgovMap>  list = ASManagementListService.getASRulstEditFilterInfo(params);
		
		return ResponseEntity.ok(list);  
	}
	
	
	@RequestMapping(value = "/selectASDataInfo", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectASDataInfo(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  selectASDataInfo.....");		
		logger.debug("params : {}", params.toString());
		List<EgovMap>  list = ASManagementListService.selectASDataInfo(params);
		return ResponseEntity.ok(list);  
	}
	
	
	
	
	
	
	

	@RequestMapping(value = "/newResultAdd.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> newResultAdd(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {
		
		logger.debug("in  newResultAdd ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");  
		
		params.put("updator", sessionVO.getUserId());   
		
		LinkedHashMap  asResultM = (LinkedHashMap)  params.get("asResultM");
		List<EgovMap>  add			= (List<EgovMap>)  params.get("add");
		List<EgovMap>  remove	= (List<EgovMap>)  params.get("remove");
		List<EgovMap>  update 	= (List<EgovMap>)  params.get("update");
		   
		logger.debug("asResultM ===>"+asResultM.toString());  
		logger.debug("add ===>"+add.toString());
		logger.debug("remove ===>"+remove.toString());
		logger.debug("update ===>"+update.toString());
		
		
		
		ReturnMessage message = new ReturnMessage();
		
		HashMap   mp= new HashMap();
		mp.put("serviceNo", asResultM.get("AS_NO"));
		int  isAsCnt =	 ASManagementListService.isAsAlreadyResult(mp);
		
		
		 if(isAsCnt == 0){
    		EgovMap  rtnValue = ASManagementListService.asResult_insert(params);  
    		if( null !=rtnValue){
    			HashMap   spMap =(HashMap)rtnValue.get("spMap");
    			logger.debug("spMap :"+ spMap.toString());   
    			if(! "000".equals(spMap.get("P_RESULT_MSG"))){
    				rtnValue.put("logerr","Y");
    			}
    			servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
    		}
    		message.setCode(AppConstants.SUCCESS);
    		message.setData(rtnValue.get("AS_NO"));
    		message.setMessage("");
		
		 }else{
			 message.setCode("98");
			 message.setData(asResultM.get("AS_NO"));
	         message.setMessage("There is complete result exist already");
		 }
		
		return ResponseEntity.ok(message);  
		
	}
	
	
	@RequestMapping(value = "/newResultUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> newResultUpdate(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {
		
		logger.debug("in  newResultUpdate ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");  
		
		params.put("updator", sessionVO.getUserId());   
		
		LinkedHashMap  asResultM = (LinkedHashMap)  params.get("asResultM");
		List<EgovMap>  add			= (List<EgovMap>)  params.get("add");
		List<EgovMap>  remove	= (List<EgovMap>)  params.get("remove");
		List<EgovMap>  update 	= (List<EgovMap>)  params.get("update");
		   
		logger.debug("asResultM ===>"+asResultM.toString());  
		logger.debug("add ===>"+add.toString());
		logger.debug("remove ===>"+remove.toString());
		logger.debug("update ===>"+update.toString()); 
		
		EgovMap  rtnValue = ASManagementListService.asResult_update(params);  
		
		
		logger.debug("newResultUpdate   done!!--->"+rtnValue.toString());  
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(rtnValue.get("AS_NO"));
		message.setMessage("");

				
		return ResponseEntity.ok(message);  
		
	}
	
	
	@RequestMapping(value = "/newResultBasicUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> newResultBasicUpdate(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {
		
		logger.debug("in  newResultBasicUpdate ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");  
		
		params.put("updator", sessionVO.getUserId());     
		
		LinkedHashMap  asResultM = (LinkedHashMap)  params.get("asResultM");
		   
		logger.debug("asResultM ===>"+asResultM.toString());  
		
		int  rtnValue = ASManagementListService.asResultBasic_update(params);  
		
		ReturnMessage message = new ReturnMessage();
		
		if(rtnValue >0 ){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		return ResponseEntity.ok(message);  
	}
	
	

	@RequestMapping(value = "/addASRemark.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> addASRemark(@RequestParam Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {
		
		logger.debug("in  addASRemark ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");  
		
		params.put("USER_ID", sessionVO.getUserId());   
		   
	    //CCR0007d
		params.put("AS_ID", params.get("asId"));
		params.put("CALL_STUS_ID",  "40");
		params.put("CALL_FDBCK_ID", "0");
		params.put("CALL_REM",  params.get("callRem"));
		params.put("CALL_HC_ID",  "0");
		params.put("CALL_ROS_AMT",  "0");
		params.put("CALL_SMS", "0");
		params.put("CALL_SMS_REM" ,"");
		
		
		int  rtnValue = ASManagementListService.addASRemark(params);  
		
		ReturnMessage message = new ReturnMessage();
		if(rtnValue >0 ){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		return ResponseEntity.ok(message);  
		
	}
	
	
	@RequestMapping(value = "/addASRemarkPop.do")
	public String addASRemarkPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("AS_ID", (String)params.get("asId"));   
		
		// 호출될 화면
		return "services/as/addASRemarkPop";
	}
	
	

	
	@RequestMapping(value = "/assignCTTransferPop.do")
	public String assignCTTransferPop(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("in  assignCTTransferPop ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");  
		
		// 호출될 화면
		return "services/as/assignCTTransferPop"; 
	}
	
	

	@RequestMapping(value = "/assignCtList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> assignCtList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("in  assignCtList.....");		
		logger.debug("params : {}", params.toString());
		//BRNCH_ID
		List<EgovMap>  list = ASManagementListService.assignCtList(params);
		
		return ResponseEntity.ok(list);  
	}
	
	
	@RequestMapping(value = "/assignCtOrderList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> assignCtOrderList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("in  assignCtOrderList.....");		
		logger.debug("params : {}", params.toString());
		
		String vAsNo =  (String)params.get("asNo");
		String[] asNo =  null;
		
		if(! StringUtils.isEmpty(vAsNo)){ 
			asNo =  ((String)params.get("asNo")).split(",");
			params.put("asNo" ,asNo);
		}
		
		List<EgovMap>  list =  ASManagementListService.assignCtOrderList(params);
		
		return ResponseEntity.ok(list);  
	}
	
	


	@RequestMapping(value = "/assignCtOrderListSave.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> assignCtOrderListSave(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {
		
		logger.debug("in  assignCtOrderListSave ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");  
		
		params.put("updator", sessionVO.getUserId());   
		List<EgovMap>  update 	= (List<EgovMap>)  params.get("update");
		logger.debug("asResultM ===>"+update.toString());  
		
		int   rtnValue = ASManagementListService.updateAssignCT(params);  
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(99);
		message.setMessage("");

				
		return ResponseEntity.ok(message);  
		
	}
	
	@RequestMapping(value = "/selectCTByDSC.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCTMByDSC( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> selectCTSubGroupDscList = ASManagementListService.selectCTByDSC(params);
		logger.debug("selectCTSubGroupDscList {}", selectCTSubGroupDscList);
		return ResponseEntity.ok(selectCTSubGroupDscList);
	}
	
	
	
	
	@RequestMapping(value = "/inHouseGetProductMasters.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> inHouseGetProductMasters( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> getProductMasters = inHouseRepairService.getProductMasters(params);
		logger.debug("GetProductMasters {}", getProductMasters);
		return ResponseEntity.ok(getProductMasters);
	}
	
	@RequestMapping(value = "/inHouseGetProductDetails.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> inHouseGetProductDetails( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
	
		logger.debug("params {}", params);
		List<EgovMap> getProductDetails = inHouseRepairService.getProductDetails(params);
		logger.debug("getProductDetails {}", getProductDetails);
		return ResponseEntity.ok(getProductDetails);
	}
	
	
	@RequestMapping(value = "/inHouseIsAbStck.do", method = RequestMethod.GET)
	public ResponseEntity <EgovMap> inHouseIsAbStck( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		
		logger.debug("params {}", params);
		EgovMap  isAbStck = inHouseRepairService.isAbStck(params); 
		logger.debug("isAbStck {}", isAbStck);
		return ResponseEntity.ok(isAbStck);
	}
	
	

	@RequestMapping(value = "/newASInHouseAdd.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> newASInHouseAdd(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {
		
		logger.debug("in  newASInHouseAdd ");
		logger.debug("			pram set  log");
		logger.debug("					" + params.toString());
		logger.debug("			pram set end  ");  
		
		params.put("updator", sessionVO.getUserId());    
		
		

		ReturnMessage message = new ReturnMessage();
		
		HashMap   mp= new HashMap();
		Map  svc0004dmap =   (Map) params.get("asResultM");//hash
		mp.put("serviceNo", svc0004dmap.get("AS_NO"));
		int  isAsCnt =	 ASManagementListService.isAsAlreadyResult(mp);
		
		
		 if(isAsCnt == 0){
        		EgovMap  rtnValue = ASManagementListService.asResult_insert(params);  
        		
        		if( null !=rtnValue){
        			HashMap   spMap =(HashMap)rtnValue.get("spMap");
        			logger.debug("spMap :"+ spMap.toString());   
        			if(! "000".equals(spMap.get("P_RESULT_MSG"))){
        				rtnValue.put("logerr","Y");
        			}
        			  servicesLogisticsPFCService.SP_SVC_LOGISTIC_REQUEST(spMap);
        			  logger.debug("			SP_SVC_LOGISTIC_REQUEST===> "+spMap.toString());  
        		}
        		

        		message.setCode(AppConstants.SUCCESS);
        	    message.setData(rtnValue.get("asNo"));  
        		message.setMessage("");
        		
		 }else{

				message.setCode("98");
			    message.setData( svc0004dmap.get("AS_NO") );  
		        message.setMessage("There is complete result exist already");
		 }	
				
		return ResponseEntity.ok(message);  
		
	}
	
	

	
	@RequestMapping(value = "/getErrMstList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getErrMstList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		List<EgovMap> getErrMstList = ASManagementListService.getErrMstList(params);
		logger.debug("getErrMstList {}", getErrMstList);
		return ResponseEntity.ok(getErrMstList);
	}

	
	@RequestMapping(value = "/getErrDetilList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getErrDetilList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		
		List<EgovMap> getErrDetilList = ASManagementListService.getErrDetilList(params);
		logger.debug("getErrDetilList {}", getErrDetilList);
		return ResponseEntity.ok(getErrDetilList);
	}
	
	
	

	@RequestMapping(value = "/getSLUTN_CODE_List.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getSLUTN_CODE_List( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		
		List<EgovMap> getSLUTN_CODE_List = ASManagementListService.getSLUTN_CODE_List(params);
		logger.debug("getErrDetilList {}", getSLUTN_CODE_List);
		return ResponseEntity.ok(getSLUTN_CODE_List);
	}
	
	
	

	@RequestMapping(value = "/getDTAIL_DEFECT_List.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getDTAIL_DEFECT_List( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		
		List<EgovMap> getDTAIL_DEFECT_List = ASManagementListService.getDTAIL_DEFECT_List(params);
		logger.debug("getErrDetilList {}", getDTAIL_DEFECT_List);
		return ResponseEntity.ok(getDTAIL_DEFECT_List);
	}
	
	
	

	@RequestMapping(value = "/getDEFECT_PART_List.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getDEFECT_PART_List( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		
		List<EgovMap> getDEFECT_PART_List = ASManagementListService.getDEFECT_PART_List(params);
		logger.debug("getErrDetilList {}", getDEFECT_PART_List);
		return ResponseEntity.ok(getDEFECT_PART_List);
	}
	
	
	

	@RequestMapping(value = "/getDEFECT_CODE_List.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getDEFECT_CODE_List( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		
		List<EgovMap> getDEFECT_CODE_List = ASManagementListService.getDEFECT_CODE_List(params);
		logger.debug("getErrDetilList {}", getDEFECT_CODE_List);
		return ResponseEntity.ok(getDEFECT_CODE_List);
	}
	
	
	

	@RequestMapping(value = "/getDEFECT_TYPE_List.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> getDEFECT_TYPE_List( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		logger.debug("params {}", params);
		
		List<EgovMap> getDEFECT_TYPE_List = ASManagementListService.getDEFECT_TYPE_List(params);
		logger.debug("getErrDetilList {}", getDEFECT_TYPE_List);
		return ResponseEntity.ok(getDEFECT_TYPE_List);
	}
	
	
}
