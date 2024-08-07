package com.coway.trust.web.logistics.sirim;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import com.coway.trust.biz.logistics.sirim.SirimService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/sirim")
public class SirimController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "SirimService")
	private SirimService SirimService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/sirimList.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "logistics/sirim/sirimList";
	}

	@RequestMapping(value = "/sirimtransferList.do")
	public String transdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "logistics/sirim/sirimTran";
	}

	//셀렉트박스 조회
	@RequestMapping(value = "/selectWarehouseList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectWarehouseList(@RequestParam Map<String, Object> params) {
		List<EgovMap> warehouseList = SirimService.selectWarehouseList(params);
//		for (int i = 0; i < warehouseList.size(); i++) {
//			logger.debug("%%%%%%%%warehouseList%%%%%%%: {}", warehouseList.get(i));
//		}

		return ResponseEntity.ok(warehouseList);
	}


	@RequestMapping(value = "/selectSirimList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSirimList(@RequestBody Map<String, Object> params, Model model) {

//		logger.debug("%%%%%%%%sirimList%%%%%%%: {}",params.get("searchSirimNo") );
//		logger.debug("%%%%%%%%sirimList%%%%%%%: {}",params.get("searchCategory") );
//		logger.debug("%%%%%%%%sirimList%%%%%%%: {}",params.get("searchWarehouse") );

		List<EgovMap> list = SirimService.selectSirimList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}


	@RequestMapping(value = "/insertSirimList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertSirimList(@RequestBody Map<String, Object> params, Model model) {

//		logger.debug("%%%%%%%%addWarehouse%%%%%%%: {}",params.get("addWarehouse") );
//		logger.debug("%%%%%%%%addTypeSirim%%%%%%%: {}",params.get("addTypeSirim") );
//		logger.debug("%%%%%%%%addPrefixNo%%%%%%%: {}",params.get("addPrefixNo") );
//		logger.debug("%%%%%%%%addQuantity%%%%%%%: {}",params.get("addQuantity") );
//		logger.debug("%%%%%%%%addSirimNoFirst%%%%%%%: {}",params.get("addSirimNoFirst") );
//		logger.debug("%%%%%%%%addSirimNoLast%%%%%%%: {}",params.get("addSirimNoLast") );


		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		params.put("crtuser_id", loginId);
		params.put("upuser_id", loginId);

		String retMsg = AppConstants.MSG_SUCCESS;

		Map<String, Object> map = new HashMap();

		try {
		 SirimService.insertSirimList(params);
		} catch (Exception ex) {
			retMsg = AppConstants.MSG_FAIL;
		} finally {
			map.put("msg", retMsg);
		}

		return ResponseEntity.ok(map);

	}


	@RequestMapping(value = "/selectSirimNo.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSirimNo(@RequestBody Map<String, Object> params,
			HttpServletRequest request, HttpServletResponse response,Model model) {

		logger.debug("####prefix&&&: {}",params.get("prefix"));
		logger.debug("####first&&&: {}",params.get("first"));
		logger.debug("####iCnt&&&: {}",params.get("iCnt"));
		//List<EgovMap> list = SirimService.selectSirimNo(params);
		String count = SirimService.selectSirimNo(params);


		Map<String, Object> map = new HashMap();
		map.put("data", count);

		return ResponseEntity.ok(map);
	}


	@RequestMapping(value = "/selectSirimTransList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectSirimTransList(@RequestBody Map<String, Object> params, Model model) {

		List<EgovMap> list = SirimService.selectSirimTransList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectSirimToTransit.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectSirimToTransit(@RequestParam Map<String, Object> params, Model model) {


		List<EgovMap> list = SirimService.selectSirimToTransit(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectTransitItemlist.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectTransitItemlist(@RequestParam Map<String, Object> params, Model model) {


		List<EgovMap> list = SirimService.selectTransitItemlist(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/insertSirimToTransitItem.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertSirimToTransitItem(@RequestBody Map<String, Object> params, Model model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		String key = SirimService.insertSirimToTransitItem(params , loginId);

		Map<String, Object> map = new HashMap();
		map.put("data", key);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		map.put("message", message);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/updateSirimTranItemDetail.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> updateSirimTranItemDetail(@RequestParam Map<String, Object> params, Model model) {


		SirimService.updateSirimTranItemDetail(params);

		Map<String, Object> map = new HashMap();

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		map.put("message", message);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectSirimModDetail.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectSirimModDetail(@RequestParam Map<String, Object> params, Model model) {


		List<EgovMap> list = SirimService.selectSirimModDetail(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selecthasItemReceiveByReceiverCnt.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selecthasItemReceiveByReceiverCnt(@RequestParam Map<String, Object> params, Model model) {


		int list = SirimService.selecthasItemReceiveByReceiverCnt(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
	@RequestMapping(value = "/doUpdateSirimTransit.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> doUpdateSirimTransit(@RequestBody Map<String, Object> params, Model model) {

		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}
		params.put("suserid", loginId);
		SirimService.doUpdateSirimTransit(params);

		Map<String, Object> map = new HashMap();

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		map.put("message", message);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectWarehouseLocByUserBranch.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectWarehouseLocByUserBranch(@RequestParam Map<String, Object> params,
			ModelMap model) {
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int branchId;
		if (sessionVO == null) {
			branchId = 0;
		} else {
			branchId = sessionVO.getUserBranchId();
		}
		params.put("branchId", branchId);


		List<EgovMap> codeList = SirimService.selectWarehouseLocByUserBranch(params);
		return ResponseEntity.ok(codeList);
	}

	@RequestMapping(value = "/selectWarehouseLoc.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectWarehouseLoc(@RequestParam Map<String, Object> params,
			ModelMap model) {


		List<EgovMap> codeList = SirimService.selectWarehouseLoc(params);
		return ResponseEntity.ok(codeList);
	}
}
