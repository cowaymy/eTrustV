package com.coway.trust.web.scm;

import java.util.ArrayList;
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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.scm.ScmMasterManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/scm")
public class ScmMasterManagementController {
	
	private static final Logger LOGGER	= LoggerFactory.getLogger(ScmMasterManagementController.class);
	
	@Autowired
	private ScmMasterManagementService scmMasterManagementService;
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	//	view
	@RequestMapping(value = "/scmMasterManagement.do")
	public String masterMngmentView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/scmMasterManagement";
	}
	
	//	search
	@RequestMapping(value = "/selectScmMasterList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectScmMasterList(@RequestBody Map<String, Object> params) {
		LOGGER.debug("selectScmMasterList : {}", params.toString());
		
		List<EgovMap> selectScmMasterList	= scmMasterManagementService.selectScmMasterList(params);
		
		Map<String, Object> map	= new HashMap<>();
		
		//	main Data
		map.put("selectScmMasterList", selectScmMasterList);
		
		return	ResponseEntity.ok(map);
	}
	
	//	save
	@RequestMapping(value = "/saveScmMaster.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveScmMaster(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		
		LOGGER.debug("saveScmMaster : {}", params.toString());
		
		int totCnt	= 0;	//	save at SCM0008M
		int saveCnt	= 0;	//	save at SCM0017M
		
		List<Object> updList	= params.get(AppConstants.AUIGRID_UPDATE);	//	Get gride UpdateList
		
		if ( 0 < updList.size() ) {
			totCnt	= scmMasterManagementService.saveScmMaster(updList, sessionVO);
			saveCnt	= scmMasterManagementService.saveScmMaster2(updList, sessionVO);
		}
		
		LOGGER.debug("SCM0008M : " + totCnt + ", SCM0017M : " + saveCnt);
		
		ReturnMessage message	= new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return	ResponseEntity.ok(message);
	}
}