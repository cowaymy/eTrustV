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
import com.coway.trust.biz.payment.mobilePayment.RequestRefundService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestRefundController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/payment/requestRefund")
public class RequestRefundController {



	@Resource(name = "RequestRefundService")
    private RequestRefundService requestRefundService;



    @Autowired
    private MessageSourceAccessor messageAccessor;



	@RequestMapping(value = "/initRequestRefund.do")
	public String initSearchPayment(@RequestParam Map<String, Object> param, ModelMap model) {
		return "payment/mobilePayment/requestRefund";
	}



    @RequestMapping(value = "/selectTicketStatusCode.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectTicketStatusCode() throws Exception{
        return ResponseEntity.ok(requestRefundService.selectTicketStatusCode());
    }



    @RequestMapping(value = "/selectRequestRefundList.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> selectRequestRefundList(@RequestBody Map<String, Object> param) throws Exception{
        ReturnMessage result = requestRefundService.selectRequestRefundList(param);
        result.setCode(AppConstants.SUCCESS);
        result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        return ResponseEntity.ok(result);
    }



    @RequestMapping(value = "/saveRequestRefundArrpove.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> saveRequestRefundArrpove(@RequestBody Map<String, Object> param, SessionVO sessionVO) throws Exception{
        param.put("userId", sessionVO.getUserId());
        requestRefundService.saveRequestRefundArrpove(param);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        return ResponseEntity.ok(message);
    }



    @RequestMapping(value = "/saveRequestRefundReject.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> saveRequestRefundReject(@RequestBody Map<String, Object> param, SessionVO sessionVO) throws Exception{
        param.put("userId", sessionVO.getUserId());
        requestRefundService.saveRequestRefundReject(param);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        return ResponseEntity.ok(message);
    }
}
