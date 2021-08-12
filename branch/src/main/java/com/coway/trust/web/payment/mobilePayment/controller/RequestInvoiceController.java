package com.coway.trust.web.payment.mobilePayment.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.mobilePayment.RequestInvoiceService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestInvoiceController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 27.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/payment/requestInvoice")
public class RequestInvoiceController {



	@Resource(name = "RequestInvoiceService")
    private RequestInvoiceService requestInvoiceService;



    @Autowired
    private MessageSourceAccessor messageAccessor;



	@RequestMapping(value = "/initRequestInvoice.do")
	public String initSearchPayment(@RequestParam Map<String, Object> param, ModelMap model) {
		return "payment/mobilePayment/requestInvoice";
	}



    @RequestMapping(value = "/selectTicketStatusCode.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectTicketStatusCode() throws Exception{
        return ResponseEntity.ok(requestInvoiceService.selectTicketStatusCode());
    }



    @RequestMapping(value = "/selectInvoiceType.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectInvoiceType() throws Exception{
        return ResponseEntity.ok(requestInvoiceService.selectInvoiceType());
    }



    @RequestMapping(value = "/selectRequestInvoiceList.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> selectRequestInvoiceList(@RequestBody Map<String, Object> param) throws Exception{
        ReturnMessage result = requestInvoiceService.selectRequestInvoiceList(param);
        result.setCode(AppConstants.SUCCESS);
        result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        return ResponseEntity.ok(result);
    }



    @RequestMapping(value = "/saveRequestInvoiceArrpove.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> saveRequestInvoiceArrpove(@RequestBody Map<String, Object> param, SessionVO sessionVO) throws Exception{
        requestInvoiceService.saveRequestInvoiceArrpove(param, sessionVO.getUserId());
        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        return ResponseEntity.ok(message);
    }



    @RequestMapping(value = "/saveRequestInvoiceReject.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> saveRequestInvoiceReject(@RequestBody Map<String, Object> param, SessionVO sessionVO) throws Exception{
        requestInvoiceService.saveRequestInvoiceReject(param, sessionVO.getUserId());
        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        return ResponseEntity.ok(message);
    }
}
