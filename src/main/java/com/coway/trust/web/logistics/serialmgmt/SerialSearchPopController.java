package com.coway.trust.web.logistics.serialmgmt;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.logistics.serialmgmt.SerialScanningGRService;
import com.coway.trust.biz.logistics.serialmgmt.SerialSearchPopService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialSearchPopController.java
 * @Description : Serial Search
 *
 * @History
 *
 * <pre>
 * Date               Author       Description
 * -------------  -----------  -------------
 * 2019.11.28.     KR-JUN       First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/logistics/SerialMgmt")
public class SerialSearchPopController {
	private static final Logger logger = LoggerFactory.getLogger(SerialSearchPopController.class);

	@Resource(name = "SerialScanningGRService")
	private SerialScanningGRService serialScanningGRService;

	@Resource(name = "SerialSearchPopService")
	private SerialSearchPopService serialSearchPopService;

	@RequestMapping(value = "/serialSearchPop.do")
	public String serialSearchPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVo) {
		Map<String, Object> map = new HashMap();
		map.put("codeMasterId", 446);
		List<EgovMap> codeList446 = serialScanningGRService.serialScanningGRCommonCode(map);
		model.addAttribute("codeList446", codeList446);

		// Location Type/Code selection
		if (sessionVo.getUserTypeId() == 2) {
			// CODY
			params.put("locgb", "04");
		}
		else if (sessionVo.getUserTypeId() == 3) {
			// CT
			params.put("locgb", "03");
		}
		params.put("userBrnchId", sessionVo.getUserBranchId());
		String defLocType = serialScanningGRService.selectDefLocationType(params);

		model.addAttribute("defLocType", defLocType);

		params.put("locgb", defLocType);
		if ("03".equals(defLocType) || "04".equals(defLocType)) {
			params.put("userName", sessionVo.getUserName());
		}
		String defLocCode = serialScanningGRService.selectDefLocationCode(params);

		model.addAttribute("defLocCode", defLocCode);
		model.addAttribute("GR_FROM_DT", params.get("GR_FROM_DT"));
		model.addAttribute("GR_TO_DT", params.get("GR_TO_DT"));

		String locType = (String)params.get("pLocationType");
		String locCode = (String)params.get("pLocationCode");

		if ("".equals(locType)) {
			locType = defLocType;
		}

		if ("".equals(locCode)) {
			locCode = defLocCode;
		}

		// Popup Param
		model.put("pGubun", params.get("pGubun"));
		model.put("pFixdYn", params.get("pFixdYn"));
		model.put("pLocationType", locType);
		model.put("pLocationCode", locCode);
		model.put("pItemCodeOrName", params.get("pItemCodeOrName"));
		model.put("pStatus", params.get("pStatus"));
		model.put("pSerialNo", params.get("pSerialNo"));

		return "logistics/SerialMgmt/serialSearchPop";
	}

	@RequestMapping(value = "/serialSearchDataList.do", method = RequestMethod.POST)
	public ResponseEntity<Map> serialSearchDataList(@RequestBody Map<String, Object> params) {
		List<EgovMap> list = serialSearchPopService.serialSearchDataList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
}
