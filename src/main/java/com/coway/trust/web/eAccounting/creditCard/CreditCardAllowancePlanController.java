package com.coway.trust.web.eAccounting.creditCard;

import java.io.File;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.eAccounting.creditCard.CrcLimitService;
import com.coway.trust.biz.eAccounting.creditCard.CreditCardAllowancePlanService;
import com.coway.trust.biz.eAccounting.creditCard.CreditCardApplication;
import com.coway.trust.biz.eAccounting.creditCard.CreditCardService;
import com.coway.trust.biz.eAccounting.webInvoice.WebInvoiceService;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.eAccounting.pettyCash.PettyCashController;
import com.google.gson.Gson;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/eAccounting/creditCardAllowancePlan")
public class CreditCardAllowancePlanController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PettyCashController.class);

	@Value("${app.name}")
	private String appName;

	@Value("${web.resource.upload.file}")
	private String uploadDir;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

    @Autowired
    private CreditCardAllowancePlanService creditCardAllowancePlanService;

	@Autowired
	private CreditCardApplication creditCardApplication;

	@Autowired
	private WebInvoiceService webInvoiceService;

	@RequestMapping(value = "/crcAllowanceMasterPlan.do")
	public String crcAllowanceMasterPlan(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

		return "eAccounting/creditCard/crcAllowancePlanLimit/crcAllowanceMasterPlan";
	}

	@RequestMapping(value = "/crcAllowanceMasterPlanAddPop.do")
	public String crcAllowanceMasterPlanAdd(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		EgovMap cardHolderDetail = creditCardAllowancePlanService.getCreditCardHolderDetail(params);

		model.addAttribute("cardHolder", cardHolderDetail);
		return "eAccounting/creditCard/crcAllowancePlanLimit/crcAllowanceMasterPlanAddPop";
	}

	@RequestMapping(value = "/crcAllowanceMasterPlanEditPop.do")
	public String crcAllowanceMasterPlanEditPop(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws Exception {
		EgovMap cardHolderDetail = creditCardAllowancePlanService.getCreditCardHolderDetail(params);
		EgovMap limitPlanDetail = creditCardAllowancePlanService.getAllowanceLimitDetailPlan(params);
		model.addAttribute("cardHolderDetail", cardHolderDetail);
		model.addAttribute("limitPlanDetail", limitPlanDetail);
		return "eAccounting/creditCard/crcAllowancePlanLimit/crcAllowanceMasterPlanEditPop";
	}

	@RequestMapping(value = "/getCreditCardHolderList.do")
    public ResponseEntity<List<EgovMap>> getCreditCardHolderList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		LOGGER.debug("params =====================================>>  " + params);

		String[] crditCardStus = request.getParameterValues("crditCardStus");

		params.put("crditCardStus", crditCardStus);
        List<EgovMap> creditCardHolderList = creditCardAllowancePlanService.getCreditCardHolderList(params);
        return ResponseEntity.ok(creditCardHolderList);
    }

	@RequestMapping(value = "/getAllowanceLimitDetailPlanList.do")
    public ResponseEntity<List<EgovMap>> getAllowanceLimitDetailPlanList(@RequestParam Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        List<EgovMap> allowanceLimitDetailPlanList = creditCardAllowancePlanService.getAllowanceLimitDetailPlanList(params);
        return ResponseEntity.ok(allowanceLimitDetailPlanList);
    }

	@RequestMapping(value = "/removeAllowanceLimitDetailPlan.do")
    public ResponseEntity<ReturnMessage> removeAllowanceLimitDetailPlan(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		message = creditCardAllowancePlanService.removeAllowanceLimitDetailPlan(params,sessionVO);
        return ResponseEntity.ok(message);
    }

	@RequestMapping(value = "/createAllowanceDetailLimitPlan.do")
    public ResponseEntity<ReturnMessage> createAllowanceDetailLimitPlan(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
        ReturnMessage message = new ReturnMessage();
        message = creditCardAllowancePlanService.createAllowanceDetailLimitPlan(params,sessionVO);
        return ResponseEntity.ok(message);
    }

	@RequestMapping(value = "/editAllowanceDetailLimitPlan.do")
    public ResponseEntity<ReturnMessage> editAllowanceDetailLimitPlan(@RequestBody Map<String, Object> params, HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		message = creditCardAllowancePlanService.editAllowanceLimitDetailPlan(params,sessionVO);
        return ResponseEntity.ok(message);
    }
}
