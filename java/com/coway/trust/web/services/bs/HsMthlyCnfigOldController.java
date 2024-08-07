package com.coway.trust.web.services.bs;

import java.text.ParseException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import com.coway.trust.biz.services.bs.HsMthlyCnfigOldService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.MemberListController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/bs")
public class HsMthlyCnfigOldController {
	private static final Logger logger = LoggerFactory.getLogger(MemberListController.class);

	@Resource(name = "hsMthlyCnfigOldService")
	private HsMthlyCnfigOldService hsMthlyCnfigOldService;

	@RequestMapping(value = "/hsMonthlyConfigOldVer.do")
	public String hsManualOld(@RequestParam Map<String, Object> params, ModelMap model) {
		return "services/bs/hsMonthlyConfigOldVer";
	}

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/selectHsMnthlyMaintainOldList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectHsMnthlyMaintainOldList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
		params.put("user_id", sessionVO.getUserId());

		String[] bsStatusList =  request.getParameterValues("bsStatus");
		params.put("bsStatusList",bsStatusList);

		List<EgovMap> hsBasicList = hsMthlyCnfigOldService.selectHsMnthlyMaintainOldList(params);

		return ResponseEntity.ok(hsBasicList);
	}

	@RequestMapping(value = "/hsMnthlyMaintainOldPop.do")
	public String hsMnthlyMaintainOldPop(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model ,SessionVO sessionVO) {
		params.put("user_id", sessionVO.getUserId());
		model.put("SCHDUL_ID",(String) params.get("schdulId"));
logger.info("@@@@@@@@@@@@@@@@@@@@@@params.get :: " + params.get("schdulId"));
        EgovMap hsMonthlyConfigOldInfo = hsMthlyCnfigOldService.selectHsMnthlyMaintainOldDetail(params);

        model.put("hsMonthlyConfigOldInfo", hsMonthlyConfigOldInfo);

        return "services/bs/hsMonthlyConfigOldPop";
	}


	@RequestMapping(value = "/getHSMnthlyCnfigOldInfo.do")
	public String getHSMnthlyCnfigOldInfo(@RequestParam Map<String, Object> params, ModelMap model) throws Exception  {

		logger.debug("params : {}", params.toString());
		params.put("orderNo", params.get("salesOrdId"));

		return "services/bs/hsMonthlyConfigOldPop";
	}

	@RequestMapping(value = "/updateCurrentMonthSettingCody.do",method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> updateCurrentMonthSettingCody(@RequestBody Map<String, Object> params, HttpServletRequest request,SessionVO sessionVO) throws ParseException {
		ReturnMessage message = new ReturnMessage();
		params.put("updator", sessionVO.getUserId());

		logger.debug("params : {}", params);
		LinkedHashMap  hsResultM = (LinkedHashMap)params.get("hsResultM");
        hsResultM.put("hscodyId", hsResultM.get("codyCode"));
		String codyId = hsMthlyCnfigOldService.selectHSCodyByCode(hsResultM);
		params.put("codyId",codyId);
		params.put("schdulId",hsResultM.get("schdulId"));

		int resultValue = hsMthlyCnfigOldService.updateCurrentMonthSettingCody(params);

		if(resultValue>0){
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		}else{
			message.setCode(AppConstants.FAIL);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_FAIL));
		}
		return ResponseEntity.ok(message);
	}

}



