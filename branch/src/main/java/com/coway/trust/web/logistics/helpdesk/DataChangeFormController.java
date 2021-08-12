package com.coway.trust.web.logistics.helpdesk;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
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
import com.coway.trust.biz.logistics.helpdesk.HelpDeskService;
import com.coway.trust.biz.logistics.sirim.SirimReceiveService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/helpdesk")
public class DataChangeFormController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Value("${app.name}")
	private String appName;

	@Resource(name = "HelpDeskService")
	private HelpDeskService HelpDeskService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/helpdesk.do")
	public String listdevice(Model model, HttpServletRequest request, HttpServletResponse response) throws Exception {
		return "logistics/HelpDesk/DataChangeFormList";
	}
	
	
	
	//Reason 셀렉트박스  리스트 조회
	@RequestMapping(value = "/selectReasonList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectReasonList(@RequestParam Map<String, Object> params) {

		logger.debug("selectBrandListCode : {}", params.get("groupCode"));

		List<EgovMap>ReasonList = HelpDeskService.selectReasonList(params);
//		for (int i = 0; i < ReasonList.size(); i++) {
//			logger.debug("@@@@@@@@@@@ReasonList@@@@@@@@@@@@@: {}", ReasonList.get(i));
//		}
		
		return ResponseEntity.ok(ReasonList);
	}
	
	@RequestMapping(value = "/selectDataChangeList.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectDataChangeList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
			
		String[] searchApprovalStatus = request.getParameterValues("searchApprovalStatus");
		String[] searchRequestBranch = request.getParameterValues("searchRequestBranch");
		String[] searchRequestDepartment = request.getParameterValues("searchRequestDepartment");
		
		params.put("searchApprovalStatus", searchApprovalStatus);
		params.put("searchRequestBranch", searchRequestBranch);
		params.put("searchRequestDepartment", searchRequestDepartment);
		params.put("cmbType", 1);
		params.put("cmbCategory", 16);
		params.put("cmbSubject", 81);
		
		logger.debug("%%%%%%%%searchDcfNo%%%%%%%: {}",params.get("searchDcfNo"));
		logger.debug("%%%%%%%%searchRequestor%%%%%%%: {}",params.get("searchRequestor"));
		logger.debug("%%%%%%%%searchApprovalStatus%%%%%%%: {}",searchApprovalStatus );
		logger.debug("%%%%%%%%searchRequestDepartment%%%%%%%: {}",searchRequestDepartment);
		logger.debug("%%%%%%%%searchReqDate1%%%%%%%: {}",params.get("searchReqDate1") );
		logger.debug("%%%%%%%%searchReqDate2%%%%%%%: {}",params.get("searchReqDate2") );	
		
		List<EgovMap> list = HelpDeskService.selectDataChangeList(params);
		
		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/DetailInfoList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> DetailInfoList(@RequestBody Map<String, Object> params, Model model) {
		
		logger.debug("DetailInfoListDcfreqentryid   ?? ::::::: {}",params.get("dcfreqentryid") );
		
		List<EgovMap> Compulsorylist = HelpDeskService.CompulsoryList(params);
		List<EgovMap> ChangeItemlist = HelpDeskService.ChangeItemList(params);
		List<EgovMap> RespondLoglist = HelpDeskService.RespondList(params);
		List<EgovMap> detailDatalist = HelpDeskService.detailDataChangeList(params);
		
//	for (int i = 0; i < Compulsorylist.size(); i++) {
//			logger.debug("Compulsorylist ::::::: {}",Compulsorylist.get(i) );
//	}
//	for (int i = 0; i < ChangeItemlist.size(); i++) {
//		logger.debug("ChangeItemlist *&(*&*(&*(*(&*(&&  ?? ::::::: {}",ChangeItemlist.get(i) );
//}
//	for (int i = 0; i < RespondLoglist.size(); i++) {
//		logger.debug("RespondLoglist  ::::::: {}",RespondLoglist.get(i) );
//}
	for (int i = 0; i < detailDatalist.size(); i++) {
	logger.debug("detailDatalist  ^^: {}",detailDatalist.get(i) );
	}		
		Map<String, Object> map = new HashMap();
		map.put("data1", Compulsorylist);
		map.put("data2", ChangeItemlist);
		map.put("data3", RespondLoglist);
		map.put("data4", detailDatalist);

		return ResponseEntity.ok(map);
	}
	
	@RequestMapping(value = "/insertDataChangeList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertDataChangeList(@RequestBody Map<String, Object> params, ModelMap mode)
			throws Exception {

		logger.debug("insApprovalStatus ???????       : {}", params.get("insApprovalStatus"));
		logger.debug("insReason  : {}", params.get("insReason"));
		logger.debug("insApprovalRemark  : {}", params.get("insApprovalRemark"));
//		logger.debug("reqId  : {}", params.get("reqId"));
//		logger.debug("DcfReqStatusId : {}", params.get("DcfReqStatusId"));
//		logger.debug("receiveInfoTransitBy  : {}", InsertReceiveMap.get("receiveInfoTransitBy"));
//		logger.debug("receiveInfoTransitLocation  : {}", InsertReceiveMap.get("receiveInfoTransitLocation"));
//		logger.debug("receiveInfoCourier  : {}", InsertReceiveMap.get("receiveInfoCourier"));
//		logger.debug("receiveInfoTotalSirimTransit  : {}", InsertReceiveMap.get("receiveInfoTotalSirimTransit"));
//		logger.debug("receiveRadio  : {}", InsertReceiveMap.get("receiveRadio"));
//		logger.debug("SirimLocTo  : {}", InsertReceiveMap.get("SirimLocTo"));
//		logger.debug("SirimLocFrom  : {}", InsertReceiveMap.get("SirimLocFrom"));
		
		
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);	
		
		
		SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
		int loginId;
		if (sessionVO == null) {
			loginId = 99999999;
		} else {
			loginId = sessionVO.getUserId();
		}

		String retMsg = AppConstants.MSG_SUCCESS;

		Map<String, Object> map = new HashMap();

		map =HelpDeskService.insertDataChangeList(params,loginId,today);
		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));	
		message.setData(map);
		
		logger.debug("컨트롤러  ^^: {}",map );
//		try {
//		} catch (Exception ex) {
//			retMsg = AppConstants.MSG_FAIL;
//		} finally {
//			map.put("msg", retMsg);
//		}

		return ResponseEntity.ok(message);
	}
	
	
	@RequestMapping(value = "/sendEmail.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> sendEmails(@RequestBody Map<String, Object> params, ModelMap mode)
			throws Exception {

		logger.debug("params 이메일 ???????       : {}", params);
	
		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("ddMMyyyy hh:mm:ss", Locale.getDefault(Locale.Category.FORMAT));
		String today = df.format(date);	
			
		HelpDeskService.sendEmailList(params,today);
		
		String retMsg = AppConstants.MSG_SUCCESS;

		Map<String, Object> map = new HashMap();

		
		// 결과 만들기 예.
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));	

		
//		logger.debug("컨트롤러  ^^: {}",map );
//		try {
//		} catch (Exception ex) {
//			retMsg = AppConstants.MSG_FAIL;
//		} finally {
//			map.put("msg", retMsg);
//		}

		return ResponseEntity.ok(message);
	}
	
	
	

}
