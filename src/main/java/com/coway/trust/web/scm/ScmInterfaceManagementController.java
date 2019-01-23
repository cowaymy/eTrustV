package com.coway.trust.web.scm;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

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

import com.coway.trust.biz.scm.ScmInterfaceManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.scm.PoMngementService;
import com.coway.trust.biz.scm.SalesPlanMngementService;
import com.coway.trust.biz.scm.ScmCommonService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class ScmInterfaceManagementController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ScmMasterMngmentController.class);
	
	@Autowired
	private ScmInterfaceManagementService	scmInterfaceManagementService;

	@Autowired
	private ScmCommonService scmCommonService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	//	view
	@RequestMapping(value = "/interface.do")
	public String interfaceManagement(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/scmInterfaceManagement";
	}
	
	@RequestMapping(value = "/selectScmIfType.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmIfType(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectScmIfType : {}", params.toString());
		
		List<EgovMap> selectScmIfType	= scmCommonService.selectScmIfType(params);
		return ResponseEntity.ok(selectScmIfType);
	}
	@RequestMapping(value = "/selectScmIfStatus.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmIfStatus(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectScmIfTranStatus : {}", params.toString());
		
		List<EgovMap> selectScmIfStatus	= scmCommonService.selectScmIfStatus(params);
		return ResponseEntity.ok(selectScmIfStatus);
	}
	@RequestMapping(value = "/selectScmIfErrCode.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectScmIfErrCode(@RequestParam Map<String, Object> params) {
		
		LOGGER.debug("selectScmIfErrCode : {}", params.toString());
		
		List<EgovMap> selectScmIfErrCode	= scmCommonService.selectScmIfErrCode(params);
		return ResponseEntity.ok(selectScmIfErrCode);
	}
	
	//	search
	@RequestMapping(value = "/selectInterfaceList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectInterfaceList(@RequestBody Map<String, Object> params) {
		LOGGER.debug("selectInterfaceList : {}", params.toString());
		
		List<EgovMap> selectInterfaceList	= scmInterfaceManagementService.selectInterfaceList(params);
		
		Map<String, Object> map	= new HashMap<>();
		
		map.put("selectInterfaceList", selectInterfaceList);
		
		return	ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/doInterface.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> doInterface(@RequestBody Map<String, List<Map<String, Object>>> params) {
		
		int totCnt	= 0;
		List<Map<String, Object>> chkList	= params.get(AppConstants.AUIGRID_CHECK);
		LOGGER.debug("chkList : {}", chkList.toString());
		totCnt	= scmInterfaceManagementService.doInterface(chkList);
		
		ReturnMessage message = new ReturnMessage();
		
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
}