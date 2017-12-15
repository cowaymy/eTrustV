/**
 * @author Adrian C.
 **/
package com.coway.trust.web.logistics.serialmgmt;

import java.util.HashMap;
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
import com.coway.trust.biz.logistics.serialmgmt.SerialMgmtService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/SerialMgmt")
public class SerialMgmtController {

	private static final Logger logger = LoggerFactory.getLogger(SerialMgmtController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "SerialMgmtService")
	private SerialMgmtService serialMgmtService;

	@RequestMapping(value = "/serialMgmtMain.do")
	public String SerialLocation(@RequestParam Map<String, Object> params)
	{
		return "logistics/SerialMgmt/serialMgmtMain";
	}

	@RequestMapping(value = "/selectDeliveryBalance.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectDeliveryBalance(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> list = serialMgmtService.selectDeliveryBalance(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectDeliveryList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectDeliveryList(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> list = serialMgmtService.selectDeliveryList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectScanList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectScanList(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> list = serialMgmtService.selectScanList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectBoxNoList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> selectBoxNoList(@RequestBody Map<String, Object> params, Model model)
	throws Exception
	{

		if (!"".equals(params.get("barcode")) || null != params.get("barcode"))
		{
			logger.debug("barcode : {}", params.get("barcode"));

			List<Object> tmp = (List<Object>) params.get("barcode");
			params.put("barcodeList", tmp);
		}

		List<EgovMap> list = serialMgmtService.selectBoxNoList(params);

		for (int i = 0; i < list.size(); i++)
		{
			logger.debug("list ??  : {}", list.get(i));
		}

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/insertScanItems.do", method = RequestMethod.POST)
	public ResponseEntity<Map> insertScanItems(@RequestBody Map<String, Object> params, Model mode, SessionVO sessionVo)
	{

		int userID = sessionVo.getUserId();

		logger.debug("params : {}", params.toString());

		List<Object> scanItems = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		Map<String, Object> formItems = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		Map<String, Object> paramArray = new HashMap();
		paramArray.put("userid", userID);
		paramArray.put("frmlocid", formItems.get("frmlocid"));
		paramArray.put("tolocid", formItems.get("tolocid"));
		paramArray.put("scantype", formItems.get("scantype"));
		paramArray.put("scanItems", scanItems);

		if(paramArray.get("scantype") == "30")
		{
			paramArray.put("reqstno", formItems.get(""));
			paramArray.put("reqstdt", formItems.get("reqstdt"));
		}
		else
		{
			paramArray.put("reqstno", formItems.get("txtDelNo"));
			paramArray.put("reqstdt", formItems.get("txtCrtDt"));
		}

		serialMgmtService.insertScanItems(paramArray);

		Map<String, Object> delNo = new HashMap();

		delNo.put("delno", formItems.get("txtDelNo"));

		List<EgovMap> list = serialMgmtService.selectScanList(delNo);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
}
