package com.coway.trust.web.sales.ccp;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.ccp.CcpAgreementService;
import com.coway.trust.biz.sales.order.OrderDetailService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/ccp") 
public class CcpAgreementController {

	
	private static final Logger LOGGER = LoggerFactory.getLogger(CcpAgreementController.class);
	
	@Resource(name = "ccpAgreementService")
	private CcpAgreementService ccpAgreementService;
	
	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;
	
	@RequestMapping(value = "/selectCcpAgreementList.do")
	public String selectCcpAgreementList (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		return "sales/ccp/ccpAgreementList";
	}
	
	
	@RequestMapping(value = "/selectCcpAgreementJsonList" , method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCcpAgreementJsonList (@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) throws Exception{
		
		List<EgovMap> ccpAgrList = null;
		
		String govAgPrgsIdList[] = request.getParameterValues("progressVal");
		String govAgStusIdList[] = request.getParameterValues("statusVal");
		String govAgTypeIdList[] = request.getParameterValues("typeVal");
		
		params.put("govAgPrgsIdList", govAgPrgsIdList);
		params.put("govAgStusIdList", govAgStusIdList);
		params.put("govAgTypeIdList", govAgTypeIdList);
		
		LOGGER.info("########## selectCcpAgreementJsonList Start ############");
		
	    ccpAgrList = ccpAgreementService.selectContactAgreementList(params);
		
		return ResponseEntity.ok(ccpAgrList);
		
	}
	
	
	@RequestMapping(value = "/insertCcpAgreementSearch.do") 
	public String insertCcpAgreementSearch (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		return "sales/ccp/ccpAgreementNewSearch";
	}
	
	
	@RequestMapping(value = "/getOrderId", method = RequestMethod.GET)
	public ResponseEntity<EgovMap> getOrderId(@RequestParam Map<String, Object> params) throws Exception{
		
		EgovMap resultMap = null;
		//서비스
		resultMap = ccpAgreementService.getOrderId(params);
		
		return ResponseEntity.ok(resultMap);
	}
	
	
	@RequestMapping(value = "/getOrderDetailInfo.do", method = RequestMethod.POST)
	public String getOrderDetailInfo (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		int prgrsId = 0;
		
		params.put("prgrsId", prgrsId);

		EgovMap orderDetail = orderDetailService.selectOrderBasicInfo(params);
		
		model.put("orderDetail", orderDetail);
		model.put("salesOrderNo", params.get("salesOrderNo"));
		
		return "sales/ccp/ccpAgreementNewSearchResult";
	}
	
	
	@RequestMapping(value = "/selectAfterServiceJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAfterServiceJsonList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> afServiceList = null;
		
		afServiceList = ccpAgreementService.selectAfterServiceJsonList(params);
		
		return ResponseEntity.ok(afServiceList);
		
	}
	
	
	@RequestMapping(value = "/selectBeforeServiceJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBeforeServiceJsonList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> afServiceList = null;
		
		afServiceList = ccpAgreementService.selectBeforeServiceJsonList(params);
		
		return ResponseEntity.ok(afServiceList);
		
	}
	
	
	@RequestMapping(value = "/searchOrderNoPop.do")
	public String	searchOrderNoPop (@RequestParam Map<String, Object> params) throws Exception{
		
		return "sales/ccp/ccpAgreementSearchOrderNoPop";
	}
	
	
	@RequestMapping(value = "/selectsearchOrderNo")
	public ResponseEntity<List<EgovMap>> selectsearchOrderNo (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> ordList = null;
		
		ordList = ccpAgreementService.selectSearchOrderNo(params);
		
		return ResponseEntity.ok(ordList);
		
	}
	
	
	@RequestMapping(value = "/searchMemberPop.do")
	public String searchMemberPop (@RequestParam Map<String, Object> params) throws Exception{
		
		return "sales/ccp/ccpAgreementSearchMemberPop";
	}
	
	
	@RequestMapping(value = "/selectSearchMemberCode")
	public ResponseEntity<List<EgovMap>> selectSearchMemberCode (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> memList = null;
		
		memList = ccpAgreementService.selectSearchMemberCode(params);
		
		return ResponseEntity.ok(memList);
	}
	
	@RequestMapping(value = "/getMemCodeConfirm")
	public ResponseEntity<EgovMap> getMemCodeConfirm (@RequestParam Map<String, Object> params) throws Exception{
		
		EgovMap memMap = null;
		
		memMap = ccpAgreementService.getMemCodeConfirm(params);
		
		return ResponseEntity.ok(memMap);
	}
}

