package com.coway.trust.web.logistics.serialmgmt;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import com.coway.trust.biz.logistics.serialmgmt.SerialLastInfoMgmtService;
import com.coway.trust.biz.logistics.serialmgmt.SerialScanningGRService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialLastInfoMgmtController.java
 * @Description : Serial No. Last Info Management Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 22.   KR-OHK        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/logistics/serialLastMgmt")
public class SerialLastInfoMgmtController {

	private static final Logger logger = LoggerFactory.getLogger(SerialLastInfoMgmtController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "serialLastInfoMgmtService")
	private SerialLastInfoMgmtService serialLastInfoMgmtService;

	@Resource(name = "SerialScanningGRService")
	private SerialScanningGRService serialScanningGRService;

	@RequestMapping(value = "/serialLastInfoMgmt.do")
	public String serialLastInfoMgmt(@RequestParam Map<String, Object> params, ModelMap model,	SessionVO sessionVo) {

		// In/Out STUS
		model.addAttribute("stusList", commonService.selectCodeList("446", "CODE_ID"));

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

		return "logistics/SerialMgmt/serialLastInfoMgmt";
	}

	@RequestMapping(value = "/selectSerialLastInfoList", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> selectSerialLastInfoList(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model) throws Exception {

		ReturnMessage result = new ReturnMessage();

		int firstIndex = -1;
		int lastIndex  = -1;
		// 한페이지에서 보여줄 행 수
		int rowCount = params.containsKey("rowCount")?(int)params.get("rowCount"):100;
		// 호출한 페이지
		int goPage = params.containsKey("goPage")?(int)params.get("goPage"):0;
		if(rowCount != 0 && goPage != 0){
			firstIndex = (rowCount * goPage) - rowCount;
			lastIndex = rowCount * goPage;
		}
		params.put("firstIndex", firstIndex);
		params.put("lastIndex", lastIndex);

		List<EgovMap> list = null;

		int cnt = serialLastInfoMgmtService.selectSerialLastInfoListCnt(params);

		if(cnt > 0){
			list =  serialLastInfoMgmtService.selectSerialLastInfoList(params);
		}

		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setTotal(cnt);
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectSerialLastInfoHistoryList", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> selectSerialLastInfoHistoryList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

		List<EgovMap> list = serialLastInfoMgmtService.selectSerialLastInfoHistoryList(params);

		ReturnMessage result = new ReturnMessage();
		result.setCode(AppConstants.SUCCESS);
		result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		result.setDataList(list);
		return ResponseEntity.ok(result);
	}

	@RequestMapping(value = "/selectOrderBasicInfoByOrderId.do")
	public ResponseEntity<EgovMap> selectOrderBasicInfoByOrderId(@RequestParam Map<String, Object> params, ModelMap model) {
		EgovMap orderBasicInfo = null;

		logger.debug("params : {}", params);

		orderBasicInfo = serialLastInfoMgmtService.selectOrderBasicInfoByOrderId(params).get(0);

		return ResponseEntity.ok(orderBasicInfo);
	}

	@RequestMapping(value = "/saveSerialLastInfo.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> saveSerialLastInfo(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) throws Exception {

		params.put("userId", sessionVO.getUserId());

		serialLastInfoMgmtService.saveSerialLastInfo(params);

		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

		return ResponseEntity.ok(message);
	}
}
