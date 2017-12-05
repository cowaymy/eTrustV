package com.coway.trust.web.logistics.importbl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import com.coway.trust.biz.logistics.importbl.ImportService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "logistics/importbl")

public class ImportController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private MessageSourceAccessor messageAccessor;
	
	@Autowired
	private SessionHandler sessionHandler;
	
	@Resource(name = "importService")
	private ImportService importService;
	
	@RequestMapping(value = "/ImportBL.do")
	public String importBL(@RequestParam Map<String, Object> params, ModelMap model) {
		return "logistics/importbl/importBL";
	}
	
	@RequestMapping(value = "/ImportLocationList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> LocationList(@RequestParam Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {

		List<EgovMap> data = importService.importLocationList(params);
		return ResponseEntity.ok(data);
	}
	
	@RequestMapping(value = "/ImportBLList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> importBLList(@RequestBody Map<String, Object> params, Model model) {
		List<EgovMap> dataList = importService.importBLList(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(dataList);
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/reqSMO.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> reqSTO(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) {
		params.put("userId", sessionVo.getUserId());
		Map<String, Object> data = importService.reqSTO(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(data);
		return ResponseEntity.ok(message);
	}
	
	@RequestMapping(value = "/searchSMO.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> searchSMO(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVo) {
		// params.put("userId", sessionVo.getUserId());
		List<EgovMap> dataList = importService.searchSMO(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(dataList);
		return ResponseEntity.ok(message);
	}

	
}
