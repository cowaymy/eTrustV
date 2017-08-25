package com.coway.trust.web.logistics.helpdesk;

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

import com.coway.trust.biz.logistics.helpdesk.HelpDeskService;
import com.coway.trust.biz.logistics.sirim.SirimReceiveService;
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
	
	
	@RequestMapping(value = "/selectDataChangeList.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> selectDataChangeList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
//		logger.debug("%%%%%%%%searchDcfNo%%%%%%%: {}",params.get("searchDcfNo") );
//		logger.debug("%%%%%%%%searchRequestor%%%%%%%: {}",params.get("searchRequestor") );
//		logger.debug("%%%%%%%%searchReqDate1%%%%%%%: {}",params.get("searchReqDate1") );
//		logger.debug("%%%%%%%%searchReqDate2%%%%%%%: {}",params.get("searchReqDate2") );	
//		logger.debug("%%%%%%%%searchApprovalStatus%%%%%%%: {}",params.get("searchApprovalStatus") );
//		logger.debug("%%%%%%%%searchRequestBranch%%%%%%%: {}",params.get("searchRequestBranch") );
//		logger.debug("%%%%%%%%searchRequestDepartment%%%%%%%: {}",params.get("searchRequestDepartment") );
	
		String[] searchApprovalStatus = request.getParameterValues("searchApprovalStatus");
		String[] searchRequestBranch = request.getParameterValues("searchRequestBranch");
		String[] searchRequestDepartment = request.getParameterValues("searchRequestDepartment");
		
		logger.debug("%%%%%%%%searchRequestDepartment%%%%%%%: {}",searchApprovalStatus );
		logger.debug("%%%%%%%%searchRequestDepartment%%%%%%%: {}",searchRequestBranch );
		logger.debug("%%%%%%%%searchRequestDepartment%%%%%%%: {}",searchRequestDepartment);
		
		List<EgovMap> list = HelpDeskService.selectDataChangeList(params);
		
		Map<String, Object> map = new HashMap();
		map.put("data", list);

		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/detailDataChangeList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> detailDataChangeList(@RequestBody Map<String, Object> params, Model model) {
		
		logger.debug("dcfreqentryid   ?? ::::::: {}",params.get("dcfreqentryid") );
		
		List<EgovMap> list = HelpDeskService.detailDataChangeList(params);
	for (int i = 0; i < list.size(); i++) {
			logger.debug("detailDataChangeList *&(*&*(&*(*(&*(&&  ?? ::::::: {}",list.get(i) );
	}
		Map<String, Object> map = new HashMap();
	//	map.put("data", list);

		return ResponseEntity.ok(map);
	}
	
	
	@RequestMapping(value = "/DetailInfoList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> DetailInfoList(@RequestBody Map<String, Object> params, Model model) {
		
		logger.debug("DetailInfoListDcfreqentryid   ?? ::::::: {}",params.get("dcfreqentryid") );
		
//		List<EgovMap> list = HelpDeskService.DetailInfoList(params);
//		List<EgovMap> list = HelpDeskService.ChangeItemList(params);
//		List<EgovMap> list = HelpDeskService.RespondLogList(params);
		
//	for (int i = 0; i < list.size(); i++) {
//			logger.debug("detailDataChangeList *&(*&*(&*(*(&*(&&  ?? ::::::: {}",list.get(i) );
//	}
		Map<String, Object> map = new HashMap();
	//	map.put("data", list);

		return ResponseEntity.ok(map);
	}
	
	
	
	

}
