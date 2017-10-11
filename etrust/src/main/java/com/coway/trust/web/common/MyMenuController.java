package com.coway.trust.web.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.MyMenuService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class MyMenuController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MyMenuController.class);	
	
	@Autowired
	private MyMenuService myMenuService;
	
	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/myMenu.do")
	public String myMenu(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {				
		LOGGER.debug("Call MyMenu Init");		
		return "common/mymenu";
	}
	
	@RequestMapping(value = "/selectMyMenuList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMyMenuList(@RequestParam Map<String, Object> params, ModelMap model) {		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		LOGGER.debug("Select MyMenu Param ",params.toString());
		return ResponseEntity.ok(myMenuService.selectMyMenuList(params,sessionVO));
	}
	
	@RequestMapping(value = "/saveMyMenuList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveMyMenuList(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model) {		
		LOGGER.debug("Save MyMenu");
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		myMenuService.saveMyMenu(params, sessionVO);
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		//message.setData(cnt);
		//message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);		
	}
	
	@RequestMapping(value = "/selectMyMenuProgrmList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMyMenuProgrmList(@RequestParam Map<String, Object> params, ModelMap model) {		
		LOGGER.debug("Select MyMenu Progrm");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		return ResponseEntity.ok(myMenuService.selectMyMenuProgrmList(params, sessionVO));
	}
	
	@RequestMapping(value = "/savetMyMenuProgrmList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> savetMyMenuProgrmList(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model) {		
		LOGGER.debug("Save MyMenu Progrm");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		myMenuService.saveMyMenuProgrm(params, sessionVO);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/menuPop.do")
	public String menuPop(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {							
		return "common/menuPop";
	}
	
	@RequestMapping(value = "/selectMenuPop.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMenuPop(@RequestParam Map<String, Object> params, ModelMap model) {						
		return ResponseEntity.ok(myMenuService.selectMenuPop(params));
	}
	
	@RequestMapping(value = "/mymenuPop.do")
	public String mymenuPop(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {							
		return "common/mymenuPop";
	}
}
