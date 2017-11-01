package com.coway.trust.web.logistics.roommanage;

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
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.roommanage.RoomManagementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/misc/room")
public class RoomManagementController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Autowired
	private FileApplication fileApplication;

	@Resource(name = "roomManagementService")
	private RoomManagementService roomManagementService;

	@RequestMapping(value = "/roomManagement.do")
	public String roomManagement(@RequestParam Map<String, Object> params) {
		return "logistics/roommanage/roomManagement";
	}

	@RequestMapping(value = "/roomManagementList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> roomManagementList(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		logger.debug("adjNo : {} ", params);
		List<EgovMap> list = roomManagementService.roomManagementList(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/roomBookingList.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> roomBookingList(@RequestParam Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {

		List<EgovMap> list = roomManagementService.roomBookingList(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/getEditData.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> roomEditData(@RequestParam Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {

		List<EgovMap> list = roomManagementService.selectEditData(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/saveNewEditData.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveNewEditData(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		logger.debug("adjNo : {} ", params);
		logger.debug("roomId : {} ", params.get("roomId"));
		params.put("userId", sessionVO.getUserId());
		String roomId = String.valueOf(params.get("roomId"));
		if ("NEW".equals(roomId)) {
			params.put("roomId", 0);
		}
		int data = roomManagementService.saveNewEditData(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setData(data);
		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/updateDeActive.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateDeActive(@RequestBody Map<String, Object> params, Model model,
			SessionVO sessionVO) throws Exception {
		logger.debug("adjNo : {} ", params);
		params.put("userId", sessionVO.getUserId());
		roomManagementService.updateDeActive(params);
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(message);
	}
}
