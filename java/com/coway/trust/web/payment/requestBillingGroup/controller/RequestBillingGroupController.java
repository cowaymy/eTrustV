package com.coway.trust.web.payment.requestBillingGroup.controller;

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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.MobileAppTicketApiCommonMapper;
import com.coway.trust.biz.payment.requestBillingGroup.service.RequestBillingGroupService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : RequestBillingGroupController.java
 * @Description : RequestBillingGroupController
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 23.   KR-HAN        First creation
 * </pre>
 */
@Controller
@RequestMapping(value = "/payment/requestBillingGroup")
public class RequestBillingGroupController {

	private static final Logger LOGGER = LoggerFactory.getLogger(RequestBillingGroupController.class);

	@Resource(name = "requestBillingGroupService")
	private RequestBillingGroupService requestBillingGroupService;


    @Autowired
    private MessageSourceAccessor messageAccessor;

	 /**
	 * initRequestBillingGroup
	 * @Author KR-HAN
	 * @Date 2019. 10. 23.
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/initRequestBillingGroup.do")
	public String initRequestBillingGroup(@RequestParam Map<String, Object> params, ModelMap model) {

		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalDate(-30), SalesConstants.DEFAULT_DATE_FORMAT3, SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);

		return "payment/requestBillingGroup/requestBillingGroupList";
	}

	  /**
	 * selectRequestBillingGroupList
	 * @Author KR-HAN
	 * @Date 2019. 10. 23.
	 * @param params
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectRequestBillingGroupJsonList.do", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectRequestBillingGroupList(@RequestParam Map<String, Object> params,
		HttpServletRequest request, ModelMap model) {
		List<EgovMap> requestBillingGroupList = null;
		LOGGER.info("##### selectRequestBillingGroupList START #####");
		requestBillingGroupList = requestBillingGroupService.selectRequestBillingGroupList(params);

        // 데이터 리턴.
        return ResponseEntity.ok(requestBillingGroupList);
	  }

	     /**
	     * saveRequestBillingGroupReject
	     * @Author KR-HAN
	     * @Date 2019. 10. 23.
	     * @param param
	     * @param sessionVO
	     * @return
	     * @throws Exception
	     */
	    @RequestMapping(value = "/saveRequestBillingGroupReject.do", method = RequestMethod.POST)
	    public ResponseEntity<ReturnMessage> saveRequestBillingGroupReject(@RequestBody Map<String, Object> param, SessionVO sessionVO) throws Exception{
	        param.put("userId", sessionVO.getUserId());
	        requestBillingGroupService.saveRequestBillingGroupReject(param);

	        ReturnMessage message = new ReturnMessage();
	        message.setCode(AppConstants.SUCCESS);
	        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	        return ResponseEntity.ok(message);
	    }

	     /**
	     * saveRequestBillingGroupArrpove
	     * @Author KR-HAN
	     * @Date 2019. 10. 23.
	     * @param param
	     * @param sessionVO
	     * @return
	     * @throws Exception
	     */
	    @RequestMapping(value = "/saveRequestBillingGroupArrpove.do", method = RequestMethod.POST)
	    public ResponseEntity<ReturnMessage> saveRequestBillingGroupArrpove(@RequestBody Map<String, Object> param, SessionVO sessionVO) throws Exception{
	        param.put("userId", sessionVO.getUserId());
	        requestBillingGroupService.saveRequestBillingGroupArrpove(param);

	        ReturnMessage message = new ReturnMessage();
	        message.setCode(AppConstants.SUCCESS);
	        message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
	        return ResponseEntity.ok(message);
	    }
}



