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
	@RequestMapping(value = "/scmMasterManagerView.do")
	public String scmMasterManagerView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/scmMasterManagement";
	}
	@RequestMapping(value = "/cdcWhMappingView.do")
	public String cdcWhMappingView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/cdcWhMapping";
	}
	@RequestMapping(value = "/cdcWhMappingPopupView.do")
	public String cdcWhMappingPopupView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/cdcWhMappingPopup";
	}
	@RequestMapping(value = "/cdcBrMappingView.do")
	public String cdcBrMappingView(@RequestParam Map<String, Object> params, ModelMap model, Locale locale) {
		return	"/scm/cdcBrMapping";
	}

	/*
	 * SCM Master Manager
	 */
	//	search
	@RequestMapping(value = "/selectScmMasterList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectScmMasterList(@RequestBody Map<String, Object> params) {
		LOGGER.debug("selectScmMasterList : {}", params.toString());

		List<EgovMap> selectScmMasterList	= scmMasterManagementService.selectScmMasterList(params);

		Map<String, Object> map	= new HashMap<>();

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

		if((totCnt + saveCnt) < 0 ){
			message.setMessage("Error when update the SCM Master Management Data.");
		} else if ((totCnt + saveCnt) == 0 ){
			message.setMessage("No data is being updated.");
		} else {
			message.setCode(AppConstants.SUCCESS);
			message.setData(totCnt);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}

		return	ResponseEntity.ok(message);
	}

	/*
	 * CDC Warehouse Mapping
	 */
	//	search
	@RequestMapping(value = "/selectCdcWhList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectCdcWhList(@RequestBody Map<String, Object> params) {
		LOGGER.debug("selectCdcWhList : {}", params.toString());

		List<EgovMap> selectCdcWhMappingList	= scmMasterManagementService.selectCdcWhMappingList(params);
		List<EgovMap> selectCdcWhUnmappingList	= scmMasterManagementService.selectCdcWhUnmappingList(params);

		Map<String, Object> map	= new HashMap<>();

		//	main Data
		map.put("selectCdcWhMappingList", selectCdcWhMappingList);
		map.put("selectCdcWhUnmappingList", selectCdcWhUnmappingList);

		return	ResponseEntity.ok(map);
	}

	//	save Unmap
	@RequestMapping(value = "/saveUnmap.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveUnmap(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		int totCnt	= 0;

		//	Only delete
		List<Object> delList	= params.get(AppConstants.AUIGRID_UPDATE);	//	Get grid delList

		if ( 0 < delList.size() ) {
			totCnt	= scmMasterManagementService.deleteCdcWhMapping(delList, sessionVO.getUserId());
		}

		ReturnMessage message	= new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return	ResponseEntity.ok(message);
	}

	//	save Map
	@RequestMapping(value = "/saveMap.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveMap(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		int totCnt	= 0;

		//	Only delete
		List<Object> insList	= params.get(AppConstants.AUIGRID_UPDATE);	//	Get grid insList : AUIGRID_UPDATE -> row insert

		if ( 0 < insList.size() ) {
			totCnt	= scmMasterManagementService.insertCdcWhMapping(insList, sessionVO.getUserId());
		}

		ReturnMessage message	= new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return	ResponseEntity.ok(message);
	}

	/*
	 * CDC Branch Mapping
	 */
	@RequestMapping(value = "/selectCdcBrList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectCdcBrList(@RequestBody Map<String, Object> params) {
		LOGGER.debug("selectCdcWhList : {}", params.toString());

		List<EgovMap> selectCdcBrMappingList	= scmMasterManagementService.selectCdcBrMappingList(params);
		List<EgovMap> selectCdcBrUnmappingList	= scmMasterManagementService.selectCdcBrUnmappingList(params);

		Map<String, Object> map	= new HashMap<>();

		//	main Data
		map.put("selectCdcBrMappingList", selectCdcBrMappingList);
		map.put("selectCdcBrUnmappingList", selectCdcBrUnmappingList);

		return	ResponseEntity.ok(map);
	}

	//	save Unmap
	@RequestMapping(value = "/saveUnmapBr.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveUnmapBr(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		int totCnt	= 0;

		//	Only delete
		List<Object> delList	= params.get(AppConstants.AUIGRID_UPDATE);	//	Get grid delList

		if ( 0 < delList.size() ) {
			totCnt	= scmMasterManagementService.deleteCdcBrMapping(delList, sessionVO.getUserId());
		}

		ReturnMessage message	= new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return	ResponseEntity.ok(message);
	}

	//	save Map
	@RequestMapping(value = "/saveMapBr.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveMapBr(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		int totCnt	= 0;

		//	Only delete
		List<Object> insList	= params.get(AppConstants.AUIGRID_UPDATE);	//	Get grid insList : AUIGRID_UPDATE -> row insert

		if ( 0 < insList.size() ) {
			totCnt	= scmMasterManagementService.insertCdcBrMapping(insList, sessionVO.getUserId());
		}

		ReturnMessage message	= new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return	ResponseEntity.ok(message);
	}

//	save Map
	@RequestMapping(value = "/saveMapLeadTime.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveMapLeadTime(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) {
		int totCnt	= 0;

		//	Only edit
		List<Object> insList	= params.get(AppConstants.AUIGRID_UPDATE);	//	Get grid insList : AUIGRID_UPDATE -> row insert

		if ( 0 < insList.size() ) {
			totCnt	= scmMasterManagementService.updateCdcLeadTimeMapping(insList, sessionVO.getUserId());
		}

		ReturnMessage message	= new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setData(totCnt);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return	ResponseEntity.ok(message);
	}
}