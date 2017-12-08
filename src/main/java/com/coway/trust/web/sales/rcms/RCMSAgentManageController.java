package com.coway.trust.web.sales.rcms;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.biz.sales.rcms.RCMSAgentManageService;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/sales/rcms")
public class RCMSAgentManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(RCMSAgentManageController.class);
	
	@Resource(name = "rcmsAgentManageService")
	private RCMSAgentManageService rcmsAgentService;
	
	
	@RequestMapping(value = "/selectRcmsAgentList.do")
	public String selectRcmsAgentList (@RequestParam Map<String, Object> params) throws Exception{
		
		return "sales/rcms/rcmsAgentManagementList";
	}
	
	
	@RequestMapping(value = "/selectAgentTypeList")
	public ResponseEntity<List<EgovMap>> selectAgentTypeList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> agentList = null;
		
		agentList = rcmsAgentService.selectAgentTypeList(params);
		
		return ResponseEntity.ok(agentList);
		
	}
}
