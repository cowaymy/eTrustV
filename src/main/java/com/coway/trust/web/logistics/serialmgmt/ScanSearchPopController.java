package com.coway.trust.web.logistics.serialmgmt;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.logistics.serialmgmt.ScanSearchPopService;
import com.coway.trust.biz.logistics.serialmgmt.SerialScanningGRService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ScanSearchPopController.java
 * @Description : Scan Search
 *
 * @History
 *
 * <pre>
 * Date               Author       Description
 * -------------  -----------  -------------
 * 2019.11.21.     KR-JUN       First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/logistics/SerialMgmt")
public class ScanSearchPopController {
	private static final Logger logger = LoggerFactory.getLogger(ScanSearchPopController.class);

	@Resource(name = "SerialScanningGRService")
	private SerialScanningGRService serialScanningGRService;

	@Resource(name = "ScanSearchPopService")
	private ScanSearchPopService scanSearchPopService;

	@RequestMapping(value = "/scanSearchPop.do")
	public String scanSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {
		Map<String, Object> map = new HashMap();
		map.put("codeMasterId", 446);

		List<EgovMap> codeList446 = serialScanningGRService.serialScanningGRCommonCode(map);

		model.addAttribute("codeList446", codeList446);

		model.put("pDeliveryNo", params.get("pDeliveryNo"));
		model.put("pDeliveryItem", params.get("pDeliveryItem"));
		model.put("pRequestNo", params.get("pRequestNo"));
		model.put("pRequestItem", params.get("pRequestItem"));
		model.put("pStatus", params.get("pStatus"));
		model.put("pSerialNo", params.get("pSerialNo"));
		model.put("pTrnscType", params.get("zTrnscType"));
		model.put("pFromLoc", params.get("zFromLoc"));

		return "logistics/SerialMgmt/scanSearchPop";
	}

	@RequestMapping(value = "/scanSearchDataList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> scanSearchDataList(@RequestParam Map<String, Object> params) {
		List<EgovMap> list = scanSearchPopService.scanSearchDataList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
}
