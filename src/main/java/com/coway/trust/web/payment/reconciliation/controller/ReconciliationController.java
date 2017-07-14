package com.coway.trust.web.payment.reconciliation.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.application.SampleApplication;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementService;
import com.coway.trust.biz.payment.reconciliation.service.CRCStatementVO;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleService;
import com.coway.trust.biz.sample.SampleVO;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.util.Precondition;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/payment")
public class ReconciliationController {

	private static final Logger logger = LoggerFactory.getLogger(ReconciliationController.class);

	@Resource(name = "commonService")
	private CommonService commonService;
	
	@Value("${app.name}")
	private String appName;

	@Value("${com.file.upload.path}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	
	/******************************************************
	 * Reconciliation Search List
	 *****************************************************/	
	/**
	 * Reconciliation Search List초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initReconciliationList.do")
	public String initCRCStatementTranList(@RequestParam Map<String, Object> params, ModelMap model) {
		
		Map<String, Object> param = null;
		
		//Branch 리스트 조회
		param = new HashMap<String, Object>();
		param.put("kind","1");
		param.put("separator","-");
		List<EgovMap> branchList  = commonService.getBranchList(param);
		
		//은행 계좌 정보 조회
		param = new HashMap<String, Object>();		
		param.put("accountType","CASH");		
		List<EgovMap> bankComboList  = commonService.getAccountList(param);
		
		// 화면 단으로 전달할 데이터.
		model.addAttribute("branchList", branchList);
		model.addAttribute("bankComboList", bankComboList);			
		
		return "payment/reconciliation/reconciliationList";
	}
	
}
