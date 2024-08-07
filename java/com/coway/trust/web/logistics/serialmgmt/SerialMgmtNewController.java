/**
 * @author Adrian C.
 **/
package com.coway.trust.web.logistics.serialmgmt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.serialmgmt.SerialMgmtNewService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

@Controller
@RequestMapping(value = "/logistics/serialMgmtNew")
public class SerialMgmtNewController {

	private static final Logger logger = LoggerFactory.getLogger(SerialMgmtNewController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	//@Autowired
	//private SessionHandler sessionHandler;

	@Resource(name = "serialMgmtNewService")
	private SerialMgmtNewService serialMgmtNewService;


	@Resource(name = "commonService")
	private CommonService commonService;


	@RequestMapping(value = "/serialScanCommonPop.do")
	public String serialScanCommonPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("url", params);
		Map<String, Object> sParam = new HashMap<String, Object>();
		sParam.put("groupCode", "42");
		model.addAttribute("uomList", commonService.selectCodeList(sParam));
		return "logistics/SerialMgmt/serialScanCommonPop";
	}


	// inbound serial
	@RequestMapping(value = "/serialScanInPop.do")
	public String serialScanInPop(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("url", params);
		//model.put("nextDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1,nextDay));

		Map<String, Object> sParam = new HashMap<String, Object>();
		sParam.put("groupCode", "42");
		model.addAttribute("uomList", commonService.selectCodeList(sParam));


		return "logistics/SerialMgmt/serialScanInPop";
	}

	// homecare serial save
	@RequestMapping(value = "/saveHPSerialCheck.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveHPSerialCheck(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception {

		List<Object> list = serialMgmtNewService.saveHPSerialCheck(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);

		return ResponseEntity.ok(result);
	}

	// homecare serial delete
	@RequestMapping(value = "/deleteHPSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteHPSerial(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

		serialMgmtNewService.deleteHPSerial(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/allDeleteHPSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> allDeleteHPSerial(@RequestBody Map<String, ArrayList<Map<String, Object>>> params, SessionVO sessionVO) throws Exception {

		serialMgmtNewService.allDeleteHPSerial(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(result);
	}

	// 1.Non Homecare serial save
	@RequestMapping(value = "/saveLogisticBarcode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveLogisticBarcode(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception {

		List<Object> list = serialMgmtNewService.saveLogisticBarcode(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);

		return ResponseEntity.ok(result);
	}

	// 2.Non Homecare serial delete
	@RequestMapping(value = "/deleteSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteSerial(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

		serialMgmtNewService.deleteSerial(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(result);
	}

	// 3. Non Homecare serial Grid All Delete
	@RequestMapping(value = "/deleteGridSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteGridSerial(@RequestBody Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception {

		serialMgmtNewService.deleteGridSerial(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(result);
	}

	// Stock Audit serial delete
	@RequestMapping(value = "/deleteAdSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteAdSerial(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

		serialMgmtNewService.deleteAdSerial(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(result);
	}

	// Stock Audit serial delete
	@RequestMapping(value = "/deleteOgOiSerial.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> deleteOgOiSerial(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

		serialMgmtNewService.deleteOgOiSerial(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		return ResponseEntity.ok(result);
	}

	// 2.Non Homecare serial delete
	@RequestMapping(value = "/boxSerialBarcode.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> boxSerialBarcode(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

		String serialBarcode = serialMgmtNewService.selectBoxSerialBarcode(params, sessionVO);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(serialBarcode);
		return ResponseEntity.ok(result);
	}
}
