package com.coway.trust.web.logistics.serial;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.serial.SerialService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/serial")
public class SerialController {

	private static final Logger logger = LoggerFactory.getLogger(SerialController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "serialService")
	private SerialService serialService;

	@RequestMapping(value = "/serialEdit.do")
	public String SerialEdit(@RequestParam Map<String, Object> params) {
		return "logistics/serial/serialEdit";
	}

	@RequestMapping(value = "/searchSeialList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> searchSeialList(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {

		if (!"".equals(params.get("srchcatagorytype")) || null != params.get("srchcatagorytype")) {
			logger.debug("srchcatagorytype : {}", params.get("srchcatagorytype"));
			List<Object> tmp = (List<Object>) params.get("srchcatagorytype");
			params.put("cateList", tmp);
		}
		if (!"".equals(params.get("materialtype")) || null != params.get("materialtype")) {
			logger.debug("materialtype : {}", params.get("materialtype"));
			List<Object> tmp = (List<Object>) params.get("materialtype");
			params.put("typeList", tmp);
		}
		List<EgovMap> list = serialService.searchSeialList(params);
		
		for (int i = 0; i < list.size(); i++) {
			logger.debug("list ??  : {}", list.get(i));
		}
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/selectSerialDetails.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectSerialDetails(@RequestParam Map<String, Object> params) {

		logger.debug("serialNo : {}", params.get("serialNo"));
		List<EgovMap> list = serialService.selectSerialDetails(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectSerialOne.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectSerialOne(@RequestParam Map<String, Object> params) {

		logger.debug("serialNo : {}", params.get("serialNo"));
		List<EgovMap> list = serialService.searchSeialListPop(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/modifySerialOne.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> modifySerialOne(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		String loginId = String.valueOf(sessionVO.getUserId());
		int cnt = 0;
		List<Object> addList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updateList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		
		for (int i = 0; i < addList.size(); i++) {
			logger.debug("addList : {}", addList.get(i));
		}
		
		for (int i = 0; i < updateList.size(); i++) {
			logger.debug("updateList : {}", updateList.get(i));
		}
		
		if (addList.size() > 0) {
			logger.info("addList : {}", addList.toString());
			cnt = serialService.insertSerial(addList, loginId);
		} else if (updateList.size() > 0) {
			logger.info("updateList : {}", updateList.toString());
			cnt = serialService.updateSerial(updateList, loginId);

		}
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		// message.setDataList(list);
		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/saveExcelGrid.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveExcelGrid(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		String loginId = String.valueOf(sessionVO.getUserId());
		// int cnt = 0;
		List<Object> addList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		if (addList.size() > 0) {
			logger.info("addList : {}", addList.toString());
			serialService.insertExcelSerial(addList, loginId);
		}
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		// message.setDataList(list);
		return ResponseEntity.ok(message);

	}

	@RequestMapping(value = "/newSerialCheck.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> newSerialCheck(@RequestParam Map<String, Object> params) {

		logger.debug("serialNo : {}", params.get("serialNo"));
		List<EgovMap> list = serialService.searchSeialListPop(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/selectSerialExist.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectSerialExist(@RequestParam Map<String, Object> params) {

		logger.debug("serialNo : {}", params.get("serialNo"));
		List<EgovMap> list = serialService.selectSerialExist(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}
}
