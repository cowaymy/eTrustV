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

	@RequestMapping(value = "/serialScanGRCDC.do")
	public String SerialScanGRCDC(@RequestParam Map<String, Object> params)
	{
		return "logistics/SerialMgmt/serialScanGRCDC";
	}

	@RequestMapping(value = "/serialScanGICDC.do")
	public String SerialScanGICDC(@RequestParam Map<String, Object> params)
	{
		return "logistics/SerialMgmt/serialScanGICDC";
	}

	@RequestMapping(value = "/serialScanGIRDC.do")
	public String SerialScanGIRDC(@RequestParam Map<String, Object> params)
	{
		return "logistics/SerialMgmt/serialScanGIRDC";
	}

	@RequestMapping(value = "/selectDeliveryBalance.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectDeliveryBalance(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> list = serialMgmtService.selectDeliveryBalance(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectGIRDCBalance.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectGIRDCBalance(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> list = serialMgmtService.selectGIRDCBalance(params);

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

	@RequestMapping(value = "/selectSerialDetails.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectSerialDetails(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> list = serialMgmtService.selectSerialDetails(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}

	@RequestMapping(value = "/selectRDCScanList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectRDCScanList(@RequestParam Map<String, Object> params)
	{
		List<EgovMap> list = serialMgmtService.selectRDCScanList(params);

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

	@RequestMapping(value = "/selectUserDetails.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectUserDetails(Model mode, SessionVO sessionVo)
	{
		int brnchid = sessionVo.getUserBranchId();

		List<EgovMap> list = serialMgmtService.selectUserDetails(brnchid);

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
		paramArray.put("scanItems", scanItems);

		Map<String, Object> map = new HashMap();

		int scanType = Integer.parseInt(formItems.get("scantype").toString());

		if(scanType == 30)
		{
			paramArray.put("reqstno", formItems.get(""));
			paramArray.put("reqstdt", formItems.get("reqstDt"));
			paramArray.put("frmlocid", formItems.get("RDCFrmLocID"));
			paramArray.put("tolocid", formItems.get("RDCToLoc"));
			paramArray.put("scantype", formItems.get("scantype"));

			serialMgmtService.insertScanItems(paramArray);
		}
		else
		{
			paramArray.put("reqstno", formItems.get("reqstno"));
			paramArray.put("reqstdt", formItems.get("reqstdt"));
			paramArray.put("frmlocid", formItems.get("frmlocid"));
			paramArray.put("tolocid", formItems.get("tolocid"));
			paramArray.put("scantype", formItems.get("scantype"));

			serialMgmtService.insertScanItems(paramArray);

			Map<String, Object> delNo = new HashMap();
			delNo.put("delno", formItems.get("reqstno"));

			List<EgovMap> list = serialMgmtService.selectScanList(delNo);
			map.put("data", list);
		}

		return ResponseEntity.ok(map);
	}
}
