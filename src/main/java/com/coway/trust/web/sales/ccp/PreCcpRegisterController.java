package com.coway.trust.web.sales.ccp;

//import com.coway.trust.config.ctos.client.xml.proxy.ws.RequestData;
//import com.coway.trust.config.ctos.client.xml.proxy.ws.Proxy;
//import com.coway.trust.config.ctos.client.xml.proxy.ws.StaxXMLReader;
//import com.coway.trust.config.ctos.client.xml.proxy.ws.ResRequestVO;

import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.time.StopWatch;
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
import com.coway.trust.util.BeanConverter;
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

//    @Autowired
//    private Proxy proxy;

	@RequestMapping(value = "/initPreCcpRegisterList.do")
	public String initPreCcpRegisterList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		return "sales/ccp/preCcpRegisterList";
	}


	@RequestMapping(value="/checkPreCcpResult.do", method=RequestMethod.GET)
	public ResponseEntity <EgovMap> checkPreCcpResult(@RequestParam Map<String, Object>params, SessionVO sessionVO) throws Exception {

		EgovMap getExistCustomer= preCcpRegisterService.getExistCustomer(params);

		if(getExistCustomer != null){
			getExistCustomer.put("customerType", 7289);
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


//    Pre-CCP Phase 2 still in development
//    public boolean ctos(Map<String, Object> params){
//
//        try
//    	{
//		    params.put("batchNo", "testing");
//		    params.put("orderNo", "");
//		    params.put("oldIc", "testing");
//
//        	preCcpRegisterService.insertNewCustomerInfo(params);
//        	List <EgovMap> resultMapList = (List<EgovMap>) params.get("b2bData");
//            String reqPayload = RequestData.PrepareRequest(params.get("batchNo").toString(), params.get("customerName").toString(), params.get("customerNric").toString(), params.get("oldIc").toString());
//
//            byte[] bytes = proxy.request(reqPayload);
//
//            String response = new String(bytes);
//            int ficoScore = StaxXMLReader.getFicoScore(response);
//            String bankRupt = StaxXMLReader.getBankruptcy(response);
//            String confirmEntity = StaxXMLReader.getConfirmEntity(response);
//
//            if(!confirmEntity.equals("0") && ficoScore == 0){
//              ficoScore = 9999;
//            }
//
//            ResRequestVO resRequestVO = ResRequestVO.builder().custIc(params.get("customerNric").toString()).resultRaw(response)
//                    .ficoScore(ficoScore).batchNo(params.get("batchNo").toString()).ctosDate(new Date()).bankRupt(bankRupt).confirmEntity(confirmEntity).build();
//
//            Map<String, Object> param = BeanConverter.toMap(resRequestVO);
//            param.put("ccrisId", resultMapList.get(0).get("ccrisId").toString());
//            param.put("seq", params.get("seq"));
//        	preCcpRegisterService.updateCcrisScre(param);
//        	preCcpRegisterService.updateCcrisId(param);
//        	return true;
//    	}
//        catch(Exception e){
//        	LOGGER.debug("selectCustomerScoring e{}" + CommonUtils.printStackTraceToString(e));
//        	return false;
//        }
//    }


//	@RequestMapping(value = "/preCcpSubmissionRegister.do")
//	public String preCcpSubmissionRegister(@RequestParam Map<String, Object> params, ModelMap model) {
//		return "sales/ccp/preCcpSubmissionRegister";
//	}


//   @Transactional
//   @RequestMapping(value = "/submitPreCcpSubmission.do", method = RequestMethod.POST)
//    public ResponseEntity<ReturnMessage> submitPreCcpSubmission(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {
//
//	    params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
//	    EgovMap getExistCustomer = preCcpRegisterService.getExistCustomer(params);
//
//	    ReturnMessage message = new ReturnMessage();
//	    boolean flag=true;
//
//	    if(getExistCustomer == null){
//	    	try{
//	    		params.put("customerType", 7290);
//		    	preCcpRegisterService.insertNewCustomerDetails(params);
//		    	List <EgovMap> resultMapList = (List<EgovMap>) params.get("preccpData");
//		    	params.put("seq", resultMapList.get(0).get("preccpId").toString());
//		    	flag = ctos(params);
//	    	}
//	    	catch(Exception e){
//	    		flag=false;
//	    	}
//	    }
//	    else{
//	    	message.setCode(AppConstants.FAIL);
//	   	    message.setMessage("Existing customer cannot check in this part.");
//	   	    return ResponseEntity.ok(message);
//	    }
//
//	    if(flag){
//
//	    	EgovMap getPreccpResult = preCcpRegisterService.getPreccpResult(params);
//
//	    	message.setData(getPreccpResult !=null ? getPreccpResult : null);
//	    	message.setCode(AppConstants.SUCCESS);
//	   	    message.setMessage("Success to check");
//
//	    }
//	    else{
//	    	message.setCode(AppConstants.FAIL);
//	   	    message.setMessage("Fail check in Pre-CCP register. Kindly contact system administrator or respective department.");
//	    }
//
//	    return ResponseEntity.ok(message);
//  }


//   @RequestMapping(value = "/preCcpSubmissionRegisterResult.do")
//	public String preCcpSubmissionRegisterResult(@RequestParam Map<String, Object> params, ModelMap model) {
//		model.put("preccpResult", params);
//		return "sales/ccp/preCcpSubmissionRegisterResult";
//  }

   @RequestMapping(value = "/preCcpEditRemark.do")
	public String preCcpEditRemark(@RequestParam Map<String, Object> params, ModelMap model) {
	    int result = preCcpRegisterService.insertRemarkRequest(params);
		return "sales/ccp/preCcpEditRemark";
   }

   @RequestMapping(value = "/preCcpEditRemarkDetails.do")
	public String preCcpEditRemarkDetails(@RequestParam Map<String, Object> params, ModelMap model) {
	    model.put("remarkDetails", preCcpRegisterService.getPreCcpRemark(params).get(0));
		return "sales/ccp/preCcpEditRemarkDetails";
   }

   @RequestMapping(value = "/getPreCcpRemark.do", method = RequestMethod.GET)
   public ResponseEntity<List<EgovMap>> getPreCcpRemark(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model, SessionVO sessionVO) {

       List<EgovMap> preCcpRemarkList = preCcpRegisterService.getPreCcpRemark(params);

       return ResponseEntity.ok(preCcpRemarkList);
   }

   @Transactional
   @RequestMapping(value = "/editRemarkRequest.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> editRemarkRequest(@RequestBody Map<String, Object> params, SessionVO sessionVO) throws Exception {

	    params.put("userId", sessionHandler.getCurrentSessionInfo().getUserId());
	    ReturnMessage message = new ReturnMessage();
	    boolean flag=true;

	    try{
	    	int result = preCcpRegisterService.editRemarkRequest(params);
	    	flag = result > 0 ? true : false;
	    }catch(Exception e){
	    	flag=false;
	    }

    	message.setCode(flag==true ? AppConstants.SUCCESS : AppConstants.FAIL);
   	    message.setMessage(flag==true ? "Success to update remark" : "Fail to update remark");

	    return ResponseEntity.ok(message);
  }


}