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

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/ccp") 
public class CcpAgreementController {

	
	private static final Logger logger = LoggerFactory.getLogger(CcpAgreementController.class);
	
	@Resource(name = "ccpAgreementService")
	private CcpAgreementService ccpAgreementService;
	
	
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
		
		logger.info("########## selectCcpAgreementJsonList Start ############");
		
	    ccpAgrList = ccpAgreementService.selectContactAgreementList(params);
		
		return ResponseEntity.ok(ccpAgrList);
		
	}
	
}

