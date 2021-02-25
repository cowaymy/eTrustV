package com.coway.trust.web.services.ecom;

import java.io.File;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.services.ecom.CpeService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/services/ecom")
public class CpeApprovalController {

	private static final Logger logger = LoggerFactory.getLogger(CpeController.class);

	@Resource(name = "cpeService")
	private CpeService cpeService;

	@Resource(name = "orderDetailService")
	private OrderDetailService orderDetailService;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@RequestMapping(value = "/cpeApproval.do")
	public String viewCpe(@RequestParam Map<String, Object> params, ModelMap model) {
		model.addAttribute("params", params);

		List<EgovMap> cpeStat = cpeService.getCpeStat(params);
		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3,
						SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		model.addAttribute("cpeStat", cpeStat);

		return "services/ecom/cpeApprovalList";
	}

	@RequestMapping(value = "/selectCpeApprovalList", method = RequestMethod.GET )
	public ResponseEntity<List<EgovMap>> selectCpeApprovalList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

		logger.debug("selectCpeApprovalList==========================>> " + params);
		List<EgovMap> cpeApprovalList = cpeService.selectCpeApprovalList(params);
		return ResponseEntity.ok(cpeApprovalList);
	}

	@RequestMapping(value = "/cpeApproveViewPop.do")
	public String viewRequestPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO session) {

		logger.debug("params =====================================>>  " + params);

		EgovMap requestInfo = cpeService.selectRequestInfo(params);

		model.addAttribute("requestInfo", requestInfo);

		// TODO: Yong - return different View depending on Cpe request type (those needing approval, and those not needing approval)
		return "services/ecom/cpeApproveViewPop";
	}

}
