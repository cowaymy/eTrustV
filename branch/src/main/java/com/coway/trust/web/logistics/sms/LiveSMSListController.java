package com.coway.trust.web.logistics.sms;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
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
import com.coway.trust.biz.common.AdaptorService;
import com.coway.trust.biz.logistics.sms.SmsService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.cmmn.model.SmsResult;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**************************************
 * Author	Date				Remark
 * Kit			2018/02/27		Create for SMS Live
 *
 ***************************************/
@Controller
@RequestMapping(value = "/logistics/sms")
public class LiveSMSListController {
	private static final Logger logger = LoggerFactory.getLogger(LiveSMSListController.class);

	@Resource(name = "SmsService")
	private SmsService smsService;

	@Autowired
	private AdaptorService adaptorService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/initLiveSMSList.do")
	public String initASManagementList(@RequestParam Map<String, Object> params, ModelMap model) {
		// 호출될 화면
		return "logistics/sms/liveSMSList";
	}

	@RequestMapping(value = "/selectLiveSmsList.do", method = RequestMethod.GET)
	public ResponseEntity<Map> selectLiveSmsList(@RequestParam Map<String, Object> params,HttpServletRequest request, Model model) {

		String[] arrCmbStatus   = request.getParameterValues("cmbStatus"); //cmbStatus
		if(arrCmbStatus      != null && !CommonUtils.containsEmpty(arrCmbStatus)) params.put("arrCmbStatus", arrCmbStatus);

		params.put("smsPrio", 1);
		List<EgovMap> list = smsService.selectLiveSmsList(params);

		Map<String, Object> map = new HashMap();
		map.put("data", list);


		return ResponseEntity.ok(map);
	}

}
