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
import com.coway.trust.biz.payment.mobilePayment.RequestFundTransferService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestFundTransferController.java
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
@RequestMapping(value = "/payment/requestFundTransfer")
public class RequestFundTransferController {



	@Resource(name = "RequestFundTransferService")
    private RequestFundTransferService requestFundTransferService;



    @Autowired
    private MessageSourceAccessor messageAccessor;



	@RequestMapping(value = "/initRequestFundTransfer.do")
	public String initSearchPayment(@RequestParam Map<String, Object> param, ModelMap model) {
		return "payment/mobilePayment/requestFundTransfer";
	}



    @RequestMapping(value = "/selectTicketStatusCode.do", method = RequestMethod.GET)
    public ResponseEntity<List<EgovMap>> selectTicketStatusCode() throws Exception{
        return ResponseEntity.ok(requestFundTransferService.selectTicketStatusCode());
    }



    @RequestMapping(value = "/selectRequestFundTransferList.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> selectRequestFundTransferList(@RequestBody Map<String, Object> param) throws Exception{
        ReturnMessage result = requestFundTransferService.selectRequestFundTransferList(param);
        result.setCode(AppConstants.SUCCESS);
        result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        return ResponseEntity.ok(result);
    }



    @RequestMapping(value = "/selectOutstandingAmount.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> selectOutstandingAmount(@RequestBody Map<String, Object> param) throws Exception{
        ReturnMessage result = requestFundTransferService.selectOutstandingAmount(param);
        result.setCode(AppConstants.SUCCESS);
        result.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        return ResponseEntity.ok(result);
    }



    @RequestMapping(value = "/saveRequestFundTransferArrpove.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> saveRequestFundTransferArrpove(@RequestBody Map<String, Object> param, SessionVO sessionVO) throws Exception{
        param.put("userId", sessionVO.getUserId());
        requestFundTransferService.saveRequestFundTransferArrpove(param);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        return ResponseEntity.ok(message);
    }



    @RequestMapping(value = "/saveRequestFundTransferReject.do", method = RequestMethod.POST)
    public ResponseEntity<ReturnMessage> saveRequestFundTransferReject(@RequestBody Map<String, Object> param, SessionVO sessionVO) throws Exception{
        param.put("userId", sessionVO.getUserId());
        requestFundTransferService.saveRequestFundTransferReject(param);

        ReturnMessage message = new ReturnMessage();
        message.setCode(AppConstants.SUCCESS);
        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
        return ResponseEntity.ok(message);
    }
}
