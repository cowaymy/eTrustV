package com.coway.trust.web.sales.ccp;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.ccp.CcpRentMemShipService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/ccp")
public class CcpRentMemShipController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CcpRentMemShipController.class);
	
	@Resource(name = "ccpRentMemShipService")
	private CcpRentMemShipService ccpRentMemShipService;
	
	@RequestMapping(value = "/selectCcpRentList.do")
	public String selectCcpRentList (@RequestParam Map<String, Object>  Params) throws Exception{
		LOGGER.info("################ go To Ccp Rent Membership List");
		
		return "sales/ccp/ccpRentMemShipList";
	}
	
	
	@RequestMapping(value = "/getBranchCodeList")
	public ResponseEntity<List<EgovMap>> getBranchCodeList() throws Exception{
		
		LOGGER.info("#############################################");
		LOGGER.info("#############get Branch Code List Start");
		LOGGER.info("#############################################");
		
		List<EgovMap> branchMap = null;
		
		branchMap = ccpRentMemShipService.getBranchCodeList();
		
		return ResponseEntity.ok(branchMap);
		
	}
	
	
	@RequestMapping(value = "/getReasonCodeList")
	public ResponseEntity<List<EgovMap>> getReasonCodeList()throws Exception{
		
		LOGGER.info("#############################################");
		LOGGER.info("#############getReasonCodeList Start");
		LOGGER.info("#############################################");
		
		List<EgovMap> regionMap = null;
		
		regionMap = ccpRentMemShipService.getReasonCodeList();
		
		return ResponseEntity.ok(regionMap);
		
	}
	
	
	@RequestMapping(value = "/selectCcpRentListSearchList")
	public ResponseEntity<List<EgovMap>> selectCcpRentListSearchList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception{
		
		LOGGER.info("#############################################");
		LOGGER.info("#############selectCcpRentListSearchList Start");
		LOGGER.info("#############################################");
		
		String arryStatus[] = request.getParameterValues("memShipStatus");
		String arryBranch[] = request.getParameterValues("keyInBranch");
		String arryReason[] = request.getParameterValues("reasonCode");
	
		//params Set
		params.put("arryStatus", arryStatus);
		params.put("arryBranch", arryBranch);
		params.put("arryReason", arryReason);
		
		List<EgovMap> resultList = null;
		
		resultList = ccpRentMemShipService.selectCcpRentListSearchList(params);
		
		return ResponseEntity.ok(resultList);
		
		
	}
}
