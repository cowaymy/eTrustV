package com.coway.trust.web.services.as;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
		
		params.put("asTypeList",asTypeList);
		params.put("asStatusList",asStatusList);
		
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
		// 호출될 화면
		return "services/as/ASReceiveEntryPop";
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
	public String resultASReceiveEntryPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception  {
		
		logger.debug("params : {}", params.toString());
		
		logger.debug("in resultASReceiveEntryPop :==>" +params.toString());
		params.put("orderNo", params.get("ordNo"));
		  
		    
		//[Tap]Basic Info 
		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params);
		EgovMap as_ord_basicInfo = ASManagementListService.selectOrderBasicInfo(params);
		EgovMap asentryInfo =null;
		
		model.put("orderDetail", orderDetail);   
		model.put("as_ord_basicInfo", as_ord_basicInfo); 
		model.put("AS_NO", (String)params.get("AS_NO"));   
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
	 * Services - AS  - ASReceiveEntry Order No search
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/addASNo.do")
	public ResponseEntity<ReturnMessage> insertAddASNo(@RequestParam Map<String, Object> params, ModelMap model,SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		boolean success =false; 
		logger.debug("params : {}", params);
		success = ASManagementListService.insertASNo(params,sessionVO);
		
		// 호출될 화면
		return ResponseEntity.ok(message);
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
	public String insertASResult(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		
		model.put("ORD_ID",(String) params.get("ord_Id"));   
		model.put("ORD_NO",(String) params.get("ord_No"));
		model.put("AS_NO", (String)params.get("as_No"));    
		model.put("AS_ID", (String)params.get("as_Id"));   
		return "services/as/newASResultPop";
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
		
		EgovMap  rtnValue = ASManagementListService.asResult_insert(params);  
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(99);
		message.setMessage("");

				
		return ResponseEntity.ok(message);  
		
	}
	
	
}
