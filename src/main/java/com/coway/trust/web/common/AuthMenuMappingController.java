package com.coway.trust.web.common;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import com.coway.trust.biz.common.AuthMenuMappingService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/common")
public class AuthMenuMappingController {

	private static final Logger LOGGER = LoggerFactory.getLogger(AuthMenuMappingController.class);	
	
	@Autowired
	private AuthMenuMappingService authMenuMappingsService;
	
	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/authMenuMapping.do")
	public String myMenu(@RequestParam Map<String, Object> params, SessionVO sessionVO,
			ModelMap model) {				
		LOGGER.debug("Call MyMenu Init");		
		return "common/authMenuMapping";
	}
	
	@RequestMapping(value = "/selectAuthList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAuthList(@RequestParam Map<String, Object> params, ModelMap model) {		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		LOGGER.debug("Select Auth ",params.toString());
		return ResponseEntity.ok(authMenuMappingsService.selectAuthList(params,sessionVO));
	}	
	
	@RequestMapping(value = "/selectAuthMenuMappingList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectAuthMenuMappingList(@RequestParam Map<String, Object> params, ModelMap model) {		
		LOGGER.debug("Select Auth Menu Mapping");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		return ResponseEntity.ok(authMenuMappingsService.selectAuthMenuMappingList(params, sessionVO));
	}
	
	@RequestMapping(value = "/saveAuthMenuMappingList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> savetAuthMenuMappingList(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model) {		
		LOGGER.debug("Save Auth Menu Mapping");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		authMenuMappingsService.saveAuthMenuMappingList(params, sessionVO);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/newAuthAccessCopyPop.do")
	public String newAuthAccessCopyPop(@RequestParam Map<String, Object> params, SessionVO sessionVO, ModelMap model) {
		LOGGER.debug("Call newAuthAccessCopyPop Init");
		return "common/newAuthAccessCopyPop";
	}

	@RequestMapping(value = "/selectMultAuthMenuMappingList.do")//, method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectMultAuthMenuMappingList(@RequestBody Map<String, Object> params, ModelMap model,HttpServletRequest request) {
		LOGGER.debug("Select Auth Menu Mapping");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		/*String[] authList   = request.getParameterValues("authList");

		if(authList      != null && !CommonUtils.containsEmpty(authList))      {
			params.put("authCode", authList);
		}*/

		List<Map<String, Object>> gridList = (List<Map<String, Object>>) params.get("gridData");
		String[] authList = new String[gridList.size()] ;
		int k = 0;
		if(gridList.size() > 0){
			for(int i=0; i<gridList.size(); i++){
				Map<String, Object> gridData = (Map<String, Object>) gridList.get(i);
				authList[k] =  gridData.get("authCode").toString();
				k++;
			}
			params.put("authCode", authList);
		}

		if(params.get("authCode") == null){
			String[] noAuthList = {"0"};
			params.put("authCode", noAuthList);
		}
		return ResponseEntity.ok(authMenuMappingsService.selectMultAuthMenuMappingList(params, sessionVO));
	}


	@RequestMapping(value = "/saveMultAuthMenuMappingList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveMultAuthMenuMappingList(@RequestBody Map<String, Object> params, ModelMap model) {
		LOGGER.debug("Save Auth Menu Mapping");
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		authMenuMappingsService.saveMultAuthMenuMappingList(params, sessionVO);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);

		return ResponseEntity.ok(message);
	}
}
