package com.coway.trust.web.sales.rcms;

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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.rcms.RCMSAgentManageService;

import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/sales/rcms")
public class RCMSAgentManageController {

	private static final Logger LOGGER = LoggerFactory.getLogger(RCMSAgentManageController.class);
	
	@Resource(name = "rcmsAgentManageService")
	private RCMSAgentManageService rcmsAgentService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	
	@RequestMapping(value = "/selectRcmsAgentList.do")
	public String selectRcmsAgentList (@RequestParam Map<String, Object> params) throws Exception{
		
		return "sales/rcms/rcmsAgentManagementList";
	}
	
	@RequestMapping(value = "/rcmsAssignAgentList.do")
	public String rcmsAssignAgent (@RequestParam Map<String, Object> params) throws Exception{
		
		return "sales/rcms/rcmsAssignAgentList";
	}
	
	@RequestMapping(value = "/selectAgentTypeList")
	public ResponseEntity<List<EgovMap>> selectAgentTypeList (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> agentList = null;
		
		agentList = rcmsAgentService.selectAgentTypeList(params);
		
		return ResponseEntity.ok(agentList);
	}
	
	
	@RequestMapping(value = "/checkWebId")
	public ResponseEntity<List<Object>> checkWebId (@RequestBody Map<String, Object> params) throws Exception{
		
		List<Object> resultList = rcmsAgentService.checkWebId(params);
		
		return ResponseEntity.ok(resultList);
	}
	
	
	
	@RequestMapping(value = "/chkDupWebId")
	public ResponseEntity<List<Object>> chkDupWebId (@RequestBody Map<String, Object> params) throws Exception{
		
		List<Object> resultList = rcmsAgentService.chkDupWebId(params);
		
		return ResponseEntity.ok(resultList);
	}
	
	
	@RequestMapping(value = "/insUpdAgent.do")
	public ResponseEntity<ReturnMessage> insUpdAgent(@RequestBody Map<String, Object> params , SessionVO session) throws Exception{
		
		params.put("crtUserId", session.getUserId());
		rcmsAgentService.insUpdAgent(params);
		
		//Return Message
		ReturnMessage message = new ReturnMessage();
    	message.setCode(AppConstants.SUCCESS);
    	message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		
		return ResponseEntity.ok(message);
	}
	
	
	@RequestMapping(value = "/selectAgentList")
	public ResponseEntity<List<EgovMap>> selectAgentList (@RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception{
		
		List<EgovMap> agentList = null;
		
		String typeArr[] =  request.getParameterValues("agentType");
		String statusArr[] = request.getParameterValues("agentStatus");
				
		params.put("typeList", typeArr);
		params.put("statusList", statusArr);
		
		agentList = rcmsAgentService.selectAgentList(params);
		
		return ResponseEntity.ok(agentList);
		
	}
	
	
	@RequestMapping(value = "/selectRosCaller")
	public ResponseEntity<List<EgovMap>> selectRosCaller (@RequestParam Map<String, Object> params) throws Exception{
		
		List<EgovMap> rosCallertList = null;
		
		rosCallertList = rcmsAgentService.selectRosCaller();
		
		return ResponseEntity.ok(rosCallertList);
		
	}
	
	@RequestMapping(value = "/selectAssignAgentList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAssignAgentList (@RequestParam Map<String, Object> params,
			HttpServletRequest request, ModelMap model) throws Exception{

		LOGGER.debug("param ===================>>  " + params);
		
		String rentalStatus[] = request.getParameterValues("rentalStatus");
		String companyType[] = request.getParameterValues("companyType");
		String openMonth[] = request.getParameterValues("openMonth");
		String rosCaller[] = request.getParameterValues("rosCaller");
		

		params.put("rentalStatus", rentalStatus);
		params.put("companyType", companyType);
		params.put("openMonth", openMonth);
		params.put("rosCaller", rosCaller);

		
		List<EgovMap> assignAgentList = null;
		
		assignAgentList = rcmsAgentService.selectAssignAgentList(params);
		
		return ResponseEntity.ok(assignAgentList);
		
	}
	
	@RequestMapping(value = "/saveAssignAgent", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveAssignAgent(@RequestBody Map<String, Object> params, Model model  ,HttpServletRequest request, SessionVO sessionVO) {
			
		LOGGER.debug("param ===================>>  " + params);
		
		params.put("userId", sessionVO.getUserId());
		
		rcmsAgentService.saveAssignAgent(params);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData("");
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);  
		
	}
	
	
}
