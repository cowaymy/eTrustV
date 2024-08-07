package com.coway.trust.web.organization.organization;

import java.io.IOException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.organization.organization.AllocationService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.config.excel.ExcelReadComponent;
import com.coway.trust.web.organization.organization.excel.TerritoryRawDataVO;
   
import egovframework.rte.psl.dataaccess.util.EgovMap; 

@Controller
@RequestMapping(value = "/organization/allocation")


public class AllocationController {
	private static final Logger logger = LoggerFactory.getLogger(AllocationController.class);
	
	@Resource(name = "allocationService")
	private AllocationService allocationService;
	
	@Resource(name = "commonService") 
	private CommonService commonService;
	
	
	/** 
	 * organization territoryList page  
	 *
	 * @param request
	 * @param model 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/allocation.do")
	public String main(@RequestParam Map<String, Object> params, ModelMap model) {
		
		logger.debug("===================>");
		logger.debug(params.toString());
		model.addAttribute("ORD_ID",params.get("ORD_ID"));
		model.addAttribute("S_DATE",params.get("S_DATE"));    
		model.addAttribute("TYPE",params.get("TYPE"));    
		model.addAttribute("CallBackFun",params.get("OPTIONS[CallBackFun]"));
		    
		// 호출될 화면  
		return "organization/organization/allocationListPop";  
	}
	
	
	

	@RequestMapping(value = "/selectList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectList(@RequestParam Map<String, Object>params) {
        
		logger.debug(" in selectList ...");
		logger.debug(" in selectList prams ["+params.toString()+"]");
		List<EgovMap> resultList = allocationService.selectList(params);        
		
		if(null !=resultList){
			logger.debug(" selectList ===> out ["+resultList.toString()+"]");   
		}

		return ResponseEntity.ok(resultList);
	}
	
	
	
	
	@RequestMapping(value = "/selectDetailList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectDetailList(@RequestParam Map<String, Object>params) {
      

		logger.debug(" in selectDetailList ...");
		logger.debug(" in selectDetailList prams ["+params.toString()+"]");
		
		List<EgovMap> resultList = allocationService.selectDetailList(params);        

		return ResponseEntity.ok(resultList);
	}
	
}
