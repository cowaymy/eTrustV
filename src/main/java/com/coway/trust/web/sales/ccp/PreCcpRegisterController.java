package com.coway.trust.web.sales.ccp;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.ccp.PreCcpRegisterService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Controller
@RequestMapping(value = "/sales/ccp")
public class PreCcpRegisterController {

	private static final Logger LOGGER = LoggerFactory.getLogger(PreCcpRegisterController.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "preCcpRegisterService")
	private PreCcpRegisterService preCcpRegisterService;

    @Autowired
    private SessionHandler sessionHandler;

	@RequestMapping(value = "/initPreCcpRegisterList.do")
	public String initPreCcpRegisterList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

//		List<EgovMap> preccpStatus = preCcpRegisterService.selectPreCcpStatus();
//		model.put("preccpStatus", preccpStatus);

		return "sales/ccp/preCcpRegisterList";
	}


	@RequestMapping(value="/checkPreCcpResult.do", method=RequestMethod.GET)
	public ResponseEntity <EgovMap> checkPreCcpResult(@RequestParam Map<String, Object>params, SessionVO sessionVO) throws Exception {

		EgovMap getExistCustomer= preCcpRegisterService.getExistCustomer(params);

		if(getExistCustomer != null){
			getExistCustomer.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
			int result = preCcpRegisterService.insertPreCcpSubmission(getExistCustomer);
		}

		return ResponseEntity.ok(getExistCustomer);
	}

	@RequestMapping(value = "/preCcpOrderSummary.do")
	public String preCcpOrderSummary(@RequestParam Map<String, Object> params, ModelMap model) {
		model.put("custId", params.get("custId"));
		return "sales/ccp/preCcpOrderSummary";
	}

    @RequestMapping(value = "/searchOrderSummaryList.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> searchOrderSummaryList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

        List<EgovMap> orderSummaryList = preCcpRegisterService.searchOrderSummaryList(params);

        return ResponseEntity.ok(orderSummaryList);
    }

//	@RequestMapping(value = "/preCcpSubmissionRegister.do")
//	public String preCcpSubmissionRegister(@RequestParam Map<String, Object> params, ModelMap model) {
//		return "sales/ccp/preCcpSubmissionRegister";
//	}


//   @Transactional
//   @RequestMapping(value = "/submitPreCcpSubmission.do", method = RequestMethod.POST)
//    public ResponseEntity<ReturnMessage> submitPreCcpSubmission(@RequestBody Map<String, Object> params) throws Exception {
//
//	  try{
//		    SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
//		    params.put("userId", sessionVO.getUserId());
//
//		    ReturnMessage message = new ReturnMessage();
//
//		    EgovMap getExistCustomer = preCcpRegisterService.getExistCustomer(params);
//
//		    if(getExistCustomer == null){
//		    	message.setCode(AppConstants.FAIL);
//		   	    message.setMessage("This customer does not exist. Please key in again.");
//		   	    return ResponseEntity.ok(message);
//		    }
//
//		    params.put("custId", getExistCustomer.get("custId"));
//		    params.put("chsStatus", getExistCustomer.get("chsStatus"));
//		    params.put("chsRsn", getExistCustomer.get("chsRsn"));
//		    params.put("customerName", getExistCustomer.get("name"));
//
//		    int result = preCcpRegisterService.insertPreCcpSubmission(params);
//
//		    if(result > 0){
//		    	 message.setCode(AppConstants.SUCCESS);
//		    	 message.setMessage("Success to create");
//		    	 message.setData(params);
//		    }else{
//		    	message.setCode(AppConstants.FAIL);
//		   	    message.setMessage("Fail to check in Pre-CCP register. Kindly contact system administrator or respective department.");
//		    }
//
//		    return ResponseEntity.ok(message);
//	  }
//	  catch(Exception e){
//		  	throw e;
//	  }
//  }

//   @RequestMapping(value = "/preCcpSubmissionRegisterResult.do")
//	public String preCcpSubmissionRegisterResult(@RequestParam Map<String, Object> params, ModelMap model) {
//	    model.put("preccpResult", params);
//		if (params != null && params.get("chsStatus") != null) {
//			switch ((String) params.get("chsStatus")) {
//				case "GREEN":
//					model.put("chsRemark", params.get("chsStatus").toString());
//					break;
//				case "YELLOW":
//					model.put("chsRemark", params.get("chsStatus").toString() + "_" + params.get("chsRsn").toString());
//					break;
//				default:
//					model.put("chsRemark", "-");
//			}
//		}
//		return "sales/ccp/preCcpSubmissionRegisterResult";
//  }

//   @RequestMapping(value = "/searchPreCcpRegisterList.do", method = RequestMethod.GET)
//   public ResponseEntity<List<EgovMap>> searchPreCcpRegisterList(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model, SessionVO sessionVO) {
//
//     String[] preccpStatusList = request.getParameterValues("preccpStatus");
//     params.put("preccpStatusList", preccpStatusList);
//
//     List<EgovMap> preCcpRegisterList = preCcpRegisterService.searchPreCcpRegisterList(params);
//
//     return ResponseEntity.ok(preCcpRegisterList);
//   }

}