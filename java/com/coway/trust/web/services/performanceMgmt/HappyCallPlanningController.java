package com.coway.trust.web.services.performanceMgmt;

import java.util.ArrayList;
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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.services.performanceMgmt.HappyCallPlanningService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/performanceMgmt")
public class HappyCallPlanningController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(HappyCallPlanningController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Resource(name = "happyCallPlanningService")
	private HappyCallPlanningService happyCallPlanningService;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@RequestMapping(value = "/happyCallPlanning.do")
	public String surveyMgmt(@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		return "services/performanceMgmt/happyCallPlanning";
	}
	
	@RequestMapping(value = "/selectCodeNameList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCodeNameList( @RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model) {
		LOGGER.debug("params {}", params);
		List<EgovMap> selectCodeNameList = happyCallPlanningService.selectCodeNameList(params);
		LOGGER.debug("selectCodeNameList {}", selectCodeNameList);
		return ResponseEntity.ok(selectCodeNameList);
	}
	
	@RequestMapping(value = "/selectHappyCallList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHappyCallList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		LOGGER.debug("params {}", params);
		List<EgovMap> selectHappyCallList = null;
		selectHappyCallList = happyCallPlanningService.selectHappyCallList(params);        
		LOGGER.debug("happyCallList {}", selectHappyCallList);
		return ResponseEntity.ok(selectHappyCallList);
	}
	
	@RequestMapping(value = "/saveHappyCallList.do", method = RequestMethod.POST)
	public  ResponseEntity<ReturnMessage> saveHappyCallList(@RequestBody Map<String, ArrayList<Object>> params, ModelMap model, SessionVO sessionVO) {

		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 		// Get grid addList
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
		List<Object> delList = params.get(AppConstants.AUIGRID_REMOVE);  // Get grid DeleteList
		
		LOGGER.debug("addList {}", addList);
		LOGGER.debug("udtList {}", udtList);
		LOGGER.debug("delList {}", delList);
		
		ReturnMessage message = new ReturnMessage();
		boolean addSuccess = false;
		boolean updateSuccess = false;
		boolean delSuccess = false;
		
		if(addList != null){
			addSuccess = happyCallPlanningService.insertHappyCall(addList,sessionVO);
		}
		if(udtList != null){
			updateSuccess = happyCallPlanningService.updateHappyCall(udtList,sessionVO);
		}
		if(delList != null){
			delSuccess = happyCallPlanningService.deleteHappyCall(delList,sessionVO);
		}
		
		if(addSuccess){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		if(updateSuccess){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		if(delSuccess){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
	
}
