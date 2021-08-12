package com.coway.trust.web.logistics.serialmgmt;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.logistics.serialmgmt.SerialMgmtService;
import com.coway.trust.biz.logistics.serialmgmt.SerialScanningGISMOService;
import com.coway.trust.biz.logistics.serialmgmt.SerialScanningGRService;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @ClassName : SerialScanningGISMOController.java
 * @Description : GI Serial No. Scanning (SMO)  Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 21.   KR-OHK        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/logistics/SerialMgmt")
public class SerialScanningGISMOController {

	private static final Logger logger = LoggerFactory.getLogger(SerialScanningGISMOController.class);

	@Value("${app.name}")
	private String appName;

	@Autowired
	private SerialScanningGISMOService serialScanningGISMOService;

	@Resource(name = "SerialMgmtService")
	private SerialMgmtService serialMgmtService;

	@Resource(name = "SerialScanningGRService")
	private SerialScanningGRService serialScanningGRService;

	@RequestMapping(value = "/serialScanningGISMOList.do")
	public String serialScanningGISMOList(@RequestParam Map<String, Object>params, ModelMap model,	SessionVO sessionVo) throws Exception {
		Map<String, Object> map = new HashMap();
		map.put("codeMasterId", 306);

		List<EgovMap> codeList306 = serialScanningGRService.serialScanningGRCommonCode(map);

		model.addAttribute("codeList306", codeList306);

		map = new HashMap();
		map.put("codeMasterId", 308);

		List<EgovMap> codeList308 = serialScanningGRService.serialScanningGRCommonCode(map);

		model.addAttribute("codeList308", codeList308);

		// Location Type/Code selection
		if(sessionVo.getUserTypeId() == 2) { 			// CODY
			params.put("locgb", "04");
		} else if(sessionVo.getUserTypeId() == 3) { // CT
			params.put("locgb", "03");
		}
		params.put("userBrnchId", sessionVo.getUserBranchId());
		String defLocType = serialScanningGRService.selectDefLocationType(params);

		model.addAttribute("defLocType", defLocType);
		params.put("locgb", defLocType);

		if("03".equals(defLocType) || "04".equals(defLocType)) {
			params.put("userName", sessionVo.getUserName());
		}
		String defLocCode = serialScanningGRService.selectDefLocationCode(params);
		model.addAttribute("defLocCode", defLocCode);

		model.addAttribute("GR_FROM_DT", params.get("GR_FROM_DT"));
		model.addAttribute("GR_TO_DT", params.get("GR_TO_DT"));

		return "logistics/SerialMgmt/serialScanningGISMOList";
	}

	@RequestMapping(value = "/selectSerialScanningGISMOList.do", method = RequestMethod.POST)
	public ResponseEntity<List<EgovMap>> selectSerialScanningGISMOList(@RequestBody Map<String, Object> params)
	{
		List<EgovMap> list = serialScanningGISMOService.selectSerialScanningGISMOList(params);

		return ResponseEntity.ok(list);
	}
}
