package com.coway.trust.web.organization.organization;

import java.io.File;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.application.FileApplication;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.organization.organization.WebCrawlService;
import com.coway.trust.biz.sales.order.OrderDetailService;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.text.SimpleDateFormat;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/organization/compliance")
public class WebCrawlController {
	private static final Logger logger = LoggerFactory.getLogger(WebCrawlController.class);

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "webCrawlService")
	private WebCrawlService WebCrawlService;



	/**
	 * Organization Compliance Call Log
	 *
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/WebCrawlLog.do")
	public String WebCrawlList(@RequestParam Map<String, Object> params, ModelMap model) {/*
		params.put("typeId", "1389");
		params.put("inputId", "1");
		params.put("separator", "-");

		List<EgovMap> WebCrawlList = WebCrawlService.selectWebCrawlList(params);
		model.put("WebCrawlList", WebCrawlList);
		System.out.print(model);
		// 호출될 화면
*/		return "organization/organization/WebCrawl";
	}
		@RequestMapping(value = "/WebCrawlResult.do")
		public ResponseEntity<List<EgovMap>> WebCrawlResult(@RequestParam Map<String, Object>  params, HttpServletRequest request, ModelMap model) {

			String status[] = request.getParameterValues("link_status");
			params.put("status",status);

			List<EgovMap> WebCrawlList = WebCrawlService.selectWebCrawlList(params);
			// 호출될 화면
			return ResponseEntity.ok(WebCrawlList);
	}

		@RequestMapping(value = "/SaveLinkStatus.do")
		public ResponseEntity<ReturnMessage> SaveLinkStatus(@RequestBody Map<String, Object> params,SessionVO sessionVO) {


			System.out.print("HEREZ");
			params.put("updator", sessionVO.getUserId());
			logger.debug("			pram set  log");
			logger.debug("					" + params.toString());
			logger.debug("			pram set end  ");
			WebCrawlService.updateLinkStatus(params);
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setData("");
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			return ResponseEntity.ok(message);
	}
		@Autowired
		private MessageSourceAccessor messageAccessor;
}
